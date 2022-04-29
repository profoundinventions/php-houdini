---------------------------------
Adding New Methods and Properties
---------------------------------

PHP Houdini also allows you to complete methods and properties that
don't exist at all on the dynamic class.

The methods for doing so are ``addNewMethods()`` and ``addNewProperties()``.

Adding New Methods
~~~~~~~~~~~~~~~~~~

To add new methods, you call ``addNewMethods`` after ``overrideClass``
and then you must specify an :ref:`available source <available-sources>` for the new methods.

Sources include constants, properties, or methods of the same class or another class.


.. note::
    The autocompleted methods have zero arguments. This is ideal for configuring getter methods.

    In the future, there may be a way to configure the arguments for each dynamic method. Please contact us
    at ``support@profoundinventions.com`` if you would like to request this feature.


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
       ->addNewMethods()
       ->fromAllPropertiesOfTheSameClass()
       ->filter( AccessFilter::isProtected() )
       ->transform( NameTransform::camelCase() )


Adding New Properties
~~~~~~~~~~~~~~~~~~~~~

Here's an example that completes the same as the previous example for methods, but
generates properties instead of methods:

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->overrideClass(YourDynamicClass::class)
       ->addNewProperties()
       ->fromAllPropertiesOfTheSameClass()
       ->filter( AccessFilter::isProtected() )
       ->transform( NameTransform::camelCase() )

.. _available-sources:

Available Sources
~~~~~~~~~~~~~~~~~

The sources for methods or properties are configured with another method call with the return value of
``addNewMethods()`` and ``addNewProperties()``.

This gives you flexibility to generate completion from any many combinations of methods, properties,
and constants.

Here's a list of all the available sources.

   ``fromAllMethodsOfTheSameClass()``
       Use all methods of the same class that you're overriding in ``overrideClass`` as a source.
   ``fromAllMethodsOfAnotherClass(string $className)``
       Use all methods of the class specified by ``$className`` as a source.
   ``fromAllPropertiesOfTheSameClass()``
       Use all properties of the same class that you're overriding in ``overrideClass`` as a source.
   ``fromAllPropertiesOfAnotherClass(string $className)``
       Use all properties of the class specified by ``$className`` as a source.
   ``fromPropertyOfTheSameClass(string $propertyName)``
       Use a single property with the name of ``$propertyName`` of the same class that you're overriding in ``overrideClass`` as a source.
   ``fromAllConstantsOfTheSameClass()``
       Use all contants of the same class that you're overriding in ``overrideClass`` as a source.
   ``fromAllConstantsOfAnotherClass(string $className)``
       Use all constants of the class specified by ``$className`` as a source.
   ``fromConstantOfTheSameClass(string $constantName)``
       Use a single constant with the name of ``$constantName`` of the same class that you're overriding in ``overrideClass`` as a source.

Using Static Properties and Methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default, methods and properties are added in *instance* context. This means
you can only access them as instance methods, and not as static methods or properties. Also,

You can specify autocompleting in one context or another using the ``useContext`` method, and
then specifying which context with ``Context::isStatic()`` or ``Context::isInstance()``.

Here's an example that adds completion for the `MyCLabs Enum <https://github.com/myclabs/php-enum>`_
library. To use that library, you extend an ``Enum`` class provided by the library that
allows you to access a static method that corresponds to constants on the enum class. This example
will add completion for those enums as static methods:

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use MyCLabs\Enum\Enum;

   houdini()->overrideClass(Enum::class)
   ->addNewMethods()
   ->fromAllConstantsOfTheSameClass()
   ->useContext( Context::isStatic() );

This example will add completion for *all* Enum classes in your project that
extend ``MyCLabs\Enum\Enum`` - you don't need to specify each one individually.

Swapping contexts
#################

Note you can also autocomplete a static property or method from a non-static property
or method, or vice versa. If you want to do this,
you use the ``fromContext()`` method to specify whether the source is a static or instance method,
and then the ``toContext()`` method to specify the context for the autocompleted property or method.
Effectively, ``useContext(Context::isStatic()`` is equivalent to
``fromContext(Context::isStatic())->toContext(Context::isStatic())``

.. note::
    Constants are always treated as static. So, when completing from a constant,
    ``fromContext(Context::isInstance())`` will have no effect.


Configuring the Name and Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can also configure how the name or the type are determined.

Configuring the Name
####################

You can configure the name using a few different methods:

   ``useTheSameName()``
       This will use the same name as the source for a method or property.
   ``useValueAsTheName()``
       This will use the default value of the property or constant as
       the name of the property or method. Not available if the source
       is a method, which doesn't have a value.
   ``useTypeAsTheName()``
       Use the fully-qualified type (so the constant or property type, or
       for a method, the return type) as the name. For names that
       start with a backslash, they won't be legal names in PHP, but you
       can use ``transform()`` to change that by replacing the backslashes
       with something else (for example, underscores).

Configuring the Type
####################

The types of properties and methods are also configurable using methods:

   ``useTheSameType``
      This uses the same type as the source. This is the default.
   ``useValueAsTheType``
       This uses the value of the constant or field as the type.
       For example if a property looks like ``protected $foo = 'string'``,
       this method will make the type to be ``string`` for the method
       or property generated from that.

       Not available when the source is a method, which can't have a value.
   ``useNameAsTheType``
       This uses the name of the method, property, or constant as the type.
   ``useCustomType(string $type)``
        This uses a custom type that you pass as a parameter.

Go to the :doc:`next step <array-patterns>` to learn about
adding methods or properties from specialized patterns of arrays.
