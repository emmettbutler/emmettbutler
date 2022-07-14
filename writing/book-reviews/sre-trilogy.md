Site Reliability Engineering
============================

"Site Reliability Engineering" presents a "hierarchy of needs" for reliable systems and describes in extreme detail
how to implement that hierarchy in an organization. It ranges from technical details on monitoring to organizational
guidelines and best practices related to reliability. This book is available for free in digital format, and each
chapter has its own URL, making it easy to pss around selected excerpts. A majority of chapters are directly applicable
to present-day Parse.ly, specifically for our team and others for whom system reliability is a primary concern. I
strongly recommend this book. Here are the chapters I found most inspiring and applicable.

Chapter 3 - Embracing Risk - A philosophy of risk as it relates to running production systems. It's not something to
be feared, but expected and planned for. "Hope is not a strategy".

Chapter 4 - Service Level Objectives - Details on how to implement SLOs and why they are useful. Foundational for the
rest of the SRE approach.

Chapter 5 - Eliminating Toil - Discusses the creation of useful alerts and handling of interruptive work

Chapter 8 - Release Engineering - Describes how releases are managed at Google. One major takeaway is the first-class
concept of a "turnup", or increasing the percentage of traffic exercising new code over time.

Chapter 11 - Being on Call - Applicable tips and philosophy on how to maintain a useful on-call rotation

Chapter 12 - Effective Troubleshooting - Handbook on how to investigate bugs in complex systems

Chapter 13 - Emergency Response - Case studies of responses to incidents from within Google

Chapter 14 - Managing Incidents - Includes discussion of Incident State Documents, details on how to manage fires

Chapter 15 - Postmortem Culture: Learning from Failure - Explains the importance of postmortems and ways to maximize
their value

Chapter 20 - Load Balancing in the Datacenter - Overview of how to make systems talk to each other effectively

Chapter 22 - Addressing Cascading Failures - One of the most useful and detailed descriptions of the kind of
crazy-making distributed system failure we sometimes experience on our team. Lots of information on how to think about
distributed systems.

Chapter 26 - Data Integrity: What You Read Is What You Wrote - Discusses data integrity through the lens of SLOs, an
area we've debated for a while and still don't have a great systematic handle on.

Chapter 28 - Accelerating SREs to On-Call and Beyond - Framework for onboarding Product Engineers

Chapter 29 - Dealing with Interrupts - Philosophy and practical advice on balancing reactive work with project work

Chapter 30 - Embedding an SRE to Recover from Operational Overload - Has implications for the "pods" approach


Site Reliability Workbook
=========================

The hands-on companion to Site Reliability Engineering. Includes practical advice on how to implement the concepts of
SRE and lots of case studies from other companies who put the ideas into practice. Certain chapters, especially those
on how to implement SLOs and error budgets, and how to reduce toil, are highly applicable to the current moment on our
team, and all product team members would benefit from reading these chapters. The book, like Site Reliability
Engineering, is available for free in HTML format, and each chapter is linked separately. Following is a list of
chapters I found especially applicable.

Chapter 2 - Implementing SLOs - Practical advice on how to move from "chaos" to organizationally-accepted SLOs and
error budgets. Unlike the corresponding chapter of SRE, the audience of this chapter is limited to those interested
in putting SLOs into practice, but still can provide useful context to anyone wishing to understand how to think about
measuring service reliability.

Chapter 3 – SLO Engineering Case Studies – Stories from Evernote and The Home Depot describing the actual application
of the approach laid out in chapter 2. Provides a great basis on which to build an SLO adoption strategy. Useful read
for leaders.

Chapter 5 – Alerting on SLOs – Iterative description of how to move from “chaotic” alerting to alerting based on user
experience. Useful for anyone changing PagerDuty alerting rules.

Chapter 6 – Eliminating Toil – Strategies for getting out from under piles of reactive work. Relevant for teams whose
time is more consumed by toil

Chapter 9 – Incident Response – Case studies of actual uses of Google’s incident response framework. Useful for anyone
involved in on-call rotation.

Chapter 10 – Postmortem Culture: Learning from Failure – Dissection and comparison of a“bad” and “good” postmortem,
and discussion of how to organizationally incentivize postmortem culture. Aside from Chapter 2, probably the most
important chapter in the book for us right now.

Chapter 12 – Introducing Non-Abstract Large System Design – The most lucid and comprehensible description of the
process of designing distributed systems that I have ever read, primarily for its integration of quantitative methods
with hueristics. Useful read especially for engineers with less experience designing systems.

Chapter 13 – Data Processing Pipelines – Though SRE principles are applicable to any organization concerned with 24/7
reliability of a software product, most technical examples in the book presume a web-based “serving system” processing
interactive requests from human or machine users. This chapter explicitly applies the same principles to “pipelines”,
which maps well onto systems we're responsible for.

Chapter 19 – SRE: Reaching Beyond Your Walls – Especially applicable to our support process. In particular, the
insight in “Step 1: SLOs and SLIs Are How You Speak” matches perfectly with a common source of toil for support and
product teams.


Seeking SRE
===========

This is a collection of essays by various authors from across the industry about their experiences applying the
principles of Site Reliability Engineering inside their own organizations. Much of the book is not directly relevant
to our team, but the book is great as a meditation on how to run an effective engineering organization. Reading it
feels like attending a full slate of talks at an SRE conference.

Chapters that are especially relevant to our engineers:

6: How to Apply SRE Principles Without a Dedicated SRE Team - Tells the story of the evolution of DevOps and SRE at
SoundCloud. Many of the issues discussed are things that we have experienced firsthand, especially cross-team
reliability and velocity difficulties, and challenges getting buy-in to the SRE approach.

7: SRE Without SRE: The Spotify Case Study - Another history of a DevOps organzation, this time from Spotify. In my
view, our team in 2021 is similar to Spotify in 2012 from a DevOps/SRE perspective.

10: Clearing the Way for SRE in the Enterprise - Strategies and tactics for applying SRE principles in large
organizations. Though our company isn't large, the mode of thinking this chapter describes is very relevant to
applying the principles at any scale.

11: SRE Patterns Loved by DevOps People Everywhere - Work patterns used at Google that enact the SRE principles,
including a monorepo and production readiness reviews.

20: Active Teaching and Learning - Frames learning as the core of an engineer's job, then discusses strategies for
constant learning that go beyond listening to lectures. Describes some simple games that teach operational skills.

22: SRE as a Success Culture - Most of this chapter isn't especially relevant, but the section "Phases of SRE
Execution" provides an interesting roadmap of the evolution of DevOps in a typical organization. The idea of "ops as
gatekeepers" resonated with me after watching our own ops practice change.

23: SRE Antipatterns - A fun read of ways to misapply SRE principles as an individual contributor or leader. Luckily,
we avoid most of them as of this writing!
