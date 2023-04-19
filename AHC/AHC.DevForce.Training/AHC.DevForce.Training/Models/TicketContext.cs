using System;
using Microsoft.EntityFrameworkCore;

namespace AHC.DevForce.Training.Models
{
    public class TicketContext : DbContext
    {
        public TicketContext(DbContextOptions<TicketContext> options) : base(options)
        {
       
        }

        public DbSet<Event> Events { get; set; }

        public DbSet<Location> Locations { get; set; }

        public DbSet<Sales> Sales { get; set; }

    }
    
}
