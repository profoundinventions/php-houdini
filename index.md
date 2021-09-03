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
1. [Adding dynamic properties](#adding-dynamic-properties)
   1. [from a single property](#dynamic-properties-from-a-single-property)
   1. [from all properties](#dynamic-properties-from-all-properties)
   1. [from a single constant](#dynamic-properties-from-a-single-constant)
   1. [from all constants](#dynamic-properties-from-all-constants)
1. [Adding dynamic methods](#adding-dynamic-methods)
   1. [from a single property](#dynamic-methods-from-a-single-property)
   1. [from all properties](#dynamic-methods-from-all-properties)
   1. [from a single constant](#dynamic-methods-from-a-single-constant)
   1. [from all constants](#dynamic-properties-from-all-constants)
1. [Array Patterns](#array-patterns)
   1. [Completing properties from ArrayPatterns](#completing-properties-from-arraypatterns)
   1. [Completing methods from ArrayPatterns](#completing-methods-from-arraypatterns)
1. [List of filters](#list-of-filters)
1. [List of transforms](#list-of-transforms)
1. [Support or contact](#support-or-contact)

### The Houdini config file

The Houdini plugin is configured by a `.houdini.php` config file
in the root of each project. This file is similar  to `.phpstorm.meta.php`.
You will use some function calls within this file to configure the plugin.

The namespace of the config file must be `Houdini\Config\V1`. 
Each configuration of a dynamic class will begin with the function call `houdini()`.
That function returns an object you can use for configuring the plugin.

So, to start configuring the plugin, you can do this:

```php
<?php // inside .houdini.php
namespace Houdini\Config\V1;

houdini()->
```

PhpStorm should show a dropdown with completion options once you finish typing
the `->` arrow. You'll need to use the `modifyClass()` method to add dynamic
completion.

### Promoting Properties

Let's say you have a class that uses `__get()` to allow public access
to properties that are `private` and `protected`. Here's an example that
will cause PhpStorm to complete the private/protected properties for you
for that class:

```php
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

Methods can be promoted similarly to properties - just use `promoteMethods()` instead
of `promoteProperties():`

```php
<?php

namespace YourNamespace;

class YourDynamicClass {
   public function __call($method) {
      return $this->$method();
   }
   
   protected function protectedMethod(): string {
   }
}
```

```php
<?php // inside .houdini.php
namespace Houdini\Config\V1;

use YourNamespace\YourDynamicClass;

// promote the protected methods so they're visible outside the class:
houdini()->modifyClass(YourDynamicClass::class)
    ->promoteMethods()
    ->filter( AccessFilter::isProtected() );
```

### Filters

You can pass multiple filters to the filter method, and they will be combined with logical AND - so *all* of the filters
passed must apply for the method or property to be added. If you want to combine filters with logical OR, you can
use `AnyFilter::create()` method and pass both filters in:

```php
<?php // inside .houdini.php
namespace Houdini\Config\V1;

use YourNamespace\YourDynamicClass;

houdini()->modifyClass(YourDynamicClass::class)
    ->promoteProperties()
    ->filter( AnyFilter::create(
       AccessFilter::isProtected(), 
       AccessFilter::isPrivate() 
    ));
```

### Transforms

If the names of the public versions of the properties / methods are 
different, you can use the `transform()` method to change the publicly visible name of the property:

```php
<?php // inside .houdini.php
namespace Houdini\Config\V1;

use YourNamespace\YourDynamicClass;

// Make the publicly visible name camelCase instead of snake_case:
houdini()->modifyClass(YourDynamicClass::class)
    ->promoteProperties()
    ->transform( NameTransform::camelCase() );
```

A list of available transforms is on the NameTransform class. You can see the full list by
typing `NameTransform::` and then invoking PhpStorm's completion, or here on the [list of transforms](#list-of-transforms)

### Adding dynamic properties

#### Dynamic properties from a single property

#### Dynamic properties from all properties

#### Dynamic properties from a single constant

#### Dynamic properties from all constants

### Adding dynamic methods

#### Dynamic methods from a single property

#### Dynamic methods from all properties

#### Dynamic methods from a single constant

#### Dynamic methods from all constants
      
### Array Patterns

#### Completing properties from ArrayPatterns

#### Completing methods from ArrayPatterns
      
### List of filters

### List of transforms

### Support or Contact

Having trouble with the plugin or feature requests? Send an email to `profoundinventions+houdini@gmail.com`
and we'll help you sort it out.
Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.
