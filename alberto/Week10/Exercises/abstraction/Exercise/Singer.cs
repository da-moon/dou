using System;
namespace Exercise
{
    public class Singer : Person
    {

        protected string bandName;
        public Singer(string name, string designation, string bandName)
        {
            this.name = name;
            this.designation = designation;
            this.bandName = bandName;
        }

        public override void Learn(string song)
        {
            Console.WriteLine($"{this.name} is learning to play {song}");
        }

        public void Singing(string song)
        {
            Console.WriteLine($"{this.name} is singing {song} with the band" +
                $"{bandName}");
        }

        public void PlayGuitar()
        {
            Console.WriteLine($"{this.name} plays the guitar for the band {bandName}");
        }
    }
}
