//Client Approve Shifts Scheduling Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/hcpapp/services/hcp_timecard_service.dart';
import 'package:flutter/material.dart';
import 'package:cms_web/features/clientapp/services/client_work_order_campaign_service.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/clientapp/models/client_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/services/utility_services.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ClientMitigateOTSchedulingPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientMitigateOTSchedulingPage({super.key, required this.args});

  @override
  State<ClientMitigateOTSchedulingPage> createState() =>
      _ClientMitigateOTSchedulingPageState();
}

class _ClientMitigateOTSchedulingPageState
    extends State<ClientMitigateOTSchedulingPage> {
  AuthService authService = AuthService();

  late dynamic currentUser;

  late int? clientId;
  late String? startWorkDay;
  Future<List<dynamic>>? listHCPs;
  ClientUser? clientUser;
  List<Map<String, dynamic>>? allItemsTemp;

  late List<Map<String, dynamic>> allItems;
  late ClientWorkOrderCampaignService clw = ClientWorkOrderCampaignService();
  late HCPTimeCardService htc = HCPTimeCardService();

  String? email;

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> _showActionDialog(
      BuildContext context, String title, String? description) async {
    print('line 49 showdialog');
// Future.delayed(Duration(seconds: 3), () {
//   Navigator.of(context).pop(); // Close the dialog
// });
    return showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description!),
          contentTextStyle: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          titleTextStyle: TextStyle(
              color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
          actions: <Widget>[
// TextButton(
//   onPressed: () => Navigator.pop(context, 'Cancel'),
//   child: const Text('Cancel'),
// ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      elevation: 2,
                      backgroundColor: Colors.amber),
                  onPressed: () => Navigator.of(context).pop('Cancel'),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      elevation: 2,
                      backgroundColor: Colors.amber),
                  onPressed: () => Navigator.of(context).pop('Mitigate OT'),
                  child: Text(
                    'Mitigate OT',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>>? otDates;
  Future<List<Map<String, dynamic>>> getAllItems() async {
    List<Map<String, dynamic>>? allItemsTemp =
        await clw.getWorkOrderCampaignsShiftsWithRequiredOT(clientId!);
    return allItemsTemp!;
  }

  void setUpAsyncVariables(int clientId, BuildContext context,
      ClientWorkOrderCampaignService clw, HCPTimeCardService htc) async {
    try {
// allItems = await clw.getWorkOrderCampaignsApproved(clientId);

      listHCPs = htc.getRelatedHCPTimeCards(clientId);
      if (listHCPs == null) {
        throw Exception('No time cards available');
      }
    } catch (e) {
      print('line 114: $e');
      throw Exception(e.toString());
    }
  }

  bool? isShiftApproved = false;
  Map<String, dynamic>? arguments;
  Map<String, dynamic>? clientMap;
  String? userEmail;
  @override
  void initState() {
    super.initState();

    arguments = widget.args;
    arguments = widget.args;
    clientId = arguments!['clientId'];
    clientMap = authService.clientMap!;
    startWorkDay = clientMap!['startWeekDay'];
    userEmail = clientMap!['email'];
    clw = ClientWorkOrderCampaignService();
    htc = HCPTimeCardService();

    print('line 39:  $clw');
  }

  void onButtonPressed(Map<String, dynamic> item, BuildContext ctx) async {
    print(
        'line 91 in onButtonPressed: ${item['shiftDate']} ${item['shiftCode']}');

    try {
      var response = '';
      response = await _showActionDialog(context, "Overtime Mitigation Actions",
          'This shift would result in the employee having OT. Do you wish to mitigate the OT payment? ');
      print('line 169: $response');
      if (response == 'OK') {
        bool bl = await clw.updateClientMitigateOTForShift(item['id']);
        Navigator.of(context)
            .pushNamed(clientSchedulingMenu, arguments: arguments!);
      } else if (response == 'Cancel') {
        return;
      }
      ;
    } catch (e) {
      print('line 129 error: $e');
      throw Exception(e.toString());
    }
  }

  double? screenWidth;
  double? screenHeight;
  double fontSize = 16;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 16;
    fontSize /= h;

    print('line 128 in showaccepted ashifts $screenWidth $screenHeight');
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Stops widgets from being moved by keyboard
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("OT Shift Mitigation",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            )),
        leading: GestureDetector(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 24,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(clientSchedulingMenu, arguments: arguments!);
            },
          ),
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: Future.wait([
            getAllItems(),
          ]),
          builder: (context, snapshot) {
            print(
                'line 129: ${snapshot.data}  ${snapshot.connectionState} ${snapshot.hasData}');
            double screenWidth = MediaQuery.sizeOf(context).width;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  height: 110,
                  width: screenWidth - 10,
                  child: SizedBox(
                      height: 10,
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize! /
                                  h!,
                              color: Colors.red,
                              fontWeight: FontWeight.bold))),
                ),
              );
            } else if (snapshot.data == [[]] &&
                snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    height: 110,
                    width: screenWidth - 10,
                    child: Text(
                        'There are no mobile shifts for mitigation for this client.',
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize! /
                                h!,
                            color: color2,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            } else {
              allItems = snapshot.data[0]; // cast to List<Marker>
              print('line 111 ${allItems.length}');
              if (allItems.length == 0) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Container(
                      height: 110,
                      width: screenWidth - 10,
                      child: Text(
                          'There are no accepted mobile shifts for mitigation for this client.',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize! /
                                  h!,
                              color: color2,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              } else {
                return LayoutBuilder(builder: (context, constraints) {
                  if (screenWidth <= 400) {
                    fontSize = 16;
                  } else if (screenWidth > 400 && screenWidth < 960) {
                    fontSize = 20;
                  } else {
                    fontSize = 24;
                  }
                  fontSize /= h!;
                  return ListView.builder(
                    restorationId: 'ClientCampaignListView',
                    itemCount: allItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = allItems[index];
                      return item['shiftStatus'] == 'Accepted'
                          ? ClientCampaignTile(
                              itemm: item,
                              fontSize: fontSize,
                              ctx: context,
                              onButtonPressed: onButtonPressed)
                          : item['shiftStatus'] == 'Accepted'
                              ? ClientCampaignTile1(
                                  itemm: item,
                                  fontSize: fontSize,
                                  ctx: context,
                                  onButtonPressed: onButtonPressed)
                              : Container();
                    },
                  );
                });
              }
            }
          }),
    );
  }
}

