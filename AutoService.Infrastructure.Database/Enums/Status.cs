using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoService.Data.Enums
{
    public enum Status
    {
        New = 1,
        AwaitingCar = 2,
        Rejected = 3, 
        InService = 4,
        PendingPayment = 5,
        PickupReady = 6,
        Completed = 7,
        Canceled = 8
    }
}
