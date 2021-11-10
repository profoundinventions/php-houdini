Filters
-------

Filters allow you to control which properties or methods are generated that will affect the source
. For example, you can use ``promoteMethods()`` and the ``filter()`` operator to only promote methods
of a class that have a certain character string:

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->overrideClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter( NameFilter::contains('foo') );

Here we used passed a ``NameFilter`` to the ``filter()`` method. This will
enable autocompletion for private and protected properties of ``YourDynamicClass``,
but only if those properties contain the string `foo`.

You can see the complete list of name filters supported by typing ``NameFilter::`` and PhpStorm will
autocomplete them for you inside ``.houdini.php``. Another way to view them is to look at the
:doc:`list of filters <list-of-filters>`.

Using multiple filters (with logical AND)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can pass multiple filters to the filter method, and they will be combined implicitly with logical AND -
so *all* of the filters passed must apply for the method or property to be added:

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->overrideClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter(
          NameFilter::contains('foo'),
          NameFilter::startsWith('get')
       ));

This will promote any property that both filters, so only properties that start
with `get` and also contain `foo` somewhere in the name will be promoted.

You can also combine multiple filters explicitly with the ``AllFilters`` class.
This isn't useful though unless you are :ref:`combining filters <combining-filters-with-logical-or-and-logical-and>`

Using multiple filters (with logical OR)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to combine filters with logical OR, you can
use ``AnyFilter::create()`` method and pass both filters in:

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->overrideClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter( AnyFilter::create(
          NameFilter::contains('foo'),
          AccessFilter::isPrivate()
       ));

Here we used the ``AnyFilter`` class to combine filters, and the ``AccessFilter`` class
to limit it to private properties. This will promote any property that matches either
filter, so all private properties, and any filter that matches `foo`.

Combining filters with logical OR and logical AND
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can use ``AllFilters`` and ``AnyFilter`` classes together to filter by arbitrary
complicated conditions:

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->overrideClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter( AnyFilter::create(
          NameFilter::contains('foo'),
          AllFilters::create(
            AccessFilter::isPrivate(),
            NameFilter::contains('bar')
          )
       ));

This will promote autocompletion for any property that contains foo, or is both a private property and contains
the string ``bar``.

Go to the :doc:`next step <transforms>` to see how you can change the names of
autocompleted methods and properties.
