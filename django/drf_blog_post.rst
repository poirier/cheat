Tutorial on serialization in Django Rest Framework
==================================================

In `his blog post <https://www.caktusgroup.com/blog/2019/02/01/creating-api-endpoint-django-rest-framework/>`_,
my colleague Dmitriy gave a good example of starting to use Django Rest Framework (DRF) with Django models.

Now you might want to start learning more about DRF from its documentation. I
found that just starting with the documentation was rather challenging for me,
as there were some basic concepts assumed that I wasn't aware of. I thought in
this post, I'd go over some of them. Then I found I was getting deeper and
deeper into serialization, so this has ended up being all about serialization.

And to state some of my own assumptions up front: for this post, I'll be
assuming an API that uses JSON to transport data.

(If you've seen the
`first Tutorial on the DRF site <https://www.django-rest-framework.org/tutorial/1-serialization/>`_,
there is some overlap in what this post covers, but then this post digs deeper
into serialization while the DRF tutorial moves on to other aspects of building
an API.)

Serialization
-------------

In our Django application, we're working with Python objects, but for our
API we want to use a format called JSON to transport information over the
network. Serializing is the process of converting Python objects
to JSON, and deserializing is the process of converting JSON to Python objects
again.

(It might help to think of "serializing" as creating a "serial" stream of bytes
that can flow over a network connection, and "deserializing" as consuming a
serial stream of bytes and turning it into something more useful again.)

In DRF, serialization and deserialization are handled by the same class.
This kind of makes sense, give that you want deserialization to be the
reverse of serialization, but it can also be confusing.

It also turns out that writing a serializer class that can just serialize
is pretty trivial, but when you start wanting it to deserialize, all sorts
of complications appear.

Python class for examples
-------------------------

I'll use this tiny Python class for my first examples::

    class Thing:
        def __init__(self, id: int, b: str):
            self.id = a
            self.b = b

        def __str__(self):
            return '<Thing(%d, "%s")>' % (self.id, self.b)


How to serialize
----------------

The serializer class for Thing is pretty simple::

    from rest_framework import serializers

    class ThingSerializer(serializers.Serializer):
        id = serializers.IntegerField()
        b = serializers.CharField()

Now suppose we want to use it to serialize something. In this case, we want to start with a Thing
object, and end up with JSON.

To do this, we construct an instance of ThingSerializer, passing in our Thing
as the `instance` argument.
Then we can get the serialized data from the `.data` property of the serializer.

Example::

    a_thing = Thing(1, 'foo')
    serializer = ThingSerializer(instance=a_thing)
    data = serializer.data
    print(data)

    {
       'id': 1,
       'b': 'foo'
    }

There is no validation involved when serializing. It is assumed that the object
you are going to serialize is valid, and up to you to ensure that before you try
to serialize it.

How to deserialize
------------------

If we have a serialized form of a Thing and we want to get a Thing object from
it, we again use our ThingSerializer class, but in a different way.

To do this, we construct an instance of ThingSerializer, passing in the serialized
data as the `data` argument. Then we check the validity of the serialized data.
If it's valid, then we can get the deserialized data from the `.validated_data`
attribute.

Example::

    data = {'id': 1, 'b': 'foo'}
    serializer = ThingSerializer(data=data)
    serializer.is_valid(raise_exception=True)
    print(serializer.validated_data)

    {
       'id': 1,
       'b': 'foo'
    }

It is important to notice that in this case, validation is mandatory. DRF
won't let us do much until after we've called `.is_valid()`.

But wait a minute. We ended up here with a dictionary exactly the same as we
started with - weren't we expecting a Thing object? We were expecting that, but
it'll take a little more work on our part to get there. We'll get there.

For now, notice that what we got corresponds to how we defined the fields in
our serializer. `id` was an IntegerSerializer field and we got an integer, while
`b` was a CharSerializer field and we got a string. DRF has deserialized the
fields for us individually. What's missing is
putting all of them together into a Thing object, and DRF doesn't know how to
do that yet. We'll have to add some code for it.

How does it know
----------------

How does the serializer instance know whether it's supposed to serialize or
deserialize? It's entirely based on what was passed in when it was constructed -
if data was passed in, it will deserialize; otherwise, it will serialize.

How this is used in an API
--------------------------

At a very high level, if an API client submits a GET request to our application,
we'll end up finding the object they want, serializing it, and sending a response
with the serialized data as its body.

Similarly, if an API client wants to create an object, it'll submit a POST request
whose body contains the JSON data representing the object it wants to create.
Our app will validate the data, deserialize it, and add the object to the database.
The URI path of the POST request tells us what kind of thing it is,
and where to store it.

