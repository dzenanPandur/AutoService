// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:autoservice_desktop/providers/RequestProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../enum.dart';
import '../../globals.dart';
import '../../models/Employee/requestModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RequestsScreen extends StatefulWidget {
  final Function(RequestModel) onRequestSelected;

  const RequestsScreen({Key? key, required this.onRequestSelected})
      : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final RequestProvider requestProvider = RequestProvider();
  List<RequestModel>? requests;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  TextEditingController searchByClientName = TextEditingController();
  TextEditingController searchByVehicleName = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  List<Status> selectedStatuses = [];
  List<RequestModel> filteredRequests = [];

  Future<void> _fetchRequests() async {
    requests = await requestProvider.getAll();
    filteredRequests = requests ?? [];
    setState(() {});
  }

  void _refreshRequests() {
    _fetchRequests();
  }

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryBackgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchByClientName,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search by Client Name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchByVehicleName,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search by Vehicle Name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MultiSelectDialogField<Status>(
                    checkColor: fontColor,
                    backgroundColor: primaryBackgroundColor,
                    selectedColor: secondaryColor,
                    dialogWidth: MediaQuery.of(context).size.width * 0.3,
                    dialogHeight: MediaQuery.of(context).size.height * 0.7,
                    chipDisplay: MultiSelectChipDisplay.none(),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.fromBorderSide(BorderSide(
                        color: Colors.grey,
                      )),
                    ),
                    title: const Text('Select Status'),
                    buttonText: const Text('Select Status'),
                    items: Status.values
                        .map((status) => MultiSelectItem<Status>(
                              status,
                              status.toString().split('.').last,
                            ))
                        .toList(),
                    listType: MultiSelectListType.LIST,
                    onConfirm: (List<Status> statuses) {
                      setState(() {
                        selectedStatuses = statuses;
                      });
                    },
                    initialValue: selectedStatuses,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    label: 'From Date',
                    selectedDate: fromDate,
                    onDateSelected: (date) => setState(() {
                      fromDate = date;
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDatePicker(
                    label: 'To Date',
                    selectedDate: toDate,
                    onDateSelected: (date) => setState(() {
                      toDate = date;
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50),
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    _searchRequests();
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
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
                    List<RequestModel> displayedRequests =
                        _getDisplayedRequests();
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: PaginatedDataTable(
                              headingRowColor:
                                  MaterialStateProperty.all(secondaryColor),
                              arrowHeadColor: secondaryColor,
                              columns: [
                                DataColumn(
                                    label: Text(
                                  '#',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Status',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Request Date',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Client Name',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Car',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Details',
                                  style: TextStyle(color: fontColor),
                                )),
                              ],
                              header: const Center(
                                child: Text(
                                  'Requests',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              rowsPerPage: 5,
                              source: RequestDataTableSource(displayedRequests,
                                  requestProvider: requestProvider,
                                  context: context,
                                  refreshData: _refreshData,
                                  onRequestUpdated: _refreshRequests,
                                  onRequestSelected: widget.onRequestSelected),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  final pdf = pw.Document();

                  List<RequestModel> reportRequests =
                      filteredRequests.isNotEmpty
                          ? filteredRequests
                          : requests ?? [];

                  pdf.addPage(pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Column(
                        children: [
                          pw.Center(
                            child: pw.Text(
                              'AutoService',
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 20),
                          pw.Text(
                            'Request report generated at: ${DateFormat('dd.MM.yyyy').format(DateTime.now())} at ${DateFormat('HH:mm').format(DateTime.now())}',
                            style: const pw.TextStyle(fontSize: 16),
                          ),
                          pw.SizedBox(height: 20),
                          pw.TableHelper.fromTextArray(
                            headers: [
                              '#',
                              'Status',
                              'Request Date',
                              'Client name',
                              'Vehicle'
                            ],
                            data: reportRequests
                                .asMap()
                                .map((index, request) => MapEntry(
                                      index,
                                      [
                                        '${index + 1}',
                                        request.status,
                                        DateFormat('dd.MM.yyyy')
                                            .format(request.dateRequested),
                                        request.clientName,
                                        request.vehicleName,
                                      ],
                                    ))
                                .values
                                .toList(),
                            border: pw.TableBorder.all(),
                            cellAlignment: pw.Alignment.centerLeft,
                            headerStyle:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            cellStyle: const pw.TextStyle(fontSize: 12),
                            cellPadding: const pw.EdgeInsets.all(8),
                          ),
                        ],
                      );
                    },
                  ));

                  final bytes = await pdf.save();

                  final directory =
                      await FilePicker.platform.getDirectoryPath();
                  if (directory != null) {
                    final file = File(
                        '$directory/Request_Report_${DateFormat('dd-MM-yyyy_HH-mm-ss').format(DateTime.now())}.pdf');
                    await file.writeAsBytes(bytes);
                    showSnackBar(context,
                        'PDF saved successfully at ${file.path}', accentColor);
                  }
                },
                child: const Text('Generate Report'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? selectedDate,
    required ValueChanged<DateTime?> onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        onDateSelected(pickedDate);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
        ),
        child: Text(
          selectedDate != null
              ? DateFormat('dd-MM-yyyy').format(selectedDate)
              : 'Select Date',
        ),
      ),
    );
  }

  void _searchRequests() {
    String clientNameSearchText = searchByClientName.text.toLowerCase();
    String vehicleNameSearchText = searchByVehicleName.text.toLowerCase();

    if (requests != null) {
      filteredRequests = requests!
          .where((request) =>
              request.clientName.toLowerCase().contains(clientNameSearchText) &&
              request.vehicleName
                  .toLowerCase()
                  .contains(vehicleNameSearchText) &&
              (fromDate == null ||
                  request.dateRequested.isAfter(fromDate!) ||
                  request.dateRequested.isAtSameMomentAs(fromDate!)) &&
              (toDate == null ||
                  request.dateRequested.isBefore(toDate!) ||
                  request.dateRequested.isAtSameMomentAs(toDate!)) &&
              (selectedStatuses.isEmpty ||
                  selectedStatuses
                      .contains(Status.values[request.statusId - 1])))
          .toList();

      String message;
      if (filteredRequests.isNotEmpty) {
        message =
            '${filteredRequests.length} request(s) found for selected filters';
      } else {
        message = 'No requests found for selected filters';
      }

      showSnackBar(context, message, accentColor);

      _refreshData();
    }
  }

  List<RequestModel> _getDisplayedRequests() {
    if (filteredRequests.isNotEmpty) {
      return filteredRequests;
    } else {
      return requests ?? [];
    }
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
  final VoidCallback onRequestUpdated;
  final Function(RequestModel) onRequestSelected;

  RequestDataTableSource(
    this._requests, {
    required this.refreshData,
    required this.requestProvider,
    required this.context,
    required this.onRequestUpdated,
    required this.onRequestSelected,
  });
  @override
  DataRow getRow(int index) {
    final RequestModel request = _requests[index];
    var rowNumber = _requests.indexOf(
            _requests.firstWhere((element) => element.id == request.id)) +
        1;
    return DataRow(
      cells: [
        DataCell(Text(rowNumber.toString())),
        DataCell(Text(request.status)),
        DataCell(Text(DateFormat('dd-MM-yyyy').format(request.dateRequested))),
        DataCell(Text(request.clientName)),
        DataCell(Text(request.vehicleName)),
        DataCell(ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            backgroundColor: secondaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.white),
            ),
          ),
          onPressed: () => _openDetailsScreen(context, request),
          child: const Text('Details'),
        )),
      ],
    );
  }

  void _openDetailsScreen(BuildContext context, RequestModel request) {
    onRequestSelected(request);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _requests.length;

  @override
  int get selectedRowCount => 0;
}
