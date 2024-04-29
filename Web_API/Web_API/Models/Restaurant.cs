using System;
using System.Collections.Generic;

namespace Web_API.Models
{
	public class Restaurant
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public string Address { get; set; }
		public double Latitude { get; set; } // Latitude property
		public double Longitude { get; set; } // Longitude property
		public ICollection<Product> Products { get; set; }
	}
}
