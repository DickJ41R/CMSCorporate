//workOrder Profile Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/workorderapp/workorder_services.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class WorkOrderRateDataPage extends StatefulWidget {
  final Map<String, String> args;
  const WorkOrderRateDataPage({super.key, required this.args});

  @override
  State<WorkOrderRateDataPage> createState() => _WorkOrderRateDataPageState();
}

class _WorkOrderRateDataPageState extends State<WorkOrderRateDataPage> {
  final formKey = GlobalKey<FormState>();
  WorkOrderServices workOrderServices = WorkOrderServices();
  Map<String, dynamic>? arguments;
  Map<String, dynamic> clientMap = {};
  UtilitiesServices utilityServices = UtilitiesServices();

  String? localTitle;
  //section 1
  TextEditingController orderIdController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController rateGroupIdController = TextEditingController();
  TextEditingController rateIdController = TextEditingController();
  //section 2
  TextEditingController shiftDateController = TextEditingController();
  TextEditingController shiftCodeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  //section 3
  TextEditingController billDblPlusRateController =  TextEditingController();
  TextEditingController billDblRateController = TextEditingController();
  TextEditingController billHolidayPlusRateController = TextEditingController();
  TextEditingController billHolidayRateController = TextEditingController();
  //section 4
  TextEditingController billMaxPlusRateController = TextEditingController();
  TextEditingController billMaxRateController = TextEditingController();
  TextEditingController billOTPlusRateController = TextEditingController();
  TextEditingController billOTRateController = TextEditingController();
  //section 5
  TextEditingController disciplineIdController = TextEditingController();
  TextEditingController disciplineNameController = TextEditingController();
  TextEditingController overrideBillModifiersController = TextEditingController();
  TextEditingController overridePayModifiersController = TextEditingController();
  //section 6
  TextEditingController payDblPlusRateController = TextEditingController();
  TextEditingController payDblRateController = TextEditingController();
  TextEditingController payHolidayPlusRateController = TextEditingController();
  TextEditingController payHolidayRateController = TextEditingController();
  //section 7
  TextEditingController payMaxPlusRateController = TextEditingController();
  TextEditingController payMaxRateController = TextEditingController();
  TextEditingController payOTPlusRateController = TextEditingController();
  TextEditingController payOTRateController = TextEditingController();
  //section 8
  TextEditingController departmentNameController = TextEditingController();



  int? orderId;
  Future<void> getWorkOrderMapX() async {
    await getWorkOrderMap();

  }

  Future<void> getWorkOrderMap() async {
    debugPrint('line 57 get client : $orderId' );

    Map<String, dynamic>? wrk = await workOrderServices.getWorkOrder(orderId!);
    debugPrint('line 74: ${wrk!['dates']}');
    //section 1
    orderIdController.text = wrk!['orderId'].toString();
    clientNameController.text = wrk['clientName'];
    rateGroupIdController.text = wrk['dates']['rates']['rateGroupId'].toString();
    rateIdController.text = wrk['dates']['rates']['rateId'].toString();
    //section 2

    shiftDateController.text = wrk['shiftDate'];
    shiftCodeController.text = wrk['dates']['shiftDateInfo']['shiftCode'].toString();
    startTimeController.text = wrk['dates']['shiftDateInfo']['startTime'];
    endTimeController.text = wrk['dates']['shiftDateInfo']['endTime'];
    //section 3
    billDblPlusRateController.text = wrk['dates']['rates']['billMaxPlusRate'] == null ? "" : wrk['dates']['rates']['billMaxPlusRate'].toString();
    billDblRateController.text = wrk['dates']['rates']['billDblRate'] == null ? "" : wrk['dates']['rates']['billDblRate'].toString();
    billHolidayPlusRateController.text = wrk['dates']['rates']['billHolidayPlusRate'] == null ? "" : wrk['dates']['rates']['billHolidayPlusRate'].toString();
    billHolidayRateController.text = wrk['dates']['rates']['billHolidayRate'] == null ? "" : wrk['dates']['rates']['billHolidayRate'].toString();
   //section 4
    billMaxPlusRateController.text = wrk['dates']['rates']['billMaxPlusRate'] == null ? "" : wrk['dates']['rates']['billMaxPlusRate'].toString();
    billMaxRateController.text = wrk['dates']['rates']['billMaxRate'] == null ? "" : wrk['dates']['rates']['billMaxRate'].toString();
    billOTPlusRateController.text = wrk['dates']['rates']['billOTPlusRate'] == null ? "" : wrk['dates']['rates']['billOTPlusRate'].toString();
    billOTRateController.text = wrk['dates']['rates']['billOTRate'] == null ? "" : wrk['dates']['rates']['billOTRate'].toString();
    //section 5
    disciplineIdController.text = wrk['dates']['rates']['disciplineId'].toString();
    disciplineNameController.text = wrk['dates']['rates']['disciplineName'];
    overrideBillModifiersController.text = wrk['dates']['rates']['overrideBillModifiers'] == null ? 'false' :
    wrk['dates']['rates']['overrideBillModifiers'].toString();
    overrideBillModifiersController.text = wrk['dates']['rates']['overridePayModifiers'] == null ? 'false' :
    wrk['dates']['rates']['overridePayModifiers'].toString();
    //section 6
    payDblPlusRateController.text = wrk['dates']['rates']['payMaxPlusRate'] == null ? "" : wrk['dates']['rates']['payMaxPlusRate'].toString();
    payDblRateController.text = wrk['dates']['rates']['payDblRate'] == null ? "" : wrk['dates']['rates']['payDblRate'].toString();
    payHolidayPlusRateController.text = wrk['dates']['rates']['payHolidayPlusRate'] == null ? "" : wrk['dates']['rates']['payHolidayPlusRate'].toString();
    payHolidayRateController.text = wrk['dates']['rates']['payHolidayRate'] == null ? "" : wrk['dates']['rates']['payHolidayRate'].toString();

    //section 7
    payMaxPlusRateController.text = wrk['dates']['rates']['payMaxPlusRate'] == null ? "" : wrk['dates']['rates']['payMaxPlusRate'].toString();
    payMaxRateController.text = wrk['dates']['rates']['payMaxRate'] == null ? "" : wrk['dates']['rates']['payMaxRate'].toString();
    payOTPlusRateController.text = wrk['dates']['rates']['payOTPlusRate'] == null ? "" : wrk['dates']['rates']['payOTPlusRate'].toString();
    payOTRateController.text = wrk['dates']['rates']['payOTRate'] == null ? "" : wrk['dates']['rates']['payOTRate'].toString();
    //section 8
    departmentNameController.text = wrk['dates']['rates']['departmentName'];

    debugPrint('line 87: exiting get workorder map $wrk');
  }

