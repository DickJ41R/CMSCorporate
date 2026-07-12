//workOrder Profile Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/workorderapp/workorder_services.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class WorkOrderRateDetailsDataPage extends StatefulWidget {
  final Map<String, String> args;
  const WorkOrderRateDetailsDataPage({super.key, required this.args});

  @override
  State<WorkOrderRateDetailsDataPage> createState() => _WorkOrderRateDetailsDataPageState();
}

class _WorkOrderRateDetailsDataPageState extends State<WorkOrderRateDetailsDataPage> {
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
  TextEditingController rateGroupIdController = TextEditingController();
  TextEditingController rateIdController = TextEditingController();
  //section 2
  TextEditingController shiftDateController = TextEditingController();
  TextEditingController shiftCodeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  //section 3
  TextEditingController shiftCodeCodeIdController = TextEditingController();
  TextEditingController shiftCodeDescController = TextEditingController();
  TextEditingController shiftCountController = TextEditingController();
  TextEditingController calcTypeController = TextEditingController();
  //Section 4
  TextEditingController hourController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController isAHolidayController = TextEditingController();
  TextEditingController isAWeekendController = TextEditingController();
  //Section 5
  TextEditingController billRateController = TextEditingController();
  TextEditingController billRateWEController = TextEditingController();
  TextEditingController payRateController = TextEditingController();
  TextEditingController payRateWEController = TextEditingController();
  //Section 6
  TextEditingController marginController = TextEditingController();
  TextEditingController marginWEController = TextEditingController();
  TextEditingController mealsController = TextEditingController();



  int? orderId;
  Future<void> getWorkOrderMapX() async {
    await getWorkOrderMap();

  }

  Future<void> getWorkOrderMap() async {
    debugPrint('line 57 get client : $orderId');

    Map<String, dynamic>? wrk = await workOrderServices.getWorkOrder(orderId!);
    //   debugPrint('line 177: ${cli!}');
    debugPrint('line 68: ${wrk!['dates']['rates']['rateDetails']['shiftCodeCodeId']}');
    //section 1
    orderIdController.text = wrk['orderId'].toString();
    clientNameController.text = wrk['clientName'];
    rateGroupIdController.text = wrk['dates']['rates']['rateGroupId'].toString();
    rateIdController.text = wrk['dates']['rates']['rateId'].toString();
    //section 2

    shiftDateController.text = wrk['shiftDate'];
    shiftCodeController.text = wrk['dates']['shiftDateInfo']['shiftCode'].toString();
    startTimeController.text = wrk['dates']['shiftDateInfo']['startTime'];
    endTimeController.text = wrk['dates']['shiftDateInfo']['endTime'];
     //section 3
    shiftCodeCodeIdController.text = wrk['dates']['rates']['rateDetails']['shiftCodeCodeId'].toString();
    shiftCodeDescController.text =  wrk['dates']['rates']['rateDetails']['shiftCodeDesc'];
    shiftCountController.text = wrk['dates']['rates']['rateDetails']['shiftCount'].toString();
    calcTypeController.text =  wrk['dates']['rates']['rateDetails']['calcType'];
    //section 4
    hourController.text = wrk['dates']['rates']['rateDetails']['hour'];
    hoursController.text = wrk['dates']['rates']['rateDetails']['hours'];
    isAHolidayController.text = wrk['dates']['rates']['rateDetails']['isAHoliday'] == false ? 'false' : 'true';
    isAWeekendController.text = wrk['dates']['rates']['rateDetails']['isAWeekend'] == false ? 'false' : 'true';
    //section 5
    billRateController.text = wrk['dates']['rates']['rateDetails']['billRate'].toString();
    billRateWEController.text = wrk['dates']['rates']['rateDetails']['billRateWE'].toString();
    payRateController.text =  wrk['dates']['rates']['rateDetails']['payRate'].toString();
    payRateWEController.text = wrk['dates']['rates']['rateDetails']['payRateWE'].toString();
    //section 6
    marginController.text = wrk['dates']['rates']['rateDetails']['margin'].toStringAsFixed(2);
    marginWEController.text  = wrk['dates']['rates']['rateDetails']['marginWE'].toStringAsFixed(2);
    mealsController.text = wrk['dates']['rates']['rateDetails']['meals'].toString();

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
    shiftCodeCodeIdController.dispose();
    shiftCodeDescController.dispose();
    shiftCountController.dispose();
    calcTypeController.dispose();
    //Section 4
    hourController.dispose();
    hoursController.dispose();
    isAHolidayController.dispose();
    isAWeekendController.dispose();
    //Section 5
    billRateController.dispose();
    billRateWEController.dispose();
    payRateController.dispose();
    payRateWEController.dispose();
    //Section 6
    marginController.dispose();
    marginWEController.dispose();
    mealsController.dispose();

  }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    debugPrint('line 113 ${arguments!}');
    orderId = int.parse(arguments!['workOrderId'].toString());

    localTitle = 'WorkOrder Rate Details';
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
    final title = 'WorkOrder Rate Details Form ';
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
                            style: TextStyle(
                              fontSize: smallFontSize,
                            ),
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
                SizedBox(width: 10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 50,
                        width: 300,
                        child: TextFormField(
                            style: TextStyle(
                              fontSize: smallFontSize,
                            ),
                            controller: shiftCodeCodeIdController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Shift Code Id')),
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
                            controller: shiftCodeDescController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('Shift Desc')),
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
                            maxLength: 40,
                            decoration: InputDecoration(
                                label: Text('Shift Count')),
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
                            controller: calcTypeController,
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Calc Type')),
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
                            controller: hourController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Hour')),
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
                            controller: hoursController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Hours')),
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
                            controller: isAHolidayController,
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
                            controller: isAWeekendController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Weekend')),
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
                            controller: billRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Bill Rate')),
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
                            controller: billRateWEController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Bill Rate WE')),
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
                            controller: payRateController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Pay Rate')),
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
                            controller: payRateWEController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Pay Rate WE')),
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
                            controller: marginController,
                            maxLength: 20,
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
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Margin WE')),
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
                            controller: mealsController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Meals')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),


                SizedBox(width: 10),
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
