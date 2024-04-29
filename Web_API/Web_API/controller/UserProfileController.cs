using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Web_API.Models;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using System;
using System.IO;

namespace Web_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserProfileController : ControllerBase
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ApplicationDBContext _context;
        private readonly IWebHostEnvironment _hostingEnvironment;

        public UserProfileController(UserManager<ApplicationUser> userManager, ApplicationDBContext context, IWebHostEnvironment hostingEnvironment)
        {
            _userManager = userManager;
            _context = context;
            _hostingEnvironment = hostingEnvironment;
        }

        // Update profile picture for a user identified by email
        [HttpPost("upload-profile-picture")]
        public async Task<IActionResult> UploadProfilePicture(string email, IFormFile profilePicture)
        {
            if (profilePicture != null && profilePicture.Length > 0)
            {
                try
                {
                    // Find the user with the specified email
                    var user = _userManager.Users.FirstOrDefault(u => u.Email == email);

                    if (user != null)
                    {
                        // Generate a unique filename for the uploaded image (e.g., using Guid)
                        string uniqueFileName = Guid.NewGuid().ToString() + "_" + Path.GetFileName(profilePicture.FileName);

                        // Specify the directory where you want to save the image (e.g., within the web root)
                        string uploadDirectory = Path.Combine(_hostingEnvironment.WebRootPath, "profile-pictures");

                        // Ensure the directory exists; create it if it doesn't
                        Directory.CreateDirectory(uploadDirectory);

                        // Combine the directory and filename to get the full path
                        string filePath = Path.Combine(uploadDirectory, uniqueFileName);

                        using (var stream = new FileStream(filePath, FileMode.Create))
                        {
                            await profilePicture.CopyToAsync(stream);
                        }

                        // Store the relative path or URL to the image in your database
                        string relativePath = "/profile-pictures/";
                        string imagePath = relativePath + uniqueFileName;

                        // Update the user's profile picture path in your database
                        user.ProfilePicturePath = imagePath;
                        await _userManager.UpdateAsync(user);

                        return Ok(new { imagePath });
                    }
                    else
                    {
                        return NotFound($"User with email {email} not found.");
                    }
                }
                catch (Exception ex)
                {
                    return BadRequest($"Error: {ex.Message}");
                }
            }

            // Handle error case if no file was uploaded
            return BadRequest("No file uploaded");
        }

        // Get profile picture for a user identified by email
        [HttpGet("profile-picture")]
        public async Task<IActionResult> GetProfilePicture(string email)
        {
            var user = _userManager.Users.FirstOrDefault(u => u.Email == email);
            if (user == null)
            {
                return NotFound($"User with email {email} not found.");
            }

            if (string.IsNullOrEmpty(user.ProfilePicturePath))
            {
                return NotFound("Profile picture not set for this user.");
            }

            var profilePictureUrl = CreateFullProfilePictureUrl(user.ProfilePicturePath);
            return Ok(new { profilePictureUrl });
        }

        // Helper method to create the full URL for profile picture
        private string CreateFullProfilePictureUrl(string profilePicturePath)
        {
            // Assuming that the profile picture path is a relative path stored in the database
            var request = this.HttpContext.Request;
            return $"{request.Scheme}://{request.Host}{request.PathBase}{profilePicturePath}";
        }

        // Other actions in the controller...
    }
}
