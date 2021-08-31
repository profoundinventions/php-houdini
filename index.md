## PHP Houdini Documentation

This document describes how to use the PhpStorm plugin `PHP Houdini`

`PHP Houdini` allows you to add completion for classes with magic methods
and properties.

### Table of Contents

1. [The .houdini.php config file](#the-houdini-config-file)
1. [Promoting properties](#promoting-properties)
1. [Promoting methods](#promoting-methods)
1. [Filters](#filters)
1. [Transforms](#transforms)
1. [Completing methods from properties]()
1. [Completing methods from constants]()
1. [Completing properties from methods]()
1. [Completing properties from properties]()
1. [Completing properties from constants]()
1. [ArrayPatterns]()
1. [Completing methods from ArrayPatterns]()
1. [Completing properties from ArrayPatterns]()

### The houdini config file

The plugin is configured by a `.houdini.php` config file with a special syntax
in the root of each project. This file is similar  to `.phpstorm.meta.php`.
You will use some function calls within this file to configure the plugin.

The namespace of the config file must begin with `Houdini\Config\V1`. 
Each configuration of a class will begin with the function call `houdini()`,
That function returns an object you can use for configuring the plugin.

So, to start configuring the plugin, you can do this:
```php
<?php // inside .houdini.php
namespace Houdini\Config\V1;

houdini()->
```

### Promoting Properties

Let's say you have a class that uses `__get()` to allow public access
to properties that are `private` and `protected`. Here's an example that
will cause PhpStorm to complete the private/protected properties for you
for that class:

```php
<?php // inside .houdini.php
namespace Houdini\Config\V1;

use YourNamespace\YourDynamicClass;

houdini()->modifyClass(YourDynamicClass::class)
    ->promoteProperties();
```

#### Only promoting protected properties

The previous example will promote all properties, private and protected.
If you only wanted to promote protected ones, you could add a [filter](#filters):

```php
<?php // inside .houdini.php
namespace Houdini\Config\V1;

use YourNamespace\YourDynamicClass;

houdini()->modifyClass(YourDynamicClass::class)
    ->promoteProperties()
    ->filter( AccessFilter::isProtected() );
```

The `AccessFilter` class used here is defined in the `Houdini\Config\V1`
namespace. 

### Promoting Methods

#### todo
### Filters

You can pass multiple filters to the filter method, and they will be
combined with logical AND - so all the filters must apply. 
If you want to combine filters with logical OR, you can use `AnyFilter`:

```php
<?php // inside .houdini.php
namespace Houdini\Config\V1;

use YourNamespace\YourDynamicClass;

houdini()->modifyClass(YourDynamicClass::class)
    ->promoteProperties()
    ->filter( AnyFilter::create(AccessFilter::isProtected(), AccessFilter::isPrivate() );
```

### Transforms


### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.
