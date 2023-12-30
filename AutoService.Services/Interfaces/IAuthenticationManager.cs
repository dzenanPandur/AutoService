namespace AutoService.Services.Interfaces
{
    //Auth Test
    
    public interface IAuthenticationManager
    {
        Task<AuthenticationResponse> Authenticate(AuthenticationRequest request);
    }



    public class AuthenticationResponse
    {
        public string Token { get; set; }
    }
    public class AuthenticationRequest
    {
        public string Username { get; set; }

        public string Password { get; set; }
    }
}
