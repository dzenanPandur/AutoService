import 'package:autoservice_mobile/globals.dart';
import 'package:autoservice_mobile/models/requestModel.dart';
import 'package:autoservice_mobile/providers/ClientProvider.dart';
import 'package:autoservice_mobile/screens/request_details_screen.dart';
import 'package:flutter/material.dart';

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
      print('Error deleting request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        foregroundColor: fontColor,
        title: const Text('My service requests'),
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
                        label: Text(
                      'ID',
                      style: TextStyle(color: secondaryColor),
                    )),
                    DataColumn(
                        label: Text('Vehicle',
                            style: TextStyle(color: secondaryColor))),
                    DataColumn(
                        label: Text('Status',
                            style: TextStyle(color: secondaryColor))),
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
                        DataCell(Text(request.vehicleName)),
                        DataCell(Text(request.status)),
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
