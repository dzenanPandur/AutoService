using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using AutoService.Data.Entities.VehicleData;

namespace AutoService.Data.Entities.ServiceData;

public class ServicesPerformed
{
    [Key]
    public int Id { get; set; }
    public VehicleServiceRecord Record { get; set; }
    public int RecordId { get; set; }
    public Service Service { get; set; }
    public int ServiceId { get; set; }
}
