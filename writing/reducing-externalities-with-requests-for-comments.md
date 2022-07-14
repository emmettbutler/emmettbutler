Reducing Externalities with Requests For Comments
=================================================

Move fast and break things?
---------------------------

Rapid iteration and incremental improvement are values deeply embedded in our company's culture. While this approach
gives our developers a fantastic amount of autonomy, it creates a “structural conflict…between pace of innovation and
product stability”, as the Google SRE book puts it. The mantras “code wins arguments” and “results over potential” have
supported our early-startup approach of rapid prototyping since the beginning, but the company has reached the stage of
life at which this approach creates conflicting incentives.

We’ve seen this in practice. Fast-moving projects implementing new features often drag to a halt when they reach the
integration stage. Maybe the new logic must be tested against the old, or the cloud resource provisioned during
prototyping doesn’t have the right permissions, or the pull request is so large that the review takes weeks. Some
recent projects involving complex integrations with existing systems have experienced the confict between innovation
and stability firsthand.

The Last 10% of the Work Takes 90% of the Time
----------------------------------------------

For the implementor, these dragging factors are externalities, or costs that affect a party who did not choose to
incur those costs. When a feature is put into production with permissions misconfigured, fixing that configuration
becomes a "devops problem". When a large pull request is submitted against an existing system, the system’s owner has
to review it. In both cases, the cost incurred by the feature’s developer falls to the system maintainer, and this cost
is multiplied by the maintainer’s lack of familiarity with the feature and concerns about its implementation. This is
the “structural conflict” that Google noticed, and at the organizational level, it has a clear adverse effect on
innovation velocity.

Visibility and Agency
---------------------

The classic economics solution to negative externalities is to “internalize” them by moving their costs back to the
party that generated them, and the Google SRE approach of error budgets accomplishes this by aligning incentives. At
our company, while we do the organizational work necessary to implement fixes like “pods” and error budgets, there are
simpler tools available to us right now that can reduce these externalities. In particular, we can view the problem
from the opposite direction: instead of compelling feature developers to pay some additional cost for the unplanned
work their projects incur for other teams, we can give those other teams agency in the implementation of the feature.

This immediately seems at odds with our culture of rapid prototyping, because every person added to a project has a
geometric effect on the amount of coordination overhead required. However, giving other teams visibility and agency
over a project is not the same as adding them to the group of implementors. For other teams, awareness of project plans
and the ability to suggest changes to them has a significant effect on the integration-stage blockage that so many
projects face. This doesn’t violate our core principle of rapid iteration, because they don’t require presence At
synchronous meetings, blocking on feedback, or sign-off. In fact, giving maintainers visibility and agency over
in-progress projects can substantially reduce the drag from the integration step.

How does an implementor gain an understanding of which other parties might be involved in the integration step, and
how do they go about maintaining visibility and agency over the project for those parties? Proactively communicating
project plans to a large, heterogenous group of specializations and soliciting feedback is one low-effort way to do so.
At our company, we’ve been referring to this practice as the Request For Comments, or RFC.

Request For Comments
--------------------

An RFC is a document that describes a project’s plan at a moment in time, raises questions, and solicits feedback.
It’s written by a core feature implementor, and often starts life as a spec or design document. It goes into detail
about the planned architecture and implementation relevant to integrating the project into existing systems. It is
distributed early in a project, possibly more than once as designs and plans change.

Three key aspects of how RFCs are used make them a good fit for solving the integration problem.

* Proactively distributed
* Opt-in for the recipients
* Non-blocking for the sender

Proactive distribution increases the number of potentially interested parties that will gain visibility and agency,
and thus increases the chances that someone will save time at the integration step.

Opt-in for recipients means that anyone who has no opinion or has no stake in the integration step of the project can
simply ignore it, avoiding the creation of busywork.

Non-blocking for the sender is the most important characteristic. It guarantees that the process of soliciting feedback
does not impede the project owner’s ability to iterate rapidly.

These three aspects make the RFC a powerful tool at our organization’s disposal to ease the pain of integrating
cross-team projects. It’s not a solution to the issue of misaligned incentives like the “pod” team structure or
Google’s error budgets, but a simple, high-leverage tool that shouldn’t be overlooked.

The RFC approach has been used successfully on a few recent projects, and because of the benefits it’s been shown to
provide and the low overhead it incurs, it’s worth applying to all sufficiently complex projects to ease the integration
step.