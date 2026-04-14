== Assignment 1
Pairs vs Stripes
- Stripes are faster than pairs because you can use an in-mapper combiner to speed things up. You can't necessarily do that with pairs because you're operating on unique pairs of words, so in a single line there's nothing to map. 
  - There are fewer key-value pairs to send, and combiners can do more work, but it's a heavier object (not supported by Hadoop) and it's more computationally expensive (usually better for data intensive programs if it removes the shuffle) and there's a concern the map will fit in memory.

For PMI you require two passes, where one is the modified word count (counting number of lines containing token) and second pass for the cooccurrences of pairs/stripes. The two passes are to ensure total counts of both terms in the pair are available to the reducer.

PMI is used to generate semantic meaning, where greater positive numbers means perfect synonym, and greater negative numbers means perfect antonyms. Thi sis useful to generate word embeddings.

```pseudocode
def map(key:Long, value:String):
  for u in tokenize(value):
    for each v cooccurring with u in value:
      emit((u, v), 1)
def reduce(key: (String, String), values: List[Int]):
  for value in values:
    sum += value
  emit(key, sum)
```

```pseudocode
def map(k: Long, v: string):
  for u in tokenize(v):
    counts = {}
    for each v cooccurring with u in v:
      counts(v) += 1
    emit(u, counts)
def reduce(k: Long, v: List[Map[String->Int]]):
  for value in v:
    sum += value
  emit(key, sum)
```

== Assignment 2
1 was PMI MapReduce, 2 was PMI Spark + BigramRelFreq

Pairs:
```scala
val tokenizedLines = sc.textFile(args.input(), numReducers)
      .map(line => tokenize(line).take(maxTokens).toSet)
      .cache()

    val wordCounts = tokenizedLines
      .flatMap(line_words => line_words.toSeq :+ "*")
      .map((_, 1))
      .reduceByKey(_ + \_, numReducers)
      .collectAsMap()
    
    val wordCountsBc = sc.broadcast(wordCounts)
    val numLines = wordCountsBc.value("*")
    
    val pairs = tokenizedLines
      .flatMap(line_tokens => {
        line_tokens.toList.combinations(2).flatMap { case List(w1, w2) =>
          List((w1, w2), (w2, w1))
        }
      })
      .map((_, 1))
      .reduceByKey(_ + _, numReducers)
      .filter { case (_, count) => count >= threshold }

    val pmi = pairs.map { case ((w1, w2), count) => {
        val prob_w1 = wordCountsBc.value(w1).toDouble / numLines
        val prob_w2 = wordCountsBc.value(w2).toDouble / numLines
        val prob_pair = count.toDouble / numLines
        val pmi_value = math.log10(prob_pair / (prob_w1 * prob_w2))

        (s"($w1, $w2)", f"($pmi_value%.12f, $count)")
      }
    }
```

Stripes: Above but change pairs to stripes below and pmi changes calculation
```scala
val stripes = tokenizedLines
      .flatMap(line => {
        line.toSeq.combinations(2).flatMap {
          case Seq(w1, w2) => Seq((w1, Map(w2 -> 1)), (w2, Map(w1 -> 1)))
        }
      })
      .reduceByKey({ (m1, m2) =>
        m2.foldLeft(m1)((acc, kv) => acc + (kv._1 -> (acc.getOrElse(kv._1, 0) + kv._2)))
      }, numReducers)

    val pmi = stripes.map { case (w1, stripe) =>
      val prob_w1 = wordCountsBc.value(w1).toDouble / numLines
      
      val pmi_stripe = stripe
        .filter{ case (w2, pair_freq) => pair_freq >= threshold }
        .map { case (w2, pair_freq) =>
          val prob_w2 = wordCountsBc.value(w2).toDouble / numLines
          val pair_prob = pair_freq.toDouble / numLines
          val pmi_value = math.log10(pair_prob / (prob_w1 * prob_w2))
          (w2, (pmi_value, pair_freq))
        }
      
      (w1, pmi_stripe)
    }
    .filter { case (word, stripe) => stripe.nonEmpty }
```

