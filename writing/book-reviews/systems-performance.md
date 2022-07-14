Systems Performance
===================

I recently finished reading Brendan Gregg's new book Systems Performance (2nd edition), and I'm wanting to share a few
thoughts about it through the lens of the #parselyengreadinglist.

Systems Performance essentially teaches you how to definitively answer pretty much any question you could ask related
to the performance characteristics of a Linux system. It provides an architecture survey of each of a computer system's
resources (CPU, memory, disk, network, etc) as context for performance investigations. From there, the book gives
exhaustive descriptions of how to use all available tools to observe the activity of each resource. These tools cover
a wide range of granularity, from top and ps all the way down the stack to bpftrace, a tool written by the author
based on a relatively new Linux feature called Extended BPF. This tool provides visibility into thousands of different
kernel-level events like block IO, TCP message receipt, LLC hits, and so much more, often at the level of individual
CPU cycles. This is one of Gregg's favorite diagrams of eBPF's capabilities:

![](media/bpf_performance_tools.png)

Brendan Gregg's data visualization design skills at work

Aside from the resource-specific chapters, there are three chapters that are essentially manpages for performance
observability tools including perf, Ftrace, and bpftrace (I skipped these). The most referenceable and futureproof
chapter is Chapter 2 on Methodologies. It defines dozens of "performance investigation methodologies" that can be
applied in different contexts to answer questions about performance. These are things like "workload characterization",
"drill-down analysis", static performance tuning, micro-benchmarking, and the "tools method". My favorite among these
is his "USE" method, where USE stands for utilization, saturation, and errors. The idea is that checking USE
characteristics for each resource on a system is a good way to get a snapshot of what's going on and find likely
bottlenecks. An appendix even provides a checklist for applying this method on Linux. This chapter also starts with
some "anti-methodologies", which helped me put the others in perspective as someone who has applied many such
antipatterns to performance investigations. Each of these methodologies is revisited multiple times in later chapters
in the context of specific system resources.

Another highlight for me was the chapter on virtualization. Before reading it, I had only a vague idea of how the
interface between an AWS EC2 instance and the physical hardware it was running on worked, and now I feel like I could
explain it to another engineer. In a sense this knowledge isn't necessary for my job, because hardware virtualization
presents an interface that's almost identical to a bare-metal Linux machine. Even so, it's comforting to know exactly
what a hypervisor is, and the boundaries of what I could observe under AWS Nitro virtualization.

As you might guess, this book is kind of a monster. It doesn't seem to be written for approachability, instead taking
the structure of a textbook, complete with multi-level section headings and comprehension questions. It's only
recently that I became comfortable enough with my own understanding of Linux internals to attempt reading it. I'm glad
I did, but there were still lots of bits that went over my head, especially the specific bpftrace examples that
require understanding of deep kernel internals. I'd also describe Gregg's writing style as idiosyncratic, and he loves
to plug his own GitHub account in the footnotes, which was a minor turnoff for me.

My strongest impression after reading this book is that I now have the tools to understand the performance of Parse.ly
code in production as well as anyone possibly could. Even though I certainly don't remember many of the specifics
about tools and the kernel, I have a roadmap to follow when I want to dig into a particular area. I wouldn't heartily
recommend this book to anyone at Parse.ly unless they were already really excited about deep Linux hacking, because I
think the majority of the book isn't actionable for us on a day-to-day basis. However, I can think of a few times over
the years at Parse.ly where this knowledge would have been invaluable to me, especially the methodologies. I do
recommend reading those from Gregg's website (linked above).
