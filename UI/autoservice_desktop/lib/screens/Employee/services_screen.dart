import 'package:autoservice_desktop/providers/ServiceProvider.dart';
import 'package:autoservice_desktop/providers/CategoryProvider.dart';
import 'package:flutter/material.dart';
import '../../models/Employee/serviceModel.dart';
import '../../models/Employee/categoryModel.dart';
import '../../globals.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final ServiceProvider serviceProvider = ServiceProvider();
  final CategoryProvider categoryProvider = CategoryProvider();
  List<ServiceModel>? services;
  List<CategoryModel> categories = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  TextEditingController serviceNameControllerAdd = TextEditingController();
  TextEditingController serviceCategoryControllerAdd = TextEditingController();
  TextEditingController isActiveControllerAdd = TextEditingController();
  TextEditingController priceControllerAdd = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await categoryProvider.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Management'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder<List<ServiceModel>>(
                future: serviceProvider.getAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    services = snapshot.data;

                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: PaginatedDataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Service Name')),
                              DataColumn(label: Text('Service Category')),
                              DataColumn(label: Text('Is Active')),
                              DataColumn(label: Text('Price')),
                              DataColumn(label: Text('Delete')),
                            ],
                            header: const Center(
                              child: Text('Services'),
                            ),
                            rowsPerPage: 5,
                            source: ServiceDataTableSource(
                              services!,
                              serviceProvider: serviceProvider,
                              context: context,
                              //showDetailsDialog: _showDetailsDialog,
                              refreshData: _refreshData,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: primaryBackgroundColor,
                                  title: const Text(
                                    'Add Service',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildRow(
                                          "Service Name",
                                          serviceNameControllerAdd,
                                          false,
                                        ),
                                        DropdownButtonFormField<CategoryModel>(
                                          value: categories.isNotEmpty
                                              ? categories.first
                                              : null,
                                          items: categories
                                              .map((CategoryModel category) {
                                            return DropdownMenuItem<
                                                CategoryModel>(
                                              value: category,
                                              child: Text(category.name),
                                            );
                                          }).toList(),
                                          onChanged: (CategoryModel? value) {
                                            setState(() {
                                              if (value != null) {
                                                serviceCategoryControllerAdd
                                                    .text = value.id.toString();
                                              } else {
                                                serviceCategoryControllerAdd
                                                    .text = '';
                                              }
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Service Category',
                                          ),
                                        ),
                                        buildRow(
                                          "Price",
                                          priceControllerAdd,
                                          false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          ServiceModel request = ServiceModel(
                                            id: 0,
                                            name: serviceNameControllerAdd.text,
                                            isActive: true,
                                            price: double.tryParse(
                                                    priceControllerAdd.text) ??
                                                0.0,
                                            categoryId: int.tryParse(
                                                    serviceCategoryControllerAdd
                                                        .text) ??
                                                0,
                                          );
                                          var createdService =
                                              await serviceProvider
                                                  .create(request);
                                          serviceNameControllerAdd.text = '';
                                          serviceCategoryControllerAdd.text =
                                              '';
                                          isActiveControllerAdd.text = '';
                                          priceControllerAdd.text = '';

                                          Navigator.pop(context);
                                          _refreshData();
                                          print(
                                              'Service created: $createdService');
                                        } catch (e) {
                                          print('Failed to create service: $e');
                                        }
                                      },
                                      child: const Text('Add'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        serviceNameControllerAdd.text = '';
                                        serviceCategoryControllerAdd.text = '';
                                        isActiveControllerAdd.text = '';
                                        priceControllerAdd.text = '';
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('Add Service'),
                        )
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

class ServiceDataTableSource extends DataTableSource {
  final List<ServiceModel> _services;
  final ServiceProvider serviceProvider;
  final BuildContext context;
  //final Function(ServiceModel) showDetailsDialog;
  final Function refreshData;

  ServiceDataTableSource(this._services,
      {
      //required this.showDetailsDialog
      required this.refreshData,
      required this.serviceProvider,
      required this.context});

  @override
  DataRow getRow(int index) {
    final ServiceModel service = _services[index];

    return DataRow(
      cells: [
        DataCell(Text(service.id.toString())),
        DataCell(Text(service.name)),
        DataCell(Text(service.categoryName ?? 'N/A')),
        DataCell(Checkbox(
          value: service.isActive,
          onChanged: (bool? value) {},
        )),
        DataCell(Text(service.price.toString())),
        DataCell(ElevatedButton(
          onPressed: () {
            showDeleteConfirmationDialog(service);
          },
          child: const Text('Delete'),
        )),
      ],
    );
  }

  Future<void> showDeleteConfirmationDialog(ServiceModel service) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryBackgroundColor,
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${service.name}?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await serviceProvider.delete(service.id);
                Navigator.of(context).pop();
                refreshData();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _services.length;

  @override
  int get selectedRowCount => 0;
}