```scala
// Bigram pairs computation
val partitioner = new Partitioner {
      override def numPartitions: Int = reducers

      override def getPartition(key: Any): Int = {
        val (w1, _) = key.asInstanceOf[(String, String)]
        math.abs(w1.hashCode) % numPartitions
      }
    }

    val textFile = sc.textFile(args.input())
    val bigram_freq = textFile
      .map(line => tokenize(line))
      .filter(line_tokens => line_tokens.length > 1)
      .flatMap(line_tokens =>
        line_tokens.sliding(2).flatMap {
          case List(w1, w2) => {
            List(
              ((w1, w2), 1),
              ((w1, "*"), 1)
            )
          }
        }
      )
      .reduceByKey(_ + _, reducers)
      .repartitionAndSortWithinPartitions(partitioner)
      .mapPartitions(iter => { 
        // Note mapPartitions is superfluoous, it operates on an iterator of values in a partition
        // instead of each row. This is good if setup costs are high, and you can use a single initializer for 
        // all rows, like a db or API connection
        var word_freq = 0

        iter.flatMap { case ((w1, w2), pair_freq) =>
          if (w2 == "*") {
            word_freq = pair_freq
            Some((w1, w2), word_freq)
          } else {
            val relFreq: Float = pair_freq.toFloat / word_freq.toFloat
            Some((w1, w2), relFreq)
          }
        }
      })
```

== Assignment 3

Pseudocode:
+ Map Tokenizer + wordcount to get (docId, Map[Term, Freq]) pairs
+ flatMap to get ((term, docID), freq) pairs
+ repartitionAndSortWithinPartitions to get secondary sort pattern
+ mapPartitions to build posting lists

```scala
// BoolRetrievalBasic

/* Takes a posting ( ArrayListWritable of docID, term frequency pairs) and extracts just the docIDs into a SortedSet */
def postingToSet(posting : ArrayListWritable[PairOfLongInt]) : SortedSet[Long] = {
  (for (p <- posting.asScala.iterator) yield p.getLeftElement()).to[collection.immutable.TreeSet]
}

/* takes a query and a set of postings and returns the set of documents that match the query
    PRE: all terms in the `query`` have a posting in `postings`*/
def queryMatch(query : Expr, postings : Map[String, SortedSet[Long]]) : SortedSet[Long] = {
  query match {
    case Term(s) => postings.getOrElse(s, SortedSet[Long]())
    case And(left, right) => queryMatch(left, postings).intersect(queryMatch(right, postings))
    case Or(left, right) => queryMatch(left, postings).union(queryMatch(right, postings))
  }
}

// load the index and convert the MapReduce types into regular Scala types.
val invertedIndex = sc.sequenceFile[Text, ArrayListWritable[PairOfLongInt]](args.index()).map{case (term, posting) => (term.toString, postingToSet(posting))}.cache

// load the document collection and make it an indexed pair RDD
val docs = sc.textFile(args.collection()).zipWithIndex.map{case (contents, docid) => docid -> contents}.cache

// Interactive query search
for (queryText <- Source.stdin.getLines()) {
  try{
    val query = PostfixParser.parse(queryText)
    // get all distinct terms mentioned in the query
    val terms = query.getTerms
    // retrieve posting lists for all query terms
    val postings = invertedIndex.filter{case (term, _) => terms.contains(term.toString())}.collectAsMap.toMap

    // perform term-at-a-time matching
    val hits = queryMatch(query, postings)
    println(f"Hits: ${hits.size}")

    // show up to the first 10 hits 
    for (hit <- hits.slice(0,10)) println(f"$hit\t${docs.lookup(hit)(0)}")
  }
}
```

```scala
//BuildInvertedMatrix

// zipWithIndex(RDD[T]) => RDD[(T, Long)] -- this doesn't require a shuffle, but does require the workers to coordinate
textFile.zipWithIndex.flatMap{ case (doc, docID) => {
    var counts = Map[String, Int]() // generate word-count Map for this document
    for (word <- tokenize(doc)) counts(word) = counts.getOrElse(word,0) + 1
    counts.mapValues((docID, _)).iterator 
}}.groupByKey(partitions).map{ case (term, unsortedPostings) => {
  // We're saving to a sequence file, so we need the keys and values to be Writables - so string to text, array to ArrayListWritable
  new Text(term) ->
  new ArrayListWritable[PairOfLongInt](new ArrayList(unsortedPostings.toSeq.sortBy(_._1).map(p => new PairOfLongInt(p._1, p._2)).asJava))
}}.saveAsSequenceFile(args.output()) // a sequence file is a binary file format - will be much smaller than text.
```

== Assignment 4
```scala
/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package ca.uwaterloo.cs451.a4

import org.apache.spark.rdd.RDD

import org.apache.log4j._
import org.apache.hadoop.fs._
import org.apache.spark._
import org.rogach.scallop._

