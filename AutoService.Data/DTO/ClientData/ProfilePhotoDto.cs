using AutoService.Data.DTO.ServiceData;
using AutoService.Data.Entities.ClientData;
using AutoService.Data.Entities.ServiceData;

namespace AutoService.Data.DTO.ClientData
{
    public class ProfilePhotoDto
    {
        public ProfilePhotoDto()
        {

        }

        public ProfilePhotoDto(ProfilePhoto profilePhoto)
        {
            Id = profilePhoto.Id;
            CreatedDate = profilePhoto.CreatedDate;
            ModifiedDate = profilePhoto.ModifiedDate;
            Active = profilePhoto.Active;
            Path = profilePhoto.Path;
            FileSystemPath = profilePhoto.FileSystemPath;
            SizeInBytes = profilePhoto.SizeInBytes;
            Name = profilePhoto.Name;
            Extension = profilePhoto.Extension;
            Format = profilePhoto.Format;
            Height = profilePhoto.Height;
            Width = profilePhoto.Width;
            Xresolution = profilePhoto.Xresolution;
            Yresolution = profilePhoto.Yresolution;
            //ResolutionUnit = profilePhoto.ResolutionUnit;

            //if (profilePhoto.ApplicationUserProfilePhotos is not null)
            //{
            //    ApplicationUserProfilePhotos = new List<ApplicationUserProfilePhotoDto>(
            //        profilePhoto.ApplicationUserProfilePhotos
            //        .Select(p => new ApplicationUserProfilePhotoDto(p))
            //        .ToList());

            //    ApplicationUserProfilePhotoIdList = profilePhoto.ApplicationUserProfilePhotos
            //        .Select(s => s.Id)
            //        .ToList();
            //}
        }
        public int Id { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public bool? Active { get; set; }
        public string? Path { get; set; }
        public string? FileSystemPath { get; set; }
        public long SizeInBytes { get; set; }
        public string? Name { get; set; }
        public string? Extension { get; set; }
        public string? Format { get; set; }
        public decimal Height { get; set; }
        public decimal Width { get; set; }
        public decimal Xresolution { get; set; }
        public decimal Yresolution { get; set; }
        public string? ResolutionUnit { get; set; }
        //public ICollection<ApplicationUserProfilePhotoDto> ApplicationUserProfilePhotos { get; set; } = new List<ApplicationUserProfilePhotoDto>();
        //public ICollection<int> ApplicationUserProfilePhotoIdList { get; set; } = new List<int>();
    }
}
