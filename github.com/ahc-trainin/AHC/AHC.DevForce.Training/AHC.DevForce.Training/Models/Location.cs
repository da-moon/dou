using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AHC.DevForce.Training.Models
{
    [Table("Locations")] 
    public class Location
    {
            public int Id { get; set; }

            [Required(ErrorMessage ="The property of name is required")]
            public string Name { get; set; }

            public string Address { get; set; }

            [Column("Max_Capacity")]
            public int MaxCapacity { get; set; }

    }
    
}