class ClientCampaignTile extends StatefulWidget {
  final Map<String, dynamic> itemm;
  final double fontSize;
  final BuildContext ctx;
  final void Function(Map<String, dynamic>, BuildContext) onButtonPressed;

  ClientCampaignTile(
      {required this.itemm,
      required this.fontSize,
      required this.ctx,
      required this.onButtonPressed});

  @override
  State<ClientCampaignTile> createState() => _ClientCampaignTileState();
}

class _ClientCampaignTileState extends State<ClientCampaignTile> {
  _ClientCampaignTileState();

  late Map<String, dynamic> item;
  late double fontSize;
  late BuildContext ctx;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  UtilitiesServices utilitiesServices = UtilitiesServices();

  @override
  initState() {
    super.initState();
    item = widget.itemm;
    fontSize = widget.fontSize;
    ctx = widget.ctx;
  }

  String getOvertimeFlag(bool? requiresOvertime) {
    if (requiresOvertime == null || requiresOvertime == true) {
      return "Yes";
    }
    return "No";
  }

  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dte);
    return formatted;
  }

  String getOvertimeString(bool? value) {
    print('line 450: $value');
    String str = 'No';
    if (value == null) {
      return str;
    }
    if (value == true) {
      str = 'Yes';
    }
    print('line 457: $str');
    return str;
  }

  String getShiftHoursAsString(dynamic value) {
    if (value == null) {
      return '0.00';
    }
    double val = double.parse(value.toString());
    String str = val.toStringAsFixed(2);
    print('line 466: $str');
    return str;
  }

  String _convertFromTimestamp(Timestamp? t) {
    if (t == null) {
      DateTime d = new DateTime(1970, 1, 1);
      int itt = d.millisecondsSinceEpoch;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(itt);
      String ss = getFormattedDate(dateTime);
      return ss;
    }
    DateTime date = t.toDate();
    String s = getFormattedDate(date);
    return s;
  }

  bool isShiftApproved = false;
  DateFormat formatter = DateFormat('MM-dd-yyyy');
  double? screenWidth;
  double? screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 16;
    fontSize /= h;
    double height = 290; // * (screenHeight! / 800);
    print('line 98 in tile building');
    return Container(
      width: screenWidth! - 10,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(color: Color.fromARGB(255, 19, 125, 103), width: 4),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Date: ${_convertFromTimestamp(item['shiftDate'])}',
                style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
// SizedBox(width:5),
// Text('${item['dayValue']}',
//     style: TextStyle(
//       color:Colors.black87,
//       fontWeight: FontWeight.bold,
//       fontSize: fontSize,
//     )
// ),
              SizedBox(width: 20),
              Text('Shift: ${item['shiftCode']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(children: [
            Text('Discipline: ',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
            Text('${item['disciplineName']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
            SizedBox(width: 12),
            Text('Rate: ',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
            Text('\$${item['billRate'].toStringAsPrecision(2)}',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize)),
          ]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//   Text('Id: ${item['hcpId']} - ',
//       style: TextStyle(
//         color: Colors.black87,
//         fontWeight: FontWeight.bold,
//         fontSize: fontSize,
//       )
//   ),
//   SizedBox(width: 5),
            Text('${item['hcpName']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text('Start: ${item['startTime']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
            SizedBox(width: 12),
            Text('End: ${item['endTime']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text('Decimal Hours: ${item['decimalHours'].toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
            SizedBox(width: 12),
            Text('Meals: ${item['meals'].toString()}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ]),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: (screenWidth! - 16) / 2,
                child: Text(
                    'Prior Hours: ' +
                        getShiftHoursAsString(item['shiftPriorHours']),
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
              SizedBox(width: 4),
              Container(
                height: 20,
                width: (screenWidth! - 16) / 2,
                child: Text('OT: ' + getOvertimeString(item['shiftOvertime']),
                    style: TextStyle(
                      color: item['shiftOvertime'] == false
                          ? Colors.black87
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
            ],
          ),

// Container(
//   height: 32,
//   width: screenWidth! - 10,
//   child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//     Container(
//       height: 32,
//       child: Text(
//         'Hours/Minutes: ${utilitiesServices.getHours(item['startTime'], item['endTime'], item['meals']).toStringAsPrecision((2))}',
//         style: TextStyle(
//           color: Colors.black87,
//           fontWeight: FontWeight.bold,
//           fontSize: fontSize,
//         ),
//       ),
//     ),
//     SizedBox(width: 12),
//     Container(
//       height: 32,
//       child: Text(
//           'Overtime: ${getOvertimeFlag(item['requiresOvertime'])} ',
//           style: TextStyle(
//             color: item['requiresOvertime'] == true
//                 ? Colors.red
//                 : Colors.black87,
//             fontWeight: FontWeight.bold,
//             fontSize: fontSize,
//           )),
//     ),
//   ]),
// ),
// SizedBox(height: 12),
          item['shiftStatus'] == "Accepted"
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 130,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromARGB(255, 19, 125, 103),
                              width: 3,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextButton(
                          onPressed: () {
                            item['actionType'] = 'Approve';
                            widget.onButtonPressed(item, ctx);
                          },
                          child: isShiftApproved == false
                              ? Text(
                                  'Approve',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 19, 125, 103),
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .fontSize! /
                                        h,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Approve',
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .fontSize! /
                                        h,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        height: 50,
                        width: 130,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromARGB(255, 19, 125, 103),
                              width: 3,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextButton(
                          onPressed: () {
                            item['actionType'] = 'Decline';
                            widget.onButtonPressed(item, ctx);
                          },
                          child: isShiftApproved == false
                              ? Text(
                                  'Decline',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 19, 125, 103),
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .fontSize! /
                                        h,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Decline',
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .fontSize! /
                                        h,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromARGB(255, 19, 125, 103),
                            width: 3,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          'Awaiting Confirmation',
                          style: TextStyle(
                            color: Color.fromARGB(255, 19, 125, 103),
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize! /
                                h,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                ),
        ],
      ),
    );
  }
}

class ClientCampaignTile1 extends StatefulWidget {
  final Map<String, dynamic> itemm;
  final double fontSize;
  final BuildContext ctx;
  final void Function(Map<String, dynamic>, BuildContext) onButtonPressed;

  ClientCampaignTile1(
      {required this.itemm,
      required this.fontSize,
      required this.ctx,
      required this.onButtonPressed});

  @override
  State<ClientCampaignTile1> createState() => _ClientCampaignTile1State();
}

class _ClientCampaignTile1State extends State<ClientCampaignTile1> {
  _ClientCampaignTile1State();

  late Map<String, dynamic> item;
  late double fontSize;
  late BuildContext ctx;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  UtilitiesServices utilitiesServices = UtilitiesServices();

  @override
  initState() {
    super.initState();
    item = widget.itemm;
    fontSize = widget.fontSize;
    ctx = widget.ctx;
  }

  String getOvertimeFlag(bool? requiresOvertime) {
    if (requiresOvertime == null) {
      return "No";
    }
    if (requiresOvertime == false) {
      return "No";
    }
    return "Yes";
  }

  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dte);
    return formatted;
  }

  String _convertFromTimestamp(Timestamp? t) {
    if (t == null) {
      DateTime d = new DateTime(1970, 1, 1);
      int itt = d.millisecondsSinceEpoch;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(itt);
      String ss = getFormattedDate(dateTime);
      return ss;
    }
    DateTime date = t.toDate();
    String s = getFormattedDate(date);
    return s;
  }

  bool isShiftApproved = false;
  DateFormat formatter = DateFormat('MM-dd-yyyy');
  double? screenWidth;
  double? screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 16;
    fontSize /= h;
    double height = 200; // * (screenHeight! / 800);
    print('line 98 in tile building');
    return Container(
      width: screenWidth! - 10,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(color: Color.fromARGB(255, 19, 125, 103), width: 4),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: screenWidth! - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Date: ${_convertFromTimestamp(item['shiftDate'])}',
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
// SizedBox(width:5),
// Text('${item['dayValue']}',
//     style: TextStyle(
//       color:Colors.black87,
//       fontWeight: FontWeight.bold,
//       fontSize: fontSize,
//     )
// ),
                SizedBox(width: 20),
                Text('Shift: ${item['shiftCode']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 24,
            width: screenWidth! - 10,
            child: Row(children: [
              Text('Discipline: ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
              Text('${item['disciplineName']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
//   SizedBox(width: 12),
//   Text('Rate: ',
//       style: TextStyle(
//         color: Colors.black87,
//         fontWeight: FontWeight.bold,
//         fontSize: fontSize,
//       )),
//   Text('\$${item['billRate'].toStringAsPrecision(2)}',
//       style: TextStyle(
//           color: Colors.red,
//           fontWeight: FontWeight.bold,
//           fontSize: fontSize)),
            ]),
          ),
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth! - 10,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text('Employee: ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
              SizedBox(width: 5),
              Text('${item['hcpName']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
            ]),
          ),
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth! - 10,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text('Start: ${item['startTime']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
              SizedBox(width: 12),
              Text('End: ${item['endTime']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
            ]),
          ),
          SizedBox(height: 5),
          Center(
            child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.red,
                      width: 3,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    'Awaiting Confirmation',
                    style: TextStyle(
                      color: Color.fromARGB(255, 19, 125, 103),
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize! / h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
