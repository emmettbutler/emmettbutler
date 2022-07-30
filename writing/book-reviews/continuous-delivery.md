WIP

A Review of the Book _Continuous Delivery_
==========================================

This is a book by Jez Humble, one of the authors of [Accelerate](accelerate.md), in which many of the same ideas are
clearly visible in embryonic form. The basic issue that both books attempt to solve is that software "integration" is
really complex and difficult. The essence of Humble's solution to the problem is to do the integration step constantly,
thus practicing it and making it easier. _Continuous Delivery_ is a mostly technology-agnostic description of the ideal
setup enabling tech teams to realize that solution.

_Continuous Delivery_ is showing its age in 2022. Git and other distributed version control systems are mentioned only
in passing, and Python is only a footnote. Humble also mostly takes for granted that teams and computers will be
colocated. Most strikingly, the book is full of uncritical discussion of separate "dev" and "ops" teams, going only as
far as recommending that they work closely together at some key moments in the delivery process. It's hard to blame
Humble and his coauthor David Farley for this, because their book turned out to exert a huge influence on the practice
of DevOps over the past decade. Thus, I found this book pretty interesting from a historical perspective. I could see
the germ of Site Reliability Engineering and that the authors couldn't fully articulate the details of practical
solutions to the integration problem back in 2010. As I read, I considered how applicable the book's approach still is
given the ubiquity of remote work, cloud computing, and distributed version control.

If asked for a single, pithy takeaway from this read, I would probably say "don't use branches", a controversial
statement that will probably start an interesting discussion. I was surprised when I read _Continuous Delivery_'s strong
position against developing on branches, having built my career in the time of GitHub and Google Hangout. However, the
book makes a compelling case that the use of branches is unresolvably at odds with integrating changes continuously.
It's pretty intuitive: you will eventually release *one* version of your software to production, and a branch is
a *second copy* of your software that will necessarily have to be *integrated* before release.

Instead of using branches, the book's strong recommendation is to commit directly to master at least once a day.
Attempting to apply that approach right now on my current team would probably do more harm than good - trunk (the master
branch) would be broken all the time. Despite this fact, I can see the benefit of treating frequent changes to master as
the goal. Changing master while keeping it releasable forces us to integrate our changes *now* instead of later, when it
will be harder. My personal experience that the amount of integration work scales superlinearly with the size of a merge
is backed up by anecdotes from this book. This leads to a clear conclusion: over a long enough timescale, integrating
more frequently by committing directly to master and keeping it releasable requires less effort than integrating
infrequently.

![](media/ci-effort.png)

That spike on the far left of the CI curve is very real. Planning a big project such that every individual step is
releasable is not a small task, but the authors strongly believe that it's possible in nearly every case. More
convincingly, they suggest in _Continuous Delivery_ and attempt to prove in _Accelerate_ that putting in this up-front
work to decompose large projects has a demonstrably positive impact on a project's cycle time (the average time
a feature takes from idea to production) in the long run.

Humble and Farley offer a few broad outlines of strategies for keeping the trunk releasable that are worth reproducing
here:

*Hide new functionality until it is finished*

At its simplest, this can be done by committing unreachable code to master. Beyond that, feature flags and canary
deployments are two common approaches to hiding in-progress functionality while simultaneously integrating and testing
it.

*Make all changes incrementally as a series of small changes, each of which is releasable*

On this point, the authors' own words are too perfect not to quote directly:

> The bigger the apparent reason to branch, the more you shouldn't branch...
> Even if turning large changes into a series of small, incremental changes is hard work while you're doing it, it
> means you're solving the problem of keeping the application working as you go along, preventing pain at the end. It
> also means you can stop at any time if you need to, avoiding the sunk cost involved in getting halfway through a big
> change and then having to abandon it.

*Use [branch by
abstraction](https://continuousdelivery.com/2011/05/make-large-scale-changes-incrementally-with-branch-by-abstraction/)
to make large-scale changes*

Essentially, this is an example of how to break down apparently non-decomposable problems into a series of steps that
can be committed individually to master.

1. Create an abstraction over the part of the system that you need to change.
2. Refactor the rest of the system to use the abstraction layer.
3. Create new classes in your new implementation, and have your abstraction layer delegate to the old or the new classes as required.
4. Remove the old implementation.
5. Rinse and repeat the previous two steps, shipping your system in the meantime if desired.
6. Once the old implementation has been completely replaced, you can remove the abstraction layer if you like.

*Decouple parts of the application that change at different rates*

The book goes into a lot of detail about the concepts of components and dependencies, but the main point as I see it is
that loosely-coupled architecture supports continuous integration.


main way to reduce the pain of frequent integration is by automating it away (echoes of SRE)
test suite should give complete confidence that the software is fit for purpose
it's possible to eliminate the need for all manual testing - if there's a manual step you feel compelled to do to check
for releasability, automate it.
85 test quadrants
automated acceptance testing, 3 layers, owned by the whole team
210 tension re integrating with external systems in acceptance tests
difference between acceptance tests with stubs and integration tests
196 executable specification
acceptance testing (and all testing) is toil reduction
automation is executable documentation

230 balance between assuming you can fix all capacity problems later and writing overly defensive code that solves
problems you may never have
in distributed client/server architectures, representative capacity testing is often impossible

most constants should be configuration
properties files for configuration
164 smoke testing deployments
253 first deployment list

autonomic infrastructure

419 model
![](../media/maturity-model.png)

team health questions
* How are you tracking progress?
* How are you preventing defects?
* How are you discovering defects?
* How are you tracking defects?
* How do you know a story is finished?
* How are you managing your environments?
* How are you managing configuration?
* How often do you showcase working features?
* How often do you do retrospectives?
* How often do you run your automated tests?
* How are you deploying your software?
* How are you building your software?
* How are you ensuring that your release plan is workable?
* How are you ensuring that your risk-and-issue log is up to date?
