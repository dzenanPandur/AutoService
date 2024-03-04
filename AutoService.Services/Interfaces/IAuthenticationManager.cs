using AutoService.ViewModels.AuthData;

namespace AutoService.Services.Interfaces
{
    public interface IAuthenticationManager
    {
        Task<AuthenticationResponse> Authenticate(AuthenticationRequest request);
    }

}
