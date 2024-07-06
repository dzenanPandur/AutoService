// ignore_for_file: use_build_context_synchronously

import 'package:autoservice_desktop/globals.dart';
import 'package:autoservice_desktop/models/Admin/transmissionTypeModel.dart';
import 'package:autoservice_desktop/providers/FuelTypeProvider.dart';
import 'package:flutter/material.dart';
import '../../models/Admin/fuelTypeModel.dart';
import '../../models/Admin/vehicleTypeModel.dart';
import '../../providers/TransmissionTypeProvider.dart';
import '../../providers/VehicleTypeProvider.dart';

class VehicleDataScreen extends StatefulWidget {
  const VehicleDataScreen({Key? key}) : super(key: key);

  @override
  _VehicleDataScreenState createState() => _VehicleDataScreenState();
}

class _VehicleDataScreenState extends State<VehicleDataScreen> {
  final VehicleTypeProvider _vehicleTypeProvider = VehicleTypeProvider();
  final FuelTypeProvider _fuelTypeProvider = FuelTypeProvider();
  final TransmissionTypeProvider _transmissionTypeProvider =
      TransmissionTypeProvider();
  final TextEditingController _vehicleNameControllerAdd =
      TextEditingController();
  final TextEditingController _fuelNameControllerAdd = TextEditingController();
  final TextEditingController _transmissionNameControllerAdd =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Vehicle Data Management',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: primaryBackgroundColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              createButtonDialog(
                context: context,
                typeProvider: _vehicleTypeProvider,
                dialogTitle: 'Manage Vehicle Types',
                future: _vehicleTypeProvider.getAll(),
                listType: VehicleTypeModel,
                headerText: 'Vehicle Types',
                buttonText: 'Manage Vehicle Types',
                addButtonCallback: () => createAddDialog(
                  context: context,
                  dialogTitle: 'Add New Vehicle Type',
                  textFieldLabel: 'Vehicle Type Name',
                  controller: _vehicleNameControllerAdd,
                  createFunction: (name) {
                    return _vehicleTypeProvider.create(VehicleTypeModel(
                      id: 0,
                      name: name,
                      isActive: true,
                    ));
                  },
                ),
                showEditDialog: (vehicleType) => createEditDialog(
                  context: context,
                  dialogTitle: 'Edit Vehicle Type',
                  textFieldLabel: 'Vehicle Type Name',
                  controller: TextEditingController(text: vehicleType.name),
                  updateFunction: (name) async {
                    vehicleType.name = name;
                    await _vehicleTypeProvider.update2(vehicleType);
                  },
                ),
              ),
              const SizedBox(height: 40),
              createButtonDialog(
                context: context,
                typeProvider: _fuelTypeProvider,
                dialogTitle: 'Manage Fuel Types',
                future: _fuelTypeProvider.getAll(),
                listType: FuelTypeModel,
                headerText: 'Fuel Types',
                buttonText: 'Manage Fuel Types',
                addButtonCallback: () => createAddDialog(
                  context: context,
                  dialogTitle: 'Add New Fuel Type',
                  textFieldLabel: 'Fuel Type Name',
                  controller: _fuelNameControllerAdd,
                  createFunction: (name) {
                    return _fuelTypeProvider.create(FuelTypeModel(
                      id: 0,
                      name: name,
                      isActive: true,
                    ));
                  },
                ),
                showEditDialog: (fuelType) => createEditDialog(
                  context: context,
                  dialogTitle: 'Edit Fuel Type',
                  textFieldLabel: 'Fuel Type Name',
                  controller: TextEditingController(text: fuelType.name),
                  updateFunction: (name) async {
                    fuelType.name = name;
                    await _fuelTypeProvider.update2(fuelType);
                  },
                ),
              ),
              const SizedBox(height: 40),
              createButtonDialog(
                context: context,
                typeProvider: _transmissionTypeProvider,
                dialogTitle: 'Manage Transmission Types',
                future: _transmissionTypeProvider.getAll(),
                listType: TransmissionTypeModel,
                headerText: 'Transmission Types',
                buttonText: 'Manage Transmission Types',
                addButtonCallback: () => createAddDialog(
                  context: context,
                  dialogTitle: 'Add New Transmission Type',
                  textFieldLabel: 'Transmission Type Name',
                  controller: _transmissionNameControllerAdd,
                  createFunction: (name) {
                    return _transmissionTypeProvider
                        .create(TransmissionTypeModel(
                      id: 0,
                      name: name,
                      isActive: true,
                    ));
                  },
                ),
                showEditDialog: (transmissionType) => createEditDialog(
                  context: context,
                  dialogTitle: 'Edit Transmission Type',
                  textFieldLabel: 'Transmission Type Name',
                  controller:
                      TextEditingController(text: transmissionType.name),
                  updateFunction: (name) async {
                    transmissionType.name = name;
                    await _transmissionTypeProvider.update2(transmissionType);
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget createButtonDialog(
      {required BuildContext context,
      required String dialogTitle,
      required Future<List<dynamic>> future,
      required Type listType,
      required String headerText,
      required String buttonText,
      required Function addButtonCallback,
      required Function showEditDialog,
      required dynamic typeProvider}) {
    return SizedBox(
      width: 500,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dialogTitle,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: secondaryColor, size: 45),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                content: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder<List<dynamic>>(
                          future: future,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<dynamic> items = snapshot.data ?? [];
                              return SingleChildScrollView(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: SingleChildScrollView(
                                    child: PaginatedDataTable(
                                      headingRowColor:
                                          MaterialStateProperty.all(
                                              secondaryColor),
                                      arrowHeadColor: secondaryColor,
                                      header: Text(headerText),
                                      columns: [
                                        DataColumn(
                                            label: Text(
                                          '#',
                                          style: TextStyle(color: fontColor),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Name',
                                          style: TextStyle(color: fontColor),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'isActive',
                                          style: TextStyle(color: fontColor),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Edit',
                                          style: TextStyle(color: fontColor),
                                        )),
                                      ],
                                      rowsPerPage: 4,
                                      source: GenericDataTableSource(
                                        items: items,
                                        updateFunction: (item) =>
                                            typeProvider.update2(item),
                                        context: context,
                                        showEditDialog: showEditDialog,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
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
                            addButtonCallback();
                          },
                          child: const Text('Add New'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Text(buttonText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  Future<void> createAddDialog({
    required BuildContext context,
    required String dialogTitle,
    required String textFieldLabel,
    required TextEditingController controller,
    required Future<void> Function(String name) createFunction,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: primaryBackgroundColor,
          title: Text(dialogTitle),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: textFieldLabel,
            ),
          ),
          actions: [
            ElevatedButton(
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
                if (controller.text.isNotEmpty) {
                  try {
                    await createFunction(controller.text);
                    setState(() {});
                    Navigator.pop(context);
                    Navigator.pop(context);
                    showSnackBar(
                        context, "Successfully created item!", accentColor);
                  } catch (e) {
                    showSnackBar(context, "$e", secondaryColor);
                  }
                } else {
                  showSnackBar(context, 'Please enter a name.', secondaryColor);
                }
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> createEditDialog({
    required BuildContext context,
    required String dialogTitle,
    required String textFieldLabel,
    required TextEditingController controller,
    required Future<void> Function(dynamic) updateFunction,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: primaryBackgroundColor,
          title: Text(dialogTitle),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: textFieldLabel,
            ),
          ),
          actions: [
            ElevatedButton(
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
                if (controller.text.isNotEmpty) {
                  try {
                    await updateFunction(controller.text);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    showSnackBar(
                        context, "Name successfully updated!", accentColor);
                  } catch (e) {
                    showSnackBar(context, "$e", secondaryColor);
                  }
                } else {
                  showSnackBar(context, 'Please enter a name.', secondaryColor);
                }
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class GenericDataTableSource<T> extends DataTableSource {
  final List<T> items;
  final Future<void> Function(dynamic) updateFunction;
  final BuildContext context;
  final Function showEditDialog;

  GenericDataTableSource({
    required this.items,
    required this.updateFunction,
    required this.context,
    required this.showEditDialog,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) return null;
    final item = items[index];
    bool isActive = (item as dynamic).isActive;
    return DataRow(
      cells: [
        DataCell(Text((item as dynamic).id.toString())),
        DataCell(Text((item as dynamic).name)),
        DataCell(
          Checkbox(
            value: isActive,
            onChanged: (value) async {
              try {
                (item as dynamic).isActive = value ?? false;
                await updateFunction(item);
                Navigator.pop(context);
                showSnackBar(
                    context, "Status updated successfully", accentColor);
              } catch (e) {
                showSnackBar(context, "$e", secondaryColor);
              }
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showEditDialog(item);
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}
