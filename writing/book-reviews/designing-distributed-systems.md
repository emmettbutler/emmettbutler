Designing Distributed Systems
=============================

This is an overview of design patterns for distributed systems of the kind that Parse.ly maintains. Pretty much all of
the patterns are now or have been used in the Parse.ly data system, which makes this book an awesome way for Parse.ly
engineers to build context about how our design decisions fit into thinking in the industry. It's written by
a Kubernetes creator and includes practical examples that use Kubernetes. For a reader with no Kubernetes experience,
these can be a little tedious. Even so, this book is so short and relevant that I strongly recommend it for anyone
hacking on Parse.ly's data system.

Especially relevant sections:

Chapter 5: Replicated Load-Balanced Services - Dash, Pixel, and API all use this pattern

Chapter 6: Sharded Services - solid context on sharding as a concept and when to apply it versus replication

Chapter 7: Scatter/Gather - Elasticsearch uses this patern

Chapter 11: Event-Driven Batch Processing - all of our Storm topologies and connected services use this patternt
