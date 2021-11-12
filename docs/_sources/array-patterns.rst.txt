--------------
Array Patterns
--------------

In some projects, you may encounter classes that have complex specifications
of types inside of constants or properties.

Houdini can generate methods, constants, or properties from such definitions
using *Array Patterns*

.. note::
    The use of this is pretty specialized, and you don't need it to use Houdini, which is why
    it's at the end of this tutorial. Feel free to :doc:`skip to the next document <support>`
    if you don't need it.


Array patterns parse the class definition, and then autocomplete methods or properties from
the default values based on patterns you describe in the ``.houdini.php`` file.

Simple Array Patterns Example
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here's a simple example of autocompleting a property from a specification inside an array:

.. code-block:: php
   :caption: array-pattern-example1.php

   <?php
   namespace SomeNamespace;

   class SimpleArrayPatternExample {

      /**
       * This static array defines the valid methods.
       */
      protected static $methodDefinitions = [
         'methodOne' => 'string',
      ];

      /**
       * Where this class stores its data.
       */
      protected $data = [];

      public function __call($name) {
         if (isset(self::$methodDefinitions[$name])) {
            return $this->data[$name];
         }
      }
   }

test

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use SomeNamespace\SimpleArrayPatternExample;

   houdini()->overrideClass(SimpleArrayPatternExample::class)
       ->addMethodFromProperty('methodDefinitions')
       ->matchMethodInfoFromArrayPattern(
            ArrayPattern::create()
            ->match([ArrayPattern::METHOD_NAME' => ArrayPattern::METHOD_RETURN_TYPE])
       );

In this example, we're autocompleting a method from a definition in the array stored
in the static property ``$methodDefitions``. The definition has to include
both the method name and the return type in for a completion match to be generated, and
a call to the ``match`` method on the ``ArrayPattern`` that includes both will autocomplete
the method.

.. note::
    We used a static property in the previous example as a source for the methods, but it could also have been
    an instance property.


The ``match()`` method
~~~~~~~~~~~~~~~~~~~~~~

The ``match`` specification takes an array that matches the structure of the array in the
specification. You can include arbitrary strings and arrays to match the structure of how the method
name or return type are laid out in your method or property definition.

When matching against an array value, the ``match()`` method looks
only at the relevant subset of the array - so an array can contain values not in the pattern
and still match:

.. code-block:: php
   :caption: array-pattern-match-example.php

   <?php
   namespace SomeNamespace;

   class ArrayMatchExample {

      /**
       * This static array defines the valid methods.
       */
      protected static $methodDefinitions = [
         'methodOne' => [
            'type' => 'string',
            'irrelevant_key' => 'irrelevant_value', // match() will still work even with this set.
         ]
      ];

      /**
       * Where this class stores its data.
       */
      protected $data = [];

      public function __call($name) {
         if (isset(self::$methodDefinitions[$name])) {
            return $this->data[$name];
         }
      }
   }


.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use SomeNamespace\ArrayMatchExample;

   houdini()->overrideClass(ArrayMatchExample::class)
       ->addMethodFromProperty('methodDefinitions')
       ->matchMethodInfoFromArrayPattern(
            ArrayPattern::create()
            ->match([
               ArrayPattern::METHOD_NAME' => [
                  'type' => ArrayPattern::METHOD_RETURN_TYPE
               ]
            ])
       );


Autocompleting Properties Example
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Hopefully that gives you an idea of what you can do with Array Patterns. Here's a
similar example, that generates properties from constants:

.. code-block:: php
   :caption: array-pattern-property-constant-example.php

   <?php
   namespace SomeNamespace;

   class PropertyConstantExample {

      /**
       * This static array defines the valid properties.
       */
      const PROPERTY_DEFINITIONS = [
         'propertyOne' => 'string',
      ];

      /**
       * Where this class stores its data.
       */
      protected $data = [];

      public function __get($name) {
         if (isset(self::PROPERTY_DEFINITIONS[$name])) {
            return $this->data[$name];
         }
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use SomeNamespace\ArrayPatternExample;

   houdini()->overrideClass(PropertyConstantExample::class)
       ->addPropertyFromConstant('PROPERTY_DEFINITIONS')
       ->matchPropertyInfoFromArrayPattern(
            ArrayPattern::create()
            ->match([ArrayPattern::PROPERTY_NAME' => ArrayPattern::PROPERTY_TYPE])
       );

Note here that we use a different method ``addPropertiesFromConstant`` than the previous example.
Also, we don't pass in the constant itself, but a ``string`` that refers to it. And we're
also using the ``ArrayPattern::PROPERTY_NAME`` and ``ArrayPattern::PROPERTY_TYPE``

Generating more than one match from a pattern
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using forEachKeyAndValue()
--------------------------

It's also possible to generate more than one match, but you need to modify the pattern itself
to iterate with ``forEachKeyAndValue()``:

.. code-block:: php
   :caption: array-pattern-multipattern-example.php

   <?php
   namespace SomeNamespace;

   class MultiConstantExample {

      /**
       * This static array defines the valid properties.
       */
      const PROPERTY_DEFINITIONS = [
         'propertyOne' => 'string',
         'propertyTwo' => 'int',
      ];

      /**
       * Where this class stores its data.
       */
      protected $data = [];

      public function __get($name) {
         if (isset(self::PROPERTY_DEFINITIONS[$name])) {
            return $this->data[$name];
         }
      }
   }

test

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use SomeNamespace\MultiConstantExample;

   houdini()->overrideClass(MultiConstantExample::class)
       ->addProperties('PROPERTY_DEFINITIONS')
       ->matchPropertyInfoFromArrayPattern(
            ArrayPattern::create()
            ->forEachKeyAndValue()
            ->match([ArrayPattern::PROPERTY_NAME' => ArrayPattern::PROPERTY_TYPE])
       );

Here we changed the example to generate multiple properties from our constant definitions.

Because the ``match`` method will only generate a single match, we need to add ``forEachKeyAndValue()``
to iterate all the entries in the ``PROPERTY_DEFINITIONS`` constant.

Using forEachValue()
--------------------

You use ``forEachKeyAndValue()`` when either the method name / property name or the return type / property
type are in the key of the definition. If the key is not in the definition, use `forEachValue()` instead,
and then the pattern will exclude the key and only match inside the value.

Basically, you would use ``forEachKeyAndValue()`` if the definition is associative, and ``forEachValue()``
if the definition is indexed.

Here's an example of using ``forEachValue()``

.. code-block:: php
   :caption: array-pattern-foreach-value-example.php

   <?php
   namespace SomeNamespace;

   class ForEachValueExample {

      /**
       * This static array defines the valid properties.
       */
      const PROPERTY_DEFINITIONS = [
         ['name' => 'propertyOne', 'type' => 'string',
         ['name' => 'propertyTwo', 'type' => 'int',
      ];

      /**
       * Where this class stores its data.
       */
      protected $data = [];

      public function __get($name) {
         foreach (self::PROPERTY_DEFINITIONS as $definition) {
            if ($definition['name'] === $name) {
               return $this->data[$name];
         }
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use SomeNamespace\ForEachValueExample;

   houdini()->overrideClass(ForEachValueExample::class)
       ->addProperties('PROPERTY_DEFINITIONS')
       ->matchPropertyInfoFromArrayPattern(
            ArrayPattern::create()
            ->forEachValue()
            ->match([
               'name' => ArrayPattern::PROPERTY_NAME,
               'type' => ArrayPattern::PROPERTY_TYPE
            ])
       );

Combining forEachValue() and forEachKeyAndValue()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the definition has a mixture of both types of associative and indexed arrays, it's possible
to use both ``forEachValue()`` and ``forEachKeyAndValue()`` combinined with multiple ``match``
calls to match each property or method:

.. code-block:: php
   :caption: array-pattern-example-multi-foreach-example.php

   <?php
   namespace SomeNamespace;

   class MultiForEachExample {

      /**
       * This static array defines the valid properties.
       */
      const PROPERTY_DEFINITIONS = [
            'propertyOne' => [
               'type' => 'string',
            ]
            'propertyTwo' => [
               'type' => 'int'
            ]
      ];

      /**
       * Where this class stores its data.
       */
      protected $data = [];

      public function __get($name) {
         if (self::PROPERTY_DEFINITIONS[$name]) {
            return $this->data[$name];
         }
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use SomeNamespace\MultiForEachExample;

   houdini()->overrideClass(MultiForEachExample::class)
       ->addProperties('PROPERTY_DEFINITIONS')
       ->matchPropertyInfoFromArrayPattern(
            ArrayPattern::create()
            ->forEachKeyAndValue()
            ->match([ArrayPattern::PROPERTY_NAME => ArrayPattern::ANY_ARRAY]
            ->forEachValue()
            ->match([
               'type' => ArrayPattern::PROPERTY_TYPE
            ])
       );


Here we used the ``ArrayPattern::ANY_ARRAY`` as a placeholder to match an array of any format
in the first ``match()`` method. The match isn't complete at that point though, and so we iterate
the contents of that array with ``forEachValue()`` and then pull out the property type from the
contents of the ``type`` parameter.

Combining Patterns with other methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TODO - also possible to use patterns with `setReturnType()` or `setPropertyType()`

Adieu to Array Patterns
~~~~~~~~~~~~~~~~~~~~~~~

Hopefully that helps to illustrate Array Patterns and what you would use them for. It
can be a powerful feature if you have to deal with code that makes heavy use of
array definitions for magic methods or properties.

If you have any question, feel free to email ``profoundinventions+houdini@gmail.com``
and let us know you questions or concerns.