object PersonalizedPageRank {
  val logger = Logger.getLogger(getClass().getName())

  val DAMPING = 0.85f
  
  class Conf(args: Seq[String]) extends ScallopConf(args) {
    mainOptions = Seq(input, output, iterations)
    val input = opt[String](descr = "input path", required = true)
    val output = opt[String](descr = "output path", required = true)
    val iterations = opt[Int](descr = "number of iterations", required = true, validate = (_ > 0))
    val partitions = opt[Int](descr = "number of partitions (0 = determine from input)", required = false, default = Some(0))
    val sources = opt[List[Int]](descr = "list of source nodes", required = true)
    verify()
  }

  def main(argv: Array[String]) {
    val args = new Conf(argv)
    logger.info("Input: " + args.input())
    logger.info("Output: " + args.output())
    logger.info("Number of partitions: " + args.partitions())
    logger.info("Numer of iterations: " + args.iterations())
    logger.info("Source nodes: " + args.sources())
    val conf = new SparkConf().setAppName("PageRank")
    val sc = new SparkContext(conf)
    sc.setLogLevel("warn")

    val iterations = args.iterations()
    val sources = args.sources().toSet

    val outputDir = new Path(args.output())
    FileSystem.get(sc.hadoopConfiguration).delete(outputDir, true)
    val textFile = sc.textFile(args.input())

    // if number of partitions argument is not specified, use the same number as the input file
    val partitions = if (args.partitions() > 0) args.partitions() else textFile.getNumPartitions
    
    val adjList: RDD[(Int, Array[Int])] = textFile.map(line => {
       val parts = line.split("\\s+")
       val nodeId = parts(0).toInt
       val adjNodes = parts.drop(1).map(_.toInt)
       (nodeId, adjNodes)
    })
    .partitionBy(new HashPartitioner(partitions))
    .cache
    
    val N = adjList.count
    var M = sources.size

    var ranks: RDD[(Int, Double)] = adjList.mapValues(_ => 0.0d)
    val startRank = 1.0d / M

    ranks = ranks.map{ case (id, _) => 
      if (sources.contains(id)) (id, startRank) else (id, 0.0d)
      }
    .partitionBy(new HashPartitioner(partitions))
    .cache()

    for (i <- 1 to iterations) {
      val contribs: RDD[(Int, Double)] = adjList.join(ranks).flatMap{case (id: Int, (adj: Array[Int], rank: Double)) =>
        if (adj.nonEmpty) {
          val size: Double = adj.size
          adj.map(dest => (dest, rank / size))
        } else {
          None
        }
      }

      var contribsSum: Double = contribs.values.fold(0.0){_ + _}
      val missingMass = 1.0d - contribsSum

      ranks = contribs
        .reduceByKey(_ + _, partitions)
        .rightOuterJoin(adjList) // This ensures nodes with 0 ingroup are retained in RDD
        .mapPartitions(iter => iter.map{ case (id, (incomingMassOpt, _)) => 
          val jumpMass = if (sources.contains(id)) ( (1.0 - DAMPING) + DAMPING * missingMass) / M else 0.0d
          val incomingMass = incomingMassOpt.getOrElse(0.0d)
          (id, incomingMass * DAMPING + jumpMass)
        }, preservesPartitioning = true)
        .cache()
    }

    ranks.saveAsTextFile(args.output())

    ranks.takeOrdered(20)(Ordering.by[(Int, Double), Double](_._2).reverse)
    .foreach{ case (id, rank) => println(f"$id%d\t$rank%.10f") }
  }
}
```

== Assignment 5

```scala
package ca.uwaterloo.cs451.a5

import org.apache.hadoop.fs._
import org.apache.spark._
import org.apache.log4j._
import org.rogach.scallop._

import org.apache.spark.rdd.RDD
import org.apache.spark.broadcast.Broadcast

import scala.math.exp

object ApplyEnsembleSpamClassifier {
  val logger = Logger.getLogger(getClass().getName())

  class Conf(args: Seq[String]) extends ScallopConf(args) {
      mainOptions = Seq(input, model)
      val input  = opt[String](descr = "input path", required = true)
      val output = opt[String](descr = "output path", required = true)
      val model  = opt[String](descr = "model output path", required = true)
      val method = opt[String](descr = "ensemble method", required = true)
      verify()
  }

  def loadModel(textfile: RDD[String]) = {
    val modelWeights = textfile.map(line => {
        val parts = line.substring(1, line.length - 1).split(",")
        val feature = parts(0).toInt
        val weight = parts(1).toDouble
        (feature -> weight)
    })
    .collect()
    .toMap

    modelWeights
  }

