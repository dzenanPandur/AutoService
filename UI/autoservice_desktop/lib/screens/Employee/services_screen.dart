// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_desktop/providers/ServiceProvider.dart';
import 'package:autoservice_desktop/providers/CategoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
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
  List<ServiceModel> filteredServices = [];
  List<CategoryModel> selectedCategories = [];
  bool isActiveFilter = false;
  TextEditingController searchByServiceName = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  TextEditingController serviceNameControllerAdd = TextEditingController();
  TextEditingController serviceCategoryControllerAdd = TextEditingController();
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
        title: const Text(
          'Service Management',
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
                    controller: searchByServiceName,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search by Name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MultiSelectDialogField<CategoryModel>(
                    checkColor: fontColor,
                    backgroundColor: primaryBackgroundColor,
                    selectedColor: secondaryColor,
                    dialogWidth: MediaQuery.of(context).size.width * 0.3,
                    dialogHeight: MediaQuery.of(context).size.height * 0.2,
                    chipDisplay: MultiSelectChipDisplay.none(),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.fromBorderSide(BorderSide(
                        color: Colors.grey,
                      )),
                    ),
                    title: const Text('Select Categories'),
                    buttonText: const Text('Select Categories'),
                    items: categories
                        .map((category) => MultiSelectItem<CategoryModel>(
                              category,
                              category.name,
                            ))
                        .toList(),
                    listType: MultiSelectListType.LIST,
                    onConfirm: (List<CategoryModel> selected) {
                      setState(() {
                        selectedCategories = selected;
                      });
                    },
                    initialValue: selectedCategories,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: isActiveFilter,
                        onChanged: (bool? value) {
                          setState(() {
                            isActiveFilter = value ?? false;
                          });
                        },
                      ),
                      const Text('Active Only')
                    ],
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
                    _searchServices();
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
              child: FutureBuilder<List<ServiceModel>>(
                future: serviceProvider.getAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    services = snapshot.data;

                    List<ServiceModel> displayedServices =
                        _getDisplayedServices();

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
                                  'ID',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Service Name',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Service Category',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Is Active',
                                  style: TextStyle(color: fontColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Price',
                                  style: TextStyle(color: fontColor),
                                )),
                              ],
                              header: const Center(
                                child: Text(
                                  'Services',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              rowsPerPage: 5,
                              source: ServiceDataTableSource(
                                displayedServices,
                                serviceProvider: serviceProvider,
                                context: context,
                                refreshData: _refreshData,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              backgroundColor: secondaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    elevation: 0,
                                    backgroundColor: primaryBackgroundColor,
                                    title: const Text(
                                      'Add Service',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                              TextInputType.text,
                                              20),
                                          DropdownButtonFormField<
                                              CategoryModel>(
                                            value: null,
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
                                                          .text =
                                                      (value.id).toString();
                                                } else {
                                                  serviceCategoryControllerAdd
                                                      .text = '';
                                                }
                                              });
                                            },
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              floatingLabelStyle: TextStyle(
                                                  color: secondaryColor),
                                              labelText: 'Service Category',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          buildRow("Price", priceControllerAdd,
                                              false, TextInputType.number, 10),
                                        ],
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          backgroundColor: secondaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: const BorderSide(
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (serviceNameControllerAdd
                                              .text.isEmpty) {
                                            showSnackBar(
                                              context,
                                              "Please input the service name.",
                                            );
                                            return;
                                          }
                                          if (serviceCategoryControllerAdd
                                              .text.isEmpty) {
                                            showSnackBar(
                                              context,
                                              "Please choose a category.",
                                            );
                                            return;
                                          }
                                          if (priceControllerAdd.text.isEmpty) {
                                            showSnackBar(
                                              context,
                                              "Please input the price.",
                                            );
                                            return;
                                          }
                                          try {
                                            ServiceModel request = ServiceModel(
                                              id: 0,
                                              name:
                                                  serviceNameControllerAdd.text,
                                              isActive: true,
                                              price: double.tryParse(
                                                      priceControllerAdd
                                                          .text) ??
                                                  0.0,
                                              categoryId: int.tryParse(
                                                      serviceCategoryControllerAdd
                                                          .text) ??
                                                  0,
                                            );

                                            await serviceProvider
                                                .create(request);
                                            serviceNameControllerAdd.text = '';
                                            serviceCategoryControllerAdd.text =
                                                '';
                                            priceControllerAdd.text = '';

                                            Navigator.pop(context);
                                            _refreshData();

                                            showSnackBar(context,
                                                'Service successfully created.');
                                          } catch (e) {
                                            showSnackBar(context,
                                                'Failed to create service. $e');
                                          }
                                        },
                                        child: const Text('Add'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                          backgroundColor: secondaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: const BorderSide(
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          serviceNameControllerAdd.text = '';
                                          serviceCategoryControllerAdd.text =
                                              '';
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
                      ),
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

  void _searchServices() {
    String nameSearchText = searchByServiceName.text.toLowerCase();

    if (services != null) {
      filteredServices = services!
          .where(
              (service) => service.name.toLowerCase().contains(nameSearchText))
          .where((service) =>
              selectedCategories.isEmpty ||
              selectedCategories
                  .any((category) => category.name == service.categoryName))
          .where((service) => !isActiveFilter || service.isActive)
          .toList();

      String message;
      if (filteredServices.isNotEmpty) {
        message =
            '${filteredServices.length} service(s) found for selected filters';
      } else {
        message = 'No services found for selected filters';
      }

      showSnackBar(context, message);

      _refreshData();
    }
  }

  List<ServiceModel> _getDisplayedServices() {
    if (filteredServices.isNotEmpty) {
      return filteredServices;
    } else {
      return services ?? [];
    }
  }

  void _refreshData() {
    _refreshIndicatorKey.currentState?.show();
  }

  Widget buildRow(String label, TextEditingController controller, bool obscure,
      TextInputType keyboardType, int maxLength) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          floatingLabelStyle: TextStyle(color: secondaryColor),
        ),
      ),
    );
  }
}

class ServiceDataTableSource extends DataTableSource {
  final List<ServiceModel> _services;
  final ServiceProvider serviceProvider;
  final BuildContext context;
  final Function refreshData;

  ServiceDataTableSource(
    this._services, {
    required this.refreshData,
    required this.serviceProvider,
    required this.context,
  });

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
          onChanged: (bool? value) async {
            service.isActive = value ?? false;
            await serviceProvider.update2(service);

            refreshData();

            showSnackBar(context, 'Service status updated successfully!');
          },
        )),
        DataCell(Text(service.price.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _services.length;

  @override
  int get selectedRowCount => 0;
}