  @override
  void dispose() {
    super.dispose();
    //section 1
    orderIdController.dispose();
    clientNameController.dispose();
    rateGroupIdController.dispose();
    rateIdController.dispose();
    //section 2
    shiftDateController.dispose();
    shiftCodeController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    //section 3
    billDblPlusRateController.dispose();
    billDblRateController.dispose();
    billHolidayPlusRateController.dispose();
    billHolidayRateController.dispose();
    //section 4
    billMaxPlusRateController.dispose();
    billMaxRateController.dispose();
    billOTPlusRateController.dispose();
    billOTRateController.dispose();
    //section 5
    disciplineIdController.dispose();
    disciplineNameController.dispose();
    overrideBillModifiersController.dispose();
    overridePayModifiersController.dispose();
    //section 6
    payDblPlusRateController.dispose();
    payDblRateController.dispose();
    payHolidayPlusRateController.dispose();
    payHolidayRateController.dispose();
    //section 7
    payMaxPlusRateController.dispose();
    payMaxRateController.dispose();
    payOTPlusRateController.dispose();
    payOTRateController.dispose();
    //section 8
    departmentNameController.dispose();

  }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    debugPrint('line 113 ${arguments!}');
    orderId = int.parse(arguments!['workOrderId'].toString());
    localTitle = 'WorkOrder Rate Data';
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
    final title = 'WorkOrder Rate Data Form ';
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
                            controller: rateGroupIdController,
                            maxLength: 5,
                            decoration:
                            InputDecoration(label: Text('Rate Group Id')),
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
                            controller: rateIdController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Rate Id')),
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

                            controller: shiftDateController,
                            maxLength: 12,
                            decoration:
                            InputDecoration(label: Text('Shift Date')),
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
                            controller: shiftCodeController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('Shift')),
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
                            controller: billDblPlusRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Bill Dbl Plus')),
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
                            controller: billDblRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Bill Dbl')),
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
                            controller: billHolidayPlusRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Bill Holiday Plus')),
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
                            controller: billHolidayRateController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Bill Holiday')),
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
                            controller: billMaxPlusRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Bill Max Plus')),
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
                            controller: billMaxRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Bill Max')),
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
                            controller: billOTPlusRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Bill OT Plus')),
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
                            controller: billOTRateController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Bill OT')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //section 5
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: disciplineIdController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Disc Id')),
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
                            controller: disciplineNameController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Disc')),
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
                            controller: overrideBillModifiersController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Override Bill')),
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
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Override Pay')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),

                //section 6
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: payDblPlusRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Pay Dbl Plus')),
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
                            controller: payDblRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Pay Dbl')),
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
                            controller: payHolidayPlusRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Pay Holiday Plus')),
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
                            controller: payHolidayRateController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Pay Holiday')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //section 7
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            controller: payMaxPlusRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Pay Max Plus')),
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
                            controller: payMaxRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Pay Max')),
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
                            controller: payOTPlusRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Pay OT Plus')),
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
                            InputDecoration(label: Text('Pay OT')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
              //section 8
              // IntrinsicHeight(
              // child: Row(
              // children: [
              // Container(
              //   padding: EdgeInsets.only(left: 10),
              //   height: 50,
              //   width: 300,
              //   child: TextFormField(
              //   controller: departmentNameController,
              //   maxLength: 20,
              //   decoration:
              //   InputDecoration(label: Text('Department Name')),
              //   validator: (value) {
              //   return null;
              //   }),
              //    ),
              // ],),),
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
            ),
        ),
      ),
    );
  }
}
