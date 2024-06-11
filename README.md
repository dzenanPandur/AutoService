### Setup Instructions
1. Open a terminal inside the solution folder.
2. Run the following commands:</br>
- docker-compose build </br>
- docker-compose up


## Flutter Desktop

### Administrator
- **Username:** admin
- **Password:** test

### Employee
- **Username:** employee
- **Password:** test

### Setup Instructions


Run the following commands:
</br>
- flutter pub get </br>
- flutter run


### Note
- Choose option number 1 (windows) when prompted.

---

## Flutter Mobile

### Client
- **Username:** client
- **Password:** test

### Setup Instructions
Run the following commands:
</br>
- flutter pub get </br>
- flutter run



### Using Stripe Keys
- If you want to use your own Stripe keys, use the following command: </br>
flutter run --dart-define stripePublishableKey=yourStripePublishableKey --dart-define stripeSecretKey=yourStripeSecretKey


### Stripe Test Card Number
- Test card number: 4242 4242 4242 4242

---

## Additional Information
- RabbitMQ sends an email on status change. To test using your own email, update the client email on the mobile app.
- Report generation is based on the data currently shown in the table, including filters.
- Appointments can be canceled by the client while their vehicle has not been brought to service yet.
