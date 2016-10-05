XML in Python
=============


Formatting an etree Element
---------------------------

Like this::

    def format_element(element):
        """
        Given an etree Element object, return a string with the contents
        formatted as an XML file.
        """
        tree = ElementTree(element)
        bytes = StringIO()
        tree.write(bytes, encoding='UTF-8')
        return bytes.getvalue().decode('utf-8')


