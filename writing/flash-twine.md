![](../media/twine1.jpg)

This post is about using Twine in the context of an Actionscript Flash game, since Nina and I did so successfully in our
recent game Ladylike with Deckman Coss and Winnie Song. Twine is "an open-source tool for telling interactive, nonlinear
stories", so of course upon seeing the "open-source" aspect, I promptly decided to fork the core library (conveniently
written in python) for use in our own game.

The problem we faced was this: our vision for Ladylike was a primarily dialogue-driven story that lets the player
explore youth and the lack of agency sometimes experienced by tweens. We wanted the gameplay (at least in the opening
section) to be entirely a text-adventure. When we wrote the first version of Ladylike for a game jam, the code we used
to accomplish this didn't lend itself to fitting large stories inside one's head:

```
var zero:ConvoBranch = new ConvoBranch(0, "I don't want you two being friends...");
zero.addResponse("I know.", 2);
zero.addResponse("That's not fair mom, she's my best friend!", 1);
convoTree[0] = zero;
```

Though nicely object-oriented, this method of setting up a text adventure pretty clearly doesn't scale with the size of
the story being represented. The ConvoBranch constructor accepts a parameter ID, which is an integer used to uniquely
identify that branch of the conversation tree. The addResponse calls point to new branches via their second argument.

As I'm sure Nina can attest, writing a story in this format was painstaking. The conversation tree in Nina's head was
huge, and drawing tree branches on paper and copy-pasting code blocks was getting old fast.

![](../media/twine2.jpg)

I wanted to turn Nina's writing interface from the above code into something like this:

```
var myStory:Story = new StoryGenerator(storyFile).generate();
```

Nina and I immediately looked to Twine for help, as she'd used it successfully on some other projects in the past, and
it provides a nice interface for editing interactive stories. The only issue was that the core library only supported
exporting to html format (if you click the previous link, you'll see the typical twine story format). Clearly this
wasn't great for our needs, since we wanted to use Twine as a tool in a pipeline rather than the main medium of our
game.

Long story short, I found and forked the "twee" core library, which is the base on which the Twine UI is built. I added
simple support for outputting to JSON, which enabled Nina to rapidly prototype and decoupled me from the writing
process.

Shortly after figuring out a workflow that worked well for getting Twine stories into Actionscript, I encoded this
workflow into a tool creatively called twine-as3, or "Twine for Actionscript", which we used in the final version of
Ladylike. Twine for Actionscript is a small set of classes that simplify the workflow for using a Twine story in
Actionscript applets.

The workflow is explained in the README of the twine-as3 project, but I'll go into some detail about how we used it in
Ladylike here. The library exposes a TwineImporter class, which it uses to create a "pages" array representing the parts
of a given Twine story. The structure it uses is highly generic - in fact it's little more than an Actionscript object
representation of JSON. The TwinePage object has an identifier, a list of tags, and some text. Together, this
information is enought to uniquely represent a position in the story (as is familiar to Twine users). This generic
structure, although not quite what we needed for Ladylike, seemed necessary to allow users of the library as much
freedom as they have when using Twine on its own.

```
var pages:Array = (new org.twine.TwineImporter(twineFile)).getPages();
```

In Ladylike, the conversation between the player character and the mom character takes the form of "prompts" from the
mom that have several possible answers the player can choose. Since Twine is generic enough to allow a much wider range
of story forms, Nina and I agreed on what amounts to a "rotocol" on top of the base Twine data format that would make
importing simpler for our needs. As long as the Ladylike Twine file was written a certain way, it would import
seamlessly into the Actionscript program. The code used to implement this protocol can be found here. Notably, the
following code hacks the link fields of a typical Twine story page to work with our conversation generator:

```
var regex:RegExp = /[\[\[\]\]]/g;
var stripped:Array = pages[i].getLine(j).replace(regex, "").split("|");
var response:String = stripped[0];
var targ:String = stripped[1];
cur.addResponse(response, targ);
```

This code looks at the text of a Twine page and uses a regular expression to find the first link to another page
(represented by [[ ... ]] ). In Ladylike, each page has some text followed by two line breaks, then some lines of text
for responses, each with a link to the appropriate next page - otherwise this method would break. This is the kind of
thing that still needs to be implemented oneself when using twine-as3, since it's quite hard to guess what ideas someone
might come up with for the Twine layout of their next game.

Those are the basics of how twine-as3 is used in our game Ladylike. I wrote this because I'd like more people to know
that it's possible and actually pretty easy to use Twine for things other than pure text adventures. If you're at all
interested in learning more about how to use Twine with actionscript, you can contact me at emmett {dot} butler 321 {at}
gmail {dot} com. I'm especially interested to know what kinds of features would be useful to the community of Twine
users, and in seeing games that use Twine and Actionscript together (and maybe even Twine for Actionscript!).

Thanks for reading!
