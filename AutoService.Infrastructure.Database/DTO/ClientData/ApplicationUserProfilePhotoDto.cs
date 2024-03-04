//using AutoService.Data.Entities.ClientData;

//namespace AutoService.Data.DTO.ClientData
//{
//    public class ApplicationUserProfilePhotoDto
//    {
//        public ApplicationUserProfilePhotoDto()
//        {

//        }

//        public ApplicationUserProfilePhotoDto(ApplicationUserProfilePhoto applicationUserProfilePhoto)
//        {
//            Id = applicationUserProfilePhoto.Id;
//            CreatedDate = applicationUserProfilePhoto.CreatedDate;
//            ModifiedDate = applicationUserProfilePhoto.ModifiedDate;
//            Active = applicationUserProfilePhoto.Active;
//            ProfilePhotoId = applicationUserProfilePhoto.ProfilePhotoId;

//            if (applicationUserProfilePhoto.ProfilePhoto is not null)
//            {
//                ProfilePhoto = new ProfilePhotoDto(applicationUserProfilePhoto.ProfilePhoto);
//            }
//        }

//        public int Id { get; set; }
//        public DateTime CreatedDate { get; set; }
//        public DateTime? ModifiedDate { get; set; }
//        public bool? Active { get; set; }
//        public ProfilePhotoDto ProfilePhoto { get; set; }
//        public int ProfilePhotoId { get; set; }
//    }
//}
