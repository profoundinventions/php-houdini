----------------------------
Configuring Method Promotion
----------------------------

Promoting methods can also be configuring like dynamic properties, but
there are fewer options.

Overriding the return type
~~~~~~~~~~~~~~~~~~~~~~~~~~

You can set a custom return type with ``setReturnType()``, just like
you can for properties with ``setPropertyType()``:

.. code-block:: php
   :caption: example.php

   <?php
   namespace YourNamespace;

   use SomeOtherNamespace\SomeOtherClass;

   class YourDynamicClass {
      public function __call($name) {
         return $this->sourceMethod();
      }

      protected function sourceMethod() {
         return new SomeOtherClass();
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteMethod('sourceMethod')
       ->setMethodType(SomeOtherClass::class);


Using static methods
~~~~~~~~~~~~~~~~~~~~

Like properties, static methods will be promoted as static methods, and
instance methods as instance methods, and you can control which
type is promoted by passing ``Context::isStatic()`` or ``Context::isInstance()``
to the ``filter()`` method:

.. code-block:: php
   :caption: example.php

   <?php
   namespace YourNamespace;

   use SomeOtherNamespace\SomeOtherClass;

   class YourDynamicClass {
      public function __call($name) {
         return $this->sourceMethod();
      }

      protected static function staticMethod() {
      }

      protected function sourceMethod() {
         return new SomeOtherClass();
      }

      protected function sourceMethod2() {
      }
   }

.. code-block:: php
   :caption: .houdini.php

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;
   use SomeOtherNamespace\SomeOtherClass;

   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteProperties()
       ->setPropertyTypeFromPropertyType()
       ->filter( Context::isInstance() ); // ignores staticMethod()


Go to the :doc:`next step <adding-methods-from-properties>` to learn about how
to add methods from  properties.



