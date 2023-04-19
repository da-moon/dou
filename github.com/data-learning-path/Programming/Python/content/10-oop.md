# How to Use Object-Oriented Programming in Python 🐍

Object-Oriented Programming (OOP) is a widely popular programming paradigm. This method of structuring a program uses objects that have properties and behaviors. Each programming language handles the principles of OOP a little differently, so it’s important to learn OOP for each language you are learning.

> if you want to know more about OOP, you can visit the following link: https://www.educative.io/blog/object-oriented-programming


# What is Object-Oriented Programming?
Object-Oriented Programming is a programming paradigm based on the creation of reusable “objects” that have their own properties and behavior that can be acted upon, manipulated, and bundled.

These objects package related data and behaviors into representations of real-life objects. OOP is a widely used paradigm across various popular programming languages like Python, C++, and Java.

Many developers use OOP because it makes your code reusable and logical, and it makes inheritance easier to implement. It follows the DRY principle, which makes programs much more efficient.

In OOP, every object is defined with its own properties. For example, say our object is an Employee. These properties could be their name, age, and role. OOP makes it easy to model real-world things and the relationships between them. Many beginners prefer to use OOP languages because they organize data much like how the human brain organizes information.

The four main principles of OOP are **inheritance, encapsulation, abstraction, and polymorphism.**

## Properties

![](/img/prop.png)

Property fields within sneaker1 object
Properties are the data that describes an object. Each object has unique properties that can be accessed or manipulated by functions in the program. Think of these as variables that describe the individual object.

For example, a sneaker1 object could have the properties size and isOnSale.

## Methods

![](/img/methods.png)

Methods define the behavior of an object. Methods are like functions that are within the scope of an object. They’re often used to alter the object’s properties.

For example, our sneaker1 object would have the method putOnSale that switches the isOnSale property on or off.

They can also be used to report on a specific object’s properties. For example, the same sneaker1 object could also have a printInfo method that displays its properties to the user.

## Classes

![](/img/classes.png)

Each object is created with a class. Think of this like the blueprint for a certain type of object. Classes list the properties essential to that type of object but do not assign them a value. Classes also define methods that are available to all objects of that type.

For example, sneaker1 was created from the class Shoe that defines our properties, size and isOnSale, and our methods, putOnSale and printInfo. All objects created from the Shoe class blueprint will have those same fields defined.

## Instances

![](/img/instance.png)

An object is an instance of its parent class with a unique name and property values. You can have multiple instances of the same class type in a single program. Program calls are directed to individual instances whereas the class remains unchanged.

For example, our shoe class could have two instances sneaker1, with a size of 8, and sneaker2, with a size of 12. Any changes made to the instance sneaker1 will not affect sneaker2.

## OOP in Python
Python is a multi-paradigm programming language, meaning it supports OOP as well as other paradigms. You use classes to achieve OOP in Python. Python provides all the standard features of object oriented programming.

Developers often choose to use OOP in their Python programs because it makes code more reusable and makes it easier to work with larger programs. OOP programs prevent you from repeating code because a class can be defined once and reused many times. OOP therefore makes it easy to achieve the “Don’t Repeat Yourself” (DRY) principle.

> if you want to know more about OOP, you can visit the following link: https://www.educative.io/blog/how-to-use-oop-in-python

