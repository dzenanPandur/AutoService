using AutoService.Data.Database;
using AutoService.Data.DTO.UserData;
using AutoService.Data.Entities.UserData;
using AutoService.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace AutoService.Services.Managers
{
    public class RoleManager : IRoleManager
    {
        public readonly AutoServiceContext _context;
        public RoleManager(AutoServiceContext context) 
        {
            _context = context;
        }

        public async Task<RoleDto> GetRoleById(Guid id)
        {

            var role = await _context.Roles.FirstOrDefaultAsync(x => x.Id == id);

            if (role == null)
            {
                return null;
            }

            var roleDto = new RoleDto(role);

            return roleDto;
        }

        public async Task<RoleDto> GetRoleByName(string name)
        {

            var role = await _context.Roles.FirstOrDefaultAsync(x => x.Name == name);

            if (role == null)
            {
                return null;
            }

            var roleDto = new RoleDto(role);

            return roleDto;
        }
    }
}