  def spamminess(w: Map[Int, Double], features: Array[Int]): Double = {
    var score = 0d
    features.foreach(f => if (w.contains(f)) score = score + w(f))
    score
  }

  def groupInference(parsedInput: RDD[(String, String, Array[Int])], 
                     bcW1: Broadcast[Map[Int, Double]], 
                     bcW2: Broadcast[Map[Int, Double]], 
                     bcW3: Broadcast[Map[Int, Double]]) = parsedInput.mapPartitions{partition => 
    val w1 = bcW1.value
    val w2 = bcW2.value
    val w3 = bcW3.value

    partition.map{ case (docId, label, features: Array[Int]) =>
      val w1score = spamminess(w1, features)
      val w2score = spamminess(w2, features)
      val w3score = spamminess(w3, features)

      (docId, (label, (w1score, w2score, w3score))) 
    }
  }

  def main(argv: Array[String]): Unit = {
    // Setup Spark and parse command-line arguments
      val args = new Conf(argv)

      logger.info("Input:  " + args.input())
      logger.info("Output: " + args.output())
      logger.info("Model:  " + args.model())
      logger.info("Method: " + args.method())

      val conf = new SparkConf().setAppName("ApplyEnsembleSpamClassifier")
      val sc = new SparkContext(conf)
      sc.setLogLevel("warn")

      val inputFile = sc.textFile(args.input())
      val outputDir = new Path(args.output())
      FileSystem.get(sc.hadoopConfiguration).delete(outputDir, true)

      val modelPath = args.model()

      val groupXTextFile  = sc.textFile(modelPath + "/part-00000")
      val groupYTextFile  = sc.textFile(modelPath + "/part-00001")
      val britneyTextFile = sc.textFile(modelPath + "/part-00002")

    // Load model
      val groupXWeights  = loadModel(groupXTextFile)
      val groupYWeights  = loadModel(groupYTextFile)
      val britneyWeights = loadModel(britneyTextFile)

      val bcGroupXW  = sc.broadcast(groupXWeights)
      val bcGroupYW  = sc.broadcast(groupYWeights)
      val bcBritneyW = sc.broadcast(britneyWeights)

    val parsedInput: RDD[(String, String, Array[Int])] = inputFile.map(line => {
      val parts = line.split("\\s+")
      val docId = parts(0)
      // Assume if not spam, automatically ham
      val isSpam = parts(1)
      val features: Array[Int] = parts.drop(2).map(_.toInt)

      (docId, isSpam, features)
    })

    val ensembleOutput  = groupInference(parsedInput, bcGroupXW, bcGroupYW, bcBritneyW)

    var consensus: RDD[(String, String, Double, String)] = null

    if(args.method() == "average"){
      consensus = ensembleOutput.map{ case (docId, (isSpam, (groupXPred, groupYPred, britneyPred))) =>
        val avg = (groupXPred + groupYPred + britneyPred) / 3
        val classification = if (avg > 0) "spam" else "ham"
        (docId, isSpam, avg, classification)
      }
    } else if (args.method() == "vote"){
      consensus = ensembleOutput.map{ case (docId, (isSpam, (groupXPred, groupYPred, britneyPred))) =>
        val groupXClass  = if (groupXPred > 0) 1d else -1d
        val groupYClass  = if (groupYPred > 0) 1d else -1d
        val britneyClass = if (britneyPred > 0) 1d else -1d
        val spamminess = groupXClass + groupYClass + britneyClass
        val classification = if (spamminess > 0) "spam" else "ham"
        (docId, isSpam, spamminess, classification)
      }
    }

    consensus.saveAsTextFile(args.output())
  }
}
```

```scala
package ca.uwaterloo.cs451.a5

import org.apache.hadoop.fs._
import org.apache.spark._
import org.apache.log4j._
import org.rogach.scallop._

import org.apache.spark.rdd.RDD

import scala.math.exp

object TrainSpamClassifier {
    val logger = Logger.getLogger(getClass().getName())

    class Conf(args: Seq[String]) extends ScallopConf(args) {
        mainOptions = Seq(input, model, shuffle)
        val input = opt[String](descr = "input path", required = true)
        val model = opt[String](descr = "model output path", required = true)
        val shuffle = opt[Boolean](descr = "enable shuffle data", required = false)
        verify()
    }

