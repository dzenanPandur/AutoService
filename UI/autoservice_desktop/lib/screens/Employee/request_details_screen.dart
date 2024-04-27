import 'package:autoservice_desktop/globals.dart';
import 'package:autoservice_desktop/models/Employee/vehicleModel.dart';
import 'package:autoservice_desktop/providers/VehicleProvider.dart';
import 'package:autoservice_desktop/screens/Employee/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/Employee/categoryModel.dart';
import '../../models/Employee/requestModel.dart';
import '../../models/Employee/serviceModel.dart';
import '../../providers/CategoryProvider.dart';
import '../../providers/ServiceProvider.dart';

class RequestDetailsScreen extends StatefulWidget {
  final RequestModel request;

  const RequestDetailsScreen({Key? key, required this.request})
      : super(key: key);

  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  final ServiceProvider serviceProvider = ServiceProvider();
  final CategoryProvider categoryProvider = CategoryProvider();
  final VehicleProvider vehicleProvider = VehicleProvider();
  List<CategoryModel> categories = [];
  List<ServiceModel> services = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadServices();
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;

    for (var service in services) {
      if (widget.request.serviceIdList.contains(service.id)) {
        totalPrice += service.price;
      }
    }

    return totalPrice;
  }

  Future<void> loadCategories() async {
    categories = await categoryProvider.getAll();
    setState(() {});
  }

  Future<void> loadServices() async {
    services = await serviceProvider.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //  TextEditingController idController =
    //     TextEditingController(text: widget.request.id.toString());
    //TextEditingController statusController =
    //    TextEditingController(text: widget.request.status);
    TextEditingController dateRequestedController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.request.dateRequested));
    TextEditingController customRequestController =
        TextEditingController(text: widget.request.customRequest);
    TextEditingController priceController =
        TextEditingController(text: _calculateTotalPrice().toString());
    TextEditingController statusController =
        TextEditingController(text: widget.request.status);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildServiceSection(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            'Request Date', dateRequestedController, true),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _openDetailsScreen(context);
                        },
                        child: const Text('Vehicle Details'),
                      ),
                    ],
                  ),
                  _buildTextField(
                      'Custom request', customRequestController, true),
                  _buildTextField('Final price', priceController, false),
                  _buildTextField("Status", statusController, true),

                  //Implement status dropdown

                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(16.0),
                        ),
                      ),
                      child: const Text('Save Changes',
                          style: TextStyle(fontSize: 18.0)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetailsScreen(BuildContext context) async {
    try {
      // Replace the next line with your actual logic to get the vehicle using the ID
      VehicleModel? vehicle =
          await vehicleProvider.getById(widget.request.vehicleId!);

      if (vehicle != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetailsScreen(vehicle: vehicle),
          ),
        );
      } else {
        // Handle the case where the vehicle is not found
        print('Error: Vehicle not found.');
      }
    } catch (error) {
      print('Error loading vehicle details: $error');
      // Handle the error (show a message, log it, etc.)
    }
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool editable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: editable,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selected services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (var category in categories)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: primaryBackgroundColor),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                for (var service
                    in services.where((s) => s.categoryName == category.name))
                  Row(
                    children: [
                      Checkbox(
                        value:
                            widget.request.serviceIdList.contains(service.id),
                        onChanged: null,
                      ),
                      Text(service.name),
                    ],
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
      ],
    );
  }
}
