using AutoService.Data.DTO.ServiceData;
using AutoService.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace AutoService.Controllers
{
    [ApiController]
    [Route("[controller]")]

    public class CategoryController : ControllerBase
    {
        private readonly ICategoryManager _categoryManager;
        public CategoryController(ICategoryManager categoryManager)
        {
            _categoryManager = categoryManager;
        }

        [HttpGet("GetAll")]
        public async Task<IActionResult> GetAllCategories()
        {

            IEnumerable<CategoryDto> categories = await _categoryManager.GetAllCategories();

            if (categories == null || categories.Count() == 0)
            {
                return NotFound("No Categories found.");
            }

            return Ok(categories);
            //List<UserViewModel> userViewModels = new List<UserViewModel>();

            //foreach (UserDto userDto in users)
            //{
            //    UserViewModel userViewModel = new UserViewModel(userDto);
            //    userViewModels.Add(userViewModel);
            //}

            //return Ok(userViewModels);
        }

        [HttpGet("GetById")]

        public async Task<IActionResult> GetCategoryById(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var category = await _categoryManager.GetCategory(id);

            if (category == null)
            {
                return NotFound("Category not found.");
            }

            return Ok(category);
        }

        [HttpPost("Create")]

        public async Task<IActionResult> CreateCategory(CategoryDto dto)
        {
            int message = await _categoryManager.CreateCategory(dto);
            if (message > 0)
            {
                return Ok("Category created successfully.");
            }
            else
            {
                return BadRequest("Failed to create Category.");
            }
        }

        [HttpPut("Update")]

        public async Task<IActionResult> UpdateCategory(CategoryDto dto)
        {
            CategoryDto category = await _categoryManager.UpdateCategory(dto);

            if (category == null)
            {
                return NotFound("Category not found.");
            }

            return Ok(category);
        }

        [HttpDelete("Delete")]

        public async Task<IActionResult> DeleteCategory(int id)
        {
            if (string.IsNullOrEmpty(id.ToString()))
            {
                return BadRequest("Id must be provided.");
            }

            var category = await _categoryManager.GetCategory(id);

            if (category == null)
            {
                return NotFound("Category not found.");
            }

            await _categoryManager.DeleteCategory(id);

            return Ok("Successfully deleted Category");
        }
    }
}
