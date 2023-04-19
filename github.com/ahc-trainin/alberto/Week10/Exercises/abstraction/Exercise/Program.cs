using System;

namespace Exercise
{
    class Program
    {
        static void Main(string[] args)
        {
            Programmer programmer = new Programmer("Daniela","Web dev","TechM");
            Dancer dancer = new Dancer("John", "Main dancer", "new visions");
            Singer singer = new Singer("Paul", "singer", "The beatles");

            programmer.Learn("Python");
            programmer.Coding("Javascript");
            programmer.Eat("pizza");
            Console.WriteLine($"{programmer.Coding("python", "windows")}");

            dancer.Learn("tango");
            dancer.Dancing("Mambo");

            singer.Learn("Something");
            singer.Singing("Yesterday");
            singer.PlayGuitar();
        }
    }
}
