// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_mobile/providers/AppointmentProvider.dart';
import 'package:autoservice_mobile/providers/RequestProvider.dart';
import 'package:flutter/material.dart';
import '../globals.dart';
import '../models/categoryModel.dart';
import '../models/request/requestModel.dart';
import '../models/serviceModel.dart';
import '../providers/CategoryProvider.dart';
import '../providers/ServiceProvider.dart';

class RequestDetailsScreen extends StatefulWidget {
  final RequestModel request;
  const RequestDetailsScreen({Key? key, required this.request})
      : super(key: key);

  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _vehicleController = TextEditingController();
  TextEditingController _customRequestController = TextEditingController();
  final ServiceProvider serviceProvider = ServiceProvider();
  final CategoryProvider categoryProvider = CategoryProvider();
  final RequestProvider requestProvider = RequestProvider();
  final AppointmentProvider appointmentProvider = AppointmentProvider();
  List<CategoryModel> categories = [];
  List<ServiceModel> services = [];
  List<int> selectedServiceIds = [];
  late Future<void> _initializeDataFuture;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
        text: _formatDate(widget.request.appointmentDate!));
    _customRequestController =
        TextEditingController(text: widget.request.customRequest);
    _vehicleController =
        TextEditingController(text: widget.request.vehicleName);
    selectedServiceIds = widget.request.serviceIdList;
    _initializeDataFuture = loadData();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Future<void> loadData() async {
    categories = await categoryProvider.getAll();
    services = await serviceProvider.getAll();
    setState(() {});
  }

  Widget _buildEstimatedCostSection() {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Text(
            'Estimated Cost: ${widget.request.totalCost} KM',
            style: TextStyle(
              fontSize: 20,
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
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
            'Request details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<void>(
              future: _initializeDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //const SizedBox(height: 20),
                      Text('Appointment date:',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold)),
                      TextFormField(
                        readOnly: true,
                        controller: _dateController,
                      ),
                      const SizedBox(height: 20),
                      Text('Vehicle:',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold)),
                      TextFormField(
                        readOnly: true,
                        controller: _vehicleController,
                      ),
                      const SizedBox(height: 20),
                      Text('Selected Services:',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold)),
                      _buildServiceSection(),
                      const SizedBox(height: 20),
                      Text('Custom Request:',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold)),
                      TextFormField(
                        readOnly: true,
                        controller: _customRequestController,
                      ),
                      const SizedBox(height: 20),
                      _buildEstimatedCostSection(),
                      const SizedBox(height: 20),
                    ],
                  );
                }
              }),
        )));
  }

  Widget _buildServiceSection() {
    List<ServiceModel> selectedServices = services
        .where((service) => widget.request.serviceIdList.contains(service.id))
        .toList();

    final Map<String, List<ServiceModel>> selectedServicesByCategory = {};
    selectedServices.forEach((service) {
      if (!selectedServicesByCategory.containsKey(service.categoryName)) {
        selectedServicesByCategory[service.categoryName!] = [];
      }
      selectedServicesByCategory[service.categoryName]!.add(service);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        for (final category in selectedServicesByCategory.keys)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: primaryBackgroundColor),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey.shade200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: selectedServicesByCategory[category]!.length,
                  itemBuilder: (context, index) {
                    final service =
                        selectedServicesByCategory[category]![index];
                    return Row(
                      children: [
                        Checkbox(
                          checkColor: primaryBackgroundColor,
                          fillColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return secondaryColor;
                              }
                              return null;
                            },
                          ),
                          value: true,
                          onChanged: null,
                        ),
                        Expanded(
                          child: Text(service.name),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
