-------------------------
Adding Dynamic Properties
-------------------------

PHP Houdini can not only promote properties and methods - you
can also add autocompletion for properties and methods that don't exist
on the class at all.

Adding a single dynamic property
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To add a property, you need to specify a `source` for the property.
That source can be either another property, a constant, or a method.

Here's an example of completing a property from another property:

.. code-block:: php

   <?php // example.php
   namespace YourNamespace;

   class YourDynamicClass {
      /** var string */
      protected $sourceProperty;
      public function __get($name) {
         return $this->$name();
      }
   }

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->addPropertiesFromProperty('sourceProperty'); // name of the property

Changing the property name
##########################

The previous example will autocomplete the name ``sourceProperty`` and the
type will be ``string``. You can manipulate different settings for the
autocompletion by calling additional methods after ``addPropertiesFromProperty``.

To set the name of the autocompleted property from the value of the ``sourceProperty``, you can call
``setPropertyNameFromPropertyValue()``:

.. code-block:: php

   <?php // example.php
   namespace YourNamespace;

   class YourDynamicClass {
      /** var string */
      protected $sourceProperty = 'yourPropertyName';
      private $yourPropertyName;
      public function __get($name) {
         return $this->$name();
      }
   }

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->addPropertiesFromProperty('sourceProperty')
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

   <?php // example.php
   namespace YourNamespace;

   class YourDynamicClass {
      /** var string */
      protected $sourceProperty = 'int';
      private $yourPropertyName;
      public function __get($name) {
         return $this->$name();
      }
   }

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->addPropertiesFromProperty('sourceProperty')
       ->setPropertyTypeFromPropertyValue();

Instead of ``int``, you can use any fully qualified class name, and even
import the class with a ``use`` statement and add ``::class``.

.. code-block:: php

   <?php // example.php
   namespace YourNamespace;

   use SomeOtherNamespace\SomeOtherClass;
   class YourDynamicClass {
      /** @var string */
      protected $sourceProperty = SomeOtherClass::class;
      /** @var SomeOtherClass */
      private $something;
      public function __construct() {
        $this->something = new SomeOtherClass();
      }
      public function __get($name) {
         return $this->$name();
      }
   }

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->addPropertiesFromProperty('sourceProperty')
       ->setPropertyTypeFromPropertyValue();

In the previous example, the type of the property will be taken from the type

setPropertyType
===============

You can also specify a completely custom type as a string in the ``.houdini.php``
file itself instead of in a class property:

.. code-block:: php

   <?php // example.php
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

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->addPropertiesFromProperty('sourceProperty')
       ->setPropertyType(SomeOtherClass::class);

Changes are inherited!
~~~~~~~~~~~~~~~~~~~~~~

Note that the autocompletion will work for any class that's a descendant of ``YourNamespace\YourDynamicClass``
automatically.

This helps if you have an abstract base class and a pattern for dynamic access, because
then you only have to specify the dynamic pattern on the base class, and not all
of the descendant classes individually.


Using all the properties of a class as a source
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you use the method ``addPropertiesFromAllProperties()``, you
can autocomplete a property for each property in a class.

Here's an example that generates properties from the types
specified in the class:


.. code-block:: php

   <?php // example.php
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

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->addPropertiesFromAllProperties('sourceProperty')
       ->setPropertyTypeFromPropertyType();


Go to the :doc:`next step <adding-dynamic-methods>` to learn about how to do
the same thing for methods.


