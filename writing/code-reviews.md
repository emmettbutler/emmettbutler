Code Reviews
============

On our team, we hold our code to a simple standard: your teammates need to be comfortable reading, learning, and
updating code that you write. To ensure we’re living up to the standard, we review each others’ code.

The vast majority of code changes in the repo’s master branch happen via pull request. The master branch is not
protected, but we strongly discourage committing directly to it with all but the most trivial changes.

What a Pull Request Is
----------------------

A pull request is, first and foremost, a suggestion of a possible code change. With a pull request, you communicate to
your peers, “I think this would be a beneficial change to make to our code – what do you think?”

Via its description field and conversation history, a pull request is also a historical record of your thoughts and
your teammates’ thoughts at a moment in time. It’s common that we reference old pull requests to get context about why
the code is the way it is.

Finally, a pull request is a hook for our CI/CD system that lets the automation tell us about potential problems before
they affect master.

What a Pull Request Isn’t
-------------------------

A pull request is neither a demand nor a commitment to merge a change.

A pull request is not a gatekeeping mechanism. We trust each other to know when it’s ok to skip the review request
(very rarely), and we hold each other accountable for proactively getting approval from our peers about the vast
majority of changes. The master branch isn’t protected, so we apply the Python mantra “we’re all adults here”.

We hold each other accountable to have each pull request to master reviewed by at least one other team member before
merge.

How to Get a Good Code Review
-----------------------------

When you have a branch off of master with a diff you’d like to merge, open a pull request against master. Use GitHub’s
review request feature to request a review from at least one team member who you think will have some helpful feedback
about the change. Wait a few days for the person to respond with a review, maybe @-ing them on Slack and politely
requesting their time if you’d like a review on a shorter timescale.

There is no particular person you need to get a review from for any given change. In fact, it can be beneficial for
group learning to request reviews from team members less experienced with a given system.

Make sure your pull request has a clear, descriptive title and a description that provides all of the context
necessary for the reviewer to understand the change. Check your change’s size: big diffs tend to be hard to review.
Huge code reviews aren’t unheard of, but if you want fast and detailed feedback, keep the diff small. If you have a big
diff, consider splitting it into multiple smaller pull requests that each deal with a single problem area.

Make sure your change is passing all CI checks before requesting a review. If it’s not, at least tell the reviewer
that you’re aware of it and what you plan to do about it.

How to Give a Good Code Review
------------------------------

When a guildmate requests a code review from you, prioritize it. If you can’t deliver a review by the end of the work
week, comment on the pull request letting them know that you might not be the best person to do a review at the moment.
Leave line comments on specific parts of the code you have thoughts on, and write a summary of your feedback If
applicable.

Remember that you are critiquing another human’s hard work, so be thoughtful about what you choose to comment on. What
does the reviewee need from a peer looking closely at their code? Do they want comments on their idiomatic Python
usage, or are they looking for broad feedback on their architectural approach? Have they built the skill of egoless
programming, or are they still working on it? If you don’t know the answers to these and similar questions, ask!

Build as much context as you can about the change before attempting to review it. The thought behind the change and the
high-level approach taken are generally much more important than the specifics of idiomatic Python usage.

Don’t comment on code formatting. We format our code with Black to avoid debates. We set up our editors to run Black on
save and our local gits to run Black on pre-commit, and we run Black linting in the CI pipeline. If you don’t like the
way our CI formats our code for us, pull request a change to the CI config.

When you finish your review, mark it as either “request changes”, “approve”, or “comment”. On our team, “request
changes” generally means “I’d like to review this again after you make the suggested changes and before you merge it”.
“Approve” and “comment” generally mean “I may have some suggestions on what to improve, but I don’t need to review
again after you make those changes.”

How to Receive a Review
-----------------------

Remember the practice of egoless programming: criticism of your code is not a criticism of you as a programmer. If you
have questions about the feedback, ask them on the thread.

If the reviewer “requested changes”, make their suggested changes, asking clarifying questions in the pull request
thread if necessary. When you’re done, re-request a review from the reviewer.

If the reviewer “approved” or “commented”, consider (and maybe make) their suggested changes, double-check that CI is
passing, and merge away.