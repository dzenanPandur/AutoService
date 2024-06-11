// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/globals.dart';
import 'package:autoservice_mobile/providers/ClientProvider.dart';
import 'package:autoservice_mobile/screens/request_details_screen.dart';
import 'package:flutter/material.dart';

import '../models/request/requestModel.dart';
import '../models/request/updateRequestModel.dart';
import '../providers/RequestProvider.dart';

class RequestsScreen extends StatefulWidget {
  final String userId;
  const RequestsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  late Future<List<RequestModel>> _requestFuture;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      _requestFuture = ClientProvider().getAllRequestsByClient(widget.userId);
    } catch (e) {
      showSnackBar(context, 'Error fetching request: $e', secondaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 35,
          ),
        ),
        backgroundColor: secondaryColor,
        foregroundColor: fontColor,
        title: const Text(
          'My service requests',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                  Text('No service requests found'),
                  SizedBox(height: 20),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<RequestModel> inProgressRequests = snapshot.data!
                .where((request) => [
                      'InService',
                      'PendingPayment',
                      'PickupReady'
                    ].contains(request.status))
                .toList();

            List<RequestModel> newRequests = snapshot.data!
                .where((request) =>
                    ['New', 'AwaitingCar'].contains(request.status))
                .toList();

            List<RequestModel> pastServices = snapshot.data!
                .where((request) => ['Completed'].contains(request.status))
                .toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildDividerWithHeader(
                      'Services in progress', inProgressRequests, 180),
                  _buildDividerWithHeader(
                      'New service requests', newRequests, 190),
                  _buildDividerWithHeader('Past services', pastServices, 125),
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
                        label: Text('Vehicle',
                            style: TextStyle(color: secondaryColor))),
                    DataColumn(
                        label: Text('Status',
                            style: TextStyle(color: secondaryColor))),
                    if (headerText == 'New service requests')
                      DataColumn(
                        label: Text('Cancel',
                            style: TextStyle(color: secondaryColor)),
                      ),
                  ],
                  rows: requests.map((request) {
                    return DataRow(
                      onSelectChanged: (_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RequestDetailsScreen(request: request),
                          ),
                        ).then((_) => setState(() {
                              _fetchRequests();
                            }));
                      },
                      cells: [
                        DataCell(Text(request.vehicleName)),
                        DataCell(Text(request.status)),
                        if (headerText == 'New service requests')
                          DataCell(
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: secondaryColor,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      elevation: 0,
                                      backgroundColor: primaryBackgroundColor,
                                      title: const Text("Confirmation"),
                                      content: const Text(
                                          "Are you sure you want to cancel the request?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: secondaryColor),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            UpdateRequestModel updateRequest =
                                                UpdateRequestModel(
                                                    status: 8,
                                                    id: request.id,
                                                    totalCost:
                                                        request.totalCost,
                                                    vehicleId:
                                                        request.vehicleId,
                                                    message: null);

                                            try {
                                              await RequestProvider()
                                                  .updateRequest(updateRequest);
                                              Navigator.of(context).pop();
                                              showSnackBar(
                                                  context,
                                                  'Successfully cancelled request.',
                                                  accentColor);
                                            } catch (error) {
                                              showSnackBar(
                                                  context,
                                                  'Failed to save changes. $error',
                                                  secondaryColor);
                                            }

                                            setState(() {
                                              _fetchRequests();
                                            });
                                          },
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: secondaryColor),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
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
