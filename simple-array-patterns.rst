---------------------
Simple Array Patterns
---------------------

Each ``ArrayPattern`` is a fluent object that must have one or more calls to the ``match()``
method in order to generate completions.

To create an ``ArrayPattern``, you need to use the ``ArrayPattern::create()`` method. To use
it, you pass the pattern to the ``->useArrayPattern`` method.

Simple ArrayPattern Example
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here's a simple example of autocompleting a property from a specification inside an array:

.. code-block:: php
   :caption: **array-pattern-example1.php**

   <?php
   namespace ArrayPatternExamples;

   class SimpleExample {

      /**
       * This static array defines the valid methods.
       */
      protected static $methodDefinitions = [
         'methodOne' => 'string',
         'methodTwo' => 'int',
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
   :caption: **.houdini.php**

   <?php
   namespace Houdini\Config\V1;

   use ArrayPatternExamples\SimpleExample;

   houdini()->overrideClass(SimpleExample::class)
       ->addNewMethods()
       ->fromPropertyOfTheSameClass('methodDefinitions')
       ->fromContext( Context::isStatic() )
       ->useArrayPattern(
            ArrayPattern::create()
            ->match( [ ArrayPattern::NAME => ArrayPattern::TYPE ] )
       );


In this example, we're autocompleting a method from a definition in the array stored
in the static property ``$methodDefinitions``. The definition has to include
both the method name and the return type in order for a completion match to be generated. The
name is matched with the ``ArrayPattern::NAME`` placeholder. Whatever is in the array will
be used in th completion.

Similarly, the ``ArrayPattern::TYPE`` placeholder will match the property type or the method return type.
In order for an array pattern to generate a completion, both the name and type have to be matched
(but see below for an exception to this).

So, in this example, two non-static methods will be autocompleted for the ``SimpleArrayPatternExample``
instances.

.. note::
    We used a static property in the previous example as a source for the methods, but it could also have been
    an instance property. In that case, you wouldn't pass the ``->fromContext( Context::isStatic() )``.
    part.


The ``match()`` method
~~~~~~~~~~~~~~~~~~~~~~

The argument passed to the ``match`` method is the one that is generating the completion.

There are two options to pass to ``match``: a string or an array. In the previous example, we passed an array.
We'll look at when you might want to pass a string later. The ``match`` should contain either either
``ArrayPattern::NAME`` or ``ArrayPattern::TYPE`` to get either the property type or the method return type.

When matching against an array value, the ``match()`` method looks only at the relevant
subset of the array - so an array can contain values not in the pattern and still match:

.. code-block:: php
   :caption: array-pattern-match-example.php

   <?php
   namespace ArrayPatternExamples;

   class MatchExample {

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

   use ArrayPatternExamples\MatchExample;

   houdini()->overrideClass(MatchExample::class)
       ->addNewMethods()
       ->fromPropertyOfTheSameClass('methodDefinitions')
       ->fromContext( Context::isStatic() )
       ->useArrayPattern(
            ArrayPattern::create()
            ->match([
               ArrayPattern::NAME => [
                  'type' => ArrayPattern::TYPE
               ]
            ])
       );


Autocompleting Properties Example
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Hopefully that gives you an idea of what you can do with Array Patterns. Here's a
similar example, that generates properties an array in a constant:

.. code-block:: php
   :caption: array-pattern-property-constant-example.php

   <?php
   PropertiesFromConstant;

   class PropertiesFromConstantExample {

      /**
       * This static array defines the valid properties.
       */
      const PROPERTY_DEFINITIONS = [
         'propertyOne' => 'string',
         'propertyTwo' => 'float',
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

   use ArrayPatternExamples\PropertiesFromConstantExample;

   houdini()->overrideClass(PropertiesFromConstantExample::class)
       ->addNewProperties()
       ->fromConstantOfTheSameClass('PROPERTY_DEFINITIONS')
       ->useArrayPattern(
            ArrayPattern::create()
            ->match( [ ArrayPattern::NAME => ArrayPattern::TYPE ] )
       );


Combining Patterns with other methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For generating a completion, you need both a name and a type. So, you usually will want your array pattern
to include ``ArrayPattern::NAME`` and ``ArrayPattern::TYPE``, but it's also possible to only include
one of those and grab the other one from another method.

For example, you could grab the name from the ArrayPattern with ``ArrayPattern::NAME``
and the return type with ``useCustomType('string')``. Then, you'll generate a new ``string``
property for each *name* found in the array pattern.

Go to the :doc:`next step <complex-array-patterns>` to learn about
adding methods or properties from specialized patterns of arrays.

