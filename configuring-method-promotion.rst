-------------------------
Adding Dynamic Methods
-------------------------

PHP Houdini can also add autocompletion for dynamic methods in
much the same way as for :doc:`dynamic properties <adding-dynamic-properties>`.

The API for methods is similar to properties, except you replace the words
``Property`` with ``Method``, and ``PropertyType`` with ``ReturnType`` .


For methods, you can autocomplete them from properties or constants.

.. note::
    The autocompleted methods have zero arguments. This is ideal for configuring getter methods.

    In the future, there may be a way to configure the arguments for each dynamic method. Please contact us
    at ``profoundinventions+houdini@gmail.com`` if you would like to request this feature.

Here's an example that completes methods from all the protected properties in a class, and
transforms them from ``snake_case`` to ``camelCase``. The return type of the method
is set from the type of the value of the corresponding property:

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->addMethodsFromAllProperties()
       ->filter( AccessFilter::isProtected() )
       ->transform( NameTransform::camelCase() )

Go to the :doc:`next step <using-constants-as-a-source>` to learn about how
to use constants as a source for autocompletion.


