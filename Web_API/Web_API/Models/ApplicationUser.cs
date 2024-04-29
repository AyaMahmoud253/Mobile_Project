using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace Web_API.Models
{
    public class ApplicationUser : IdentityUser
    {
        public int? Id { get; set; }

        [Required]
        public string Name { get; set; }

        public string? Gender { get; set; }

        [Required]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string Email { get; set; }

        public string? Level { get; set; } // Use nullable enum for optional field


        public string? ProfilePicturePath { get; set; }// Path to the profile picture if stored locally

        
    }

    // Define enum for level options
    public enum LevelOption
    {
        One = 1,
        Two = 2,
        Three = 3,
        Four = 4
    }
}
