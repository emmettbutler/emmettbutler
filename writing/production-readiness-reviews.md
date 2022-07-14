Production Readiness Reviews
============================

This document provides an example of how to evaluate the readiness of a new or existing service to run reliably in
production.

The objectives of the Production Readiness Review are as follows:

"Verify that a service meets accepted standards of production setup and operational readiness, and that service
owners are prepared to work with SRE and take advantage of SRE expertise.

Improve the reliability of the service in production, and minimize the number and severity of incidents that might be
expected. A PRR targets all aspects of production that SRE cares about."

~ Site Reliability Engineering

When Should I Use a PRR?
------------------------

A production readiness review is a useful tool when a team that’s been building a new system for a while wants to
begin sharing the operational burden for that system with the entire team. It can also help find improvement
opportunities in systems that are already operated by the team but generate too much toil.

Writing a PRR
-------------

The most straightforward way to conduct a production eadiness review is to focus it around the creation of a review
document (example). This document shows the findings from an investigation of the following aspects of the system:

* Architecture – Is the application architected for reliability and future scaling?
* Known issues and severity – Does the application perform as designed? What are the known issues?
* Alert type and frequency – What alerts does the application generate? Are these alerts actionable? Do they have
    corresponding entries in the on-call playbook?
* Monitoring and observability – How is the application observed and monitored? Is this information documented and
    discoverable? Sentry, Datadog, Graphite, and ELK are common observability hubs for our team.
* Core SLIs and SLOs – What are the Service Level Indicators and Service Level Objectives for this application? What
    happens when the error budget is depleted?
* Deployment process – How is the application deployed? Does it use fab prod deploy? Where is the deployment process
    documented?
* Production hygiene – How hard would it be for someone else to manage this service in production?
* Actionable Suggestions – Given the above analysis, provide a bulleted list of the top changes you’d like to see
    made to the system’s production-readiness.

Creating this document requires a significant investment in learning the system in depth. For a system that’s
sufficiently mature, even if it’s in a pre-production state, this can take the form of reading documentation, tracing
through code, looking at observability tools, inspecting issue trackers and feature backlogs, and more. Here’s an
example process for doing this learning:

* Read all documentation first
* Code read-through in processing order. Take notes related to production health during readthrough and build written
    mental map. A mental map is essentially a written description of the flowchart showing data flow through the system.
* Run through PRR investigative areas, taking preliminary research notes on each. This includes looking at monitoring,
    documentation, production deployments, and other secondary sources
* Write a few paragraphs based on the notes in each section
* Pick the top few actionable suggestions to highlight

Giving a PRR
------------

A PRR document can be presented in person or asynchronously. Because review conversations can be sensitive, in-person
presentation is interpersonally safer. Here’s an example of a PRR being presented over video call

Disclaimers
-----------

Because reviewing others’ work can be a sensitive topic, it’s important to contextualize the review before presenting
it. The following is an example of something to say to set a tone of constructive criticism and facilitation.

"I am not any more qualified than anyone who helped build this system to evaluate its production readiness. I’m only
applying a framework to the discussion to focus our efforts on the high-impact areas. Everything mentioned here is
just a suggestion. When I say “this architecture might work better with X change”, it’s only an observation, not a
hint that you’ll be held to making that change, or a suggestion that the system design isn’t good. I’m not here to
dictate the roadmap, be a gatekeeper, or put down anyone’s engineering work. I’m here to offer a bit of structure and
an outside perspective."

Start With the Mental Map
-------------------------

Aside from guiding your investigation as you learn the system, the written mental map provides a way to anchor the
conversation. Start by reading through the mental map and then asking “did I miss anything, or get anything wrong?”
If you skip this step, you risk reviewing things that aren’t relevant or are outdated.

Actionable Suggestions
----------------------

After talking through the evaluations section by section, finish with a discussion of how to follow up. These are not
mandates, just suggestions, though the PRR framework encourages everyone to prioritize certain areas before attempting
to spread the operational load among fresh engineers.