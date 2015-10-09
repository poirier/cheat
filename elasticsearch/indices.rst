Indices
=======

Create an index
---------------

`Create Index API <https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html>`_

Example args::

    {
        "settings" : {
            "number_of_shards" : 3,
            "number_of_replicas" : 2
        }
    }

    {
        "settings" : {
            "number_of_shards" : 1
        },
        "mappings" : {
            "type1" : {
                "_source" : { "enabled" : false },
                "properties" : {
                    "field1" : { "type" : "string", "index" : "not_analyzed" }
                }
            }
        }
    }

Index settings
--------------

TBD

dynamic
    `Dynamic mapping <https://www.elastic.co/guide/en/elasticsearch/guide/current/dynamic-mapping.html#dynamic-mapping>`_
    Values ``true``, ``false``, ``"strict"``.


