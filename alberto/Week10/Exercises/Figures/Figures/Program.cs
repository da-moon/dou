using System;

namespace Figures
{
    class Program
    {
        static void Main(string[] args)
        {
            IShape shape = new Triangle();
            Triangle triangle = new Triangle();

            Console.WriteLine($"The perimeter is {shape.Perimeter(10.0)}");

            Console.WriteLine($"The area of the triangle is {triangle.Area(4.0,3.0)}");
        }
    }
}
