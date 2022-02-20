Transforms
----------

If your class transforms the names of properties or methods with ``__get()`` or ``__call()``,
you can autocomplete those by passing in transforms to the ``transform()`` method.

Transforming auto-completed properties
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here's an example that autocompletes ``camelCase`` properties from private ``snake_case`` private properties:

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   // Make the publicly visible name camelCase instead of snake_case:
   houdini()->overrideClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter( AccessFilter::isPrivate() )
       ->transform( NameTransform::camelCase() );

Similar to :doc:`filters <filters>`, you can pass multiple transforms to the ``transform`` method
and they will be applied in-order.

.. note::
    Filters are checked *before* applying any transforms on them.


Transforming auto-completed methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Almost the same configuration works for methods - just replace ``promoteProperties()`` with
``promoteMethods()``:

.. code-block:: php
   :caption .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   // Make the publicly visible name camelCase instead of snake_case:
   houdini()->overrideClass(YourDynamicClass::class)
       ->promoteMethods()
       ->filter( AccessFilter::isPrivate() )
       ->transform( NameTransform::camelCase() );

A list of available transforms is on the ``NameTransform`` class in the ``Houdini\Config\V1`` namespace.
You can see the full list by typing ``NameTransform::`` and then invoking PhpStorm's completion, or here on
the :doc:`list of transforms <list-of-transforms>`

Go to the :doc:`next step <adding-new-methods-and-properties>` to learn how you can
add properties and methods that do not exist on the class already.