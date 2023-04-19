# Week 11
## Interfaces
### How do you instantiate an interface?
An interface cannot be instatiated, but we can implement it by instantiating a class with the type of our interface, example:
``` 
    IShape shape = new Triangle();
    
    interface IShape { ... }

    class Triangle : IShape { ... }
```

### What kind of items does an interface cannot contain?
it cannot have parameters, constructors or methods with a body.

### What kind of access modifiers are allowed in interfaces?
An interface could be public, protected, internal and protected internal. It cannot be private because it will be blocked and anything could be implemented or inherited.

### How can you accomplish multiple interface implementation?
In C# we can inherit from different classes or in this case interfaces by doing this:
``` class Children : Father, Mother { ... } ```

## Generics
### What a generic type is?
A generic types is the generic form, which means that no specific type is required.

### When is useful or why they were designed in first place?
It's useful in many ways. For example, when we are trying to implement a class with different methods that will work with different data types, we define it as generic as well as it methods, and when that class is instantiated it does not matter the type, it will always works do to it's nature of generic.

## Data Structures
### Difference between Array an Linked List?
An array has a size, when we declare an array we need to specify the size of it, by the other hand, a list could keep growing as we please, we just keep adding elements or removing them, and it will fix it's size according to the number of elements.

### Difference between a queue and stack?
A stack is a pile of elements, which will be process from the top to the end. Queues works the opposite way, it will process the elements in the order of appereance.

## Reflection
### Give one use of reflection
It could be useful when we are calling to a certain instance of a class/method/parameter and we are not sure the type of it..