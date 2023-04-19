using System;
namespace OOP
{
    public class Python : Animal
    {
        public Python()
        {
        }

        public override void Eat(string meal)
        {
            //base.Eat(meal);
            Console.WriteLine($"Swallowing {meal}");
        }
    }
}
