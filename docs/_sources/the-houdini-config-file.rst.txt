-----------------------
The Houdini Config File
-----------------------

The Houdini plugin is configured by a ``.houdini.php`` config file
in the root of each project. This file is similar  to ``.phpstorm.meta.php``.
Like ``.phpstorm.meta.php``, you will use some special function calls inside
this file to configure autocompletion.

The namespace of the config file must be ``Houdini\Config\V1``. Each configuration of a dynamic
class will begin with the function call one or more calls to the function ``houdini()``. That
function returns an object you can use for configuring the plugin with a fluent interface.

.. note::
    Although the syntax of the config file is PHP, you can't use PHP functions like ``str_replace``
    inside ``.houdini.php``. You can only use classes and methods from the ``Houdini\Config\V1``
    namespace inside ``.houdini.php``.

So, to start configuring the plugin, you can do this:

.. code-block:: php
    :caption: **Inside .houdini.php**

    <?php
    namespace Houdini\Config\V1;

    houdini()->

PhpStorm should show a dropdown with completion options once you finish typing
the ``->`` arrow. You'll need to use the ``overrideClass()`` method to add dynamic
completion.

The ``overrideClass()`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``overrideClass()`` method takes one paraemeter: the name of the class
to modify the autocompletion for. You can either pass a fully-qualified class
name as a string, or add a ``use`` statement add the ``::class`` modifier after the class
to affect:

.. code-block:: php
    :caption: **Inside .houdini.php**

    <?php
    namespace Houdini\Config\V1;

    use YourDynamicNamespace\YourDynamicClass;

    // works:
    houdini()
        ->overrideClass('\YourDynamicNamespace\YourDynamicClass');

    // also works:
    houdini()
        ->overrideClass(YourDynamicClass::class);

The ``overrideClass()`` by itself doesn't do anything here - it only
returns an object that you can use to further configure completion with
a `fluent interface <https://en.wikipedia.org/wiki/Fluent_interface interface>`_.

Go to the :doc:`next step <promoting-properties>` to see a more complete example.



