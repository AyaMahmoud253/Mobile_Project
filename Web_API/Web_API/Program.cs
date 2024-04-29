using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Web_API.helpers;
using Web_API.Models;
using Web_API.services;

var builder = WebApplication.CreateBuilder(args);

// Accessing configuration
var configuration = builder.Configuration;
var jwtSettings = new JWT();
configuration.GetSection("JWT").Bind(jwtSettings);
builder.Services.AddSingleton(jwtSettings);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();



// Add DbContext and Identity
builder.Services.AddDbContext<ApplicationDBContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"))
);
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options =>
{
    // Setting the password policy
    options.Password.RequireDigit = false; // Not requiring digits
    options.Password.RequireLowercase = false; // Not requiring lowercase letters
    options.Password.RequireNonAlphanumeric = false; // Not requiring non-alphanumeric characters
    options.Password.RequireUppercase = false; // Not requiring uppercase letters
    options.Password.RequiredLength = 8; // Mandatory: At least 8 characters
    // Adjust other options as needed
    // Configure email options for normalization
   
})
    .AddEntityFrameworkStores<ApplicationDBContext>()
    .AddDefaultTokenProviders();

// Add authentication
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})

.AddJwtBearer(o =>
{
    o.RequireHttpsMetadata = false;
    o.SaveToken = false;
    o.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidIssuer = configuration["JWT:Issuer"] ?? throw new ArgumentNullException("JWT:Issuer"),
        ValidAudience = configuration["JWT:Audience"] ?? throw new ArgumentNullException("JWT:Audience"),
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JWT:Key"] ?? throw new ArgumentNullException("JWT:Key")))
    };
});

// Add other scoped services
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddRazorPages();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
// Add authentication and authorization middleware
app.UseAuthentication();
app.UseAuthorization();

app.MapRazorPages();
app.MapControllers();

app.Run();
