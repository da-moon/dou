using System;
namespace Encapsulation
{
    public class SectionA : Building
    {
        public void Department1()
        {
            Console.WriteLine($"This is the department #1 in the section A of the {base.GetName()}");
        }

        public void Department2()
        {
            Console.WriteLine($"This is the department #2 in the section A of the {base.GetName()}");
        }

    }

}
