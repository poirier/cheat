.. _host-pattern:

Host Patterns
=============


See `doc <http://docs.ansible.com/intro_patterns.html#patterns>`_ for host patterns.

<hosts>:

    "all" = all hosts in inventory file
    "*" = all hosts in inventory file
    "~<regex>" = use regex syntax for this pattern
    "<pattern1>:<pattern2>" = include all hosts that match pattern1 OR pattern2
    "<pattern1>:&<pattern2>" = include all hosts that match pattern1 AND pattern2
    "<pattern1>:!<pattern2>" = include all hosts that match pattern1 but NOT pattern2