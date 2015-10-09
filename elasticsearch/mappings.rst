Mappings
---------

`Mappings API <https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-mapping.html>`_

`Mappings reference <https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html>`_

`Intro to Mappings in the Guide <https://www.elastic.co/guide/en/elasticsearch/guide/current/mapping-intro.html>`_

`Types and Mappings in the Guide <https://www.elastic.co/guide/en/elasticsearch/guide/current/mapping.html>`_

Example mapping for a ``tweet`` doctype::

    {
        "tweet" : {
            "properties" : {
                "message" : {
                    "type" : "string",
                    "store" : true,
                    "index" : "analyzed",
                    "null_value" : "na"
                },
                "user" : {
                    "type" : "string",
                    "index" : "not_analyzed",
                    "norms" : {
                        "enabled" : false
                    }
                },
                "postDate" : {"type" : "date"},
                "priority" : {"type" : "integer"},
                "rank" : {"type" : "float"}
            }
        }
    }

The string type
~~~~~~~~~~~~~~~

The string type is analyzed as full text by default.

`String type reference <https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-core-types.html#string>`_ includes all the possible attributes.

The number type
~~~~~~~~~~~~~~~

`Number type reference <https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-core-types.html#number>`_

The date type
~~~~~~~~~~~~~

`Date type reference <https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-core-types.html#date>`_

The boolean type
~~~~~~~~~~~~~~~~

`Boolean type reference <https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-core-types.html#boolean>`_ and it's ``boolean`` not ``Boolean``.

Multi fields
~~~~~~~~~~~~

`Multi fields reference <https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-core-types.html#_multi_fields_3>`_

You can store the same source field in several index fields, analyzed differently.

Object type
~~~~~~~~~~~

`Object Type Ref <https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-object-type.html#mapping-object-type>`_

You can define a `field` to contain other fields.

Root object type
~~~~~~~~~~~~~~~~

`Root object type ref <https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-root-object-type.html#mapping-root-object-type>`_

`Root object in guide <https://www.elastic.co/guide/en/elasticsearch/guide/current/root-object.html>`_ - better

The top-level doc type in a mapping is also an object type, but has some special characteristics. For example, you can set the default analyzers that fields without an explicit analyzer will use.

You can also turn off dynamic mapping for a doctype, though the Root object type ref doesn't mention this. See `Dynamic mapping <https://www.elastic.co/guide/en/elasticsearch/guide/current/dynamic-mapping.html>`_.  You can even turn it back on for one field. Example::

    {
        "my_type": {
            "dynamic":      "strict",
            "properties": {
                ...
                "stash": {
                    "type": "object",
                    "dynamic": True
            }
        }
    }
