# Django Rest Framework Surprises

These are things I found surprising or hard to understand in
learning Django Rest Framework serializers.

The analogy between Django forms and DRF serializers is real, but
only goes so far.

One big difference is what format the data is
given to your validation functions. In forms, the data has already
been converted from its simple form submission format into Python
objects like model instances.

However, in DRF, the format given to validation functions depends on
how that particular field on the serializer is declared.

It's straightforward for the most basic fields, like IntegerFields -
you get an integer.

If you have a PrimaryKeyRelatedField, you get a model instance (or
validation fails before getting to your validation code if the key
given is not valid).

But if your field is another serializer, then your validation code
is just given the raw serialized data for that field. This is even though
the reverse operation, serializing an object, expects an instance
of whatever that field is serializing on input.

That's probably as clear as mud, so let me demonstrate with a small
example::

    class Serializer1(ModelSerializer):
        #... (not important)
        class Meta:
            model = Model1

    class Serializer2(ModelSerializer):
        field1 = Serializer1()
        field2 = PrimaryKeyRelatedField(Model1)

        class Meta:
            model = Model2

        def validate(self, attributes):
            print("In Serializer2.validate, type of attributes[field1]=")
            print(type(attributes['field1']))
            print("In Serializer2.validate, type of attributes[field2]=")
            print(type(attributes['field2']))
            return attributes

Suppose I want to serialize an instance of Model2::

    renderer = JSONRenderer()
    model1 = Model1()
    model2 = Model2(field1=model1, field2=model1)
    serializer = Serializer2(instance=model2)
    serialized_data = renderer.render(serializer.data)
    print(serialized_data)

The output is::

    b'{"id":null,"model1":{"id":null}}'

Now suppose we deserialize that JSON::

    serializer = Serializer2(data={"id":None,"model1":{"id":None}})
    serializer.is_valid(raise_exception=True)

The output::

    In Serializer2.validate, type of attributes[model1]=
    <class 'collections.OrderedDict'>

This is what I'm talking about. When we serialized an instance
of model2, we had to provide a model1 instance as the value
of the model1 field. But when we're validating data, the validator
gives us a dictionary. If this was a Django form, we'd have gotten
an instance of model1 here.
