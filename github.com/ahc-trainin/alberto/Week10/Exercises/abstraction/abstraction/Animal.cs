using System;
namespace OOP
{
    public class Animal
    {
        public Animal()
        {
        }

        public virtual void Eat( string meal)
        {
            Console.WriteLine($"Digesting {meal}");
        }
    }
}
