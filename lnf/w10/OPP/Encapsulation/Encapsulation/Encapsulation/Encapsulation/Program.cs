using System;

namespace Encapsulation
{
    class Program
    {
        static void Main(string[] args)
        {
            SectionA sectionA = new SectionA();
            SectionB sectionB = new SectionB();

            sectionA.Department1();
            sectionA.Department2();
        }
    }
}
