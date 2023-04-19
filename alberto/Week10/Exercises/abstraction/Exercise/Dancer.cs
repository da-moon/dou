using System;
namespace Exercise
{
    public class Dancer : Person
    {
        protected string groupName;

        public Dancer(string name, string designation, string groupName)
        {
            this.name = name;
            this.designation = designation;
            this.groupName = groupName;
        }

        public override void Learn(string dance)
        {
            Console.WriteLine($"{this.name} is learning to dance {dance}");
        }

        public void Dancing(string dance)
        {
            Console.WriteLine($"{this.name} is dancing {dance} with {groupName}");
        }
    }
}
