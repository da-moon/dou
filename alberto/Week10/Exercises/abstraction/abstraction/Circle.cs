using System;
namespace OOP
{
    public class Circle : Shape
    {
        private double radio;
        public Circle(double r)
        {
            radio = r;
        }

        public override double Area()
        {
            return radio * radio * 3.1416;
        }
    }
}
