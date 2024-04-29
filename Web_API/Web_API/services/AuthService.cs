using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Web_API.Models;

namespace Web_API.services
{
    public class AuthService : IAuthService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly IConfiguration _configuration;

        public AuthService(
            UserManager<ApplicationUser> userManager,
            RoleManager<IdentityRole> roleManager,
            SignInManager<ApplicationUser> signInManager,
            IConfiguration configuration)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _signInManager = signInManager;
            _configuration = configuration;
        }

        public async Task<AuthModel> RegisterAsync(RegisterModel model)
        {
            // Check if the "USER" role exists, create it if not
            if (!await _roleManager.RoleExistsAsync("USER"))
            {
                var userRole = new IdentityRole("USER");
                await _roleManager.CreateAsync(userRole);
            }

            var user = new ApplicationUser
            {
                Name = model.Name,
                Gender = model.Gender,
                Email = model.Email,
                Level = model.Level,
                UserName = model.Email,
                EmailConfirmed = true
            };

            var result = await _userManager.CreateAsync(user, model.Password);
            if (!result.Succeeded)
            {
                var errors = string.Join(", ", result.Errors.Select(error => error.Description));
                return new AuthModel { IsAuthenticated = false, Message = errors };
            }

            await _userManager.AddToRoleAsync(user, "USER"); // Add user to "USER" role

            var jwtToken = GenerateJwtToken(user);

            return new AuthModel
            {
                IsAuthenticated = true,
                Email = user.Email,
                Token = jwtToken,
            };
        }


        public async Task<AuthModel> LoginAsync(TokenRequestModel model)
        {

            var user = _userManager.Users.FirstOrDefault(u => u.Email == model.Email);
            if (user == null)
            {
                return new AuthModel { IsAuthenticated = false, Message = "Invalid Email Or Password." };
            }
            var result = await _signInManager.PasswordSignInAsync(user, model.Password, false, false);
            if (!result.Succeeded)
            {
                return new AuthModel { IsAuthenticated = false, Message = "Invalid Email Or Password." };
            }

            var jwtToken = GenerateJwtToken(user);

            return new AuthModel
            {
                IsAuthenticated = true,
                Email = user.Email,
                Token = jwtToken,
            };
        }


        // Use IConfiguration to retrieve JWT settings
        public string GenerateJwtToken(ApplicationUser user)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_configuration["JWT:Key"]); // Access JWT key from app settings

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                {
                    new Claim(ClaimTypes.Name, user.Name),
                    new Claim(ClaimTypes.Email, user.Email),
                    // Add more claims as needed
                }),
                Expires = DateTime.UtcNow.AddHours(int.Parse(_configuration["JWT:ExpiryHours"])), // Access JWT expiry from app settings
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            // Check if ProfilePicturePath is null before adding to claims
            if (!string.IsNullOrEmpty(user.ProfilePicturePath))
            {
                tokenDescriptor.Subject.AddClaim(new Claim("ProfilePicturePath", user.ProfilePicturePath));
            }

            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }

    }
}
