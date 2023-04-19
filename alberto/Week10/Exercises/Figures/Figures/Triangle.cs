using System;
namespace Figures
{
    public class Triangle : IShape
    {

        public double Area(double width, double height)
        {
            return width * height / 2;
        }

        double IShape.Perimeter(double perimeter)
        {
            return perimeter;
        }
    }
}
