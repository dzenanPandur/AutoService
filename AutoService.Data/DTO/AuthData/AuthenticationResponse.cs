using AutoService.Data.Enums;

namespace AutoService.ViewModels.AuthData
{
    public class AuthenticationResponse
    {
        public Guid UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Token { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string Username { get; set; }
        public Gender Gender { get; set; }
        public string Role { get; set; }
    }
}
