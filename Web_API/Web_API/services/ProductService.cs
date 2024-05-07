using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Web_API.Models;

namespace Web_API.Services
{
    public class ProductService : IProductService
    {
        private readonly ApplicationDBContext _context;

        public ProductService(ApplicationDBContext context)
        {
            _context = context;
        }

        public async Task<List<Restaurant>> GetRestaurantsByProduct(string productName)
        {
            return await _context.Products
                .Where(p => p.Name.ToLower() == productName.ToLower())
                .Select(p => p.Restaurant)
                .Distinct()
                .ToListAsync();
        }
    }
}
