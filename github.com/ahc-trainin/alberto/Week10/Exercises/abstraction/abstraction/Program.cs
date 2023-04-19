using System;

namespace OOP
{
    class Program
    {
        static void Main(string[] args)
        {
            //Circle circle = new Circle(4.0);
            //Triangle triangle = new Triangle(4.0, 5.0);

            //Console.WriteLine($"Circle area: {circle.Area()}");
            //Console.WriteLine($"Triangle area: {triangle.Area()}");
            //Console.WriteLine($"Perimeter: {Shape.Perimeter()}");

            //Animal animal = new Animal();
            //Fox fox = new Fox();
            //Python python = new Python();

            //animal.Eat("food");
            //fox.Eat("rabbit");
            //python.Eat("mice");

            //int result1 = Operations.Add(234, 567);
            //int result2 = Operations.Add(123, 987, 456);

            //Console.WriteLine($"Operation 1: {result1}");
            //Console.WriteLine($"Operation 2: {result2}");

            Rectangle rectangle = new Rectangle();

            rectangle.SetWidth(4.3);
            rectangle.SetHeight(3.2);

            Console.WriteLine($"The are is {rectangle.GetArea()}");
        }
    }
}
