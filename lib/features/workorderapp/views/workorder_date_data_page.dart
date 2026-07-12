//workOrder Profile Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/workorderapp/workorder_services.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class WorkOrderDateDataPage extends StatefulWidget {
  final Map<String, String> args;
  const WorkOrderDateDataPage({super.key, required this.args});

  @override
  State<WorkOrderDateDataPage> createState() => _WorkOrderDateDataPageState();
}

class _WorkOrderDateDataPageState extends State<WorkOrderDateDataPage> {
  final formKey = GlobalKey<FormState>();
  WorkOrderServices workOrderServices = WorkOrderServices();
  Map<String, dynamic>? arguments;
  Map<String, dynamic> clientMap = {};
  UtilitiesServices utilityServices = UtilitiesServices();

  String? localTitle;
  //section 1
//section 1
  TextEditingController orderIdController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController departmentNumberController = TextEditingController();
  TextEditingController disciplineCodesController =  TextEditingController();
  TextEditingController createdDateController = TextEditingController();
  TextEditingController dayValueController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController holidayController = TextEditingController();
  TextEditingController marginController = TextEditingController();
  TextEditingController marginWEController = TextEditingController();
  TextEditingController overrideBillModifiersController = TextEditingController();
  TextEditingController overridePayModifiersController = TextEditingController();
  TextEditingController payOTRateController = TextEditingController();
  TextEditingController rateTypeController = TextEditingController();
  TextEditingController shiftCodeController = TextEditingController();
  TextEditingController shiftCountController = TextEditingController();
  TextEditingController shiftDateController = TextEditingController();
  TextEditingController shiftSequenceController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController statusIdController = TextEditingController();
  TextEditingController weekEndController = TextEditingController();

  int? orderId;
  Future<void> getWorkOrderMapX() async {
    await getWorkOrderMap();

  }

  Future<void> getWorkOrderMap() async {
    debugPrint('line 57 get client : $orderId');

    Map<String, dynamic>? wrk = await workOrderServices.getWorkOrder(orderId!);
    //   debugPrint('line 177: ${cli!}');
    debugPrint('line 60: ${wrk!['dates']}');
    orderIdController.text = wrk!['orderId'].toString();
    clientNameController.text = wrk['clientName'];
    departmentNumberController.text = wrk['departmentNumber'];
    departmentNameController.text =wrk['departmentName'];
    shiftCodeController.text = wrk['dates']['shiftDateInfo']['shiftCode'];
    shiftDateController.text =wrk['shiftDate'];
    startTimeController.text = wrk['dates']['shiftDateInfo']['startTime'];
    endTimeController.text = wrk['dates']['shiftDateInfo']['endTime'];
    rateTypeController.text = wrk['dates']['shiftDateInfo']['rateType'];
    statusIdController.text = wrk['dates']['shiftDateInfo']['statusId'];
    marginController.text = wrk['dates']['shiftDateInfo']['margin'].toStringAsFixed(2);
    marginWEController.text = wrk['dates']['shiftDateInfo']['marginWE'].toStringAsFixed(2);
    overrideBillModifiersController.text = wrk['dates']['shiftDateInfo']['overrideBillModifiers'] == null ? 'false' :
      wrk['dates']['shiftDateInfo']['overrideBillModifiers'].toString();
    overrideBillModifiersController.text = wrk['dates']['shiftDateInfo']['overridePayModifiers'] == null ? 'false' :
    wrk['dates']['shiftDateInfo']['overridePayModifiers'].toString();
    payOTRateController.text = wrk['dates']['shiftDateInfo']['payOTRate'] == null ? '1.5' :
      wrk['dates']['shiftDateInfo']['payOTRate'].toString();
    shiftCountController.text = wrk['dates']['shiftDateInfo']['shiftCount'].toString();
    shiftSequenceController.text = wrk['dates']['shiftDateInfo']['shiftSequence'].toString();
    holidayController.text = wrk['dates']['shiftDateInfo']['holiday'] == null ? 'false' :
    wrk['dates']['shiftDateInfo']['holiday'].toString();
    overrideBillModifiersController.text = wrk['dates']['shiftDateInfo']['weekEnd'] == null ? 'false' :
    wrk['dates']['shiftDateInfo']['weekEnd'].toString();

    debugPrint('line 87: exiting get workorder map $wrk');
  }

  @override
  void dispose() {
    super.dispose();
    //section 1
    orderIdController.dispose();
    clientNameController.dispose();
    departmentNameController.dispose();
    departmentNumberController.dispose();
    disciplineCodesController.dispose();
    createdDateController.dispose();
    dayValueController.dispose();
    endTimeController.dispose();
    holidayController.dispose();
    marginController.dispose();
    marginWEController.dispose();
    overrideBillModifiersController.dispose();
    overridePayModifiersController.dispose();
    payOTRateController.dispose();
    rateTypeController.dispose();
    shiftCodeController.dispose();
    shiftCountController.dispose();
    shiftDateController.dispose();
    shiftSequenceController.dispose();
    startTimeController.dispose();
    statusIdController.dispose();
    weekEndController.dispose();

  }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    debugPrint('line 113 ${arguments!}');
    orderId = int.parse(arguments!['workOrderId'].toString());
    localTitle = 'WorkOrder Date Data';
    debugPrint('line 118 arguments $arguments');
    getWorkOrderMapX();
  }

  double? screenHeight;
  double? fontSize;
  String? selectedMenu;
  String? selectedMenuName;
  int? selectedMenuNumber;
  int? selectedMenuIndex;
  bool flagHaveData = false;

  bool showRightSide = false;
  String genericTitle = '';
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double totalCurrentBalance = 0.0;
  double h = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = 'WorkOrder Date Data Form ';
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    debugPrint('line 115: $screenWidth $screenHeight');
    double? hh = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    h = hh!;
    if (h < 1.0) {
      h = 1.0;
    }
    fontSize = 16 / h;
    double smallFontSize = 12 / h;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localTitle!,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                          controller: orderIdController,
                          maxLength: 10,
                          decoration:
                          InputDecoration(label: Text('Order Id')),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: clientNameController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Client Name')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: departmentNameController,
                            maxLength: 5,
                            decoration:
                            InputDecoration(label: Text('Department Name')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: departmentNumberController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Dept Number')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 2
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: shiftCodeController,
                            maxLength: 80,
                            decoration:
                            InputDecoration(label: Text('Shift')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: shiftDateController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('Shift Date')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: startTimeController,
                            maxLength: 40,
                            decoration: InputDecoration(
                                label: Text('Start Time')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: endTimeController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('End Time')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 3
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: statusIdController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Work Order Status')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: rateTypeController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Rate Type')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: marginController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Margin')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: marginWEController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Margin WE')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 4
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: overrideBillModifiersController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Bill Override')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: overridePayModifiersController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Override Pay')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: payOTRateController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Pay OT Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: shiftCountController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Shift Count')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 5
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: shiftSequenceController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Sequence')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: holidayController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Holiday')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.black87,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: weekEndController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Pay OT Rate')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final navigator = Navigator.of(context)
                        .pushNamed(workOrderMenu, arguments: arguments!);
                  },
                  child: Text('Exit'),
                ),
                // SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: () {
                //     formKey.currentState?.reset();
                //   },
                //   child: Text('Reset From'),
                // ),
              ],
            )),
      ),
    );
  }
}
