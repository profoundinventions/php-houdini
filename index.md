---
nav_order: 1
---
## PHP Houdini Documentation

This document describes how to use the PhpStorm plugin `PHP Houdini`

`PHP Houdini` allows you to add completion for classes with magic methods
and properties.


1. Table of Contents

{:toc}

[comment]: <> (1. [The .houdini.php config file]&#40;#the-houdini-config-file&#41;)

[comment]: <> (1. [Promoting properties]&#40;#promoting-properties&#41;)

[comment]: <> (1. [Promoting methods]&#40;#promoting-methods&#41;)

[comment]: <> (1. [Filters]&#40;#filters&#41;)

[comment]: <> (1. [Transforms]&#40;#transforms&#41;)

[comment]: <> (1. [Adding dynamic properties]&#40;#adding-dynamic-properties&#41;)

[comment]: <> (   1. [from a single property]&#40;#dynamic-properties-from-a-single-property&#41;)

[comment]: <> (   1. [from all properties]&#40;#dynamic-properties-from-all-properties&#41;)

[comment]: <> (   1. [from a single constant]&#40;#dynamic-properties-from-a-single-constant&#41;)

[comment]: <> (   1. [from all constants]&#40;#dynamic-properties-from-all-constants&#41;)

[comment]: <> (1. [Adding dynamic methods]&#40;#adding-dynamic-methods&#41;)

[comment]: <> (   1. [from a single property]&#40;#dynamic-methods-from-a-single-property&#41;)

[comment]: <> (   1. [from all properties]&#40;#dynamic-methods-from-all-properties&#41;)

[comment]: <> (   1. [from a single constant]&#40;#dynamic-methods-from-a-single-constant&#41;)

[comment]: <> (   1. [from all constants]&#40;#dynamic-properties-from-all-constants&#41;)

[comment]: <> (1. [Array Patterns]&#40;#array-patterns&#41;)

[comment]: <> (   1. [Completing properties from ArrayPatterns]&#40;#completing-properties-from-arraypatterns&#41;)

[comment]: <> (   1. [Completing methods from ArrayPatterns]&#40;#completing-methods-from-arraypatterns&#41;)

[comment]: <> (1. [List of filters]&#40;#list-of-filters&#41;)

[comment]: <> (1. [List of transforms]&#40;#list-of-transforms&#41;)

[comment]: <> (1. [Support or contact]&#40;#support-or-contact&#41;)

### The Houdini config file

### Promoting Properties

Let's say you have a class that uses `__get()` to allow public access
to properties that are `private` and `protected`. Here's an example that
will cause PhpStorm to complete the private/protected properties for you
for that class:

```php
<?php // example.php

namespace YourNamespace;

class YourDynamicClass
{
   /** @var string */
   private $privateProperty;
   
   /** @var int */
   protected $protectedProperty;
   
   public function __get($name) { return $this->$name; }
}
```

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
<?php // example.php

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

Having trouble with the plugin or have feature requests? Send an email to `profoundinventions+houdini@gmail.com`
and we'll help you sort it out.