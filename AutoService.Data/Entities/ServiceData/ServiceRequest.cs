using System.ComponentModel.DataAnnotations;

namespace AutoService.Data.Entities.ServiceData
{
    public class ServiceRequest
    {
        [Key]
        public int Id { get; set; }
        public int ServiceId { get; set; }
        public Service Service { get; set; }
        public int RequestId { get; set; }
        public Request Request { get; set; }
    }
}
