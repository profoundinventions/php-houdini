----------------
Array Patterns
----------------

In some projects, you may encounter classes that have complex specifications
of types inside of constants or properties.

Houdini can generate completion for methods or properties from such definitions
using *Array Patterns*

.. note::
    The use of this is pretty specialized, and you don't need it to use Houdini, which is why
    it's at the end of this tutorial. Feel free to :doc:`skip array patterns <support>`
    if you don't need it.


Array patterns parse the class definition, and then autocomplete methods or properties from
the default values based on patterns you describe in the ``.houdini.php`` file.

.. toctree::
    simple-array-patterns
    complex-array-patterns
