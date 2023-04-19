using System;
namespace Abstraction
{
    public class Triangle : Shape

    {
        public double Bas { get; set; }
        public double Heigth { get; set; }

        public Triangle(double bas, double height)
        {
     
            this.Bas = bas;
            this.Heigth = height;

        }

        public override double Area()
        {
            return Bas * Heigth / 2;
        }
    }
}
