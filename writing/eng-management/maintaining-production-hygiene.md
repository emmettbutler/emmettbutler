Maintaining Production Hygiene
==============================

There are a handful of “production hygiene” tasks that our team does weekly to ensure that the on-call and testing
experiences remain manageable for everyone.

Production Health Updates
-------------------------

Once a week, we post on the team blog summarizing the state of production in the previous seven days. The main goal of
this summary is to point out noisy or unactionable PagerDuty alerts that made the on-call engineer’s time more
difficult for no good reason.

The easiest way to find such alerts is to go as far back in the incident page‘s history as possible and explore each
alert in turn. When it triggered, did the on-call engineer have to do anything to fix it? Did it trigger at the
appropriate level of urgency? If not, open a ticket describing how the alert is noisy or unactionable, and link to the
ticket in the post.

A useful production update generally includes the following:

* Notes of who was Primary and Secondary on call
* Counts of PagerDuty incidents, depleted error budgets, and Datadog incident pages from the last week
* Summaries of all noisy and/or unactionable alerts with links to tickets
* Summaries of all production incidents with links to incident pages and/or postmortems
* Summaries of all depleted error budgets

If you’re spending more than an hour writing the update, cut it short and move on. It’s not worth spending so much time
summarizing everything. It can be useful to start with a quick ten-minute scratch draft, then spend the rest of an hour
fleshing it out. If it’s still partially scratch at the end of an hour, just publish!