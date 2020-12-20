Django REST Framework - Serializers
===================================

In general, I feel like the DRF documentation is not explicit enough about
what I see as the two sides of its interfaces: the Python side and the
serialized side.

For example, the documentation for field-level validators on serializers
says "These methods take a single argument, which is the field value that requires validation."
but don't say whether the "field value" is the Python value or the "serialized" value.

I would expect that serializers are validating serialized values that need to
be deserialized, since

* we can probably assume the Python side values we're sending in are valid
* we should not have to validate outputs
* so that leaves the serialized data on input, which is quite likely to be
  invalid at times, as the only thing we could be validating.

But what do I get when I look at value? Sometimes, something like this::

   {
     'fieldA': 12,
     'fieldB': 'string',
     'fieldC': <A Python object>
   }

I cannot fathom why this would ever be passed to a method that is supposed to
be validating serialized data, since it contains a mix of serialized data and
Python objects.

URLs from viewsets
------------------

WRITE ME

Relationship between serializers and API calls
----------------------------------------------

It's helpful to know what DRF does with its views,
serializers, etc when a user of the API makes various
calls.

Let's assume a very simple model and serializer::

    class Thing(models.Model):
        text = models.TextField()

    class ThingSerializer(ModelSerializer):
        class Meta:
            model = Thing

Getting an existing object
~~~~~~~~~~~~~~~~~~~~~~~~~~

Suppose we request ``GET /api/obj/27/``. Here's some of the DRF
code that gets invoked::

    # rest_framework/mixins.py
    class RetrieveModelMixin(object):
        """
        Retrieve a model instance.
        """
        def retrieve(self, request, *args, **kwargs):
            instance = self.get_object()
            serializer = self.get_serializer(instance)
            return Response(serializer.data)

    # rest_framework/generics.py
    class GenericAPIView(views.APIView):
        ...
        def get_serializer(self, *args, **kwargs):
            """
            Return the serializer instance that should be used for validating and
            deserializing input, and for serializing output.
            """
            serializer_class = self.get_serializer_class()
            kwargs['context'] = self.get_serializer_context()
            return serializer_class(*args, **kwargs)

To unwind and simplify that a little::

    # id is from the request URL
    instance = Thing.objects.get(id=id)
    serializer = ThingSerializer(instance)
    return serializer.data

and the returned data looks like::

    {'id': 1, 'text': 'Text'}

That's very straightforward.

Creating a new object
~~~~~~~~~~~~~~~~~~~~~

``POST /api/obj/`` with data ``{text: "foo"}}``::

    # rest_framework/mixins.py
    class CreateModelMixin(object):
        """
        Create a model instance.
        """
        def create(self, request, *args, **kwargs):
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

        def perform_create(self, serializer):
            serializer.save()

        def get_success_headers(self, data):
            try:
                return {'Location': str(data[api_settings.URL_FIELD_NAME])}
            except (TypeError, KeyError):
                return {}

Again, the simple version::

    serializer = ThingSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    serializer.save()
    return serializer.data

and the returned data looks like::

    {'id': 1, 'text': 'Text'}

PUTTING an object
~~~~~~~~~~~~~~~~~

``PUT /api/object/1/`` with data ``{id: 1, text: "new text"}``::


    class UpdateModelMixin(object):
        """
        Update a model instance.
        """
        def update(self, request, *args, **kwargs):
            partial = kwargs.pop('partial', False)
            instance = self.get_object()
            serializer = self.get_serializer(instance, data=request.data, partial=partial)
            serializer.is_valid(raise_exception=True)
            self.perform_update(serializer)

            if getattr(instance, '_prefetched_objects_cache', None):
                # If 'prefetch_related' has been applied to a queryset, we need to
                # forcibly invalidate the prefetch cache on the instance.
                instance._prefetched_objects_cache = {}

            return Response(serializer.data)

        def perform_update(self, serializer):
            serializer.save()

        def partial_update(self, request, *args, **kwargs):
            kwargs['partial'] = True
            return self.update(request, *args, **kwargs)

or::

    instance = self.get_object()  # uses PK from URL
    serializer = ThingSerializer(instance, data=request.data, partial=False)
    serializer.is_valid(raise_exception=True)
    serializer.save()
    return serializer.data

and the returned data looks like::

    {'id': 1, 'text': 'Text'}

PATCHing an object
~~~~~~~~~~~~~~~~~~

Close enough to PUT for now.

Nested objects
~~~~~~~~~~~~~~

Nested objects are where things get more complicated. Let's
add another model, serializer, and view::

    class Wrapper(models.Model):
        thing = models.ForeignKey(Thing, on_delete=models.PROTECT)
        other = models.TextField()

    class WrapperSerializer(ModelSerializer):
        class Meta:
            fields = ['id', 'thing', 'other']
            model = Wrapper

    class WrapperView(ModelViewSet):
        serializer_class = WrapperSerializer
        queryset = Wrapper.objects.all()

If we try just serializing a wrapper::

    wrapper = Wrapper.objects.create(
        thing=Thing.objects.create(
            text='foo'
        ),
        other='bar')
    print(WrapperSerializer(instance=wrapper).data)

