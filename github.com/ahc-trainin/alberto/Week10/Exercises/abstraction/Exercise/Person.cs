using System;
namespace Exercise
{
    public abstract class Person
    {
        protected string name;
        protected string designation;

        public abstract void Learn(string activity);

        public static void Walk()
        {
            Console.WriteLine("The person is walking");
        }

        public void Eat(string food)
        {
            Console.WriteLine($"The person is eating {food}");
        }
    }
}
