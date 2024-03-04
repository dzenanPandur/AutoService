using AutoService.Data.DTO.ClientData;
using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.ClientData
{
    public class ProfilePhoto
    {
        public ProfilePhoto()
        {

        }

        public ProfilePhoto(ProfilePhotoDto dto)
        {
            Id = dto.Id;
            CreatedDate = dto.CreatedDate;
            ModifiedDate = dto.ModifiedDate;
            Active = dto.Active;
            Path = dto.Path;
            FileSystemPath = dto.FileSystemPath;
            SizeInBytes = dto.SizeInBytes;
            Name = dto.Name;
            Extension = dto.Extension;
            Format = dto.Format;
            Height = dto.Height;
            Width = dto.Width;
            Xresolution = dto.Xresolution;
            Yresolution = dto.Yresolution;
            ResolutionUnit = dto.ResolutionUnit;
        }

        [Key]
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
        //public ICollection<ApplicationUserProfilePhoto> ApplicationUserProfilePhotos { get; set; }
    }
}
