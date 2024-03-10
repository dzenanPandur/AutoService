import 'package:autoservice_desktop/models/userModel.dart';
import 'package:autoservice_desktop/providers/ClientProvider.dart';
import 'package:flutter/material.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final ClientProvider clientProvider = ClientProvider();
  List<userModel>? customers;
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
        title: const Text('Customer Management'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder<List<userModel>>(
                future: clientProvider.getAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    customers = snapshot.data;

                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: PaginatedDataTable(
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Location')),
                              //DataColumn(label: Text('Cars owned')),
                              DataColumn(label: Text('Details')),
                            ],
                            header: const Center(
                              child: Text('Customers'),
                            ),
                            rowsPerPage: 5,
                            source: CustomerDataTableSource(
                              customers!,
                              clientProvider: clientProvider,
                              context: context,
                              //showDetailsDialog: _showDetailsDialog,
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

class CustomerDataTableSource extends DataTableSource {
  final List<userModel> _customers;
  final ClientProvider clientProvider;
  final BuildContext context;
  final Function refreshData;

  CustomerDataTableSource(
    this._customers, {
    required this.refreshData,
    required this.clientProvider,
    required this.context,
  });
  @override
  DataRow getRow(int index) {
    final userModel customer = _customers[index];

    return DataRow(
      cells: [
        DataCell(Text("${customer.firstName} ${customer.lastName}")),
        DataCell(Text("${customer.city}, ${customer.address}")),
        //DataCell(Text("2")), //temp
        DataCell(ElevatedButton(
          onPressed: () {
            //showDeleteConfirmationDialog(service);
          },
          child: const Text('Details'),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _customers.length;

  @override
  int get selectedRowCount => 0;
}
