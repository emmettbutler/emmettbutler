Being On Call
=============

Setup
-----

Set up your Contact Methods and Notification Rules in PagerDuty (under My Profile) such that you will get alerts When
on call within 10 minutes.

Make sure your shift is covered. If you need someone to cover for you because of a vacation or other conflict, ask
around until you find a replacement. Once you do, log into PagerDuty and schedule an override. It’s your responsibility
to create the override.

Set up your phone to alert you. PagerDuty provides a v-card that contains all the numbers associated with the alerting
system. This can be imported as a contact and used to let the PagerDuty phone numbers bypass Do Not Disturb mode.

Handling an Incident
--------------------

Check the PagerDuty incidents page a few times every work day. This ensures you’ll see low-urgency alerts that don’t
send push notifications.

Acknowledge or escalate alerts within 15 minutes even during normal business hours.

Take the lead in declaring an incident. You are the decision maker about whether a situation warrants one or more of
your colleagues being interrupted. It’s often ok to interrupt, but you need to make the call. Deciding that there is
an incident in the first place and getting colleagues involved in fixing it is one of the Incident Commander’s most
important responsibilities, since without this, issues that slip past our alerting can fester for hours.

Create the Incident State Document in Datadog. You (the Primary) are the Incident Commander, and are responsible for
assigning the roles of Operations Lead and Communications Lead for this incident. Note that these roles may be filled
by the same person (even you) depending on the situation.

Communicate. Provide frequent updates, first on the Incident State Document and then on Slack, to keep other engineers
informed about the state of the incident.

Take the lead in investigation. If there’s something broken that you don’t personally know how to fix, get someone
else involved to help. It is your responsibility to decide what should be investigated and what mitigation steps should
be taken, and to delegate these tasks to teammates if you can’t do them yourself.

Delegate. When you determine that something needs to be investigated or fixed, ask a teammate involved in the
response to do it. Ask for periodic updates from this person during the fire. Assign incident response roles.

Oversee mitigation actions by assigning an Operations Lead. This can be the same person as the Incident Commander
(you), depending on the situation. The Operations Lead is the owner of technical actions taken during the incident
with the goal of mitigation.

If necessary, convene a video call. Many incidents are serious enough that one or more members of the team need to
drop everything to resolve them ASAP. In such cases, it is the Incident Commander’s job to start this call. PagerDuty
has a “Play” configured that makes it possible to start a call with a single click on the incident itself.

Assign a Communications Lead for the incident. This person is responsible for providing regular updates to customers
during the incident.

For long-lived incidents, reassign the Incident Commander role when you can no longer do it. Possible reasons for
doing this are “follow the sun” timezone situations and lack of reliable internet connection.

When the issue is resolved, declare the incident over. Update the Incident State Document accordingly. If the severity
of the incident warrants it, send an email to the whole company linking to the Incident State Document. Importantly,
this includes which services were affected, the time frame of the incident, and the degree of data loss, if any.
This ensures that customer communication is consistent and accurate after the incident.

Write a postmortem describing the incident, how it was resolved, and what actions have been or should be taken to
reduce the chances of recurrence.

Calling for Help
----------------

No single engineer knows how to solve all problems. The purpose of the on-call rotation is to serve as a first line of
defense, and to make sure the problem gets solved. If you don’t know how to fix a problem, you can call in help by
reassigning the alert to the next level, or to specific people you think might know how to solve it (even if they
are not on call).