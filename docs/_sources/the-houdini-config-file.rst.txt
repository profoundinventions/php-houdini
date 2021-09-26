The Houdini config file
^^^^^^^^^^^^^^^^^^^^^^^

The Houdini plugin is configured by a ``.houdini.php`` config file
in the root of each project. This file is similar  to ``.phpstorm.meta.php``.
You will use some function calls within this file to configure the plugin.

The namespace of the config file must be ``Houdini\\Config\V1``.
Each configuration of a dynamic class will begin with the function call ``houdini()``.
That function returns an object you can use for configuring the plugin.

So, to start configuring the plugin, you can do this:

.. code-block:: php

    <?php // inside .houdini.php
    namespace Houdini\Config\V1;

    houdini()->

PhpStorm should show a dropdown with completion options once you finish typing
the ``->`` arrow. You'll need to use the ``modifyClass()`` method to add dynamic
completion.


