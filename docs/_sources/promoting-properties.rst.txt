Promoting Properties
--------------------

Let's say you have a class that uses ``__get()`` to allow public access
to properties that are ``private`` and ``protected``. Here's an example that
will cause PhpStorm to complete the private/protected properties for you
for that class:

.. code-block:: php
   :caption: **example.php**

   <?php
   namespace YourNamespace;

   class YourDynamicClass
   {
      /** @var string */
      private $privateProperty;

      /** @var int */
      protected $protectedProperty;

      public function __get($name) { return $this->$name; }
   }

.. code-block:: php
   :caption: **.houdini.php**

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties();

Only promoting protected properties
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The previous example will promote all properties, private and protected.
If you only wanted to promote protected ones, you could add a :doc:`filter <filters>` :

.. code-block:: php
   :caption: **.houdini.php**

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties()
       ->filter( AccessFilter::isProtected() );

The ``AccessFilter`` class used here is defined in the ``Houdini\Config\V1``
namespace.

Go to the :doc:`next step <filters>` to see how to do the same thing for methods
instead of properties.
