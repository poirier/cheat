
# Tutorial on serialization in Django Rest Framework

In [his blog post](https://www.caktusgroup.com/blog/2019/02/01/creating-api-endpoint-django-rest-framework/),
my colleague Dmitriy gave a good example of starting to use 
[Django Rest Framework](https://www.django-rest-framework.org/) (DRF) with Django models.

Now you might want to start learning more about DRF from its documentation. I
found that just starting with the documentation was rather challenging for me,
as there were some basic concepts assumed that I wasn't aware of. I thought in
this post, I'd go over some of them. Then I found I was getting deeper and
deeper into serialization, so this has ended up being all about serialization.

And to state some of my own assumptions up front: for this post, I'll be
assuming an API that uses JSON to transport data, and Python 3.

(If you've seen the
[first Tutorial on the DRF site](https://www.django-rest-framework.org/tutorial/1-serialization/),
there is some overlap in what this post covers, but then this post digs deeper
into serialization while the DRF tutorial moves on to other aspects of building
an API.)

## Serialization

In our Django application, we're working with Python objects, but for our
API we want to use a format called JSON to transport information over the
network. Serializing is the process of converting Python objects
to JSON, and deserializing is the process of converting JSON to Python objects
again.

(It helps me to think of "serializing" as creating a "serial" stream of bytes
that can flow over a network connection, and "deserializing" as consuming a
serial stream of bytes and turning it into something more useful again.)

In DRF, serialization and deserialization are handled by the same class.
This kind of makes sense, give that you want deserialization to be the
reverse of serialization, but it can also be confusing.

It also turns out that writing a serializer class that can just serialize
is pretty trivial, but when you start wanting it to deserialize, all sorts
of complications appear.

## Minimal Django environment

While I won't be doing much with Django directly in this post, Django Rest Framework does assume that it's running in a configured Django environment and without it, useful things like error messages don't work. 

The following snippet at the top of a file will set up a very minimal Django environment, enough for us to experiment with DRF without having to set up a complete Django project. I got this from [_Lightweight Django_](http://shop.oreilly.com/product/0636920032502.do), by Julia Elman and Mark Lavin
(both past co-workers of mine), O'Reilly, 2014.


```python
from django.conf import settings
settings.configure(
 DEBUG=True,
 SECRET_KEY='thisisthesecretkey',
 #ROOT_URLCONF=__name__,
 MIDDLEWARE_CLASSES=(
 'django.middleware.common.CommonMiddleware',
 'django.middleware.csrf.CsrfViewMiddleware',
 'django.middleware.clickjacking.XFrameOptionsMiddleware',
 ),
)
```

## Python class for examples

I'll use this tiny Python class for my first examples:


```python
from dataclasses import dataclass

@dataclass
class Thing:
    id: int
    b: str

    def __str__(self):
        return '<Thing(%d, "%s")>' % (self.id, self.b)
```

## How to serialize

The serializer class for Thing can be pretty simple.


```python
from rest_framework import serializers

class ThingSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    b = serializers.CharField()
```

Now suppose we want to use it to serialize something. In this case, we want to start with a Thing
object, and end up with JSON.

To do this, we construct an instance of ThingSerializer, passing in our Thing
as the `instance` argument.
Then we can get the serialized data from the `.data` property of the serializer.

Example:


```python
a_thing = Thing(1, 'foo')
serializer = ThingSerializer(instance=a_thing)
data = serializer.data
print(data)
```

    {'id': 1, 'b': 'foo'}


The output of a DRF serializer is actually not quite serialized bytes yet, but a Python object ready to be rendered
as JSON, or if you like, YAML, XML, and many other options. Let's see that last step, though we'll omit it in most of our examples.  We do this by using a [DRF Renderer](https://www.django-rest-framework.org/api-guide/renderers/).


```python
from rest_framework import renderers

renderer = renderers.JSONRenderer()

print(renderer.render(data))
```

    b'{"id":1,"b":"foo"}'


Now we have raw bytes, ready to be sent over a TCP connection, saved to a file, or whater
you need. If we had non-ASCII text in our data, it would now be encoded, using UTF-8 by default.

Note that there is no validation involved when serializing. It is assumed that the object
you are going to serialize is valid, and up to you to ensure that before you try
to serialize it.

## How to deserialize

If we have a serialized form of a Thing and we want to get a Thing object from
it, we again use our ThingSerializer class, but in a different way.

To do this, we construct an instance of ThingSerializer, passing in the serialized
data as the `data` argument. Then we check the validity of the serialized data using `.is_valid()`.
If it's valid, then we can get the deserialized data from the `.validated_data`
attribute.

Here's an example, in which we start from raw bytes, parse them from JSON
using a [DRF Parser](https://www.django-rest-framework.org/api-guide/parsers/), 
and deserialize them.


```python
from io import BytesIO
from rest_framework import parsers
parser = parsers.JSONParser()

bits = b'{"id": 1, "b": "foo"}'
data = parser.parse(BytesIO(bits))
print(data)

serializer = ThingSerializer(data=data)
serializer.is_valid(raise_exception=True)
print(serializer.validated_data)
```

    {'id': 1, 'b': 'foo'}
    OrderedDict([('id', 1), ('b', 'foo')])


It is important to notice that in this case, validation is mandatory. DRF
won't let us do much until after we've called `.is_valid()`.

Also note that in this case, the serializer returned an `OrderedDict` instead
of a plain dictionary. This lets us know the order of the fields in the
original serialized data, in case that's important to us.  Although it's moot
in this case, since ordering is not (supposed to be) significant in JSON and
the JSON parser does *not* preserve ordering, so we end up just passing an ordinary
dict to the serializer. Still, the serializer preserves
ordering itself, in case it was significant. From here on, we'll just consider
an OrderedDict the equivalent of a dict in our examples.

But wait a minute. We ended up here with basically the same dictionary that we
started with. We were expecting a Thing object, but
it'll take a little more work on our part to get there.

For now, notice that what we got corresponds to how we defined the fields in
our serializer. `id` was an IntegerSerializer field and we got an integer, while
`b` was a CharSerializer field and we got a string. DRF has deserialized the
fields for us individually. What's missing is
putting all of them together into a Thing object, and DRF doesn't know how to
do that yet. We'll have to add some code for it.

## How does it know

How does the serializer instance know whether it's supposed to serialize or
deserialize? It's entirely based on what was passed in when it was constructed -
if data was passed in, it will deserialize; otherwise, it will serialize.
(It's also possible to pass in both data and an instance of an object if we
want to update an existing object. We'll get to that.)

## How this is used in an API

At a very high level, if an API client submits a GET request to our application,
we'll end up finding the object they want, serializing it, and sending a response
with the serialized data as its body.
The URI path of the GET request tells us what kind of thing we want,
and where to find it.

Similarly, if an API client wants to create an object, it'll submit a POST request
whose body contains the JSON data representing the object it wants to create.
Our app will validate the data, deserialize it, and store the object.
The URI path of the POST request tells us what kind of thing it is.

And if an API client wants to change an existing object, it'll submit a PUT request,
using the same URL it would use to GET the existing object, but the PUT will
contain in its request body the serialized data for the updated object.

An API client can even submit a PATCH request the same way, and only provide
in the request body the data for the fields it wants to change. Other fields will
be left unchanged.

## Creating a new object

Let's go into a little more detail about how serializers are used when creating
an object. DRF will handle a lot of this for us if we use its ModelSerializer and
ViewSet classes, but it's good to understand this for writing serializer tests and
to better understand what's happening when you start customizing serializers more.

We'll need to expand our serializer class a bit, and when we're done, we will be
able to get a Thing object from our serialized data. 

The updated class:


```python
from rest_framework import serializers

class ThingSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    b = serializers.CharField()

    def create(self, validated_data):
        return Thing(**validated_data)
```

We added a `create` method, which is given the validated data,
and must return the final Python object that corresponds to
that data.

If this was a Django application and Thing was a model, then `create`
would also be expected to save the new Thing before returning.
We might change `return Thing(**validated_data)` to
`return Thing.objects.create(**validated_data)`

And here's how we use it to create a Thing:


```python
data = {'id': 1, 'b': 'foo'}
serializer = ThingSerializer(data=data)
serializer.is_valid(raise_exception=True)
a_thing = serializer.save()
print(str(a_thing))
```

    <Thing(1, "foo")>


So the full process is to construct a serializer passing the data as the
`data` argument, validate it, and call `save` to create and return the
final, deserialized Python object.

But this is a bit too simple. Thinking about Django for a minute, when we create
a new record, we don't provide the value for `id`; we expect the database to
do that for us. But as we've written this, the API client must provide an `id`,
and if we were storing these in a database, it'd probably be forced to figure out
an `id` that's not already in use. We want this to work more like Django, so
let's make a few more changes.

First, we'll modify our example Thing class to behave a bit more as if it were
a Django model, generating its own `id` value if one is not provided:


```python
from dataclasses import field
from random import randint

def random_id():
    return randint(1, 99999)

@dataclass
class Thing:
    b: str
    id: int = field(default_factory=random_id)

    def __str__(self):
        return '<Thing(%d, "%s")>' % (self.id, self.b)
```


```python
print(Thing(b='test creating an id'))
```

    <Thing(73980, "test creating an id")>


Now, we'll modify our serializer.


```python
class ThingSerializer(serializers.Serializer):
    id = serializers.IntegerField(required=False)
    b = serializers.CharField()

    def validate_id(self, value):
        # Are we trying to create a new thing?
        if not self.instance and value:
            raise serializers.ValidationError('Cannot specify id when creating new thing')
        return value
    
    def create(self, validated_data):
        return Thing(**validated_data)
```

Let's try providing an id when we create a thing and see what happens:


```python
data = {'id': 1, 'b': 'bad data'}
serializer = ThingSerializer(data=data)
serializer.is_valid(raise_exception=True)
```


    ---------------------------------------------------------------------------

    ValidationError                           Traceback (most recent call last)

    <ipython-input-12-649c059160bb> in <module>
          1 data = {'id': 1, 'b': 'bad data'}
          2 serializer = ThingSerializer(data=data)
    ----> 3 serializer.is_valid(raise_exception=True)
    

    ~/.virtualenvs/cheat/lib/python3.7/site-packages/rest_framework/serializers.py in is_valid(self, raise_exception)
        242 
        243         if self._errors and raise_exception:
    --> 244             raise ValidationError(self.errors)
        245 
        246         return not bool(self._errors)


    ValidationError: {'id': [ErrorDetail(string='Cannot specify id when creating new thing', code='invalid')]}


Good, we get a ValidationError. Now, let's try it the right way.


```python
data = {'b': 'create a new thing with its own id'}
serializer = ThingSerializer(data=data)
serializer.is_valid(raise_exception=True)
thing = serializer.save()
print(thing)
```

If that seems like more work that we ought to have to do, it is.
DRF provides a `ModelSerializer` variant of a serializer class that
has most of this behavior built-in. But I think it's important to
understand that this is going on "behind the scenes".

Changing an object
------------------

Let's see how we'd implement changing one of the fields on an existing Thing.

The way an API client might do this is to GET a URI path that points
to an existing Thing, change a value on its copy of the Thing, then
make a PUT request, using the same URI path, and putting the serialized
form of its edited Thing as the request body.

Here's how we might handle the PUT (ignoring for now the problem of
finding the existing thing to modify). Like `create`, we have to write our own `update` method.
Then we can pass both an instance and a data object to the serializer, and
saving will update the instance using the data by calling our
`update` method.


```python
from rest_framework import serializers

class ThingSerializer(serializers.Serializer):
    id = serializers.IntegerField(required=False)
    b = serializers.CharField()

    def validate_id(self, value):
        # Are we trying to create a new thing?
        if not self.instance and value:
            raise serializers.ValidationError('Cannot specify id when creating new thing')
        return value

    def create(self, validated_data):
        return Thing(**validated_data)

    def update(self, instance, validated_data):
        thing = instance
        thing.__dict__.update(validated_data)
        return thing
```


```python
existing_thing = Thing(id=27, b='three')
data = {'id': 13, 'b': 'three'}
serializer = ThingSerializer(instance=existing_thing, data=data)
serializer.is_valid(raise_exception=True)
updated_thing = serializer.save()
print(str(updated_thing))
```

DRF passes the validated data to our `update` method, the same as it
does for our `create` method, along with the original object.
Our `update` method must make changes to the original
object, then return it.

But again, this is too simple. If we pass an `id` value as part of
our data, it will happily change the `id` on our Thing. If this were
a Django model, that would not be what we'd want. So on update, it
turns out we also want to prohibit passing a value in our data for
`id`:


```python
from rest_framework import serializers

class ThingSerializer(serializers.Serializer):
    id = serializers.IntegerField(required=False)
    b = serializers.CharField()

    def validate_id(self, value):
        # Are we trying to create a new thing?
        if not self.instance and value:
            raise serializers.ValidationError('Cannot specify id when creating new thing')
        # Are we trying to update an existing thing?
        if self.instance and value:
            raise serializers.ValidationError('Cannot specify id when updating a thing')
        return value

    def create(self, validated_data):
        return Thing(**validated_data)

    def update(self, instance, validated_data):
        thing = instance
        thing.__dict__.update(validated_data)
        return thing
```


```python
existing_thing = Thing(id=27, b='three')
data = {'id': 13, 'b': 'three'}
serializer = ThingSerializer(instance=existing_thing, data=data)
serializer.is_valid(raise_exception=True)
```

But that's going too far. Our client would like to be able to GET the current
thing, change the value of `b`, then PUT the updated data. The way we have
written this, the client would be forced to first delete the `id` field from
the data. If the `id` field is unchanged, then it's harmless, so let's allow that.


```python
from rest_framework import serializers

class ThingSerializer(serializers.Serializer):
    id = serializers.IntegerField(required=False)
    b = serializers.CharField()

    def validate_id(self, value):
        # Are we trying to create a new thing?
        if not self.instance and value:
            raise serializers.ValidationError('Cannot specify id when creating new thing')
        # Are we trying to update an existing thing?
        if self.instance and value != self.instance.id:
            raise serializers.ValidationError('Cannot change id when updating a thing. Current id is %r, new id is %r' % (self.instance.id, value))
        return value

    def create(self, validated_data):
        return Thing(**validated_data)

    def update(self, instance, validated_data):
        thing = instance
        thing.__dict__.update(validated_data)
        return thing
```


```python
existing_thing = Thing(id=27, b='three')
data = {'id': 27, 'b': 'three'}
serializer = ThingSerializer(instance=existing_thing, data=data)
serializer.is_valid(raise_exception=True)
```

If this was a Django application and Thing was a model, then `update`
would also be expected to save the updated Thing before returning.

Notice that this time, we passed *both* an instance and some serialized data
to our serializer constructor. This tells it that we want to make changes to
the instance based on the serialized data.


We've changed the value of Thing's `id` field from 27 to 13.

## Validation

Validation is an area of DRF where I had to figure a lot out by trial and error.

Keep in mind that validation only applies to deserializing.

There are definite parallels between DRF validation and Django form validation,
but some important differences as well.

### DRF's field validation

The first thing that DRF does is validate the input data for each field defined
on the serializer. Any additional input data is simply ignored.

Some of this is really obvious, such as providing a string as
the value for an IntegerField is not valid.

If the data passes validation, then `.validated_data`, and the data passed
to `.create()` and `.update()`, will be a dictionary with a key for each field
defined on the serializer, whose value is the *serialized* data for that field.

*Note* this is a difference from Django forms. Part of Django form validation
is to convert the input data from the form into corresponding Python data
types, but DRF does not do this during validation.

## Nesting objects using keys

There are multiple ways we can represent nested objects when we serialize. Let's add another
class to our example and then briefly go over them.


```python
@dataclass
class Box:
    id: int
    thing: Thing

    def __str__(self):
       return '<Box(%d, "%s")>' % (self.id, self.thing)
```

The Box class has an identifier and a reference to a Thing.

Our Thing class has an `id` field, and if we assume for a moment that
these are Django models, we know that all we need is the `id` value and
we can fetch the entire Thing from the database. So we can serialize
a Box most simply by just using the `id` from our Thing:


```python
from rest_framework import serializers

class BoxSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    thing = serializers.IntegerField(source='thing.id')
```

The `source` argument on a field, as you might guess, in this case tells DRF to access the `id` attribute
on the `thing` attribute of the object being serialized.

Let's make a Box and serialize it.


```python
box = Box(2, Thing(5, 'drf'))
serializer = BoxSerializer(instance=box)
data = serializer.data
print(data)
```

This looks about as we'd expect.
DRF has made the value of 'thing' be the id from our thing.

As I hinted earlier, serializing is pretty straightforward. What
about deserializing? Let's add a `create` method.


```python
def get_existing_thing(id: int) -> Thing:
    """Dummy 'get_existing_thing' method."""
    return Thing(id, 'existing')

class BoxSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    thing = ThingSerializer()

    def create(self, validated_data):
        thing = get_existing_thing(id=validated_data['thing']['id'])
        return Box(id=validated_data['id'], thing=thing)

thing = Thing(1, 'two')
ser = BoxSerializer(data={'id': 1, 'thing': ThingSerializer(thing).data})
ser.is_valid(raise_exception=True)
box = ser.save()
print(box)
print(box.thing)
```

We're assuming some method `get_existing_thing(id=...)` does the heavy
lifting in finding an existing Thing for us. In Django, it would probably
just be `Thing.objects.get(id=id)`.

Here's a place where DRF's behavior confuses me.

When we validate the data in which we've just represented the Thing
as an `IntegerField` with `source='thing.id'`, validation gives us back
not the same integer as I was expecting, but a dictionary with
`{'id': <value of integer field>}`.  That's why we had to use
`validated_data['thing']['id']` to get the value of `id` and not
just `validated_data['id']`.

Continuing with serializing the `thing` field of our Box as just
the `id` value of our `Thing`, what if we want to update our Box?
Keeping in mind that for the `thing` field, all we can really update this way
is which Thing our box is pointing at, we need to add
an ``update`` method to our serializer again::


```python
class BoxSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    thing = serializers.IntegerField(source='thing.id')

    def create(self, validated_data):
        thing = get_existing_thing(id=validated_data['thing']['id'])
        return Box(id=validated_data['id'], thing=thing)

    def update(self, instance, validated_data):
        instance.id = validated_data['id']
        instance.thing = get_existing_thing(id=validated_data['thing']['id'])
        return instance
```

Let's try it out:


```python
thing1 = Thing(1, "thing1")
thing2 = Thing(2, "thing2")
box = Box(3, thing1)
print(str(box))

data = {'id': 3, 'thing': 2}
serializer = BoxSerializer(instance=box, data=data)
serializer.is_valid(raise_exception=True)
box = serializer.save()
print(str(box))
```

We can see that the box was changed to point at a different Thing.

## Nested serialized objects

Representing nested objects using a key works well. After all, relational databases
have worked this way for decades. It might mean a few more queries, since we might have
to make another call to get the object represented by a key or update it, but generally our
application code has had a short network path to our database server, so the queries
can be pretty quick.

But in a modern app, our API's client might be a user's
browser, and that might be a long way from our server, compared to the network distance
between our web server and our database. So requiring many small API calls to get anything
done, where each call requires the latency of a complete round trip between the browser
and our web server, could have a negative effect on our app's performance.

This is one reason why we might consider it worthwhile to add the complexity
to our API of nesting entire serialized objects.

To make things more concrete, I'm going to start a new series of examples.


```python
from dataclasses import dataclass
from decimal import Decimal

from rest_framework import serializers

@dataclass
class Person:
    id: int
    name: str
    email: str

@dataclass
class Account:
    id: int
    owner: Person
    balance: Decimal

class PersonSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField()
    email = serializers.EmailField()
    
class AccountSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    balance = serializers.DecimalField(max_digits=10, decimal_places=2)
    owner = PersonSerializer()
```

Here we have very simple Person and Account classes, where the Account has a Person as owner.

Anywhere you might use a serializer field in DRF, you can instead use a serializer.
I'd have prefered to keep the two types more distinct (but nobody asked me).

So if we want to nest a serialized person in our serialized account, we just
tell DRF that the owner field on the account should be serialized using
`PersonSerializer`.


```python
person = Person(id=1, name='Fred', email='fred@example.com')
account = Account(id=1, balance=Decimal(50), owner=person)
print(AccountSerializer(instance=account).data)
```

As we've seen before, serializing is generally pretty straightforward. But with
entire nested objects, deserializing and creating a new object will have some
new complications.  Let's update our serializers with basic `create` methods.


```python
class PersonSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField()
    email = serializers.EmailField()
    
    def create(self, validated_data):
        return Person(**validated_data)
    
class AccountSerializer(serializers.Serializer):
    balance = serializers.DecimalField(max_digits=10, decimal_places=2)
    owner = PersonSerializer()
    
    def create(self, validated_data):
        owner_serializer = PersonSerializer(data=validated_data.pop('owner'))
        owner_serializer.is_valid(raise_exception=True)
        validated_data['owner'] = owner_serializer.save()
        return Account(**validated_data)
```

We have some new code in `AccountSerializer.create` that first creates a person from
the 'person' part of the validated_data, then uses that in creating the account. It's
a little more code, but still fairly straightforward.

But let's think about this a bit. This assumes that every time we create a new Account,
we also want to create a new Person at the same time. That's probably not a valid
assumption.

Worse, 

NOW:
- how does DRF validate the new field itself?
- what gets passed to 'validate'
- what gets passed to 'create'/'update'?

