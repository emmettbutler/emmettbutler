Incident Management Concepts
============================

When we’re on call, we’re not just trying to keep our heads above water. We’re instead working toward a goal: zero
alert noise, zero toil, maximum automation. With every shift, production health update, new ticket, and pull request,
you can move our team closer to that goal.

"If a human operator needs to touch your system during normal operations, you have a bug. The definition of normal
changes as your systems grow."
~Carla Geisser, Google SRE

Required Reading
----------------

Our incident management approach is heavily influenced by Google’s Site Reliability Engineering Books. Reading a few
selected chapters from Site Reliability Engineering is a great way to familiarize yourself with how we hold the pager.

Chapter 11 – Being On Call
Chapter 12 – Effective Troubleshooting
Chapter 14 – Managing Incidents
Chapter 15 – Postmortem Culture

Incident State Documents
------------------------

A key component of our incident management practice is the Incident State Document. This is a living document that is
collaboratively edited during an incident to represent the current state of the investigation and mitigation actions
taken. It answers the question “what’s the latest with this incident? I can’t tell from the Slack scrollback”. It also
reduces the likelihood of multiple engineers taking mitigation actions without awareness of each other, and makes
writing postmortems a lot easier. Datadog’s Incidents feature is the preferred medium for these documents.

Roles
-----

During incidents, we sometimes divide the team into incident roles. This division of roles is important because
“…a clear separation of responsibilities allows individuals more autonomy than they might otherwise have, since they
need not second-guess their colleagues.” Note that it can be acceptable for one person to perform multiple roles
during an incident, though it’s often important to separate Operations Lead from the other roles.

* Incident Commander: usually the primary on-call engineer, main assigner of roles
* Operations Lead: the main person performing technical mitigation actions. A group led by this person should be the
    only group making changes to a system during a fire.
* Communications Lead: public face of the incident response task force. Owns all external communication during the
    incident.