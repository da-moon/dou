using AHC.DevForce.Training.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;

namespace AHC.DevForce.Training.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SalesController : ControllerBase
    {
        private readonly TicketContext _context;

        public SalesController(TicketContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok(this._context.Sales.Include("Event").ToList());
        }

        [HttpGet("user/{id}")]
        public IActionResult Get(int id)
        {
            return Ok(this._context.Sales.Where(sales => sales.UserId == id).Include("Event").ToList());
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Sales saleInformation)
        {

            this._context.Sales.Add(saleInformation);

            int result = await this._context.SaveChangesAsync();
            return Ok(result != -1 ? true : false);
        }

    }
}
