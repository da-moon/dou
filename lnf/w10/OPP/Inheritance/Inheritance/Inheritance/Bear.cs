using System;
namespace Inheritance
{
    public class Bear : Animal
    {

        public override void Breathe()
        {
            Console.WriteLine("The Bear is breathing");
        }

        public override string Run()
        {
            return "The bear is " + base.Run();
        }

        }
    }
