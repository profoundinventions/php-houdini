---------------
List of Filters
---------------

The following transforms are supported by the ``filter`` method:

Name filters
~~~~~~~~~~~~~

These are accessible with ``NameFilter::`` in ``.houdini.php``

    - ``contains(string $str)``
    - ``startsWith(string $str)``
    - ``endsWith(string $str)``
    - ``equals(string $str)``

Type filters
~~~~~~~~~~~~

These are accessible with ``TypeFilter::`` in ``.houdini.php``:

    - ``contains(string $str)``
    - ``startsWith(string $str)``
    - ``endsWith(string $str)``
    - ``equals(string $str)``


Access filters
~~~~~~~~~~~~~~

These are accessible with ``AccessFilter::`` in ``.houdini.php``:

    - ``isPrivate()``
    - ``isProtected()``
    - ``isPublic()``

Any filter
~~~~~~~~~~

This is accessible with ``AnyFilter::`` in ``.houdini.php``:

    - ``create(Filter ...)``
        Pass a list of any filter here. If any apply, the filter will pass.

All filters
~~~~~~~~~~~

This is accessible with ``AllFilters::`` in ``.houdini.php``:

    - ``create(Filter ... $filters)``
        Pass a list of filters here. If all apply, the filter will pass.

