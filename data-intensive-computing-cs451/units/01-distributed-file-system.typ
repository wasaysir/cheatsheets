= Distrbuted File System
/ Sharding: Distribute partitions of a large file to different servers
/ Fault Tolerance: Store each chunk redundantly on multiple servers
/ Replication Factor: Number of redundant copies of each partition in a DFS

== Hadoop DFS
- Data coherency (Write-once-read-many access model) Client can only append to existing files to avoid data coordination.
- Files are broken up into blocks. Each block replicated on multiple DataNodes
- Can't do some typical operations like random write. Optimized for large sequential reads and append-only writes
- Intelligent Client (client can find location of blocks, and accesses data directly from datanode)

#image("/assets/image.png")
- Client only gives file name. 
- Namenode provides a list of block ids & block locations. Then client finds closest data node to request data.
- Namenode only stores location of data on datanodes, but not the actual data. 
- HDFS client gets data information from namenode and then interacts with datanodes to get the data. 
- Namenode has to communicate with datanodes to ensure consistency and redundancy of data (e.g. if new clone of data needs to be created)
- HDFS datanodes send signals all the time to name nodes as a heart beat so namenode knows serer is alive. 
- Namenode knows, for each block, checksums (for data integrity), and servers that contain the data. 

*Namenode*:
- Manages file system namespace
- Maps file name to set of blocks
- Maps block to datanodes where it resides
- Cluster configuration management
- Has no data, only metadata (ex. permission octet, created time)
- Replication engine for blocks (if one is corrupt check checksum. then call 2 replicas)

Namenode metadata:
- Stored in memory, so no demand paging of metadata
- Stores:
  - List of files
  - List of blocks for each file
  - List of datanodes for each block
  - File attributes
- Transaction log (file creations, deletions, etc)

*Datanode*:
- Block server
- Stores data in local file system (eg ext3)
- Stores metadata of a block
- Serves data and metadata to Clients
- Block report
  - Periodically sends a report of all existing blocks to the NameNode
- Facilitates pipelining of data
  - Forwards data to other specified datanodes

*Block Placement Policy*:
- 3 replicas stored on at least 2 racks
  - One replica on local node, remote rack, and third on same remote rack
  - Rebalancing might move this to a third rack
- Third replica is on same remote rack so the first replica is on different rack for integrity, at the cost of speed

*Replication Engine*:
- NameNode detects datanode failures via checksum and heartbeat
- Choose new datanodes for new replicas
- Balance disk usage (each HDD should have approx same usage)
- Balance communication traffic to data nodes (traffic: if node/rack is busy with traffic, don't assign it too many reshards)

== Hadoop Cluster Architecture
Typical Supercomputer:
#image("../assets/hdfs-supercomputer.png")
Problem is we're data-bound, not CPU, so single point of access for data will be a bottleneck.
Hadoop Cluster Architecture:
#image("../assets/colocated-nodes.png")
- By colocating data and processing, Hadoop can optimize significantly to minimize copy over network. 