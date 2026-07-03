import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ProcessHCPConfirmedShifts extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessHCPConfirmedShifts({super.key, required this.args});

  @override
  _ProcessHCPConfirmedShiftsState createState() =>
      _ProcessHCPConfirmedShiftsState();
}

class _ProcessHCPConfirmedShiftsState extends State<ProcessHCPConfirmedShifts> {
  _ProcessHCPConfirmedShiftsState();

  dynamic currentUser;
  AuthService authServices = AuthService();
  HCPTimeCardService hcpTimeCardService = HCPTimeCardService();
  HCPServices hcpServices = HCPServices();
  UtilitiesServices utilityServices = UtilitiesServices();
  ClientWorkOrderCampaignService clw = ClientWorkOrderCampaignService();
  int? hcpId;
  String? gEmail;
  int? clientId;
  bool haveAllItems = false;

  Future<List<Map<String, dynamic>>> _getAllApprovedConfirmedShifts() async {
    debugPrint('line 38 getAll approved shifts $hcpId');
    try {
      List<Map<String, dynamic>>? lm = await clw.getWorkOrderCampaignsApprovedConfirmed(
          hcpId!);
      debugPrint('line 41 in get all confirmed');
      if (lm == null) {
        return [];
      }
      return lm;
    } catch (e) {
      debugPrint('line 49 error in getapproved shifts: $e');
      throw Exception(e.toString());
    }
  }


