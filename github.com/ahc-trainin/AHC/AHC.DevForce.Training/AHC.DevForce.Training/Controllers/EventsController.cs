using AHC.DevForce.Training.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;

namespace AHC.DevForce.Training.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EventsController : ControllerBase
    {
        private readonly TicketContext _context;


        public EventsController(TicketContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Get()
        {
         
            return Ok(this._context.Events.Include("Location").ToList());
        }

        [HttpGet("future-events")]
        public IActionResult GetFutureEvents()
        {
            return Ok(this._context.Events.Where(eve => eve.Date > System.DateTime.Now).ToList());
        }

        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {
            return Ok(this._context.Events.Include("Location").FirstOrDefault(eve => eve.Id == id));
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Event eventInformation)
        {
       
            this._context.Events.Add(eventInformation);

            int result = await this._context.SaveChangesAsync();
            return Ok(result != -1 ? true : false );
        }

        [HttpPut]
        public async Task<IActionResult> Put([FromBody] Event eventInformation)
        {
            this._context.Update<Event>(eventInformation);
            int result = await this._context.SaveChangesAsync();
            return Ok(result != -1 ? true : false);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var evn = this._context.Events.First(eventInfo => eventInfo.Id == id);
            this._context.Events.Remove(evn);
            int result = await this._context.SaveChangesAsync();
            return Ok(result != -1 ? true : false);
        }
    }
}
