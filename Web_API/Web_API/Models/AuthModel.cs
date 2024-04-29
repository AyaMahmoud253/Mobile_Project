using System;
using System.Collections.Generic;

namespace Web_API.Models
{
    public class AuthModel
    {
        public bool IsAuthenticated { get; set; }
        public string Message { get; set; }
        public string Email { get; set; }
        public string Token { get; set; }
        public DateTime ExpiresOn { get; set; }
        
    }
}
