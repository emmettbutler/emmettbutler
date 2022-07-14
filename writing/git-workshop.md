How Git Saved My Workshop
=========================

2/25/2013

This weekend, I gave a series of two talks on iOS game development at Pace University's
computer science school. The talks, which introduced developers to cocos2d and box2d, couldn't have gone as well as they
did if I hadn't learned how to use Git as a teaching tool. I can't say I was surprised at how well Git fit this role, or
at the degree to which it became a stumbling block for those who had never seen it before.

I've been using Git for about as long as I've been programming seriously. At first, the add-commit-push paradigm was
hard for me to grasp, and I learned important lessons through trial and error: stash your changes before you pull,
always use the --rebase flag when pulling, et cetera. I learned some rules the hard way: don't use push -f unless you
really know what you're doing (even when Git's helpful error output tells you to). To learn this lesson in particular
cost me several hours of team code. I know from experience how unforgiving Git can seem to a newcomer.

My workshops were based on a toy project I made in late 2011 to teach myself the basics of iOS game dev, including
sprite animation, collision detection, and time-based actions. To prepare this old project for the workshops, I actually
rewrote most of the code in a new repository. One might ask why I didn't just use the old code; the main reason was to
provide a full change history to the workshop attendees. For a workshop that was primarily based on live coding, showing
the attendees a complete changeset representing our demo app in different stages of development made a huge difference
in their ability to learn the material.

As I rewrote the project, I git-tagged each important commit with a number and some semantic content referencing its
commit message. For example, when I added walls to the physics scene, I tagged the commit with

`git tag 2_walls`

This enabled anyone who cloned the repository to checkout commits by semantic content, rather than looking them up by
hash. That ability engendered more participation on the part of almost everyone involved, since participants who fell
behind could instantly catch up to the rest of the group with a simple git checkout.

The workshops were attended by a varied bunch: some professional developers, many beginner programmers who were
interested in iOS, and a few nonprogrammers who came for the design knowledge. Ultimately, the wide variance in
participants' experience levels proved challenging, especially given my presentation's heavy use of Git. I had to spend
some time at the outset attempting to get everyone up to speed on the basics, including the difference between saving
and committing, and the importance of stashing and unstashing changes. The workshops, especially the second (a day-long
Saturday session) comprised building my demo app with the group: I talked through and wrote the project on a projector
as if from scratch, and participants followed along and asked questions. For the beginning of the workshop, when the
group was having an easy time following along, I hardly even used the tagged commits.

At some point, though, the going got tougher. Around the time that I started leading the group through spritesheet
creation and importing, I could tell that many were getting lost. After I had blasted through the material with
characteristic disregard for those slower on the uptake, I noticed more than half of the group looking very confused.
Almost nobody had followed my logic, and those who had had made significant changes to accommodate their incomplete
understanding of the code. The whole room had code that was inconsistent with what I'd written on the projector, and few
people knew how to fix it.

Enter Git tags. As a result of my pre-workshop tag setup, I could ask everyone to stash their changes and checkout the
tagged commit that roughly corresponded to our position in the live coding session. This ensured that everyone in the
room was playing with the same code, a huge benefit for a workshop leader. Careful planning and repository construction
using naive Git features saved my workshop. Used in this way, Git works amazingly well as a teaching aid. To those who
would set up their own workshop using a similar Git-based scheme I offer the following advice. Focusing your project on
a visible change history obviously works best if your audience is already familiar with Git, at least on a superficial
level. If they aren't, you will spend time (probably more than you'd like) explaining the difference between committing
and saving, or between stashing and stash-popping. If you're alright with splitting your time between Git and your
subject matter like this (as I was), it might work well. Also, if you're live coding with a group and following the
structure of a preexisting codebase, the closer you stay to the structure of that code, the less confusing your workshop
will become.

Thanks to Andrew Montalenti for seeding the idea of Git as a teaching aid. You can find the repository referenced in
this post on my github and a video of one of the presentations on my blog.t
