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

import '../../providers/ServiceProvider.dart';

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

                  int totalRequests = requests!.length;

                  DateTime now = DateTime.now();
                  DateTime firstRequestDate = requests!
                      .map((r) => r.dateRequested)
                      .reduce((a, b) => a.isBefore(b) ? a : b);

                  double averageRequestsPerDay = totalRequests /
                      (now.difference(firstRequestDate).inDays + 1);
                  double averageRequestsPerMonth = totalRequests /
                      ((now.year - firstRequestDate.year) * 12 +
                          now.month -
                          firstRequestDate.month +
                          1);
                  double averageRequestsPerYear =
                      totalRequests / (now.year - firstRequestDate.year + 1);

                  int cancelledRequests = requests!
                      .where((request) => request.status == 'Canceled')
                      .length;
                  double cancellationRate =
                      cancelledRequests / totalRequests * 100;

                  Map<int, int> serviceFrequency = {};
                  for (var request in requests!) {
                    for (var serviceId in request.serviceIdList) {
                      serviceFrequency[serviceId] =
                          (serviceFrequency[serviceId] ?? 0) + 1;
                    }
                  }
                  var mostRequestedService = serviceFrequency.entries
                      .reduce((a, b) => a.value > b.value ? a : b);

                  Duration totalFulfillmentTime = Duration.zero;
                  int completedRequestsNum = 0;
                  for (var request in requests!) {
                    if (request.status == 'Completed') {
                      totalFulfillmentTime += request.dateCompleted
                          .difference(request.dateRequested);
                      completedRequestsNum++;
                    }
                  }
                  Duration averageFulfillmentTime = completedRequestsNum > 0
                      ? totalFulfillmentTime ~/ completedRequestsNum
                      : Duration.zero;

                  List<RequestModel> completedRequests = requests!
                      .where((request) => request.status == 'Completed')
                      .toList();

                  DateTime lastCompletedDate = completedRequests.isNotEmpty
                      ? completedRequests
                          .map((request) => request.dateCompleted)
                          .reduce((a, b) => a.isAfter(b) ? a : b)
                      : now;
                  final endMonth = DateTime(
                      lastCompletedDate.year, lastCompletedDate.month + 1, 1);
                  final currentYear = lastCompletedDate.year;

                  final List<String> allMonths = [];
                  for (var month = DateTime(now.year, 1, 1);
                      month.isBefore(endMonth);
                      month = DateTime(month.year, month.month + 1, 1)) {
                    allMonths.add(DateFormat('MM-yyyy').format(month));
                  }

                  Map<String, double> monthlyCosts = {
                    for (var month in allMonths) month: 0.0
                  };

                  for (var request in completedRequests) {
                    String month =
                        DateFormat('MM-yyyy').format(request.dateCompleted);
                    monthlyCosts[month] =
                        (monthlyCosts[month] ?? 0) + (request.totalCost ?? 0);
                  }

                  final List<MapEntry<String, double>> sortedData =
                      monthlyCosts.entries.toList()
                        ..sort((a, b) => a.key.compareTo(b.key));

                  final List<String> monthNames =
                      sortedData.map((e) => e.key).toList();
                  final List<double> costs =
                      sortedData.map((e) => e.value).toList();

                  if (costs.isEmpty) {
                    monthNames.add('No Data');
                    costs.add(0);
                  }

                  final double maxCost =
                      costs.isEmpty ? 0 : costs.reduce((a, b) => a > b ? a : b);
                  final int yAxisMax = (maxCost * 1.2).ceil();
                  Map<String, int> statusCounts = {};
                  for (var request in requests!) {
                    statusCounts[request.status] =
                        (statusCounts[request.status] ?? 0) + 1;
                  }
                  Map<int, String> serviceNames = {};
                  for (var serviceId in serviceFrequency.keys) {
                    var service = await ServiceProvider().getById(serviceId);
                    serviceNames[serviceId] =
                        service?.name ?? 'Unknown Service';
                  }
                  Map<String, int> calculateSeasonalDemand(
                      List<RequestModel>? requests) {
                    Map<String, int> seasonalDemand = {};
                    for (var request in requests!) {
                      String month =
                          DateFormat('MMMM').format(request.dateRequested);
                      seasonalDemand[month] = (seasonalDemand[month] ?? 0) + 1;
                    }
                    return seasonalDemand;
                  }

                  Map<String, int> seasonalDemand =
                      calculateSeasonalDemand(requests);
                  String mostRequestedServiceName =
                      serviceNames[mostRequestedService.key] ??
                          'Unknown Service';
                  final chart2 = pw.Chart(
                    title: pw.Text(
                      'Profit Breakdown for $currentYear',
                      style: const pw.TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    right: pw.ChartLegend(),
                    grid: pw.CartesianGrid(
                      xAxis: pw.FixedAxis(
                        List.generate(
                            monthNames.length, (index) => index.toDouble()),
                        buildLabel: (value) {
                          int index = value.toInt();
                          if (index >= 0 && index < monthNames.length) {
                            return pw.Text(monthNames[index],
                                style: const pw.TextStyle(fontSize: 8));
                          }
                          return pw.SizedBox();
                        },
                        margin: 10,
                        angle: -45,
                      ),
                      yAxis: pw.FixedAxis(
                        [0, yAxisMax / 2, yAxisMax],
                        divisions: true,
                        format: (value) => '${value.toStringAsFixed(0)} KM',
                      ),
                    ),
                    datasets: [
                      pw.LineDataSet(
                        legend: 'Total Profit',
                        drawSurface: true,
                        isCurved: true,
                        drawPoints: true,
                        color: PdfColors.blue300,
                        data: List<pw.PointChartValue>.generate(
                          costs.length,
                          (i) => pw.PointChartValue(i.toDouble(), costs[i]),
                        ),
                      ),
                    ],
                  );

                  pdf.addPage(
                    pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (pw.Context context) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                            pw.Text('Total Requests: $totalRequests'),
                            pw.Text(
                                'Average Requests per Day: ${averageRequestsPerDay.toStringAsFixed(2)}'),
                            pw.Text(
                                'Average Requests per Month: ${averageRequestsPerMonth.toStringAsFixed(2)}'),
                            pw.Text(
                                'Average Requests per Year: ${averageRequestsPerYear.toStringAsFixed(2)}'),
                            pw.Text(
                                'Cancellation Rate: ${cancellationRate.toStringAsFixed(2)}%'),
                            pw.Text(
                                'Most Requested Service: $mostRequestedServiceName (${mostRequestedService.value} times)'),
                            pw.Text(
                                'Average Fulfillment Time: ${averageFulfillmentTime.inDays} days, ${averageFulfillmentTime.inHours % 24} hours'),
                            pw.SizedBox(height: 20),
                            pw.Divider(),
                            pw.Expanded(flex: 2, child: chart2),
                            pw.SizedBox(height: 10),
                            pw.SizedBox(height: 20),
                            pw.Text('Seasonal Demand:',
                                style: pw.TextStyle(
                                  fontSize: 16,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center),
                            pw.Container(
                              height: 200,
                              child: pw.Chart(
                                title: pw.Text('Monthly Service Requests'),
                                grid: pw.CartesianGrid(
                                  xAxis: pw.FixedAxis.fromStrings(
                                    List.generate(
                                        12,
                                        (index) => DateFormat('MMM')
                                            .format(DateTime(2023, index + 1))),
                                    marginStart: 30,
                                    marginEnd: 30,
                                  ),
                                  yAxis: pw.FixedAxis(
                                    [0, 5, 10, 15, 20, 25, 30],
                                    format: (v) => v.toInt().toString(),
                                  ),
                                ),
                                datasets: [
                                  pw.BarDataSet(
                                    color: PdfColors.blue,
                                    legend: 'Service Requests',
                                    width: 15,
                                    data: List.generate(12, (index) {
                                      String month = DateFormat('MMMM')
                                          .format(DateTime(2023, index + 1));
                                      return pw.PointChartValue(
                                          index.toDouble(),
                                          seasonalDemand[month]?.toDouble() ??
                                              0);
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );

                  pdf.addPage(
                    pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (pw.Context context) {
                        const chartColors = [
                          PdfColors.blue300,
                          PdfColors.green300,
                          PdfColors.amber300,
                          PdfColors.pink300,
                          PdfColors.cyan300,
                          PdfColors.purple300,
                          PdfColors.lime300,
                        ];

                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Flexible(
                              child: pw.Chart(
                                title: pw.Text(
                                  'Most Requested Services',
                                  style: const pw.TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                grid: pw.PieGrid(),
                                datasets: List<pw.Dataset>.generate(
                                  serviceFrequency.length,
                                  (index) {
                                    final entry = serviceFrequency.entries
                                        .toList()[index];
                                    final color =
                                        chartColors[index % chartColors.length];
                                    final value = entry.value;
                                    final pct =
                                        (value / totalRequests * 100).round();
                                    final serviceName =
                                        serviceNames[entry.key] ??
                                            'Unknown Service';
                                    return pw.PieDataSet(
                                      legend: '$serviceName: $value ($pct%)',
                                      value: value.toDouble(),
                                      color: color,
                                      legendStyle: const pw.TextStyle(
                                          fontSize: 10, color: PdfColors.black),
                                    );
                                  },
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 20),
                            pw.Flexible(
                              child: pw.Chart(
                                title: pw.Text(
                                  'Request Breakdown',
                                  style: const pw.TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                grid: pw.PieGrid(),
                                datasets: List<pw.Dataset>.generate(
                                  statusCounts.length,
                                  (index) {
                                    final entry =
                                        statusCounts.entries.toList()[index];
                                    final color =
                                        chartColors[index % chartColors.length];
                                    final value = entry.value;
                                    final pct = (value / requests!.length * 100)
                                        .round();
                                    return pw.PieDataSet(
                                      legend: '${entry.key}: $value ($pct%)',
                                      value: value.toDouble(),
                                      color: color,
                                      legendStyle:
                                          const pw.TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  );

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
          fieldHintText: "dd/mm/yyyy",
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

class StatusData {
  final String status;
  final int count;

  StatusData(this.status, this.count);
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
    return DataRow(
      cells: [
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
