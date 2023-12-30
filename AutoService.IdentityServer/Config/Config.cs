using IdentityServer4;
using IdentityServer4.Models;

namespace AutoService.IdentityServer.Config
{
    public class Config
    {
        public static IEnumerable<IdentityResource> GetIdentityResources()
        {
            return new List<IdentityResource>
        {
            new IdentityResources.OpenId(),
            new IdentityResources.Profile(),
        };
        }

        public static IEnumerable<ApiResource> GetApis()
        {
            return new List<ApiResource>
        {
            new ApiResource("api1", "My API")
        };
        }

        public static IEnumerable<Client> GetClients()
        {
            return new List<Client>
        {
            new Client
            {
                ClientId = "client",
                
                AllowedGrantTypes = GrantTypes.ClientCredentials,
               
                ClientSecrets =
                {
                    new Secret("deb5059b-d97a-46d8-97ea-581cad4a4ac1".Sha256())
                },

                AllowedScopes = { "api1" }
            },
            
            new Client
            {
                ClientId = "ro.client",
                AllowedGrantTypes = GrantTypes.ResourceOwnerPassword,

                ClientSecrets =
                {
                    new Secret("deb5059b-d97a-46d8-97ea-581cad4a4ac1".Sha256())
                },
                AllowedScopes = { "api1" }
            },
            
            new Client
            {
                ClientId = "mvc",
                ClientName = "MVC Client",
                AllowedGrantTypes = GrantTypes.Hybrid,

                ClientSecrets =
                {
                    new Secret("deb5059b-d97a-46d8-97ea-581cad4a4ac1".Sha256())
                },

                RedirectUris           = { "http://localhost:7179/signin-oidc" },
                PostLogoutRedirectUris = { "http://localhost:7179/signout-callback-oidc" },

                AllowedScopes =
                {
                    IdentityServerConstants.StandardScopes.OpenId,
                    IdentityServerConstants.StandardScopes.Profile,
                    "api1"
                },

                AllowOfflineAccess = true
            },
            
            new Client
            {
                ClientId = "js",
                ClientName = "JavaScript Client",
                AllowedGrantTypes = GrantTypes.Code,
                RequirePkce = true,
                RequireClientSecret = false,

                RedirectUris =           { "http://localhost:7179/callback.html" },
                PostLogoutRedirectUris = { "http://localhost:7179/index.html" },
                AllowedCorsOrigins =     { "http://localhost:7179" },

                AllowedScopes =
                {
                    IdentityServerConstants.StandardScopes.OpenId,
                    IdentityServerConstants.StandardScopes.Profile,
                    "api1"
                }
            }
        };
        }
    }
}
