using System;
using System.Text;

namespace Inheritance
{
    public abstract class Animal
    {
        public abstract void Breathe();

        public virtual string Run()
        {
            return "running";
        }
   

    }
}
