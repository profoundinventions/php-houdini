------------------------
Complex Array Patterns
------------------------

The ``match()`` on ``ArrayPattern`` is already capable of generating multiple matches from
a single key-value pair array.

However, if the array pattern in a class is more complex, ``match()`` may not be enough. So Houdini
also has methods on the ``ArrayPattern`` class to *iterate* an array to extract methods and
properties for completion, and to specify.

Those methods and their usage is described further below.

Using forEachValue()
--------------------

You should use ``forEachValue()`` if the array you're iterating is an indexed and not an associative
array if you want to generate a match for each element.

Here's an example of using ``forEachValue()``

.. code-block:: php
   :caption: array-pattern-foreach-value-example.php

   <?php
   namespace ArrayPatternExamples;

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

   use ArrayPatternExamples\ForEachValueExample;

   houdini()->overrideClass(ForEachValueExample::class)
       ->addNewProperties()
       ->fromConstantOfTheSameClass('PROPERTY_DEFINITIONS')
       ->useArrayPattern(
            ArrayPattern::create()
            ->forEachValue()
            ->match([
               'name' => ArrayPattern::NAME,
               'type' => ArrayPattern::TYPE
            ])
       );

Here we iterating each value in the ``PROPERTY_DEFINITIONS`` constant array, and generating a property
for each. In this example, there will be two properties in the autocompletion: ``propertyOne`` as a ``string``,
and ``propertyTwo`` as an ``int``.

Using forEachKeyAndValue()
--------------------------

It's also possible to generate more than one match, but you need to modify the pattern itself
to iterate with ``forEachKeyAndValue()``:

