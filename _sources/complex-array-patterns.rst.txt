------------------------
Complex Array Patterns
------------------------

In an ``ArrayPattern``, each completion match will only be generated when you have *both*
a name and a type. For many of the more complex scenarios below, first a name match occurs,
and then the parse continues until a type match happens.

If this match happens multiple times while iterating the array the pattern is matching against,
a completion result will be generated for each of the matches that have unique names.


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

Here we look at the ``DEFINITIONS`` constant on the class. Here it has some
properties defined in the ``'properties'`` key. Calling the
``selectKey('properties')`` will select the *value* of that key for further
iteration. When we call the ``forEachValue()`` method, it will continue in the
contents of the array value of the ``properties`` key to traverse each of the
values in that array. Finally, we do the ``match()`` and extract the *name*
and *type* fields.

So, this will generate two properties named ``foo`` and ``bar`` with types
``string`` and ``int`` respectively.

Handling mixed associative arrays
---------------------------------

If an array contains a mixture of key-value pairs and unpaired elements,
there are two optional filters you can pass to ``forEachValue()`` and
``forEachKeyAndValue`` to only grab the key-value pairs or the unpaired elements.
Those filters ArrayPatternAnythingExample on the ``ForEachOptions`` class and are
created with ``ForEachOptions::onlyStringKeys()`` and
``ForEachOptions::onlyIntegerKeys()``.

The string keys will correspond to the key-value pairs, while the integer keys will
correspond to the unpaired elements.

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
           ->forEachKeyAndValue( ForEachOptions::onlyStringKeys() )
           ->match([ ArrayPattern::NAME => ArrayPattern::TYPE ])
       );

   // Match the non-paired keys (with integer keys):
   houdini()->overrideClass(MixedPairArrays::class)
      ->addNewProperties()
      ->fromConstantOfTheSameClass('PROPERTY_DEFINITIONS')
      ->useCustomType('string')
      ->useArrayPattern(
           ArrayPattern::create()
           ->forEachValue( ForEachOptions::onlyIntegerKeys() )
           ->match(ArrayPattern::NAME)
       );


This will match both types of pairs in the array: the unpaired and the paired.

In the first definition, we pass ``ForEachOptions::onlyStringKeys()`` to select
only the key value pairs. Then, we extract the name and type from the pair.

In the second definition, we pass ``ForEachOptions::onlyIntegerKeys()`` to select
only the unpaired values in the array. We use ``useCustomType("string")`` to set
a default type because we need a *name* and a *type* for each completion match.
Then, in the ``match``, we pass the ``ArrayPattern::NAME`` directly. Here, we're
passing a string to ``match()`` since the ``ArrayPattern::NAME`` constant is a
string.

Using ``ArrayPattern::NEXT``
----------------------------

You may find you want to match the name or type in the *key* of the array, but
then you want to continue iterating with ``forEachValue()`` or
``forEachKeyAndValue()``. But, what do you put in the value in the pattern in
that case?

In this case, you can use ``ArrayPattern::NEXT`` in the value to continue
iterating from wherever that value is.

Here's an example that has an associative list of properties that is keyed by the
type of the properties:

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
            ],
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
            ->forEachKeyAndValue()
            ->match([ ArrayPattern::TYPE => ArrayPattern::NEXT ])
            ->forEachValue()
            ->match([
               'name' => ArrayPattern::NAME
            ])
       );

Here we used the ``ArrayPattern::NEXT`` as a placeholder to match an array of any
format in the first ``match()`` method.

At that point, we absorb the *type* of the property from the
``ArrayPattern::TYPE`` part in the key of the array. The ``ArrayPattern::NEXT``
lets the first ``match()`` call know which part of the array to continue any
subsequent iterations from.

Then, when we call ``forEachValue()``, we start iterating the indexed array for
each of its values. Finally we do a ``match`` looking for a corresponding
``'name'`` key and generate a completion for the value its paired with.

The result of this is four properties will be autocompleted.

Using ``ArrayPattern::ANYTHING``
--------------------------------

Sometimes you don't care about the content of a key - where it isn't the *name* or
*type* - but you want to match or iterate on its value. This could be relevant
when you want to select the value of a pair with
``ForEachOptions::onlyStringKeys()`` and when you don't care about the key.

For this case, you can use ``ArrayPattern::ANYTHING`` in the key slot of an array
so you match the value.

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
         'something_else',
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
   :emphasize-lines: 13

   <?php
   namespace Houdini\Config\V1;

   use ArrayPatternExamples\AnythingExample;

   houdini()->overrideClass(AnythingExample::class)
       ->addNewProperties()
       ->fromConstantOfTheSameClass('PROPERTY_DEFINITIONS')
       ->useCustomType('string')
       ->useArrayPattern(
            ArrayPattern::create()
            ->forEachKeyAndValue( ForEachOptions::onlyStringKeys() )
            ->match( [ ArrayPattern::ANYTHING => ArrayPattern::NAME ] )
       );


In this example, we extract the pairs of keys with string keys with
``ForEachOnlys::onlyStringKeys()``. Then, we thow away the keys,
and match based on the value of those keys. For this example, two properties
``propertyOne`` and ``propertyTwo``, both of type ``string``, will be generated.

Adieu to Array Patterns
-----------------------

Hopefully that helps to illustrate Array Patterns and what you would use them for.
It can be a powerful feature if you have to deal with code that makes heavy use of
array definitions for magic methods or properties.

If you have any questions, feel free to email ``support@profoundinventions.com``
and let us know you questions or concerns.

