using System;

namespace Inheritance
{
    class Program
    {
        static void Main(string[] args)
        {
           
            Bear bear = new Bear();
            Seal seal = new Seal();

            bear.Breathe();
            Console.WriteLine(bear.Run());

            seal.Breathe();
            Console.WriteLine(seal.Run());

        }
    }
}
