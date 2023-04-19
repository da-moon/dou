using System;
namespace OOP
{
    public class ShapeParent
    {
        protected double width;
        protected double height;

        public void SetWidth(double width)
        {
            this.width = width;
        }

        public void SetHeight(double height)
        {
            this.height = height;
        }
    }
}
