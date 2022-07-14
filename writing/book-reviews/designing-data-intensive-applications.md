Designing Data-Intensive Applications
=====================================

I recently expensed and read Designing Data-Intensive Applications by Martin Kleppmann, and I'm wanting to share some of
my takeaways from it. This book has been on my radar for a while as a valuable source of shared language about data
systems of the kind Parse.ly has built over the last decade. In a context where so much software engineering literature
assumes the request/response server operation of a web app, such a source feels especially useful to me.

An example of the beautifully nerdy maps accompanying each chapter

This book's most impactful aspect on me was its incremental approach. Early on, Kleppmann gives a description of the
conceptually simplest possible "database":

```
#!/bin/bash

db_set () { echo "$1,$2" >> database }

db_get () { grep "^$1," database | sed -e "s/^$1,//" | tail -n 1 }
```

He notes that this database has great write performance but awful read performance, and then discusses ways to improve
the read performance. This leads to a description of SSTables, LSM-trees, and B-trees, all of which is kept in the
context of a this dead-simple database running on a single node.

Kleppmann starts other chapters by stating other problems with the database, like the lack of fault-tolerance and
scalability, using these as starting points for discussion of replication and partitioning in detail. Much of the book
is built around the construction of a database from this very simple starting place, with ever more complex shortcomings
being pointed out in each chapter.

Chapter 8 goes especially deep in this direction, focusing only on all of the possible issues that haven't already been
covered. These are mostly consequences of the inherent unreliability of packet-switched networks - terms like "dirty
writes", clock drift, partial failures, and even the slippery definition of "truth" in a distributed system. Keeping
this discussion grounded in the context established early on with the simple database made it possible for me to follow
along.

This book isn't about any specific technologies (though it mentions many as examples), instead going into great detail
on the abstractions and algorithms that many data systems have in common. There are lots of graphs of network
communication over time, explaining various faults that can occur in partitioned and replicated systems:

A typical map of distributed communication from the book

There's deep investigation of various replication algorithms, partitioning schemes, transaction semantics, isolation
levels, consensus, batch processing, stream processing, and all of the potential failure modes in distributed systems.
All of this is kept in the context that the book builds early on, but it's still a huge amount of domain knowledge to
sponge up.

In the course of the reading, I developed a stronger intuition for how to work with distributed data. That means I feel
more sure of what the ideal solution to a given problem might look like, and thus more able to compare possible
implementations to the ideal. I'm already feeling the impact of the shared language on architecture and tool-selection
conversations at work.

This book also expanded my understanding of what a database is. Kleppmann makes the case, and supports it convincingly,
that a useful definition of "database" is (paraphrasing) software that accepts data as input, stores it for some amount
of time, and allows it to be read back. Applying this definition makes such disparate technologies as Elasticsearch,
Postgres, Kafka, MapReduce, and Storm start to look similar in interesting ways.

As a cherry on top, I was left with the impression that Kleppmann is conscious of the impact of his work on the greater
good. The book's dedication is a fine summary of that mindset:

Technology is a powerful force in our society. Data, software, and communication can be used for bad: to entrench unfair
power structures, to undermine human rights, and to protect vested interests. But they can also be used for good: to
make underrepresented people’s voices heard, to create opportunities for everyone, and to avert disasters. This book is
dedicated to everyone working toward the good.

This book gets a strong recommendation from me for anyone who's ever committed or wanted to commit code to
Parsely/engineering. It expanded my mind and gave me confidence in my knowledge of distributed systems. If you read
Designing Distributed Systems and wanted about 10x more depth, this book is for you.
