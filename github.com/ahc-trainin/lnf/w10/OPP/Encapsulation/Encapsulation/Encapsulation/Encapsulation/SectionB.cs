using System;
namespace Encapsulation
{
    public class SectionB : Building
    {
        private void Department1()
        {
            Console.WriteLine($"This is the department #1 in the section B of the {base.GetName()}");
        }

        private void Department2()
        {
            Console.WriteLine($"This is the department #2 in the section B of the {base.GetName()}");
        }

    }

}
