//workOrder Profile Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/workorderapp/workorder_services.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'package:flutter/services.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class WorkOrderProfilePage extends StatefulWidget {
  final Map<String, dynamic> args;
  const WorkOrderProfilePage({super.key, required this.args});

  @override
  State<WorkOrderProfilePage> createState() => _WorkOrderProfilePageState();
}

class _WorkOrderProfilePageState extends State<WorkOrderProfilePage> {
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
  TextEditingController branchNameController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController hcpNameController =  TextEditingController();
  TextEditingController disciplineNameController = TextEditingController();
  TextEditingController statusIdController = TextEditingController();
  TextEditingController orientationController = TextEditingController();
  TextEditingController schedulerNameController = TextEditingController();
  TextEditingController rateTypeController = TextEditingController();
  TextEditingController shiftCanceledController = TextEditingController();
  TextEditingController shiftCanceledActionDateController = TextEditingController();
  TextEditingController shiftCanceledByNameController = TextEditingController();
  TextEditingController shiftDateController = TextEditingController();
  TextEditingController shiftDateTimeController = TextEditingController();


  int? orderId;

  Future<void> getWorkOrderMap() async {
    debugPrint('line 57 get client : $orderId');
    List<Map<String, dynamic>>? listWorkOrders;
    Map<String, dynamic>? wrk = await workOrderServices.getWorkOrder(orderId!);
    //   debugPrint('line 177: ${cli!}');
    orderIdController.text = wrk!['orderId'].toString();
    clientNameController.text = wrk['clientName'];
    branchNameController.text = wrk['branchName'];
    departmentNameController.text =wrk['departmentName'];
    disciplineNameController.text = wrk['disciplineName'];
    hcpNameController.text = wrk['disciplineName'];
    statusIdController.text = wrk['statusId'];
    orientationController.text = wrk['orientation'] == false ? 'false' : 'true';
    rateTypeController.text = wrk['rateType'];
    schedulerNameController.text =
    wrk['schedulerName'] == null ? "" : wrk['schedulerName'];
    statusIdController.text = wrk['statusId'];
    shiftCanceledController.text = wrk['canceledBy']  == false ? 'false' : 'true';
    shiftCanceledByNameController.text = wrk['shiftCanceledByName'].toString();
    shiftDateController.text = workOrderServices.getFormattedDate(wrk['shiftDate']);
    Timestamp sdts = wrk['dates']['rates']['rateDetails']['shiftDate'];
    DateTime dts = sdts.toDate();
    String fdts = workOrderServices.getFormattedDate(dts);
    String shiftDateTime = workOrderServices.deriveShiftTime(wrk['dates']['rates']['rateDetails']['shiftCode'],
        wrk['dates']['rates']['rateDetails']['calcType'],
        wrk['dates']['rates']['rateDetails']['startTime'],
        wrk['dates']['rates']['rateDetails']['endTime'],
        wrk['dates']['rates']['rateDetails']['meals']);
    shiftDateTimeController.text = shiftDateTime;
        if (wrk['shitCanceledActionDate'] == null) {
          shiftCanceledActionDateController.text = '01/01/1970';
        } else {
          sdts = wrk['shitCanceledActionDate'];
          dts = sdts.toDate();
          fdts = workOrderServices.getFormattedDate(dts);
          shiftCanceledActionDateController.text = fdts;
        }

  }

  @override
  void dispose() {
    super.dispose();
    //section 1
    orderIdController.dispose();
    clientNameController.dispose();
    branchNameController.dispose();
    departmentNameController.dispose();
    hcpNameController.dispose();
    disciplineNameController.dispose();
    statusIdController.dispose();
    orientationController.dispose;
    schedulerNameController.dispose();
    rateTypeController.dispose();
    shiftCanceledController.dispose();
    shiftCanceledByNameController.dispose();
    shiftDateController.dispose();
    shiftDateTimeController.dispose();
    shiftCanceledActionDateController.dispose();
  }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    debugPrint('line 588: ${arguments!}');
    orderId = arguments!['orderId'];
    localTitle = 'WorkOrder Profile';
    debugPrint('line 72 arguments $arguments');
    getWorkOrderMap();
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
    final title = 'WorkOrder Profile Form ';
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
                            controller: branchNameController,
                            maxLength: 5,
                            decoration:
                            InputDecoration(label: Text('Branch Name')),
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
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Discipline')),
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
                            controller: departmentNameController,
                            maxLength: 200,
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
                            controller: hcpNameController,
                            maxLength: 100,
                            decoration: InputDecoration(
                                label: Text('HCP Name')),
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
                            controller: orientationController,
                            maxLength: 40,
                            decoration: InputDecoration(
                                label: Text('Orientation')),
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
                            maxLength: 10,
                            decoration: InputDecoration(
                                label: Text('Rate Type')),
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
                            controller: schedulerNameController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Scheduler Name')),
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
                            controller: shiftCanceledController,
                            maxLength: 20,
                            decoration:
                            InputDecoration(label: Text('Shift Canceled')),
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
                            controller: shiftCanceledActionDateController,
                            maxLength: 10,
                            decoration:
                            InputDecoration(label: Text('Shift Canceled Date')),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                ),
                //row 31
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
