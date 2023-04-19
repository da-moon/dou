using System;

namespace Abstraction
{
    class Program
    {
        static void Main(string[] args)
        {

            Triangle newTriangle = new Triangle(12, 24);
            Console.WriteLine($"El area del triangulo es: {newTriangle.Area()}");
        }
    }
}
