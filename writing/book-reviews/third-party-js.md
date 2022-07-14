Third Party Javascript
======================

I recently read the book Third-Party JavaScript , written by Ben Vinegar and Anton Kovalyov from Disqus in 2013.

I became interested in reading this book after @amontalenti recommended it to me during the response to a complex bug in
the Parse.ly JavaScript SDK. In that bug hunt, we had to figure out how to safely call functions far down the SDK's
attribute tree regardless of whether client code on the page had deleted or otherwise redefined those functions. I felt
pretty lost at the time about how to handle such bugs in a repeatable way while keeping the code clean. I hoped that
this book would shed light on the issue, maybe with some design patterns or common practices. Unfortunately, it did not.

The biggest problem with reading this book in 2021 is that it is eight years old. There's an entire section on
third-party cookies that I skipped because they are effectively dead. It was written before CORS support was widely
implemented in browsers, so it goes into tons of detail about how to do cross-domain messaging in hacky ways like using
window.name as shared memory between frames. It makes the assumption that sites use HTTP by default instead of HTTPS.
There are numerous other ways that the specific guidance from this book has become outdated.

Despite all of that, Third-Party JavaScript still provides a solid foundation on how the cross-domain paradigm differs
from "stay at home" JavaScript applications. For a reader who's unfamiliar or fuzzy on concepts like the same-origin
policy, cross-site cookie persistence, request forgery, scripting attacks, or even the justification for deploying
JavaScript in a third-party context, large swaths of this book will be useful. For me at this moment, the vast majority
of the book confirmed things that I'd learned experientially over years contributing to the Parse.ly JavaScript SDK.

That's not surprising, because this book was written at Disqus in the early 2010s. Disqus and Parse.ly were actually
figuring this stuff out at the same time, and were in a very small group of companies doing so. The influence of this
book on the foundations of the Parse.ly tracker's design are pretty apparent, as is the innovation that Parse.ly has
done in this space since its publication. There were a few sections, especially the section on optimizing bundle
payload, that described approaches that Parse.ly has actually evolved beyond. @amontalenti has cited this book as an
influence on the early design of the SDK, and if memory serves @kbourgoin actually worked at Disqus prior to Parse.ly.
It's fun to get inside the minds of people solving similar problems at the same time that we were.

The only Parse.ly folks I'd recommend this book to are those who want to build a foundation of the concepts of
third-party JavaScript (as opposed to approaches). Even then, there are probably newer pieces of writing that are not
quite so stale.
