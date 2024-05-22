using System.ComponentModel.DataAnnotations;

namespace Web_API.Models
{
    public class TokenRequestModel
    {
        [Required(ErrorMessage = "Email is required")]
        [RegularExpression(@"^[a-zA-Z0-9]+@stud\.fci-cu\.edu\.eg$", ErrorMessage = "Invalid FCI email format")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Password is required")]
        [StringLength(100, MinimumLength = 8, ErrorMessage = "Password must be at least 8 characters long")]
        public string Password { get; set; }

       
    }
}
