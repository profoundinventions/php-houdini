Promoting Methods
-----------------

Methods can be promoted similarly to :doc:`properties <promoting-properties>` - just use ``promoteMethods()`` instead
of ``promoteProperties():``

.. code-block:: php

   <?php // example.php

   namespace YourNamespace;

   class YourDynamicClass {
      public function __call($method) {
         return $this->$method();
      }

      protected function protectedMethod(): string {
      }
   }

.. code-block:: php

   <?php // inside .houdini.php
   namespace Houdini\Config\V1;

   use YourNamespace\YourDynamicClass;

   // promote the protected methods so they're visible outside the class:
   houdini()->modifyClass(YourDynamicClass::class)
       ->promoteMethods()
       ->filter( AccessFilter::isProtected() );


Go to the :doc:`next step <filters>` to see how filters work.
