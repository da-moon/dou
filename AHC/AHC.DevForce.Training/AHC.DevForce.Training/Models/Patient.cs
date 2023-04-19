using System;

namespace AHC.DevForce.Training.Models
{
    public class Patient
    {
        public Guid Id { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Gender { get; set; }

        public DateTime BirthDate { get; set; }
    }
}
