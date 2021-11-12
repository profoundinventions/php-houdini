Promoting Methods
-----------------

Methods can be promoted similarly to :doc:`properties <promoting-properties>` - just use ``promoteMethods()`` instead
of ``promoteProperties():``

.. code-block:: php
   :caption: **example.php**

   <?php

   namespace YourNamespace;

   class YourDynamicClass {
      public function __call($method) {
         return $this->$method();
      }

      protected function protectedMethod(): string {
      }
   }

.. code-block:: php
   :caption: **.houdini.php**

   <?php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   // promote the protected methods so they're visible outside the class:
   houdini()->overrideClass(YourDynamicClass::class)
       ->promoteMethods()
       ->filter( AccessFilter::isProtected() );


Go to the :doc:`next step <filters>` to see how filters work.
