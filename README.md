Flutter desktop:
----------
Administrator: <br />
Username: admin <br />
Password: test <br />

Employee <br />
Username: employee <br />
Password: test <br />

Flutter mobile:
-----------
Client: <br />
Username: client <br />
Password: test <br /> 


<br /> <br />

Open a terminal inside the solution folder and use the following commands (API+DB): <br />

docker-compose build <br /> docker-compose up <br />
<br /><br />
Flutter desktop<br /><br />
flutter pub get <br /> flutter run <br />Choose option number 1 (windows) <br /><br />

Flutter mobile <br /><br />
flutter pub get <br /> flutter run <br />

If you want to use your own stripe keys use the following command: <br />
flutter run --dart-define stripePublishableKey=yourStripePublishableKey --dart-define stripeSecretKey=yourStripeSecretKey
<br />
Stripe test card number: <br />
4242 4242 4242 4242
<br />
-----------
<br />

Additional info:<br /><br />

RabbitMQ sends an email on status change, to test using Your own email, update the client email on the mobile app.
Report generating is based on the data currently shown in the table (including filters).
Appointments can be cancelled by the client while their vehicle has not been brought to service yet.
