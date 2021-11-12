---------------------------
Using Constants as a Source
---------------------------

It's also possible to use constants as a source of dynamic properties or methods.

Generators
==========

addMethodsFromAllConstants and addMethodFromConstant
----------------------------------------------------

You can add methods using ``addMethodsFromAllConstants()``
and ``addMethodFromConstant()``.

Here's an example that adds completion for the `MyCLabs Enum <https://github.com/myclabs/php-enum>`_
library. To use that library, you extend the Each class using that library has a static method that corresponds
to a constant on the enum. This example will add completion for *all* Enum classes in your project that
extend ``MyCLabs\Enum\Enum``:

.. code-block:: php
   :caption: .houdini.php

   <?php

   namespace Houdini\Config\V1;

   use MyCLabs\Enum\Enum;

   houdini()->overrideClass(Enum::class)
   ->addMethodsFromAllConstants()
   ->transform( NameTransform::lowercase(), NameTransform::camelCase() )
   ->setMethodContext( Context::isStatic() );

addPropertiesFromAllConstants and addPropertyFromConstant
---------------------------------------------------------

The method to use for using a constant as a source is ``addPropertiesFromConstant()``.

The options for configuring from a constant are similar for promoting properties --
you use ``setPropertyNameFromConstantName()`` instead, except that
you use ``setConstantName()``


Configuring
===========

There are options for configuring the autocompleted properties and methods to
change the method name or the properties:

Configuring the name
~~~~~~~~~~~~~~~~~~~~~~~~~~~

setMethodNameFromConstantName() / setPropertyNameFromConstantName
-----------------------------------------------------------------

This sets the method / property name from the constant name.

setMethodNameFromConstantValue() / setPropertyNameFromConstantValue()
---------------------------------------------------------------------

This sets the method name from the constant value.

Configuring the return / property type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can also configure the return type of the method or the property type generated from the constant.

setReturnTypeFromConstantName() / setPropertyTypeFromConstantName()
-------------------------------------------------------------------

This sets the return type / prpoerty from the name of the constant.

setReturnTypeFromConstantValue() / setPropertyTypeFromConstantValue()
---------------------------------------------------------------------

This sets the return type from the default value in the class. For example,
if the constant is ``C`` and is assigned to a value of ``'int'``
in the class definition, then the return type of the method or the type
of the property will be ``int``:

.. code-block:: php
   :caption: example.php

   <?php
   namespace YourNamespace;

   class YourDynamicClass {
      const C = 'int';
   }

setReturnTypeFromTypeOfConstantValue() / setPropertyTypeFromTypeOfConstantValue()
---------------------------------------------------------------------------------

This sets the return type / property type from the type of the constant.

This is the default.

setReturnType(string $returnType) / setPropertyType(string $propertyType)
-------------------------------------------------------------------------

This sets a custom return type / property type from a string parameter.

Go to the :doc:`next step <array-patterns>` to learn about how to use an advanced method
of generating properties and methods from array definitions.
