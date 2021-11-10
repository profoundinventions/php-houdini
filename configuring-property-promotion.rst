------------------------------
Configuring Property Promotion
------------------------------

PHP Houdini also enables you to configure property completion to change things like
the name of the promoted property or its type.

Promoting a single dynamic property
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To promote a single property, you can pass a ``NameFilter::equals`` filter to the ``filter`` method:

.. code-block:: php
   :caption: example.php

   <?php
   namespace YourNamespace;

   class YourDynamicClass {
      /** var string */
      protected $sourceProperty;

      public function __get($name) {
         return $this->$name();
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter( NameFilter::equals('sourceProperty') );

Changing the property name
##########################

You can manipulate different settings for the
autocompletion by calling additional methods after
``promoteProperties()``.

To change the name, you have a number of options. Each one is configured
with a different method listed below.

useTheSameName():
   This uses the name of the source property as the autocompleted property.
   This is the default.

useValueAsTheName():
   This uses the default value assigned to the property in the class definition
   as the name. For example, if the property looks like ``protected $property = 'name'``,
   the property name with this method will be ``name``.



To set the name of the autocompleted property from the value of the ``sourceProperty``, you can call
``useValueA()``:

.. code-block:: php
   :caption: example.php

   <?php
   namespace YourNamespace;

   class YourDynamicClass {
      /** var string */
      protected $sourceProperty = 'yourPropertyName';

      private $yourPropertyName;

      public function __get($name) {
         return $this->yourPropertyName;
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperty('sourceProperty')
       ->setPropertyNameFromPropertyValue();

Now there will be a virtual property ``yourProperty``
for ``YourDynamicClass``.

Changing the property type
##########################

You can also change the type of the autocompleted property.
There are a couple of methods to do so.

setPropertyTypeFromPropertyValue
================================

This method sets the property type from the value of the property interpreted
as a string. For example, if you specify a property whose value is the string
``int``, then the property's return type will be ``int``:

.. code-block:: php
   :caption: example.php

   <?php
   namespace YourNamespace;

   class YourDynamicClass {
      /** @var string */
      protected $sourceProperty = 'int';

      /** @var int */
      private $backingProperty = 1;

      public function __get($name) {
         return $this->backingProperty;
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperty('sourceProperty')
       ->setPropertyTypeFromPropertyValue();

Instead of ``int``, you can use any fully qualified class name, and even
import the class with a ``use`` statement or add ``::class``.

.. code-block:: php
   :caption: example.php

   <?php
   namespace YourNamespace;

   use SomeOtherNamespace\SomeOtherClass;

   class YourDynamicClass {
      /** @var string */
      protected $sourceProperty = SomeOtherClass::class;

      /** @var SomeOtherClass */
      private $backingProperty;

      public function __construct() {
        $this->backingProperty = new SomeOtherClass();
      }

      public function __get($name) {
         return $this->backingProperty;
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperty('sourceProperty')
       ->setPropertyTypeFromPropertyValue();

In the previous example, the type of the property will be taken from the type

setPropertyType
===============

You can also specify a completely custom type as a string in the ``.houdini.php``
file itself instead of in a class property:

.. code-block:: php
   :caption: example.php

   <?php
   namespace YourNamespace;

   use SomeOtherNamespace\SomeOtherClass;

   class YourDynamicClass {
      protected $sourceProperty;

      public function __construct() {
        $this->sourceProperty = new SomeOtherClass();
      }

      public function __get($name) {
         return $this->$name();
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperty('sourceProperty')
       ->setPropertyType(SomeOtherClass::class);

.. note::
    If the type of the property is a class, you can navigate to the class definition from
    ``$this->yourProperty`` as if it were a normally defined property.


Changes are inherited!
~~~~~~~~~~~~~~~~~~~~~~

Note that the autocompletion will work for any class that's a descendant of ``YourNamespace\YourDynamicClass``
automatically.

This helps if you have an abstract base class and a pattern for dynamic access, because
then you only have to specify the dynamic pattern on the base class, and not all
of the descendant classes individually.

Configuring to promote all the properties
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you use the method ``promoteProperties()``, you
can autocomplete a property for each property in a class.

Here's an example that generates properties from the types
specified in the class:

.. code-block:: php
   :caption: example.php

   <?php
   namespace YourNamespace;

   use SomeOtherNamespace\SomeOtherClass;
   class YourDynamicClass {
      protected $stringProperty = 'string';
      protected $intProperty = 'int';
      protected $dateTimeProperty = \DateTime::class;

      public function __get($name) {
         // ... perform some mapping here.
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties(')
       ->setPropertyTypeFromPropertyType();

This will complete a property for each of ``$stringProperty``, ``$intProperty``, and ``$dateTimeProperty``
of the corresponding type.

Handling static properties
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default, all properties, static and instance, will be promoted.

If you only want to promote one type, you can use the pass a ``Context::isStatic()`` or
``Context::isInstance()`` to ``filter`` to control which ones to complete:

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties()
       ->setPropertyTypeFromPropertyType()
       ->filter( Context::isInstance() ); // ignores any private/protected static properties.


If the property you're promoting is a static property, the promoted version will also be static.

If you want the promoted version to be static but the source property is an instance
property, you can control that separately with the ``setPropertyContext()`` and passing either
``Context::isStatic()`` or ``Context::isInstance()`` to complete a static or instance property.

.. note::
    Generating a static property from an instance one usually isn't useful, but can be if you want to generate
    multiple dynamic properties from a single property with :doc:`Array Patterns <array-patterns>`. That's a
    more advanced usage and not necessary for most projects.

Using the previous example, but if we wanted to use it like ``YourDynamicClass::$sourceProperty``,
it would look like this:

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperty('sourceProperty')
       ->setPropertyType(SomeOtherClass::class)
       ->setPropertyContext(Context::isStatic());


Go to the :doc:`next step <configuring-dynamic-methods>` to learn about how to
configure dynamic methods.


