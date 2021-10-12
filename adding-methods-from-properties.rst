-------------------------------------------
Adding methods from properties or constants
-------------------------------------------

You can also autocomplete methods from properties.

To do this, you use the ``addMethodsFromAllProperties`` or ``addMethodFromProperty``
methods.

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

There are a also a of other options for configuring the method and its return type.

Configuring the method name
~~~~~~~~~~~~~~~~~~~~~~~~~~~

setMethodNameFromPropertyName()
-------------------------------

The default is


Configuring the return type
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Completing static methods
~~~~~~~~~~~~~~~~~~~~~~~~~

For ``addMethodsFromAllProperties``, by default both static and instance properties
will be used. You can control this by passing ``Context::isStatic()`` to the
:doc:`filter() <filters>` method.

The context of the method will match the source property. So, a method
completed from a static property will be static and a method completed from an instance
property will be an instance method.

You can change this by doing ``setMethodContext()`` and passing ``Context::isStatic()``.

