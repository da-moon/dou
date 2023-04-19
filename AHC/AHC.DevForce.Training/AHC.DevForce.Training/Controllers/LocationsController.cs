using AHC.DevForce.Training.Models;
using Microsoft.AspNetCore.Mvc;

using System.Linq;
using System.Threading.Tasks;

namespace AHC.DevForce.Training.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LocationsController : ControllerBase
    {
        private readonly TicketContext _context;

        public LocationsController(TicketContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok(this._context.Locations.ToList());
        }

        [HttpGet("id")]
        public IActionResult Get(int id)
        {
            return Ok(this._context.Locations.FirstOrDefault(location => location.Id == id));
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Location locationInformation)
        {

            this._context.Locations.Add(locationInformation);

            int result = await this._context.SaveChangesAsync();
            return Ok(result != -1 ? true : false);
        }

        [HttpPut]
        public async Task<IActionResult> Put([FromBody] Location locationInformation)
        {
            this._context.Update<Location>(locationInformation);
            int result = await this._context.SaveChangesAsync();
            return Ok(result != -1 ? true : false);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var evn = this._context.Locations.First(locationInfo => locationInfo.Id == id);
            this._context.Locations.Remove(evn);
            int result = await this._context.SaveChangesAsync();
            return Ok(result != -1 ? true : false);
        }

    }
}
