import 'package:autoservice_desktop/providers/RequestProvider.dart';
import 'package:autoservice_desktop/screens/Employee/request_details_screen.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/Employee/requestModel.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final RequestProvider requestProvider = RequestProvider();
  List<RequestModel>? requests;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Management'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder<List<RequestModel>>(
                future: requestProvider.getAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    requests = snapshot.data;

                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: PaginatedDataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Request Date')),
                              DataColumn(label: Text('Client Name')),
                              DataColumn(label: Text('Car')),
                              DataColumn(label: Text('Details')),
                            ],
                            header: const Center(
                              child: Text('Requests'),
                            ),
                            rowsPerPage: 5,
                            source: RequestDataTableSource(
                              requests!,
                              requestProvider: requestProvider,
                              context: context,
                              refreshData: _refreshData,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _refreshData() {
    _refreshIndicatorKey.currentState?.show();
  }
}

class RequestDataTableSource extends DataTableSource {
  final List<RequestModel> _requests;
  final RequestProvider requestProvider;
  final BuildContext context;
  final Function refreshData;

  RequestDataTableSource(this._requests,
      {required this.refreshData,
      required this.requestProvider,
      required this.context});

  @override
  DataRow getRow(int index) {
    final RequestModel request = _requests[index];

    return DataRow(
      cells: [
        DataCell(Text(request.id.toString())),
        DataCell(Text(request.status)),
        DataCell(Text(DateFormat('yyyy-MM-dd').format(request.dateRequested))),
        DataCell(Text(request.clientName)),
        DataCell(Text(request.vehicleName)),
        DataCell(ElevatedButton(
          onPressed: () => _openDetailsScreen(context, request),
          child: const Text('Details'),
        )),
      ],
    );
  }

  void _openDetailsScreen(BuildContext context, RequestModel request) {
    Navigator.push(
      context,
      FluentPageRoute(
        builder: (context) => RequestDetailsScreen(request: request),
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _requests.length;

  @override
  int get selectedRowCount => 0;
}
