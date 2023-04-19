using System;

namespace TriangleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            Shape Equilaterus = new Triangle(15, 15, 15);
            Console.WriteLine("Area equals to {0}", Equilaterus.Area());
        }
    }
}
