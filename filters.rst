Filters
-------

Filters allow you to control which properties or methods are generated that will affect the source
. For example, you can use ``promoteMethods()`` to and the ``filter()`` operator to only promote methods
of a class that have a certain character string:

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter( NameFilter::contains('foo') );

Here we used the ``filter()`` operator and passed a ``NameFilter`` class. This will
promote the properties of ``YourDynamicClass`` so you'll see private and protected properties, but only
if those properties contain the string `foo`.

You can see the complete list of name filters supported by typing ``NameFilter::`` and PhpStorm will
autocomplete them for you inside ``.houdini.php``. Another way to view them is to look at the
:doc:`list of filters <list-of-filters>`.

Using Multiple Filters (with logical AND)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can pass multiple filters to the filter method, and they will be combined with logical AND - so *all* of the filters
passed must apply for the method or property to be added:

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter(
          NameFilter::contains('foo'),
          NameFilter::startsWith('get')
       ));

This will promote any property that both filters, so only properties that start
with `get` and also contain `foo` somewhere in the name will be promoted.

Using Multiple Filters (with logical OR)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to combine filters with logical OR, you can
use ``AnyFilter::create()`` method and pass both filters in:

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter( AnyFilter::create(
          NameFilter::contains('foo'),
          AccessFilter::isPrivate()
       ));

Here we used the ``AnyFilter`` class to combine filters, and the ``AccessFilter`` class
to limit it to private properties. This will promote any property that matches either
filter, so all private properties, and any filter that matches `foo`.