  Future<bool> _showDialog(
      BuildContext context, String title, String? description) async {
    debugPrint('line 67 showdialog');
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.of(context).pop(); // Close the dialog
    // });
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color2,
                  fontWeight: FontWeight.bold,
                )),
            content: Container(
              height: 200,
              child: Text(description!,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: color2,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            contentTextStyle: TextStyle(
              color: color1,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            titleTextStyle: TextStyle(
                color: Color.fromARGB(255, 19, 125, 103),
                fontSize: fontSize,
                fontWeight: FontWeight.bold),
            actions: <Widget>[
              // TextButton(
              //   onPressed: () => Navigator.pop(context, 'Cancel'),
              //   child: const Text('Cancel'),
              // ),
              TextButton(
                onPressed: (() {
                  Navigator.pop(context, true);
                }),
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 125, 103)),
                ),
              ),
            ],
          );
        }).then((exit) {
      if (exit == null || exit == false) {
        return false;
      } else {
        return true;
      }
    });
  }

  void onButtonPressed(
      Map<String, dynamic> item, int el, BuildContext ctx) async {
    debugPrint(
        'line 41 in onButtonPressed: ${item['id']} ${item['shiftDate']} ${item['shiftCode']}');
    String statusText = "Confirmed";
    bool shiftConfirmed = true;
    if (el == 2) {
      statusText = 'Dismissed';
      shiftConfirmed = false;
    }
    try {
      DateTime currentDate = DateTime.now(); //DateTime
      Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
      item['shiftConfirmedActionDate'] = myTimeStamp;
      Timestamp? shiftAcceptedDate = item['shiftConfirmedActionDate'];
      item['shiftConfirmed'] = shiftConfirmed;
      Timestamp? shiftConfirmedDate = myTimeStamp;
      if (shiftConfirmed == true) {
        int mls = DateTime.now().millisecondsSinceEpoch;
        shiftConfirmedDate = Timestamp.fromDate(currentDate);
      }
      Map<String, dynamic> data = {
        "shiftStatus": statusText,
        "shiftStatusDate": myTimeStamp,
        "shiftConfirmed": shiftConfirmed,
        "shiftConfirmedActionDate": shiftConfirmedDate,
        'disciplineName': item['disciplineName']
      };
      String result = await clw.updateClientWorkOrderCampaignConfirmed(
          item, data, item['clientWorkOrderUuid'], ctx);
      debugPrint('line 158: $result');
      if (result.indexOf("ERROR") != -1) {
        await _showDialog(ctx, "Confirmation Error", result);
      } else {
        if (result.indexOf('Not Confirmed:') != -1) {
          await _showDialog(ctx, "Confirmation", result);
        } else {
          await _showDialog(
              ctx, "Confirmation", 'You have confirmed the shift.');
          if (result.indexOf("overtime") != -1) {
            //send email
            List<String> tos = [
              'jsturgill@consolidatedStaffing.com',
              'blee@consolidatedStaffing.com',
              'dickj41r@icloud.com'
            ];
            String from = 'noreply@consolidatedstaffing.com';
            String fromUserName = 'Support';
            String subject = 'Employee Shift Confirmation';

            String text = "Shift Confirmation";
            text +=
                "\r\nEmployee: ${item['hcpName']}, HCP id = ${item['hcpId']}";
            text += "\r\nHas exceeded the weekly overtime limit";
            //uncomment next to lines after DEBUG
            // await utilityServices.sendEmailFromGMail(
            //     tos, from, fromUserName, subject, text);
          }
        }
        setState(() {});
        return;
        // final navigator = Navigator.of(ctx);
        // navigator
        //     .pushReplacement(MaterialPageRoute(builder: (BuildContext ctx) {
        //   return HCPMenu();
        // }));
      }
      if (result.indexOf('ERROR') != -1) {
        await _showDialog(ctx, "Confirmation Error", result);
        final navigator =
            Navigator.of(context).pushNamed(hcpMenu, arguments: arguments!);
      }

      setState(() {});
      //_showToast('Shift Was Confirmed');
      //  Future.delayed(const Duration(seconds: 2)).then((val) {
      //    Navigator.of(context).pop();
      //  });
    } catch (e) {
      debugPrint('line 179 error $e');
      await _showDialog(ctx, "Confirmation Error",
          'There was an error confirming this employee.  Contact CMS');
      final navigator =
          Navigator.of(context).pushNamed(hcpMenu, arguments: arguments!);
    }
  }
  void getHCPUserX() async {
    debugPrint('line 44 in get usrx');
    await getHCPUser();
  }

  Future<Map<String, dynamic>> getHCPUser() async {
    debugPrint('line 50 gethcpuser available shfts: $hcpServices');
    try {
      Map<String, dynamic>? lm = await hcpServices.getHCPUser(hcpId!);
      if (lm.isEmpty) {
        debugPrint('line 54 lm i septy');
        return lm;
      }
      clientId = lm['clientId'];
      authServices.currentHCPMap = lm;
      debugPrint('line 57 in available shifts gethcpuser $lm');
      fullName = lm['legalName'];
      return lm;
    } catch (e) {
      debugPrint('line 63 error: $e');
      throw Exception(e.toString());
    }
  }

  Map<String, dynamic>? currentHCPMap;
  String? fullName;
  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    hcpId = arguments!['hcpId'];
    currentUser = authServices.currentUser;
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('line 63 didchange');

    getHCPUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double? screenWidth;
  double? screenHeight;
  double fontSize = 16;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double smallFontSize = 14;
  @override
  Widget build(BuildContext context) {
    debugPrint('line 40 in show confirmed shifts');
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 16;
    fontSize /= h;
    smallFontSize = 14;
    smallFontSize /= h;
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("Approved Or Confirm Shifts",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h!,
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
                final navigator = Navigator.of(context)
                    .pushNamed(clientProfileMenu, arguments: arguments!);
              }),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: Future.wait([_getAllApprovedConfirmedShifts()]),
          builder: (context, snapshot) {
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
                  height: 100,
                  width: screenWidth! - 10,
                  child: Text('Error: ${snapshot.error}',
                      overflow: TextOverflow.visible,
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
                  height: 100,
                  width: screenWidth! - 10,
                  child: Text('There are no approved or confirmed shifts.',
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
              List<dynamic> data = snapshot.data![0];
              debugPrint('line 325 ${data.length}');
              if (data.length == 0) {
                return Center(
                  child: Container(
                    height: 100,
                    width: 500,
                    child: Text('There are no approved or confirmed shifts.',
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
                List<dynamic> listH = snapshot.data![0];
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // number of items in each row
                    mainAxisSpacing: 2.0, // spacing between rows
                    crossAxisSpacing: 8.0, // spacing between columns
                  ),
                  padding: EdgeInsets.all(8.0), // padding around the grid
                  restorationId: 'ClientCampaignListView',
                  itemCount: listH.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = listH[index];
                    return ClientCampaignTile(
                        itemm: item,
                        fontSize: fontSize,
                        ctx: context,
                        onButtonPressed: onButtonPressed);
                  },
                );
                // return ListView.builder(
                //   restorationId: 'ClientCampaignListView',
                //   itemCount: listH.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     final item = listH[index];
                //     return ClientCampaignTile(
                //         itemm: item,
                //         fontSize: smallFontSize,
                //         ctx: context,
                //         onButtonPressed: onButtonPressed);
                //   },
                // );
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
  final void Function(Map<String, dynamic>, int, BuildContext) onButtonPressed;

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
  late BuildContext ctx;
  bool flagPublishedButtonDisabled = false;
  @override
  initState() {
    super.initState();
    item = widget.itemm;
    fontSize = widget.fontSize;
    ctx = widget.ctx;
    flagPublishedButtonDisabled = false;
  }

  String convertFromTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    int tms = date.millisecondsSinceEpoch;

    DateTime dt = DateTime.fromMillisecondsSinceEpoch(tms + 18000);
    String sdt = formatter.format(dt);
    debugPrint('line 186: $sdt');
    return sdt;
  }

  String getCityState(dynamic city, dynamic state) {
    String cty = city + ', ' + state;
    return cty;
  }

  DateFormat formatter = DateFormat('MM-dd-yyyy');
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  Color disabledTextColor = Colors.white;
  Color disabledColor = Colors.orange;
  void localButtonPressed(int el, dynamic item) {
    setState(() {
      flagPublishedButtonDisabled = true;
    });
    if (el == 1) {
      widget.onButtonPressed(item, 1, context);
    } else {
      widget.onButtonPressed(item, 2, context);
    }
  }

  String getOvertimeString(bool? value) {
    debugPrint('line 450: $value');
    String str = 'No';
    if (value == null) {
      return str;
    }
    if (value == true) {
      str = 'Yes';
    }
    debugPrint('line 457: $str');
    return str;
  }

  String getShiftHoursAsString(dynamic value) {
    if (value == null) {
      return '0.00';
    }
    double val = double.parse(value.toString());
    String str = val.toStringAsFixed(2);
    debugPrint('line 466: $str');
    return str;
  }

  String getPayRate(dynamic pr, int dayValue, dynamic prwe) {
    String? val;
    try {
      if (dayValue == 6 || dayValue == 7) {
        val = '\$' + prwe.toStringAsFixed(2);
      } else {
        val = '\$' + pr.toStringAsFixed(2);
      }
    } catch (e) {
      if (dayValue == 6 || dayValue == 7) {
        double dbl = double.parse(prwe);
        val = '\$' + dbl.toStringAsFixed(2);
      } else {
        double dbl = double.parse(pr);
        val = '\$' + dbl.toStringAsFixed(2);
      }
    }
    return val!;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    // debugPrint('line 98 in tile building');
    // String hoursString = (item.decimalHours - (item.meals/60)).toStringAsFixed(2);
    // hoursString = '7.50';

    return Container(
      width: screenWidth - 10,
      height: 420,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color2, width: 4),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 2),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Date: ${convertFromTimestamp(item['shiftDate'])}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
                // SizedBox(width:5),
                // Text('${item['dayValue']}',
                //     style: TextStyle(
                //       color:Colors.black87,
                //       fontWeight: FontWeight.bold,
                //       fontSize: fontSize,
                //     )
                // ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Text('Discipline: ${item['disciplineName']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ),
          SizedBox(height: 5),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Text('Employee: ${item['hcpName']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text('Shift: ${item['shiftCode']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
              SizedBox(width: 20),
              Container(
                height: 24,
                child: Text(
                    'Rate: ' +
                        getPayRate(item['payRate'], item['dayValue'],
                            item['payRateWE']),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Text('Name: ${item['clientName']} ',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ),
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: item['addressLine1'] != ''
                ? Text(
                    'AddressLine: ${item['addressLine1']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  )
                : SizedBox(),
          ),
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Text(
                'City/State: ${getCityState(item['clientCity'], item['state'])}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ),
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Text("Dept: ${item['departmentName']}",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 24,
            width: screenWidth -10,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              Container(
                height: 24,
                width: (screenWidth - 16) / 2,
                child: Text('Start: ${item['startTime']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
              SizedBox(width: 4),
              Container(
                height: 24,
                width: (screenWidth - 16) / 2,
                child: Text('End: ${item['endTime']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
            ]),
          ),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              height: 24,
              width: (screenWidth - 16) / 2,
              child: Text('Hours: ${item['decimalHours'].toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
            ),
            SizedBox(width: 4),
            Container(
              height: 24,
              width: (screenWidth - 16) / 2,
              child: Text('Meals: ${item['meals'].toString()}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
            ),
          ]),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: (screenWidth - 16) / 2,
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
                width: (screenWidth - 16) / 2,
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
          SizedBox(height: 10),
          item['shiftStatus'] == 'Declined'
              ? Container(
                  height: 50,
                  width: screenWidth - 10,
                  decoration: BoxDecoration(
                      color: flagPublishedButtonDisabled == false
                          ? Colors.white
                          : disabledColor,
                      border: Border.all(color: color2),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextButton(
                    onPressed: () {
                      localButtonPressed(2, item);
                    },
                    child: Text(
                      'Declined: Press to Remove from List',
                      style: TextStyle(
                        color: color2,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : item['shiftStatus'] != 'Declined'
                  ? Center(
                      child: Container(
                        height: 50,
                        width: 240,
                        decoration: BoxDecoration(
                            color: flagPublishedButtonDisabled == false
                                ? Colors.white
                                : disabledColor,
                            border: Border.all(color: color2),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextButton(
                          onPressed: () {
                            if (flagPublishedButtonDisabled == true) {
                              return;
                            }
                            localButtonPressed(1, item);
                          },
                          child: flagPublishedButtonDisabled == false
                              ? Text(
                                  'Press to Confirm Shift',
                                  style: TextStyle(
                                    color: color2,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Wait ...',
                                  style: TextStyle(
                                    color: disabledTextColor,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        height: 50,
                        width: 240,
                        decoration: BoxDecoration(
                            color: flagPublishedButtonDisabled == false
                                ? Colors.white
                                : disabledColor,
                            border: Border.all(color: color2),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextButton(
                          onPressed: () {
                            if (flagPublishedButtonDisabled == true) {
                              return;
                            }
                            localButtonPressed(2, item);
                          },
                          child: flagPublishedButtonDisabled == false
                              ? Text(
                                  'Press to Dismiss Shift',
                                  style: TextStyle(
                                    color: color2,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Wait ...',
                                  style: TextStyle(
                                    color: disabledTextColor,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    )
        ],
      ),
    );
  }
}