Let's go into a little more detail about how serializers are used when creating
an object. DRF will handle a lot of this for us if we use its ModelSerializer and
ViewSet classes, but it's good to understand this for writing serializer tests and
to better understand what's happening when you start customizing serializers more.

We'll need to expand our serializer class a bit, and when we're done, we will be
able to get a Thing object from our serialized data. The updated class::

    from rest_framework import serializers

    class ThingSerializer(serializers.Serializer):
        id = serializers.IntegerField()
        b = serializers.CharField()

        def create(self, validated_data):
            return Thing(**validated_data)

We added a `create` method, which is given the validated data,
and must return the final Python object that corresponds to
that data.

If this was a Django application and Thing was a model, then create
would also be expected to save the new Thing before returning.

And here's how we use it to create a Thing::

    data = {'id': 1, 'b': 'foo'}
    serializer = ThingSerializer(data=data)
    serializer.is_valid(raise_exception=True)
    a_thing = serializer.save()
    print(str(a_thing))

    <Thing(1, "foo")>

So the full process is to construct a serializer passing the data as the
`data` argument, validate it, and call `save` to create and return the
final, deserialized Python object.

Changing an object
------------------

Let's see how we'd implement changing one of the fields on an existing Thing.

The way an API client might do this is to GET a URI path that points
to an existing Thing, change a value on its copy of the Thing, then
make a PUT request, using the same URI path, and putting the serialized
form of its edited Thing as the request body.

I'm going to ignore the code we need that finds the existing Thing that the
client is interested in. So here's how we might handle the
PUT::

    existing_thing = Thing(27, 'three')
    data = {'id': 13, 'b': 'three'}
    serializer = ThingSerializer(instance=existing_thing, data=request.data)
    serializer.is_valid(raise_exception=True)
    updated_thing = serializer.save()

Notice that this time, we passed *both* an instance and some serialized data
to our serializer constructor. This tells it that we want to make changes to
the instance based on the serialized data.

If we try to run this, we'll get an error::

    NotImplementedError: `update()` must be implemented.

Like `create`, we have to write our own `update` method.::

    from rest_framework import serializers

    class ThingSerializer(serializers.Serializer):
        id = serializers.IntegerField()
        b = serializers.CharField()

        def create(self, validated_data):
            return Thing(**validated_data)

        def update(self, instance, validated_data):
            thing = instance
            thing.id = validated_data['id']
            thing.b = validated_data['b']
            return thing

DRF passes the validated data to our `update` object, the same as it
does for our `create` method, along with the original object.
Our `update` method must make changes to the original
object, then return it.

If this was a Django application and Thing was a model, then update
would also be expected to save the updated Thing before returning.

Trying again::

    existing_thing = Thing(27, 'three')
    data = {'id': 13, 'b': 'three'}
    serializer = ThingSerializer(instance=existing_thing, data=data)
    serializer.is_valid(raise_exception=True)
    updated_thing = serializer.save()
    print(str(updated_thing))

    <Thing(13, "three")>

We've changed the value of Thing's `id` field from 27 to 13.

Validation
----------

This is an area of DRF where I felt I had to figure a lot out by trial and
error.

Keep in mind that validation only applies to deserializing.

There are definite parallels between DRF validation and Django form validation.

DRF's field validation
......................

The first thing that DRF does is validate the input data for each field defined
on the serializer.  Any additional input data is simply ignored.

Some of this is really obvious, such as providing a string as
the value for an IntegerField is not valid.

Starting to nest
----------------

Where I really start to get confused in DRF is when we have nested objects.
Let's add another class to our example application::

    class Box:
        def __init__(self, id: int, thing: Thing):
           this.id = id
           this.thing = thing

        def __str__(self):
           return '<Box(%d, "%s")>' % (self.id, self.thing)

The Box class has an identifier and a reference to a Thing.

A basic serializer for a Box might look like this::


    from rest_framework import serializers

    class BoxSerializer(serializers.Serializer):
        id = serializers.IntegerField()
        thing = ThingSerializer()

Notice that we are using the ThingSerializer we already defined as a field
in our new serializer.

Let's make a Box and serialize it.::

    box = Box(2, Thing(5, 'drf'))
    serializer = BoxSerializer(instance=box)
    data = serializer.data
    print(data)

    {'id': 2, 'thing': OrderedDict([('a', 5), ('b', 'drf')])}

DRF uses an OrderedDict rather than a normal dict to serialize our
Thing for some reason, but otherwise, this looks about as we'd expect.
(`OrderedDict([('a', 5), ('b', 'drf')])` is basically `{'a': 5, 'b': 'drf'}`.)

