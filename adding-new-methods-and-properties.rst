---------------------------------
Adding New Methods and Properties
---------------------------------

PHP Houdini also allows you to complete methods and properties that
don't exist on the dynamic class.

The methods for doing so are ``addNewMethods()`` and ``addNewProperties()``.

Adding New Methods
~~~~~~~~~~~~~~~~~~

To add new methods, you call the ``addNewMethods()`` after ``overrideClass()``
and the you must specify a :ref:`source<Available Sources>` for the new methods.

Sources include constants, properties, or methods from another class or the same class.


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
       Use all methods of another class as a source.
   ``fromAllConstantsOfTheSameClass()``
       Use all contants of the same class that you're overriding in ``overrideClass`` as a source.
   ``fromAllConstantsOfAnotherClass(string $className)``
       Use all constants of another class as a source.
   ``fromConstantOfTheSameClass(string $constantName)``
       Use a single property of the same class that you're overriding in ``overrideClass`` as a source.
   ``fromAllPropertiesOfTheSameClass()``
       Use all properties of the same class that you're overriding in ``overrideClass`` as a source.
   ``fromAllPropertiesOfAnotherClass(string $className)``
       Use all properties of another class as a source.
   ``fromPropertyOfTheSameClass(string $propertyName)``
       Use a single property of the same class that you're overriding in ``overrideClass`` as a source.

Using Static Properties and Methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default, methods and prpoerties are added in *instance* context. This means
you can only access them as instance methods and not as static methods or properties.

You can specify autocompleting in one context or another using the ``useContext`` method, and then
specifying the context with ``Context::isStatic()`` or ``Context::isInstance()``.

If you want to autocomplete a static property or method from a non-static one or vice-versa,
you can use the ``fromContext()`` or ``toContext()`` methods, and pass ``Context::isStatic()``
or ``Context::isInstance()`` as required. Effectively, ``useContext(Context::isStatic()``
is equivalent to ``fromContext(Context::isStatic())->toContext(Context::isStatic()``

.. note::
    Constants are always treated as static, and so when completing from a constant
    ``fromContext(Context::isInstance())`` will be ignored.

Here's an example that adds completion for the `MyCLabs Enum <https://github.com/myclabs/php-enum>`_
library. To use that library, you extend the Each class using that library has a static method that corresponds
to a constant on the enum.

Note this example will add completion for *all* Enum classes in your project that
extend ``MyCLabs\Enum\Enum`` - you don't need to specify each one individually.

.. code-block:: php
   :caption: .houdini.php

   <?php

   namespace Houdini\Config\V1;

   use MyCLabs\Enum\Enum;

   houdini()->overrideClass(Enum::class)
   ->addNewMethods()
   ->fromAllConstantsOfTheSameClass()
   ->useContext( Context::isStatic() );


Configuring the Name and Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can also how the name or the type are determined.

Configuring the Name
####################

You can configure the name to come using a few different methods:

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

       Not available when the source is a method which doesn't have a value.
   ``useNameAsTheType``
       This uses the name of the method, property, or constant as the type.
   ``useCustomType(string $type)``
        This uses a custom type that you pass as a parameter.

Go to the :doc:`next step <array-patterns>` to learn about
adding methods or properties from specialized patterns of arrays.

