using System;
namespace OOP
{
    public class Fox : Animal
    {
        public Fox()
        {
        }

        public override void Eat(string meal)
        {
            Console.WriteLine($"Chewing {meal}");
        }
    }
}
