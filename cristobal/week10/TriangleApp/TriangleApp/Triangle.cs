using System;
using System.Collections.Generic;
using System.Text;

namespace TriangleApp
{
    class Triangle : Shape
    {
        public double A;
        public double B;
        public double C; 

    public Triangle(double A, double B, double C)
        {
            this.A = A;
            this.B = B;
            this.C = C; 
        }
    public override double Area()
        {
            return A * B * C;
        }

      }
}
