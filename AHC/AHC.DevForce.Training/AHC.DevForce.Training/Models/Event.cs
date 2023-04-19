using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AHC.DevForce.Training.Models
{
    [Table("Events")]

    public class Event
    {
            public int Id { get; set; }

            [Required(ErrorMessage ="The property of name is required")]

            public string Name { get; set; }

            public int LocationId { get; set; }

            public int Tickets { get; set; }

            public DateTime Date { get; set; }

            public string Description { get; set; }

            public int PriceTicket { get; set; }

            public virtual Location Location { get; set; }
    }
    
}
