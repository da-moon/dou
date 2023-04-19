using System;
namespace Exercise
{
    public class Programmer : Person
    {
        protected string companyName { get; set; }

        public Programmer(string name, string designation, string companyName)
        {
            this.name = name;
            this.designation = designation;
            this.companyName = companyName;
        }

        public override void Learn(string language)
        {
            Console.WriteLine($"{this.name} is learning to program {language}");
        }

        public void Coding(string language)
        {
            Console.WriteLine($"{this.name} is coding on {language}, for {companyName}");
        }

        public int Coding(string language, string system)
        {
            return 1;
        }
    }
}
