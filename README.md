Flutter desktop:
----------
Administrator: <br />
Username: admin <br />
Password: admin <br />

Employee <br />
Username: employee <br />
Password: employee <br />

Flutter mobile:
-----------
Client: <br />
Username: client <br />
Password: client <br /> 


<br /> <br />

Open a terminal inside the solution folder and use the following commands (API+DB): <br />

docker-compose build <br /> docker-compose up <br />
<br /><br />
Flutter desktop
flutter pub get <br /> flutter run <br />Choose option number 1 (windows) <br /><br />

Flutter mobile <br />
flutter pub get <br /> flutter run <br />

If you want to use your own stripe keys use the following command: <br />
flutter run --dart-define stripePublishableKey=yourStripePublishableKey --dart-define stripeSecretKey=yourStripeSecretKey
<br />
Stripe test card number: <br />
4242 4242 4242 4242

