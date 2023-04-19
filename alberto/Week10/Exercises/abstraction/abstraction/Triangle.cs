using System;
namespace OOP
{
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
