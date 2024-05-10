import 'dart:convert';

import 'package:autoservice_mobile/globals.dart';
import 'package:autoservice_mobile/models/requestModel.dart';
import 'package:http/http.dart' as http;
import 'package:autoservice_mobile/providers/ClientProvider.dart';
import 'package:autoservice_mobile/screens/request_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentsPendingScreen extends StatefulWidget {
  final String userId;
  const PaymentsPendingScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _PaymentsPendingScreenState createState() => _PaymentsPendingScreenState();
}

class _PaymentsPendingScreenState extends State<PaymentsPendingScreen> {
  late Future<List<RequestModel>> _requestFuture;
  final StripePaymentHandle _stripePaymentHandle = StripePaymentHandle();

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      _requestFuture = ClientProvider().getAllRequestsByClient(widget.userId);
    } catch (e) {
      print('Error deleting request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        foregroundColor: fontColor,
        title: const Text('Pending payments'),
      ),
      body: FutureBuilder<List<RequestModel>>(
        future: _requestFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No pending payments found'),
                  SizedBox(height: 20),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<RequestModel> inProgressRequests = snapshot.data!
                .where((request) => [
                      'PendingPayment',
                    ].contains(request.status))
                .toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildDividerWithHeader(
                      'Payments ready', inProgressRequests, 145),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDividerWithHeader(
      String headerText, List<RequestModel> requests, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                headerText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    height: 2,
                    color: Colors.grey.shade300,
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      width: width,
                      height: 2,
                      color: secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (requests.isNotEmpty)
          Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: DataTable(
                  headingRowHeight: 30,
                  showCheckboxColumn: false,
                  horizontalMargin: 10,
                  columns: [
                    DataColumn(
                        label: Text(
                      'ID',
                      style: TextStyle(color: secondaryColor),
                    )),
                    DataColumn(
                        label: Text('Date completed',
                            style: TextStyle(color: secondaryColor))),
                    DataColumn(
                      label: Text('Action',
                          style: TextStyle(color: secondaryColor)),
                    ),
                  ],
                  rows: requests.map((request) {
                    return DataRow(
                      onSelectChanged: (_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RequestDetailsScreen(),
                          ),
                        ).then((_) => setState(() {
                              _fetchRequests();
                            }));
                      },
                      cells: [
                        DataCell(Text(request.id.toString())),
                        DataCell(Text(_formatDate(request.dateCompleted))),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              _stripePaymentHandle.stripeMakePayment();
                            },
                            child: const Text('Checkout'),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        if (requests.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'No requests',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}

class StripePaymentHandle {
  Map<String, dynamic>? paymentIntent;

  Future<void> stripeMakePayment() async {
    try {
      paymentIntent = await createPaymentIntent('100', 'BAM');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  /*billingDetails: const BillingDetails(
                      name: 'Test',
                      email: 'Test@gmail.com',
                      phone: 'Test',
                      address: Address(
                          city: 'Mostar',
                          country: 'Bosnia & Herzegovina',
                          line1: 'Adresa 1',
                          line2: 'Test',
                          postalCode: '88000',
                          state: 'Test')),*/
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      displayPaymentSheet();
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      Fluttertoast.showToast(msg: 'Payment succesfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(msg: '${e.error.localizedMessage}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
      }
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51N7gLcAQDwep3kcFzZXhrPEk63TaG0xB5K1u0AImKfAN92rpHcdOwGIFvkpUFBwin4shah6igMSeld6WLamJEKyB002kXkxttd',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
