Analysis
--------

`Analysis reference <https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis.html#analysis>`_

`Analysis and Analyzers in the Guide <https://www.elastic.co/guide/en/elasticsearch/guide/current/analysis-intro.html#analysis-intro>`_

An `analyzer <https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-analyzers.html#analysis-analyzers>`_ consists of:

* Zero or more `CharFilters <https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-charfilters.html>`_
* One `Tokenizer <https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-tokenizers.html>`_
* Zero or more `TokenFilters <https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-tokenfilters.html>`_

Analysis can be configured when creating an index with the top-level ``analysis``
key in the API argument.  Example::

    analysis :
        analyzer :
            standard :
                type : standard
                stopwords : [stop1, stop2]
            myAnalyzer1 :
                type : standard
                stopwords : [stop1, stop2, stop3]
                max_token_length : 500
            # configure a custom analyzer which is
            # exactly like the default standard analyzer
            myAnalyzer2 :
                tokenizer : standard
                filter : [standard, lowercase, stop]
        tokenizer :
            myTokenizer1 :
                type : standard
                max_token_length : 900
            myTokenizer2 :
                type : keyword
                buffer_size : 512
        filter :
            myTokenFilter1 :
                type : stop
                stopwords : [stop1, stop2, stop3, stop4]
            myTokenFilter2 :
                type : length
                min : 0
                max : 2000

Built-in analyzers
~~~~~~~~~~~~~~~~~~

`Built-in analyzers in the Guide <https://www.elastic.co/guide/en/elasticsearch/guide/current/analysis-intro.html#_built_in_analyzers>`_

Custom analyzers
~~~~~~~~~~~~~~~~

You can define `custom analyzers <https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-custom-analyzer.html>`_.

`Custom Analyzers in the Guide <https://www.elastic.co/guide/en/elasticsearch/guide/current/custom-analyzers.html>`_

Example::

    analysis :
        analyzer :
            myAnalyzer2 :
                type : custom
                tokenizer : myTokenizer1
                filter : [myTokenFilter1, myTokenFilter2]
                char_filter : [my_html]
                position_offset_gap: 256
        tokenizer :
            myTokenizer1 :
                type : standard
                max_token_length : 900
        filter :
            myTokenFilter1 :
                type : stop
                stopwords : [stop1, stop2, stop3, stop4]
            myTokenFilter2 :
                type : length
                min : 0
                max : 2000
        char_filter :
              my_html :
                type : html_strip
                escaped_tags : [xxx, yyy]
                read_ahead : 1024