.. code-block:: php
   :caption: **array-pattern-for-each-key-and-value**.php

   <?php
   namespace ArrayPatternExamples;

   class ForEachKeyAndValueExample {

      /**
       * This static array defines the valid properties.
       */
      const PROPERTY_DEFINITIONS = [
         'propertyOne' => [
            'metadata' => [
               'type' => 'string'
            ]
         ],
         'propertyTwo' => [
            'metadata' => [
               'type' => 'float'
            ]
         ],
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

In this example, the property definitions contain the name of the property as the first key, following

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use ArrayPatternExamples\ForEachKeyAndValueExample;

   houdini()->overrideClass(ForEachKeyAndValueExample::class)
       ->addNewProperties()
       ->fromPropertyOfTheSameClass('PROPERTY_DEFINITIONS')
       ->useArrayPattern(
            ArrayPattern::create()
            ->forEachKeyAndValue()
            ->match( [ ArrayPattern::NAME => ArrayPattern::TYPE ] )
       );

Here we changed the example to generate multiple properties from our constant definitions.

Because the ``match`` method will only generate a single match, we need to add ``forEachKeyAndValue()``
to iterate all the entries in the ``PROPERTY_DEFINITIONS`` constant.

Selecting a particular key with selectKey(string $key)
------------------------------------------------------

You may find you want to traverse only down a particular part of the array. You can use ``selectKey``
for this:


.. code-block:: php
   :caption: **array-pattern-select-key**.php

   <?php

   namespace ArrayPatternExamples;

   class SelectKeyExample {
       const DEFINITIONS = [
           'properties' => [
               [
                   'name' => 'foo',
                   'type' => 'string',
               ],
               [
                   'name' => 'bar',
                   'type' => 'int',
               ],
           ]
           'methods' => [
                // ...
           ]
       ];
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use ArrayPatternExamples\SelectKeyExample;

   houdini()->overrideClass(SelectKeyExample::class)
      ->addNewProperties()
      ->fromConstantOfTheSameClass('DEFINITIONS')
      ->useCustomType('string')
      ->useArrayPattern(
           ArrayPattern::create()
           ->selectKey('properties')
           ->forEachValue()
           ->match([
               'name' => ArrayPattern::NAME,
               'type' => ArrayPattern::TYPE
           ])
       );

Here we look at the ``DEFINITIONS`` constant on the class. Here it has some properties defined in
the ``'properties'`` key. Calling the ``selectKey('properties')`` will select that key for further
iteration.

Then, we call the ``forEachValue()`` method to traverse each of the values in that array. Finally,
we do the ``match()`` and extract the *name* and *type* fields. So, this will generate two properties
named ``foo`` and ``bar`` with types ``string`` and ``int`` respectively.

Handling mixed associative arrays
---------------------------------

If an array contains a mixture of key-value pairs and unpaired elements, there are two optional filters
you can pass to ``forEachValue()`` and ``forEachKeyAndValue`` to only grab the key-value pairs or
the unpaired elements. Those filters ArrayPatternAnythingExample on the ``ForEachOptions`` class and are created with
``ForEachOptions::onlyStringKeys()`` and ``ForEachOptions::onlyIntegerKeys()``.

The string keys will correspond to the key-value pairs, while the integer keys will correspond to the
unpaired elements.

Here's an example showing how to extract both from an array:

.. code-block:: php
   :caption: **array-pattern-mixed-pair-arrays**.php

   <?php
   namespace ArrayPatternExamples;

   class MixedPairArrays {
       const PROPERTY_DEFINITIONS = [
           'propNameOne' => 'int',
           'propNameTwo' => 'string',
           'propNameThree',
       ];
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use ArrayPatternExamples\MixedPairArrays;

   // match the key-value pairs (with string keys):
   houdini()->overrideClass(MixedPairArrays::class)
      ->addNewProperties()
      ->fromConstantOfTheSameClass('PROPERTY_DEFINITIONS')
      ->useCustomType('string')
      ->useArrayPattern(
           ArrayPattern::create()
           ->forEachValue( ForEachOptions::onlyStringKeys() )
           ->match([ ArrayPattern::NAME => ArrayPattern::TYPE ])
       );

   // Match the non-paired keys (with integer keys):
   houdini()->overrideClass(MixedPairArrays::ArrayPatternAnythingExample)
      ->addNewProperties()
      ->fromConstantOfTheSameClass('PROPERTY_DEFINITIONS')
      ->useCustomType('string')
      ->useArrayPattern(
           ArrayPattern::create()
           ->forEachValue( ForEachOptions::onlyIntegerKeys() )
           ->match(ArrayPattern::NAME)
       );


This will match both types of pairs in the array: the unpaired and the paired.

In the first definition, we pass ``ForEachOptions::onlyStringKeys()`` to select only the key value pairs. Then,
we extract the name and type from the pair.

In the second definition, we pass ``ForEachOptions::onlyIntegerKeys()`` to select only the unpaired values in
the array. We use ``useCustomType("string")`` to set a default type because we need a *name* and a *type*
for each completion match. Then, in the ``match``, we pass the ``ArrayPattern::NAME`` directly. Here, we're
passing a string to ``match()`` since the ``ArrayPattern::NAME`` constant is a string.

Using ``ArrayPattern::NEXT``
----------------------------

You may find you want to match the name or type in the *key* of the array, but then you want to
continue iterating with ``forEachValue()``, ``forEachKeyAndValue()``, or a subsequent call
to ``match()``.

In this case, you can use ``ArrayPattern::NEXT`` in the pattern to continue iterating from
wherever that value is.

Here's an example that has an associative list of properties that is keyed by the type of
the properties:

.. code-block:: php
   :caption: array-pattern-next-example.php

   <?php
   namespace ArrayPatternExamples;

   class NextExample {

      /**
       * This static array defines the valid properties.
       */
      const PROPERTY_DEFINITIONS = [
            'string' => [
               [
                  'name' => 'propertyOne',
               ],
               [
                  'name' => 'propertyTwo',
               ]
            ]
            'int' => [
               [
                  'name' => 'propertyThree'
               ],
               [
                  'name' => 'propertyFour'
               ]
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

   use ArrayPatternExamples\NextExample;

   houdini()->overrideClass(NextExample::class)
       ->addNewProperties()
       ->fromConstantOfTheSameClass('PROPERTY_DEFINITIONS')
       ->useArrayPattern(
            ArrayPattern::create()
            ->match([ ArrayPattern::TYPE => ArrayPattern::NEXT ])
            ->forEachValue()
            ->match([
               'name' => ArrayPattern::NAME
            ])
       );

Here we used the ``ArrayPattern::NEXT`` as a placeholder to match an array of any format
in the first ``match()`` method. At that point, we absorb the *type* of the property
from the ``ArrayPattern::TYPE`` part in the key of the array. The ``ArrayPattern::NEXT``
lets the first ``match()`` call know which part of the array to continue any
subsequent iterations from.

Then, when we call ``forEachValue()``, we start iterating the indexed array for each
of its values. Finally we do a ``match`` looking for a ``'name'`` key and generate a
completion for the value its paired with.

The result of this is four properties will be autocompleted.

Using ``ArrayPattern::ANYTHING``
---------------------------------

Sometimes you don't care about the content of a key - where it isn't the *name* or *type* -
but you want to match or iterate on its value.

For this case, you can use ``ArrayPattern::ANYTHING`` in the key slot.

Here's an example that maps an irrelevant key to the name with a custom type:

.. code-block:: php
   :caption: array-pattern-anything.php

   <?php
   namespace ArrayPatternExamples;

   class AnythingExample {

      /**
       * This static array defines the valid properties.
       */
      const PROPERTY_DEFINITIONS = [
         'irrelevant_key' => 'propertyOne',
         'another_irrelevant_key' => 'propertyTwo'
      ];

      /**
       * Where this class stores its data.
       */
      protected $data = [];

      public function __get($name) {
         if (in_array(self::PROPERTY_DEFINITIONS, $name)) {
            return $this->data[$name];
         }
      }
   }

.. code-block:: php
   :caption: .houdini.php
   :emphasize-lines: 12

   <?php
   namespace Houdini\Config\V1;

   use ArrayPatternExamples\AnythingExample;

   houdini()->overrideClass(AnythingExample::class)
       ->addNewProperties()
       ->fromConstantOfTheSameClass('PROPERTY_DEFINITIONS')
       ->useCustomType('string')
       ->useArrayPattern(
            ArrayPattern::create()
            ->match( [ ArrayPattern::ANYTHING => ArrayPattern::NAME ] )
       );


Adieu to Array Patterns
-----------------------

Hopefully that helps to illustrate Array Patterns and what you would use them for. It
can be a powerful feature if you have to deal with code that makes heavy use of
array definitions for magic methods or properties.

If you have any question, feel free to email ``profoundinventions+houdini@gmail.com``
and let us know you questions or concerns.

