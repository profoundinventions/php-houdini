------------------------
Iterating Array Patterns
------------------------

The ``match()`` on ``ArrayPattern`` is already capable of generating multiple matches from
a single key-value pair array.

However, if the array pattern in a class is more complex, ``match()`` may not be enough. So Houdini
also has methods on the ``ArrayPattern`` class to *iterate* an array to extract methods and
properties for completion.

Those methods are summarized here and their usage is described further below.

      ``forEachValue()``
          Iterate each value in the array.
      ``forEachKeyAndValue()``
          Iterate each key and value in the array.
      ``selectKey(string $key)``
          Select the given key in the array for further iteration.

Using forEachValue()
--------------------

You should use ``forEachValue()`` if the array you're iterating is an indexed and not an associative
array if you want to generate a match for each element.

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
   namespace SomeNamespace;

   class MultiConstantExample {

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

   use SomeNamespace\MultiConstantExample;

   houdini()->overrideClass(MultiConstantExample::class)
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


Handling mixed associative arrays
---------------------------------

If the definition has a mixture of both types of associative and indexed arrays, it's possible
to use both ``forEachValue()`` and ``forEachKeyAndValue()`` combinined with multiple ``match``
calls to match each property or method:

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
   :caption: array-pattern-example-multi-foreach-example.php

   <?php
   namespace SomeNamespace;

   class MultiForEachExample {

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
               ]
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

   use SomeNamespace\MultiForEachExample;

   houdini()->overrideClass(MultiForEachExample::class)
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

Adieu to Array Patterns
-----------------------

Hopefully that helps to illustrate Array Patterns and what you would use them for. It
can be a powerful feature if you have to deal with code that makes heavy use of
array definitions for magic methods or properties.

If you have any question, feel free to email ``profoundinventions+houdini@gmail.com``
and let us know you questions or concerns.

