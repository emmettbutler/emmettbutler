Mutable and Immutable Objects in Python
=======================================

9/25/2013

__I wrote this a while ago when I was trying to understand how arguments and scopes work in python. Here it is in case
anyone wants my explainer. Disclaimer: I use the terms "value" and "reference" here a bunch. These terms are used only
to illustrate the point. I don't mean to imply that python's calling model has any concept of a "reference" or
a "value". In particular, look at the last two paragraphs.__

When an object of a mutable type is passed to a function, what is actually passed is sort of a "fake pointer". That
means that, while it can be used to access parameters of the object it points to, the address to which it points cannot
be modified.

This is "pass by value" in the C++ sense, where the value is a reference (maybe an integer representation of some
location in memory). An important point is that the value is of an *immutable* type. That means that we cannot play with
it like a pointer: we can't, as in C, pass a pointer into a function, change the address it points to, and have that
change visible outside the function. We can, however, use the reference to play with members of the object it points to.

More clearly: when a name is assigned to at function scope, the outer-scoped value of that name is discarded (mutable or
immutable, it doesn't matter). When a name is used to reference a mutable parameter without reassigning to it, the named
object is modified.

If a name is assigned to in a function, the corresponding parameter appears to be passed by value (ie the outer object
of the same name is not modifiable). If a name is not assigned to in a function, the corresponding parameter appears to
be passed by reference (ie the outer object of the same name is modifiable).

http://docs.python.org/2/reference/datamodel.html#objects-values-and-types

If you're married to the value/reference paradigm, this can be thought of as "pass by value where sometimes the value is
a reference". By that I mean that a name can be used to *reference* the same mutable object that exists outside of the
current scope, but the identity of the object referenced by the outer name cannot be changed - any attempt to do this
will actually result in the function-scope name being reassigned to a new object, but will have no effect on the
outer-scope name.

This model is also called "pass by object" since the terms "value" and "reference" cease to be meaningful when used in
this context.
