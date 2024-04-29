using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using System.Threading.Tasks;
using Web_API.Models;

namespace Web_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]

    public class UserController : ControllerBase
    {
        private readonly UserManager<ApplicationUser> _userManager;

        public UserController(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }
        [HttpGet("ByEmail/{studentEmail}")]
        public async Task<IActionResult> GetUserByEmail(string studentEmail)
        {
            var user = _userManager.Users.FirstOrDefault(u => u.Email == studentEmail);

            if (user == null)
            {
                return NotFound("User not found");
            }

            return Ok(new
            {
                user.Name,
                user.Gender,
                user.Email,
                user.Level
            });
        }
        [HttpPut("UpdateName/{email}")]
        public async Task<IActionResult> UpdateUserNameByEmail(string email, [FromBody] string name)
        {
            var user = _userManager.Users.FirstOrDefault(u => u.Email == email);

            if (user == null)
            {
                return NotFound("User not found");
            }

            // Store the original values of other properties
            var originalName = user.Name;
            var originalGender = user.Gender;
            var originalLevel = user.Level;

            // Update only the Name property
            user.Name = name;

            // Update the user
            var result = await _userManager.UpdateAsync(user);

            if (!result.Succeeded)
            {
                // Revert back to original values if update fails
                user.Name = originalName;
                user.Gender = originalGender;
                user.Level = originalLevel;
                await _userManager.UpdateAsync(user); // Update user with original values
                var errors = string.Join(", ", result.Errors);
                return BadRequest($"Failed to update user: {errors}");
            }

            return Ok("User's name updated successfully");
        }
        [HttpPut("UpdateGender/{email}")]
        public async Task<IActionResult> UpdateUserGenderByEmail(string email, [FromBody] string gender)
        {
            var user = _userManager.Users.FirstOrDefault(u => u.Email == email);

            if (user == null)
            {
                return NotFound("User not found");
            }

            // Store the original values of other properties
            var originalName = user.Name;
            var originalGender = user.Gender;
            var originalLevel = user.Level;

            // Update only the Gender property
            user.Gender = gender;

            // Update the user
            var result = await _userManager.UpdateAsync(user);

            if (!result.Succeeded)
            {
                // Revert back to original values if update fails
                user.Name = originalName;
                user.Gender = originalGender;
                user.Level = originalLevel;
                await _userManager.UpdateAsync(user); // Update user with original values
                var errors = string.Join(", ", result.Errors);
                return BadRequest($"Failed to update user: {errors}");
            }

            return Ok("User's gender updated successfully");
        }

        [HttpPut("UpdateLevel/{email}")]
        public async Task<IActionResult> UpdateUserLevelByEmail(string email, [FromBody] string level)
        {
            var user = _userManager.Users.FirstOrDefault(u => u.Email == email);

            if (user == null)
            {
                return NotFound("User not found");
            }

            // Store the original values of other properties
            var originalName = user.Name;
            var originalGender = user.Gender;
            var originalLevel = user.Level;

            // Update only the Level property
            user.Level = level;

            // Update the user
            var result = await _userManager.UpdateAsync(user);

            if (!result.Succeeded)
            {
                // Revert back to original values if update fails
                user.Name = originalName;
                user.Gender = originalGender;
                user.Level = originalLevel;
                await _userManager.UpdateAsync(user); // Update user with original values
                var errors = string.Join(", ", result.Errors);
                return BadRequest($"Failed to update user: {errors}");
            }

            return Ok("User's level updated successfully");
        }

    }
}