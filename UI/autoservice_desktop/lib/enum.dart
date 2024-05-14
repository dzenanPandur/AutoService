enum Status {
  New,
  AwaitingCar,
  InService,
  PendingPayment,
  PickupReady,
  Completed,
  Rejected,
  Canceled,
  Idle
}

const Map<Status, int> statusValues = {
  Status.New: 1,
  Status.AwaitingCar: 2,
  Status.InService: 3,
  Status.PendingPayment: 4,
  Status.PickupReady: 5,
  Status.Completed: 6,
  Status.Rejected: 7,
  Status.Canceled: 8,
  Status.Idle: 9
};
