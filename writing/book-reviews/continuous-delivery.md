WIP

A Review of the Book _Continuous Delivery_
==========================================

same author as Accelerate (now a google SRE), same ideas visible in embryonic form
fundamental problem: software integration is really hard
solution: do it all the time, thus practicing and making it easier
relatively tech-agnostic guide on how to do that

old book: Git and Python are barely mentioned, colocation of people and machines is mostly assumed, uncritical
discussion of the "dev" and "ops" teams
can't blame them for the latter, because they later had a huge influence on the adoption of devops largely because of
their research for this Book
big question: how applicable is this approach given the ubiquity of remote work, the cloud, and distributed version
control?

don't use branches, fundamental tension with CI, especially don't release from them 390
commit to master multiple times a day
sounds crazy, if you tried this on our team master would be broken all the time
that's kind of the point - it's going to take some work to make master work with your changes (integration), and the
amount of work scales superlinearly with the size of the change, so integrate frequently and trade a little pain now for
a ton of pain later
even planning work such that you can commit meaningful, working code daily is hard
authors strongly believe it's almost always possible
347 keeping app releasable strategies
394 incremental is so good
measure cycle time!
122 pipelining

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