    def spamminess(w: scala.collection.mutable.Map[Int, Double], features: Array[Int]): Double = {
        var score = 0d
        features.foreach(f => if (w.contains(f)) score = score + w(f))
        score
    }

    def main(argv: Array[String]): Unit = {
        // Setup Spark and parse command-line arguments
            val args = new Conf(argv)

            logger.info("Input: " + args.input())
            logger.info("Model: " + args.model())
            logger.info("Shuffle: " + args.shuffle())

            val conf = new SparkConf().setAppName("TrainSpamClassifier")
            val sc = new SparkContext(conf)
            sc.setLogLevel("warn")

            val modelPath = new Path(args.model())
            FileSystem.get(sc.hadoopConfiguration).delete(modelPath, true)

            val textFile = sc.textFile(args.input(), 1)

        // Training Loop
            val parsedData: RDD[(Double, (Int, Array[Int]))] = textFile.map(line => {
                val parts = line.split("\\s+")
                val docId: String = parts(0)
                // Assume if not spam, automatically ham
                val isSpam: Int = if (parts(1) == "spam") 1 else 0
                val features: Array[Int] = parts.drop(2).map(_.toInt)

                (scala.util.Random.nextDouble, (isSpam, features))
            })

            val sortedData = if(args.shuffle()){ 
                parsedData.sortByKey() 
            } else {
                parsedData
            }

            val trainData = sortedData.map { case (_, (isSpam, features)) => 
                (0, (isSpam, features)) 
            }.groupByKey(1)

            // We're only doing one epoch of SGD
            val trainedWeights = trainData.flatMap { case (key, samples) =>
                // Setup Training Model
                val w = scala.collection.mutable.Map[Int, Double]()
                val delta = 0.002

                samples.foreach{ case (isSpam: Int, features: Array[Int]) =>
                    val score = spamminess(w, features)
                    val prob = 1.0 / (1 + exp(-score))
                    features.foreach(f => 
                        w(f) = w.getOrElse(f, 0.0) + (isSpam - prob) * delta
                    )
                }
                w.toSeq
            }

        // Save to file
            trainedWeights.saveAsTextFile(args.model())
    }
}
```
== Assignment 6

```scala
package ca.uwaterloo.cs451.a6

import org.apache.hadoop.fs._
import org.apache.spark._
import org.apache.log4j._
import org.rogach.scallop._

import org.apache.spark.rdd.RDD
import org.apache.spark.sql.SparkSession

object Q7 {
  val logger = Logger.getLogger(getClass().getName())

  class Conf(args: Seq[String]) extends ScallopConf(args) {
    mainOptions = Seq(input, date, text, parquet)
    val input = opt[String](descr = "input path", required = true)
    val date = opt[String](descr = "date in YYYY-MM-DD format", required = true)
    val text = opt[Boolean](descr = "text input flag")
    val parquet = opt[Boolean](descr = "parquet input flag")

    mutuallyExclusive(text, parquet)
    requireOne(text, parquet)

    verify()
  }

