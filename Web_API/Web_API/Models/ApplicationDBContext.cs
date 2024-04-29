using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Web_API.Models
{
    public class ApplicationDBContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDBContext(DbContextOptions<ApplicationDBContext> options) : base(options)
        {
        }
        public DbSet<Restaurant> Restaurants { get; set; }
        public DbSet<Product> Products { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Product>()
            .HasOne(p => p.Restaurant)         // A product belongs to one restaurant
            .WithMany(r => r.Products)          // A restaurant can have many products
            .HasForeignKey(p => p.RestaurantId);

            modelBuilder.Entity<Restaurant>().HasData(
            new Restaurant { Id = 1, Name = "The Cheesecake Factory", Address = "Rockefeller Plaza, New York, NY", Latitude = 40.7580, Longitude = -73.9794 },
            new Restaurant { Id = 2, Name = "McDonald's", Address = "700 Clark Ave, Mountain View, CA", Latitude = 37.3860, Longitude = -122.0838 },
            new Restaurant { Id = 3, Name = "Starbucks", Address = "1600 Amphitheatre Parkway, Mountain View, CA", Latitude = 37.4235, Longitude = -122.0866 },
            new Restaurant { Id = 4, Name = "Pizza Hut", Address = "7100 Corporate Dr, Plano, TX", Latitude = 33.0137, Longitude = -96.6925 },
            new Restaurant { Id = 5, Name = "Subway", Address = "325 Bic Dr #130, Milford, CT", Latitude = 41.2362, Longitude = -73.0627 },
            new Restaurant { Id = 6, Name = "Chick-fil-A", Address = "5200 Buffington Rd, Atlanta, GA", Latitude = 33.6499, Longitude = -84.4689 }
            // Add more restaurants with their real data
        );

            modelBuilder.Entity<Product>().HasData(
                new Product { Id = 1, Name = "Cheesecake", RestaurantId = 1 },
                new Product { Id = 2, Name = "Big Mac", RestaurantId = 2 },
                new Product { Id = 3, Name = "Latte", RestaurantId = 3 },
                new Product { Id = 4, Name = "Pepperoni Pizza", RestaurantId = 4 },
                new Product { Id = 5, Name = "Italian BMT", RestaurantId = 5 },
                new Product { Id = 6, Name = "Chick-fil-A Sandwich", RestaurantId = 6 },
                new Product { Id = 7, Name = "Chick-fil-A Sandwich", RestaurantId = 5 },
                new Product { Id = 8, Name = "Latte", RestaurantId = 5 }
            // Add more products with their real data
            );
            // Configure constraints or relationships if needed
        }
    }
}
