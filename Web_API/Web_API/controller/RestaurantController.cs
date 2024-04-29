using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Web_API.Models;

namespace Web_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RestaurantController : ControllerBase
    {
        private readonly ApplicationDBContext _context;

        public RestaurantController(ApplicationDBContext context)
        {
            _context = context;
        }

        // GET: api/restaurant
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Restaurant>>> GetRestaurants()
        {
            var restaurants = await _context.Restaurants.Include(r => r.Products).ToListAsync();

            // Configure JsonSerializerSettings to ignore reference loops
            var jsonSettings = new JsonSerializerSettings
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            };

            // Serialize the response object to JSON using JsonSerializerSettings
            var jsonResponse = JsonConvert.SerializeObject(restaurants, jsonSettings);

            return Ok(jsonResponse);
        }

        // GET: api/restaurant/5/products
        [HttpGet("{id}/products")]
        public async Task<ActionResult<IEnumerable<Product>>> GetProductsByRestaurant(int id)
        {
            var restaurant = await _context.Restaurants.Include(r => r.Products).FirstOrDefaultAsync(r => r.Id == id);
            if (restaurant == null)
            {
                return NotFound();
            }

            var jsonSettings = new JsonSerializerSettings
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            };

            var jsonResponse = JsonConvert.SerializeObject(restaurant.Products, jsonSettings);

            return Content(jsonResponse, "application/json");
        }
        [HttpGet("products")]
        public ActionResult<IEnumerable<object>> GetProductsAndRestaurantNames()
        {
            var productsWithRestaurantNames = _context.Products
                .Select(p => new
                {
                    ProductId = p.Id,
                    ProductName = p.Name,
                    RestaurantName = p.Restaurant.Name
                })
                .ToList();

            var jsonSettings = new JsonSerializerSettings
            {
                ReferenceLoopHandling = ReferenceLoopHandling.Ignore
            };

            var jsonResponse = JsonConvert.SerializeObject(productsWithRestaurantNames, jsonSettings);

            return Ok(jsonResponse);
        }


    }
}
