using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Web_API.Migrations
{
    /// <inheritdoc />
    public partial class InitialAA : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Restaurants",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Latitude = table.Column<double>(type: "float", nullable: false),
                    Longitude = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Restaurants", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Products",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    RestaurantId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Products", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Products_Restaurants_RestaurantId",
                        column: x => x.RestaurantId,
                        principalTable: "Restaurants",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Restaurants",
                columns: new[] { "Id", "Address", "Latitude", "Longitude", "Name" },
                values: new object[,]
                {
                    { 1, "Rockefeller Plaza, New York, NY", 40.758000000000003, -73.979399999999998, "The Cheesecake Factory" },
                    { 2, "700 Clark Ave, Mountain View, CA", 37.386000000000003, -122.0838, "McDonald's" },
                    { 3, "1600 Amphitheatre Parkway, Mountain View, CA", 37.423499999999997, -122.0866, "Starbucks" },
                    { 4, "7100 Corporate Dr, Plano, TX", 33.0137, -96.692499999999995, "Pizza Hut" },
                    { 5, "325 Bic Dr #130, Milford, CT", 41.236199999999997, -73.062700000000007, "Subway" },
                    { 6, "5200 Buffington Rd, Atlanta, GA", 33.649900000000002, -84.468900000000005, "Chick-fil-A" }
                });

            migrationBuilder.InsertData(
                table: "Products",
                columns: new[] { "Id", "Name", "RestaurantId" },
                values: new object[,]
                {
                    { 1, "Cheesecake", 1 },
                    { 2, "Big Mac", 2 },
                    { 3, "Latte", 3 },
                    { 4, "Pepperoni Pizza", 4 },
                    { 5, "Italian BMT", 5 },
                    { 6, "Chick-fil-A Sandwich", 6 },
                    { 7, "Chick-fil-A Sandwich", 5 },
                    { 8, "Latte", 5 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Products_RestaurantId",
                table: "Products",
                column: "RestaurantId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Products");

            migrationBuilder.DropTable(
                name: "Restaurants");
        }
    }
}