The output is::

    {'id': 1, 'thing': 1, 'other': 'bar'}

We'd probably prefer to see the Thing object's contents in there,
which we can do by
`setting depth <https://www.django-rest-framework.org/api-guide/serializers/#specifying-nested-serialization>`_::

    class WrapperSerializer(ModelSerializer):
        class Meta:
            depth = 1
            fields = ['id', 'thing', 'other']
            model = Wrapper

and now we get::

    {'id': 1, 'thing': {'id': 1, 'text': 'foo'}, 'other': 'bar'}

Which looks reasonable.

Now suppose we try creating a new Wrapper object from scratch::

    data = {
        'other': 'Other text',
        'thing': {
            'text': 'thing text'
        }
    }
    serializer = WrapperSerializer(data=data)
    serializer.is_valid(raise_exception=True)

That will fail::

    ValidationError: {'model': [ErrorDetail(string='Incorrect type. Expected pk value, received dict.', code='incorrect_type')]}

Maybe DRF expects an ID in the data for model? Which would mean creating one first.::

        thing_data = {'text': 'thing text'}
        thing_serializer = ThingSerializer(data=model_data)
        thing_serializer.is_valid(raise_exception=True)
        thing = thing_serializer.save()

        data = {
            'other': 'Other text',
            'thing': {
                'id': thing.id,
                'text': 'thing text'
            }
        }
        serializer = WrapperSerializer(data=data)
        serializer.is_valid(raise_exception=True)

But this doesn't seem to be good enough::

    ValidationError: {'model': [ErrorDetail(string='Incorrect type. Expected pk value, received dict.', code='incorrect_type')]}

Maybe we have to do pass just the PK of the model object to use the serializer as-is::

        thing_data = {'text': 'thing text'}
        thing_serializer = ThingSerializer(data=model_data)
        thing_serializer.is_valid(raise_exception=True)
        thing = thing_serializer.save()

        data = {
            'other': 'Other text',
            'thing': thing.id
        }
        serializer = WrapperSerializer(data=data)
        serializer.is_valid(raise_exception=True)
        instance = serializer.save()
        print(data)

No, that fails too::

    IntegrityError: NOT NULL constraint failed: drf_wrapper.model_id

Apparently the model ID is not getting where it needs to be.

Ah, this comment::

        The default implementation also does not handle nested relationships.
        If you want to support writable nested relationships you'll need
        to write an explicit `.create()` method.

in the DRF code seems to cover this - ModelSerializer does not
support writable nested relationships?  Though, we've giving it
an ID to put into the foreignkey field, it doesn't seem as if it
should need to do anything special.  But it does, I guess.

If we create a ModelSerializer for Wrapper without overriding
any of the fields, here's what DRF gives us::

    WrapperSerializer():
        id = IntegerField(label='ID', read_only=True)
        thing = NestedSerializer(read_only=True):
            id = IntegerField(label='ID', read_only=True)
            text = CharField(style={'base_template': 'textarea.html'})
        other = CharField(style={'base_template': 'textarea.html'})

What is this NestedSerializer? It's not documented, though it's
mentioned in the DRF 3.2.0 release notes.  Whatever it is, it
doesn't do what we want.

Let's try this serializer::

    class WrapperSerializer(ModelSerializer):
        class Meta:
            depth = 1
            fields = ['id', 'thing', 'other']
            model = Wrapper

        thing = ThingSerializer()

This gives us::

    The `.create()` method does not support writable nested fields by default.
    Write an explicit `.create()` method for serializer `drf.serializers.WrapperSerializer`, or set `read_only=True` on nested serializer fields.

So let's do that::

    class WrapperSerializer(ModelSerializer):
        class Meta:
            depth = 1
            fields = ['id', 'thing', 'other']
            model = Wrapper

        thing = ThingSerializer()

        def create(self, validated_data):
            thing_data = validated_data.pop('model')
            thing_serializer = ThingSerializer(data=thing_data)
            thing_serializer.is_valid(raise_exception=True)
            validated_data['thing'] = thing_serializer.save()
            instance = super().create(validated_data)
            return instance

Now if we pass in::

    {'other': 'Other text', 'thing': {'text': 'thing text'}}

We end up with a Thing object, and a Wrapper object whose
thing field points to that new Thing object.

Nesting an existing object
~~~~~~~~~~~~~~~~~~~~~~~~~~

We've worked out the non-obvious way to implement creating a new
object with a new nested object.  Now suppose we want to create a
new object, but have it point to an existing object. Will what
we have do what we want?

No, it will not. We might think we could tweak our create()
method to look for an 'id' in the nested object data, but
our create() method is not being given an 'id' in its
validated_data even if we provided one.

We pass in::

    {'other': 'Some text', 'thing': {'id': 1, 'text': 'thing!'}}

but validated_data as passed to clean() is::

    {'other': 'Some text', 'thing': OrderedDict([('text', 'thing!')])}

Just for grins, we can try just passing::

    {'other': 'Some text', 'thing': 1}

but that doesn't work any better now than it did before.

What if we temporarily get rid of our "depth"?

