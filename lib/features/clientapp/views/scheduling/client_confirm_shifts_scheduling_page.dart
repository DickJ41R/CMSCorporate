import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/authentication//services/auth_service.dart';
import 'package:cms_web/features/clientapp/models/client_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ClientConfirmShiftsSchedulingPages extends StatefulWidget {
  final Map<String, dynamic> args;
  ClientConfirmShiftsSchedulingPages({super.key, required this.args});

  @override
  _ClientConfirmShiftsSchedulingPagesState createState() =>
      _ClientConfirmShiftsSchedulingPagesState();
}

class _ClientConfirmShiftsSchedulingPagesState
    extends State<ClientConfirmShiftsSchedulingPages> {
  AuthService authService = AuthService();

  late dynamic currentUser;

  late int? clientId;
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

  Future<List<Map<String, dynamic>>> getAllItems() async {
    allItemsTemp = await clw.getWorkOrderCampaignsConfirmed(clientId!);
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
      debugPrint('line 114: $e');
      throw Exception(e.toString());
    }
  }

  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    clw = ClientWorkOrderCampaignService();
    htc = HCPTimeCardService();
    clientId = arguments!['clientId'];
    debugPrint('line 39: $currentUser $clw');
    // clientUser = ref.read(clientUserNotifierProvider.notifier).fromClientUser;
    // try {
    //   setUpAsyncVariables(clientId!,context,clw,htc);
    //   debugPrint('ine 49: $clientId');
    // } catch(e) {
    //   debugPrint('line 133 error: $e');
    //
    // }
  }

  bool? isShiftApproved = false;
  void onButtonPressed(Map<String, dynamic> item, BuildContext ctx) async {
    debugPrint(
        'line 91 in onButtonPressed: ${item['shiftDate']} ${item['shiftCode']}');

    try {
      String shiftApprover = clientUser!.firstName + ' ' + clientUser!.lastName;
      isShiftApproved = await clw.updateClientWorkOrderCampaignApproved(
          item, shiftApprover, ctx);
    } catch (e) {
      debugPrint('line 129 error: $e');
      throw Exception(e.toString());
    }
  }

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 18;
    fontSize /= h;
    debugPrint('line 99 in showaccepted ashifts');
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Stops widgets from being moved by keyboard
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("Confirmed Shifts",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              color: color2,
            )),
        leading: GestureDetector(
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(clientSchedulingMenu, arguments: arguments!);
              }),
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: getAllItems(),
          builder: (context, snapshot) {
            debugPrint(
                'line 129: ${snapshot.data}  ${snapshot.connectionState} ${snapshot.hasData}');
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
                  width: screenWidth! - 10,
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .fontSize! /
                              h!,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else if (snapshot.data == [[]] &&
                snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Container(
                  height: 110,
                  width: screenWidth! - 10,
                  child: Text(
                      'There are no HCP confirmed shifts for this client.',
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .fontSize! /
                              h!,
                          color: color2,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else {
              // if (!snapshot.hasData ||
              //     snapshot.connectionState ==
              //         ConnectionState.waiting) {
              //   return const SizedBox(
              //       height: 50,
              //       width: 50,
              //       child:
              //       Center(child: CircularProgressIndicator()));
              // }
              allItems = snapshot.data; // cast to List<Marker>
              debugPrint('line 111 ${allItems.length}');
              if (allItems.length == 0) {
                return Center(
                  child: Container(
                    height: 110,
                    width: screenWidth! - 10,
                    child: Text(
                        'There are no HCP confirmed shifts for this client.',
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .fontSize! /
                                h!,
                            color: color2,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              } else {
                return LayoutBuilder(builder: (context, constraints) {
                  if (screenWidth! <= 480) {
                    fontSize = 18;
                  } else if (screenWidth! > 480 && screenWidth! < 960) {
                    fontSize = 24;
                  } else {
                    fontSize = 30;
                  }
                  fontSize /= h!;
                  return ListView.builder(
                    restorationId: 'ClientCampaignListView',
                    itemCount: allItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = allItems[index];
                      return ClientCampaignTile(
                          itemm: item,
                          fontSize: fontSize,
                          ctx: context,
                          onButtonPressed: onButtonPressed);
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

  const ClientCampaignTile(
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
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double h = 1.0;

  @override
  initState() {
    super.initState();
    item = widget.itemm;
    fontSize = widget.fontSize;
  }

  String _convertFromTimestamp(Timestamp? t) {
    if (t == null) {
      DateTime d = new DateTime(1900, 1, 1);
      int itt = d.millisecondsSinceEpoch;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(itt);
      String ss = getFormattedDate(dateTime);
      return ss;
    }
    DateTime date = t.toDate();
    String s = getFormattedDate(date);
    return s;
  }

  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dte);
    return formatted;
  }

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

    debugPrint('line 98 in tile building');
    return Container(
      width: screenWidth! - 10,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color2, width: 4),
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
                style: TextStyle(fontSize: fontSize, color: Colors.black),
              ),
              // SizedBox(width: 5),
              // Text('${item['dayValue']}',
              //     style: TextStyle(
              //       color: Colors.black87,
              //       fontWeight: FontWeight.bold,
              //       fontSize: fontSize,
              //     )
              // ),
              SizedBox(width: 12),
              Text('Shift: ${item['shiftCode']}',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize)),
            ],
          ),
          SizedBox(width: 10),
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
            SizedBox(width: 5),
            Text('\$${item['billRate'].toStringAsPrecision(2)}',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ]),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            // Text('Id: ${item['hcpId']}',
            //     style: TextStyle(
            //       color: Color.fromARGB(255, 19, 125, 103),
            //       fontWeight: FontWeight.bold,
            //       fontSize: fontSize,
            //     )),
            // SizedBox(width: 5),
            Text('${item['hcpName']} - ',
                style: TextStyle(
                  color: Color.fromARGB(255, 19, 125, 103),
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
            Text('Hours: ${item['decimalHours'].toStringAsFixed(2)}',
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
        ],
      ),
    );
  }
}
