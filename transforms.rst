Transforms
----------

If the names of the public versions of the properties / methods are
different, you can use the ``transform()`` method to change the publicly visible name of the property:

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   // Make the publicly visible name camelCase instead of snake_case:
   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties()
       ->transform( NameTransform::camelCase() );

A list of available transforms is on the ``NameTransform`` class in the ``Houdini\Config\V1`` namespace. You can see the full list by
typing ``NameTransform::`` and then invoking PhpStorm's completion, or here on the :doc:`list of transforms`

