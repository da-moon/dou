using System;
namespace Inheritance
{
    public class Seal : Animal
    {

        public override void Breathe()
        {
            Console.WriteLine("The Seal is breathing");
        }

        public override string Run()
        {
            return "The seal is " + base.Run();
        }

        }
    }

