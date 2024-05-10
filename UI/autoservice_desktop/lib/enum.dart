enum Status {
  New,
  AwaitingCar,
  Rejected,
  InService,
  PendingPayment,
  PickupReady,
  Completed,
  Canceled,
  Idle
}

const Map<Status, int> statusValues = {
  Status.New: 1,
  Status.AwaitingCar: 2,
  Status.Rejected: 3,
  Status.InService: 4,
  Status.PendingPayment: 5,
  Status.PickupReady: 6,
  Status.Completed: 7,
  Status.Canceled: 8,
  Status.Idle: 9
};
