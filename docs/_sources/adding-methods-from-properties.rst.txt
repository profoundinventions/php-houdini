------------------------------
Adding Methods from Properties
------------------------------

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
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->overrideClass(YourDynamicClass::class)
       ->addMethodsFromAllProperties()
       ->filter( AccessFilter::isProtected() )
       ->transform( NameTransform::camelCase() )

There are a also other options for configuring the method and its return type.

Configuring the method name
~~~~~~~~~~~~~~~~~~~~~~~~~~~

setMethodNameFromPropertyName()
-------------------------------

This sets the method name from the property name.

setMethodNameFromPropertyValue()
--------------------------------

This sets the method name from the property value.

Configuring the return type
~~~~~~~~~~~~~~~~~~~~~~~~~~~

setReturnTypeFromPropertyName()
-------------------------------

This sets the return type from the name of the property.

setReturnTypeFromPropertyValue()
--------------------------------

This sets the return type from the default value in the class. For example,
if the property is ``$property`` and is assigned to a value of ``'int'``
in the class definition, then the return type of the method will be ``int``:

.. code-block:: php
   :caption: example.php

   <?php
   namespace YourNamespace;

   class YourDynamicClass {
      protected $property = 'int';
   }

setReturnTypeFromTypeOfPropertyValue()
--------------------------------------

This sets the return type from the type of the property.

This is the default.

setReturnType(string $returnType)
---------------------------------

This sets a custom return type from a string parameter.


Completing static methods
~~~~~~~~~~~~~~~~~~~~~~~~~

For ``addMethodsFromAllProperties``, by default both static and instance properties
will be used. You can control this by passing ``Context::isStatic()`` to the
:doc:`filter() <filters>` method.

The context of the method will match the source property. So, a method
completed from a static property will be static and a method completed from an instance
property will be an instance method.

You can change this by doing ``setMethodContext()`` and passing ``Context::isStatic()``.

Go to the :doc:`next step <using-constants-as-a-source>` to learn about
adding methods or properties from constants.

