﻿using AutoService.Data.DTO.ServiceData;
using AutoService.Services.Interfaces;
using AutoService.ViewModels.ServiceData;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class ServiceController : ControllerBase
    {
        private readonly IServiceManager _serviceManager;
        private readonly ICategoryManager _categoryManager;
        public ServiceController(IServiceManager serviceManager, ICategoryManager categoryManager)
        {
            _serviceManager = serviceManager;
            _categoryManager = categoryManager;
        }

        [HttpGet("GetAll")]
        [Authorize]
        public async Task<IActionResult> GetAllServices()
        {

            IEnumerable<ServiceDto> services = await _serviceManager.GetAllServices();

            if (services == null || services.Count() == 0)
            {
                return NotFound("No Services found.");
            }

            List<ServiceViewModel> serviceViewModels = new List<ServiceViewModel>();

            foreach (ServiceDto serviceDto in services)
            {
                ServiceViewModel serviceViewModel = new ServiceViewModel(serviceDto);
                serviceViewModels.Add(serviceViewModel);
            }

            return Ok(serviceViewModels);
        }

        [HttpGet("GetById")]
        [Authorize]
        public async Task<IActionResult> GetServiceById(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var service = await _serviceManager.GetService(id);

            if (service == null)
            {
                return NotFound("Service not found.");
            }

            return Ok(service);
        }

        [HttpPost("Create")]
        [Authorize]
        public async Task<IActionResult> CreateService(ServiceDto dto)
        {

            if (dto.Name.IsNullOrEmpty()
                || !dto.CategoryId.HasValue)
                return BadRequest("All fields must be filled");

            int message = await _serviceManager.CreateService(dto);

            if (message > 0)
            {
                return Ok("Service created successfully.");
            }
            else
            {
                return BadRequest("Failed to create Service.");
            }
        }

        [HttpPut("Update")]
        [Authorize]
        public async Task<IActionResult> UpdateService(ServiceDto dto)
        {


            CategoryDto categoryDto = await _categoryManager.GetCategory((int)dto.CategoryId);
            if (!categoryDto.isActive)
            {
                return BadRequest("Cannot edit service under inactive category.");
            }

            ServiceDto service = await _serviceManager.UpdateService(dto);
            if (service == null)
            {
                return NotFound("Service not found.");
            }

            return Ok(service);
        }

        [HttpDelete("Delete")]
        [Authorize]
        public async Task<IActionResult> DeleteService(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var Service = await _serviceManager.GetService(id);

            if (Service == null)
            {
                return NotFound("Service not found.");
            }

            await _serviceManager.DeleteService(id);

            return Ok("Successfully deleted Service");
        }
    }
}
