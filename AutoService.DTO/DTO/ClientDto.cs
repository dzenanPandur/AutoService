using AutoService.Services.Database;

namespace AutoService.DTO.DTO
{
    public class ClientDto
    {
        public ClientDto() {

        }

        public ClientDto(Client client)
        {
            Id = client.Id;
            CreatedDate = client.CreatedDate;
            ModifiedDate = client.ModifiedDate;
            Active = client.Active;
            PersonId = client.PersonId;
            ApplicationUserId = client.ApplicationUserId;
        }

        public int Id { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public bool? Active { get; set; }
        public int PersonId { get; set; }
        public Person Person { get; set; } = null!;
        public int ApplicationUserId { get; set; }
        public IdentityUser ApplicationUser { get; set; } = null!;
        public ICollection<Request> Requests { get; set; }
    }
}
