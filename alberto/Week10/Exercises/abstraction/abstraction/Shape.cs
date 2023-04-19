    using System;
namespace OOP
{
    public abstract class Shape
    {
        public abstract double Area();

        public static int Perimeter(int a)
        {
            return a;
        }

        public static double Perimeter()
        {
            return 2.0;
        }
    }
}
