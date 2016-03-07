=======
Queries
=======

Field lookups
=============

exact, iexact, contains, icontains, startswith, istartswith, endswith, iendswith,
in,
gt, gte, lt, lte,
range, year, month, day, week_day, hour, minute, second,
isnull,
search, regex

Optimizing Django queries on big data
=====================================

Suppose you have a query that needs to run against a table
or tables with many millions of rows. Maybe you need to operate
on a couple million of them.  What are the do's and don't's of a
Django query that will not pessimize performance (time and memory use)?

* Don't bother with .iterator(), it downloads the whole result and then
  iterates over it. It does not do what many of us think/thought it did
  (use a database cursor to pull down the results only as you work through them)
* Do limit the query ([start:end]) and run it repeatedly in reasonable
  sized batches, to avoid downloading too big a chunk
* Do use .only() and its kin to minimize how much of each record is downloaded to what you need
* Do not order_by() unless you must - it forces the DB to collect the
  results of the whole query first so it can sort them, even if you then limit the results you retrieve
* Same for .distinct().
