using System;
using System.Collections.Generic;

namespace Web_API.Models
{
    // Product.cs
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int RestaurantId { get; set; }
        public Restaurant Restaurant { get; set; }
    }
}
