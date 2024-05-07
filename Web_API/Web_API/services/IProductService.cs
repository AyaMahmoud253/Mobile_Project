using System.Collections.Generic;
using System.Threading.Tasks;
using Web_API.Models;

namespace Web_API.Services
{
    public interface IProductService
    {
        Task<List<Restaurant>> GetRestaurantsByProduct(string productName);
    }
}
