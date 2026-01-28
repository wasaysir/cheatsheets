= 
/ Big Data: Sufficiently large number of data (interpretation open)

/ Vertical Scaling: Improving the capacity of a single computer
/ Horizontal Scaling: Accumulating many cheap computers to create a powerful system

- Simple Word Count:
```python
counts = Counter()
with open("file.txt", "rt") as file:
  for line in file:
    counts.update(tokenize(line))
```

This is basically as fast as the first blocking read, because while you're iterating lines, the HDD is sending the next inode into memory for the OS. So if coming from an HDD, the loop is "free" and blocks on the next page of data.

Main way to improve time is increase data access speed. However, speed and cost aren't linear. So vertical scaling reaches a limit. Horizontal scaling, with 100x the servers, can offer you \~50x the speed (because of redundancy + coordination)

Problem: You need to find some way to partition the data cleanly. Dividing by bytes is simplest, because that's how data is stored in a file, but not necessarily useful. So you'll need to allow passing of data between workers.

== Physical View
- There are multiple servers in a rack. 
- A network switch connects the servers in the rack. 
- Same network switch also connects the rack to other racks.
- Clusters of racks build a data server
- Data servers can communicate to each other. 
Tangent: Moving from one server to a server in a different data server requires moving from 5 network switches (Primary rack switch, primary cluster switch, Switch between data servers, secondary cluster switch, secondary rack switch)