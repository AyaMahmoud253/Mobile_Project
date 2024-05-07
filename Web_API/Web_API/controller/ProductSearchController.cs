using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using Web_API.Services;

namespace Web_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductSearchController : ControllerBase
    {
        private readonly IProductService _productService;

        public ProductSearchController(IProductService productService)
        {
            _productService = productService;
        }

        [HttpGet("{productName}")]
        public async Task<ActionResult> GetRestaurantsByProduct(string productName)
        {
            var restaurants = await _productService.GetRestaurantsByProduct(productName);

            if (restaurants == null || restaurants.Count == 0)
            {
                return NotFound($"No restaurants found offering the product '{productName}'.");
            }

            return Ok(restaurants);
        }
    }
}