  def main(argv: Array[String]): Unit = {
    val args = new Conf(argv)

    logger.info("Input: " + args.input())
    logger.info("Date: " + args.date())
    logger.info("Is Text: " + args.text.getOrElse(false))
    logger.info("Is Parquet: " + args.parquet.getOrElse(false))

    val sparkSession = SparkSession.builder.appName("Q7").getOrCreate()
    val sc = sparkSession.sparkContext
    sc.setLogLevel("warn")

    val targetDate = args.date()

    if (args.text.getOrElse(false)) {
      // --- TEXT IMPLEMENTATION ---
      val lineitemRdd = sc.textFile(args.input() + "/lineitem.tbl")
      val ordersRdd = sc.textFile(args.input() + "/orders.tbl")

      val customerMap = sc
        .textFile(args.input() + "/customer.tbl")
        .map(line => {
          val cols = line.split("\\|")
          (cols(0).toInt, cols(1)) // (Cust_Key, Cust_Name)
        })
        .collectAsMap()
      val broadcastCustomer = sc.broadcast(customerMap)

      val lineitemFiltered = lineitemRdd
        .map(line => line.split("\\|"))
        .filter(cols => cols(10) > targetDate)
        .map(cols => {
          val orderKey = cols(0)
          val extendedPrice = cols(5).toDouble
          val discount = cols(6).toDouble

          val discPrice = extendedPrice * (1.0 - discount)

          (orderKey, discPrice)
        })

      val ordersFiltered = ordersRdd
        .map(line => line.split("\\|"))
        .filter(cols => cols(4) < targetDate)
        .map(cols => {
          val orderKey = cols(0)
          val orderDate = cols(4)
          val shipPriority = cols(7)
          val custKey = cols(1)

          (orderKey, (orderDate, shipPriority, custKey))
        })

      val cogroupedRdd = lineitemFiltered
        .cogroup(ordersFiltered)

      val joinedRdd = cogroupedRdd
        .flatMap { case (orderKey, (lineItemsIter, ordersIter)) =>
          if (lineItemsIter.nonEmpty && ordersIter.nonEmpty) {
            val revenue = lineItemsIter.sum

            ordersIter.flatMap { case (orderDate, shipPriority, custKey) =>

              val custNameOpt = broadcastCustomer.value.get(custKey.toInt)

              if (custNameOpt.isDefined) {
                Some(
                  (
                    (custNameOpt.get, orderKey, orderDate, shipPriority),
                    revenue
                  )
                )
              } else {
                None
              }
            }
          } else None
        }

      val aggregatedRdd = joinedRdd
        .reduceByKey(_ + _)
        .map { case ((custName, orderKey, orderDate, shipPriority), revenue) =>
          (custName, orderKey, orderDate, shipPriority, revenue)
        }

      val sortedRdd = aggregatedRdd
        .takeOrdered(5)(Ordering.by { case (_, _, _, _, revenue) =>
          -revenue
        })

      sortedRdd.foreach {
        case (
              custName,
              orderKey,
              orderDate,
              shipPriority,
              revenue
            ) =>
          println(
            s"($custName,$orderKey,$revenue,$orderDate,$shipPriority)"
          )
      }

    } else if (args.parquet.getOrElse(false)) {
      // --- PARQUET IMPLEMENTATION ---
      val lineitemDF = sparkSession.read.parquet(args.input() + "/lineitem")
      val ordersDF = sparkSession.read.parquet(args.input() + "/orders")
      val customerDF = sparkSession.read.parquet(args.input() + "/customer")

      val lineitemRdd = lineitemDF.rdd
      val ordersRdd = ordersDF.rdd
      val customerRdd = customerDF.rdd

      val customerMap = customerRdd
        .map(row => {
          (row.getInt(0), row.getString(1)) // (Cust_Key, Cust_Name)
        })
        .collectAsMap()
      val broadcastCustomer = sc.broadcast(customerMap)

      val lineitemFiltered = lineitemRdd
        .filter(row => row.getString(10) > targetDate)
        .map(row => {
          val orderKey = row.getInt(0)
          val extendedPrice = row.getDouble(5)
          val discount = row.getDouble(6)

          val discPrice = extendedPrice * (1.0 - discount)

          (orderKey, discPrice)
        })

      val ordersFiltered = ordersRdd
        .filter(row => row.getString(4) < targetDate)
        .map(row => {
          val orderKey = row.getInt(0)
          val orderDate = row.getString(4)
          val shipPriority = row.getInt(7)
          val custKey = row.getInt(1)

          (orderKey, (orderDate, shipPriority, custKey))
        })

      val cogroupedRdd = lineitemFiltered
        .cogroup(ordersFiltered)

      val joinedRdd = cogroupedRdd
        .flatMap { case (orderKey, (lineItemsIter, ordersIter)) =>
          if (lineItemsIter.nonEmpty && ordersIter.nonEmpty) {
            val revenue = lineItemsIter.sum

            ordersIter.flatMap { case (orderDate, shipPriority, custKey) =>

              val custNameOpt = broadcastCustomer.value.get(custKey)

              if (custNameOpt.isDefined) {
                Some(
                  (
                    (custNameOpt.get, orderKey, orderDate, shipPriority),
                    revenue
                  )
                )
              } else {
                None
              }
            }
          } else None
        }

      val aggregatedRdd = joinedRdd
        .reduceByKey(_ + _)
        .map { case ((custName, orderKey, orderDate, shipPriority), revenue) =>
          (custName, orderKey, orderDate, shipPriority, revenue)
        }

      val sortedRdd = aggregatedRdd
        .takeOrdered(5)(Ordering.by { case (_, _, _, _, revenue) =>
          -revenue
        })

      sortedRdd.foreach {
        case (
              custName,
              orderKey,
              orderDate,
              shipPriority,
              revenue
            ) =>
          println(
            s"($custName,$orderKey,$revenue,$orderDate,$shipPriority)"
          )
      }
    }
  }
}

```

== Assignment 7
