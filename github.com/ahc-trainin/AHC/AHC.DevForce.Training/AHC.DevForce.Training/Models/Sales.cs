using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace AHC.DevForce.Training.Models
{
    [Keyless]
    [Table("Sales")]
    public class Sales
    {
        [Required(ErrorMessage="An event needs to be specified")]
        public int EventId { get; set; }

        [Required(ErrorMessage = "An user needs to be specified")]
        public int UserId { get; set; }

        [Required(ErrorMessage = "The amount to pay needs to be specified")]
        public int Amount { get; set; }

        [Required(ErrorMessage ="The number of tickets needs to be specified")]
        public int Tickets { get; set; }

        public virtual Event Event { get; set; }


    }
}
