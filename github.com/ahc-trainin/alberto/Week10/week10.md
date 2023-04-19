# Week 10
## OOP
### What is an instance?
It's when we are creating an object based on a class. By doing this we are instantiating a class.

### What are the four pillars of OOP?
- Encapsulation
- Abstraction
- Polymorphysm
- Inheritance

### What is the difference between instance and class?
A class is defined by methos and properties that will be executed by an object, that object is an instance of a class.

### What does it mean a class will derive from another?
That it will have a parent class that will share it properties with it.

### How would you follow encapsulation principle in C#?
With access modifiers, which will be in charge of the encapsulation:
- public
- private
- protected
- internal

### Put an example of polymorphism?
``` 
    public void Add(int a, int b){
        Console.WriteLine(a + b);
    }

    public void Add(int a, int b, int c){
        Console.WriteLine(a + b + c);
    }
```

### If i have a the following...
```
class Animal {
  public int Weight { get; set; }
  public int Height { get; set; }

  public Animal (int weight, int height) {
    this.Weight = weight;
    this.Height = height;
  }
}

class Horse : Animal {
  public string race { get; set; }
  public Horse (string race) : base(800, 234) {
    this.Reight = race;
  }
}
```

### What are the properties you can interact with an instance of Horse?

### Explain encapsulation in your own words.
Encapsulation are the different levels of acces that a class could have, it could be public and share all of it's methods with every other class, it can be private and it's methods could be accessed only in that class or protected and it will share it's methods with it's childs.

### Difference between abstract class and interface?
An interface is an specific type of class where we will declare all of the methods, that we will might want to inherit to other classes, but this couldn't have a body. An abstract class is a hybrid between an interface an a normal class, we can create methods with a body or just declare them, but an abstract class as an interface can't be instantiated.

### How do you define an abstract class?
A special type of class were we can declare methods with a defined body, or we can add abstract methods as an interface.


### Can you define abstract methods, how?
Abstact methods are only declared on interfaces or abstract classes, this methods do not have a body and they need to be overrided wehn they are inherit to another class.


### How do you instantiate an abstract class?
Abstract classes can't be instatiated, only inherited.

### How do you implement the methods
By instantiating a class we can implement it's methods ``` Animal animal = new Animal(); animal.Eat(); ```

### How do you define a pure abstract class?
We need to specify that it will be an abstract class ``` public abstract class {} ```

### Difference between overload and override?
Overload means that we could have different methods with the same name but with different parameters.
```
    public void Add(int a, int b){
        Console.WriteLine(a + b);
    }

    public void Add(int a, int b, int c){
        Console.WriteLine(a + b + c);
    }
```
Override means that we will add or change the code from an existing (inherit) method.
```
namespace OOP
{
    public abstract class Shape
    {
        public abstract double Area();

        public static double Perimeter()
        {
            return 2.0;
        }
    }

    public class Triangle : Shape
    {
        private readonly double height;
        private readonly double width;

        public Triangle(double h, double w)
        {
            height = h;
            width = w;
        }

        public override double Area()
        {
            return height * width / 2;
        }
    }
}
```

### What does sealed mean?
The sealed modifier it's used to prevent hte inheritance from one class to another. When we sealed a class, this will be encapsulated and no other class could inherit from this.

### Explain with your own words what inheritance is?
The hability of sharing the elements of one class to another.

### What is a signature?
A signature is a special indeitifier for methods, which is composed by it's name and parameter types.