As I hinted earlier, serializing is pretty straightforward. What
about deserializing? Let's add a `create` method::


    from rest_framework import serializers

    class BoxSerializer(serializers.Serializer):
        id = serializers.IntegerField()
        thing = ThingSerializer()

        def create(self, validated_data):
           return Box(**validated_data)

That looks pretty simple, actually.

The thing is, fetching and creating objects will only take us so far.
Pretty soon, we'll want to make changes to existing objects.


Representing nested objects
---------------------------

Earlier, I skimmed over something that we should think about now.
That is, there are multiple ways we could serialize nested objects.
The way we wrote our serializer, we represent the `thing` field's
value by a fully serialized Thing. But we could just as well have
used anything that would identify for us which Thing our Box is
pointing at. In a Django app, we might well use a record's `id`
rather than serializing the entire record.

Let's write an alternative serializer for our Box class that takes
that approach. Starting off::

    class BoxSerializer2(serializers.Serializer):
        id = serializers.IntegerField()
        thing = serializers.IntegerField(source='thing.id')

We're just going to "serialize" the Thing using the value of its
`id` field. DRF has built-in support for this sort of thing, so we
can just add the `source` parameter to our serializer arguments.
Let's see what we get::


    box = Box(2, Thing(5, 'drf'))
    serializer = BoxSerializer2(instance=box)
    data = serializer.data
    print(data)

    {'id': 2, 'thing': 5}

Perfect!

Deserializing gets more complicated. When we get a `5` in our data,
we want to find the existing Thing where `id = 5` and use that instead.

We can start with creating new Boxes, but before we write `create`, we
need to know what's going to be in `validated_data` when we get it.
DRF is going to do the best it can to deserialize the individual
fields before passing them to us. For `thing`, it will actually
create a dictionary with an `id` field equal to the value it got
for `thing`::

    {'id': 2, 'thing': {'id': 5}}

Knowing that, we can write `create`::

    class BoxSerializer2(serializers.Serializer):
        id = serializers.IntegerField()
        thing = serializers.IntegerField(source='thing.id')

        def create(self, validated_data):
            thing = get_existing_thing(id=validated_data['thing']['id'])
            return Box(id=validated_data['id'], thing=thing)

We're assuming some method `get_existing_thing(id=...)` does the heavy
lifting in finding an existing Thing for us.

Trying it out in a simpler way::

    data = {'id': 2, 'thing': 5}
    serializer = BoxSerializer2(data=data)
    serializer.is_valid(raise_exception=True)
    box = serializer.save()
    print(str(box))

    <Box(2, <Thing(5, "existing")>)>

We can see that where the serialized data had `thing = 5`, we ended
up with the Thing object with `id = 5`, as we wanted.

Continuing with serializing the `thing` field of our Box as just
the `id` value of our `Thing`, what if we want to update our Box?
Keeping in mind that the only thing we can really update this way
is which Thing our box is pointing at, here's the updated BoxSerializer2::


    class BoxSerializer2(serializers.Serializer):
        id = serializers.IntegerField()
        thing = serializers.IntegerField(source='thing.a')

        def create(self, validated_data):
            thing = get_existing_thing(id=validated_data['thing']['id'])
            return Box(id=validated_data['id'], thing=thing)

        def update(self, instance, validated_data):
            instance.id = validated_data['id']
            instance.thing = get_existing_thing(id=validated_data['thing']['id'])
            return instance

Let's try it out::

    thing1 = Thing(1, "thing1")
    thing2 = Thing(2, "thing2")
    box = Box(3, thing1)
    print(str(box))

    <Box(3, <Thing(1, "thing1")>)>

    data = {'id': 3, 'thing': 2}
    serializer = BoxSerializer2(instance=box, data=data)
    serializer.is_valid(raise_exception=True)
    box = serializer.save()
    print(str(box))

    <Box(3, <Thing(2, "existing")>)>

We can see that the box was changed to point at a different Thing.

Actual nesting
--------------

What we've done so far isn't so much nested serialized objects as replacing an
object with an integer that identifies the object. This is sufficient - our client
can always make a second call to get the details of the Thing whose `id` is 5 - but
for greater convenience, we might want to return the details of the Thing as part
of the serialized Box. As you can probably guess, we can do that.

Let's write a new serializer, BoxSerializer3, that does that::

    class BoxSerializer3(serializers.Serializer):
        id = serializers.IntegerField()
        thing = ThingSerializer()

    thing = Thing(7, "seven")
    box = Box(3, thing)
    data = BoxSerializer3(instance=box).data
    print(data)

    {'id': 3, 'thing': OrderedDict([('a', 7), ('b', 'seven')])}

NOW:
- how does DRF validate the new field itself?
- what gets passed to 'validate'
- what gets passed to 'create'/'update'?
