using System;
namespace OOP
{
    public class Rectangle : ShapeParent
    {
        public Rectangle()
        {
        }

        public double GetArea()
        {
            return width * height;
        }
    }
}
