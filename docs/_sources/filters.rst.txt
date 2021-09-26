Filters
-------

You can pass multiple filters to the filter method, and they will be combined with logical AND - so *all* of the filters
passed must apply for the method or property to be added. If you want to combine filters with logical OR, you can
use ``AnyFilter::create()`` method and pass both filters in:

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter( AnyFilter::create(
          AccessFilter::isProtected(),
          AccessFilter::isPrivate()
       ));

