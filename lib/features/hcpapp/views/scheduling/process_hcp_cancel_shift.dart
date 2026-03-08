import 'package:flutter/material.dart';
import 'package:cms_web/features/hcpapp/services/hcp_timecard_service.dart';
//import 'package:hcp_app/models/client_models/client_work_order_campaign.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/clientapp/services/client_work_order_campaign_service.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/hcpapp/services/hcp_user_services.dart';
import 'package:cms_web/features/shared/services/utility_services.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/hcpapp/views/hcp_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/services/dropdown_codes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ProcessHCPCancelShifts extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessHCPCancelShifts({super.key, required this.args});

  @override
  _ProcessHCPCancelShiftsState createState() => _ProcessHCPCancelShiftsState();
}

class _ProcessHCPCancelShiftsState extends State<ProcessHCPCancelShifts> {
  dynamic hcpUser;
  Users? user;
  dynamic currentUser;
  ClientWorkOrderCampaignService clw = ClientWorkOrderCampaignService();
  HCPTimeCardService hcpTimeCardService = HCPTimeCardService();
  HCPUserServices hcpUserServices = HCPUserServices();
  UtilitiesServices utilitiesServices = UtilitiesServices();
  DropDownCodes dropDownCodes = DropDownCodes();

  AuthService authService = AuthService();
  int? hcpId;
  String? gEmail;
  _ProcessHCPCancelShiftsState();

  Future<List<Map<String, dynamic>>> _getAllConfirmedShifts() async {
    print('line 122 in getAvailable shiftgs');
    try {
      List<Map<String, dynamic>>? lm =
          await clw.getWorkOrderCampaignsConfirmed(hcpId!);
      print('line 58 in get all confirmed');
      if (lm == null) {
        return [];
      }

      return lm;
    } catch (e) {
      print('line 66 erro in cancel shifts: $e');
      throw Exception(e.toString());
    }
  }

  void getHCPUserX() async {
    print('line 44 in get usrx');
    await getHCPUser();
  }

  Future<Map<String, dynamic>> getHCPUser() async {
    print('line 50 gethcpuser available shfts: $hcpUserServices');
    try {
      Map<String, dynamic>? lm = await hcpUserServices.getHCPUser(hcpId!);

      if (lm.isEmpty) {
        print('line 54 lm i septy');
        return lm;
      }
      print('line 57 in available shifts gethcpuser $lm');
      fullName = lm['legalName'];
      return lm;
    } catch (e) {
      print('line 63 error: $e');
      throw Exception(e.toString());
    }
  }

  String? cancelReason;
  String? fullName;
  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    hcpId = arguments!['hcpId'];
    getRegistrantCancelReasons();
    print('line 39: $currentUser $clw');
    print('check');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('line 63 didchange');

    getHCPUserX();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _showDialog(
      BuildContext context, String title, String? description) async {
    print('line 12 showdialog');
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
            content: Text(description!,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color2,
                  fontWeight: FontWeight.bold,
                )),
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
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(
                  'Cancel Request',
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 125, 103)),
                ),
              )
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

  void onButtonPressed(Map<String, dynamic> item,
      bool flagPublishedButtonDisabled, BuildContext ctx) async {
    print(
        'line 41 in onButtonPressed: ${item['shiftDate']} ${item['shiftCode']}');
    //cancel  clentworkorder first
    print('line 201:${item['shiftCancellationNote']}');

    if (item['shiftCancellationNote'] == null) {
      _showDialog(
          ctx, "Cancellation Reason", "You must select a cancellation reason!");
      return;
    }
    int cancelReasonCodeId = 0;
    for (int i = 0; i < listOfRegistrantCancelReasons.length; i++) {
      Map<String, dynamic> mp = listOfRegistrantCancelReasons[i];
      print('line 204: $mp ${item['shiftCancellationNote']}');
      if (mp['reason'] == item['shiftCancellationNote']) {
        cancelReason = mp['reason'];
        cancelReasonCodeId = mp['codeId'];
        break;
      }
    }
    if (cancelReasonCodeId == 0) {
      _showDialog(ctx, "Error", 'There is no valid cancellation reason code');
      flagPublishedButtonDisabled = false;
      return;
    }
    try {
      item['shiftCanceledById'] = item['hcpId'];
      item['shiftCancellationCodeId'] = cancelReasonCodeId;
      item['shiftCanceledByName'] = item['hcpName'];
      item['shiftStatus'] = 'Canceled';
      item['cancelReasonCodeId'] = cancelReasonCodeId;
      item['cancelReason'] = cancelReason;
      item['shiftCanceledActionDate'] = Timestamp.fromDate(DateTime.now());
      item['shiftStatusDate'] = Timestamp.fromDate(DateTime.now());
      item['shiftCancellationType'] = 'E';
      item['shiftCanceledNote'] = "E";

      bool? bl1 = await clw.cancelHCPWorkOrderShift(item, item['hcpId'], ctx);
      if (bl1! == false) {
        flagPublishedButtonDisabled = false;
        _showDialog(
            ctx, "Cancel Error", "An error occurred canceling the shift");
        Navigator.of(ctx).pop();
      }
      await hcpTimeCardService.cancelScheduledShift(item, ctx);
      // List<String> tos = ['dickj41r@icloud.com'];
      // String from = 'noreply@consolidatedstaffing.com';
      // String fromUserName = 'Support';
      // String subject = 'Employee Shift Cancellation';
      //
      // String text = "Shift Cancellation";
      // text += "\r\nClient: ${item['clientName']}";
      // text += "\r\nShift: ${item['shiftCode']}";
      // text += "\r\nShiftDate:${_convertFromTimestamp(item['shiftDate'])}";
      // text += "\r\nEmployee: ${item['hcpName']}";
      // text += '\r\nReason: ${item['shiftCancellationNote']}';
      // //uncomment next to lines after DEBUG
      // await utilitiesServices.sendEmailFromGMail(
      //     tos, from, fromUserName, subject, text);
      print('line 257 just before alert');
      await _showDialog(ctx, "Cancellation",
          "You have successfully canceled the shift.  Don't forget to notify the client and your CMS representative.");
      Navigator.of(ctx).pop();
    } catch (e) {
      print('line 263 error: ${e.toString()}');
      await _showDialog(ctx, "Cancellation",
          "THere was an error:   Don't forget to notify the client and your CMS representative.");
      Navigator.of(ctx).pop();
    }
  }

  List<dynamic> listOfReasons = [];
  List<Map<String, dynamic>> listOfRegistrantCancelReasons = [];
  void getRegistrantCancelReasons() async {
    List<Map<String, dynamic>> lstw =
        await dropDownCodes.getRegistrantCancelReasons();
    List<dynamic> lst = [];
    for (int i = 0; i < lstw.length; i++) {
      Map<String, dynamic> mp = lstw[i];
      dynamic st = mp['reason'];
      lst.add(st);
    }
    setState(() {
      listOfReasons = lst;
      listOfRegistrantCancelReasons = lstw;
    });
  }

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  bool flagPublishedButtonDisabled = false;
  double h = 1.0;
  double fontSize = 18;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    double? hh = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    h = hh!;
    if (h < 1.0) {
      h = 1.0;
    }
    fontSize = 18;
    fontSize /= h;
    double smallFontSize = 14;
    smallFontSize /= h;
    print('line 40 in show cancel shifts');
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("Cancel Shifts",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
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
                  .pushNamed(hcpMenu, arguments: arguments!);
            },
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: Future.wait([_getAllConfirmedShifts()]),
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
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else if (snapshot.data == [[]] &&
                snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Container(
                  height: 100,
                  child: Text('There are no confirmed shifts to cancel.',
                      style: TextStyle(
                          fontSize: fontSize,
                          color: color2,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else {
              List<dynamic> data = snapshot.data![0];
              print('line 328 $data ${data.length} ${snapshot.data![0]}');
              if (data.length == 0) {
                return Center(
                  child: Container(
                    height: 100,
                    child: Text('There are no confirmed shifts to cancel.',
                        style: TextStyle(
                            fontSize: fontSize,
                            color: color2,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              } else {
                List<dynamic> listH = snapshot.data![0];
                return ListView.builder(
                  restorationId: 'ClientCampaignListView',
                  itemCount: listH.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = listH[index];
                    return ClientCampaignTile(
                        itemm: item,
                        onButtonPressed: onButtonPressed,
                        showDialog: _showDialog,
                        flagPublishedButtonDisabled:
                            flagPublishedButtonDisabled,
                        ctx: context,
                        reasons: listOfReasons,
                        title: 'Cancellation Dialog',
                        description:
                            'Notify both the client and your CMS representative!');
                  },
                );
              }
            }
          }),
    );
  }
}

class ClientCampaignTile extends StatefulWidget {
  final Map<String, dynamic> itemm;
  final BuildContext ctx;
  final bool flagPublishedButtonDisabled;
  final List<dynamic> reasons;
  final String title;
  final String description;

  final void Function(Map<String, dynamic>, bool, BuildContext) onButtonPressed;
  final Future<bool> Function(BuildContext, String, String?) showDialog;

  const ClientCampaignTile(
      {required this.itemm,
      required this.onButtonPressed,
      required this.showDialog,
      required this.flagPublishedButtonDisabled,
      required this.ctx,
      required this.reasons,
      required this.title,
      required this.description});

  @override
  State<ClientCampaignTile> createState() => _ClientCampaignTileState();
}

class _ClientCampaignTileState extends State<ClientCampaignTile> {
  _ClientCampaignTileState();
  final _formKey = GlobalKey<FormState>();
  static final __formKey = new GlobalKey<FormState>();
  late Map<String, dynamic> item;
  UtilitiesServices utilitiesServices = UtilitiesServices();
  DropDownCodes dropDownCodes = DropDownCodes();
  List<dynamic> listOfReasons = [];

  Future<List<dynamic>> getListOfReasons() async {
    try {
      listOfReasons = widget.reasons;

      debugPrint('line 398 get list of reasons: ${listOfReasons[0]}');
      return listOfReasons;
    } catch (e) {
      print('line 400: $e');
      return [];
    }
  }

  @override
  initState() {
    super.initState();
    item = widget.itemm;
    flagPublishedButtonDisabled = widget.flagPublishedButtonDisabled;
    print('line 409: ${widget.reasons[0]}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  String convertFromTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    int tms = date.millisecondsSinceEpoch;

    DateTime dt = DateTime.fromMillisecondsSinceEpoch(tms + 18000);
    String sdt = formatter.format(dt);
    print('line 186: $sdt');
    return sdt;
  }

  DateFormat formatter = DateFormat('MM-dd-yyyy');
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  Color disabledTextColor = Colors.white;
  Color disabledColor = Colors.orange;
  bool flagPublishedButtonDisabled = false;
  void localButtonPressed(Map<String, dynamic> item, BuildContext ctx) {
    setState(() {
      flagPublishedButtonDisabled = true;
    });
    widget.onButtonPressed(item, flagPublishedButtonDisabled, ctx);
  }

  String getCityState(dynamic city, dynamic state) {
    String cty = city + ',' + state;
    return cty;
  }

  dynamic selectedCancelReasonValue = null;
  int selectedCancelReasonIndex = -1;

  Future<int> getReasonIndex(dynamic value) async {
    print('line 458 in getReasonindex');
    for (int i = 0; i < listOfReasons.length; i++) {
      if (value == listOfReasons[i]) {
        selectedCancelReasonIndex = i;
        selectedCancelReasonValue = value;
        break;
      }
    }
    print('line 465: $selectedCancelReasonIndex');
    return selectedCancelReasonIndex;
  }

  bool flagShowRed = false;
  double h = 1.0;
  double fontSize = 16;
  String _getReason = 'Family Emergency';

  String getPayrateAsString(dynamic pr) {
    String prs = pr.toString();
    print('line 254: $pr $prs');
    double prd = double.parse(prs);
    prs = prd.toStringAsFixed(2);

    return prs;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    double? hh = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    h = hh!;
    if (h < 1.0) {
      h = 1.0;
    }
    fontSize = 16;
    fontSize /= h;
    double smallFontSize = 14;
    smallFontSize /= h;
    print('line 98 in tile building $selectedCancelReasonValue');
    String hoursString =
        (item['decimalHours'] - (item['meals'] / 60)).toStringAsFixed(2);
    return Container(
      width: screenWidth - 10,
      height: 450,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(color: Color.fromARGB(255, 19, 125, 103), width: 4),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
              height: 36,
              width: screenWidth! - 10,
              child: FutureBuilder(
                future: Future.wait([
                  getListOfReasons(),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  debugPrint(
                      'line 417 building FB ${snapshot.connectionState}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Container(
                          height: 110,
                          child: Text('Error: ${snapshot.error}',
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  } else if (snapshot.data == [[]] &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Container(
                          height: 100,
                          //  width: screenWidth! - 10,
                          child: Text(
                              overflow: TextOverflow.visible,
                              'There are no cancellation reasons for this client.',
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: color2,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  } else {
                    print('line 544: ${snapshot.data![0]} ');
                    List<dynamic> listH = snapshot.data![0];
                    if (listH.length == 0) {
                      print('line 548 check');
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            height: 100,
                            //    width: screenWidth! - 10,
                            child: Text(
                                'There are no cancellations reasons for this client.',
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontSize: fontSize,
                                    color: color2,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    } else {
                      List<dynamic> listH = snapshot.data![0]!;
                      print('line 591: ${listH[0]}');
                      return Container(
                        height: 80,
                        width: screenWidth - 10,
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            height: 36,
                            width: screenWidth - 4,
                            decoration: BoxDecoration(
                                color:
                                    flagShowRed == false ? color1 : Colors.red,
                                border: Border.all(color: Colors.black87),
                                borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton2<dynamic>(
                              isExpanded: true,
                              hint: Container(
                                height: 36,
                                width: screenWidth - 10,
                                child: Text(
                                  'Select A Cancellation Reason',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              items: listH
                                  .map((dynamic item) =>
                                      DropdownMenuItem<dynamic>(
                                        value: item,
                                        child: Container(
                                          height: 32,
                                          width: screenWidth - 10,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: fontSize,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedCancelReasonValue,
                              onChanged: (dynamic value) async {
                                selectedCancelReasonValue = value;
                                print('line 609: $value');
                                selectedCancelReasonIndex =
                                    await getReasonIndex(value);
                                print(
                                    'line 1128: $selectedCancelReasonValue $value $selectedCancelReasonIndex ');
                                setState(() {
                                  flagShowRed = false;
                                  selectedCancelReasonValue;
                                });
                              },
                            ),
                          ),
                          //    )
                        ),
                      );
                    }
                    ;
                  }
                  ;

                  return Container(
                    height: 40,
                    child: Text('line 620'),
                  );
                },
              )),
          SizedBox(height: 10),
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
                      fontSize: smallFontSize,
                    )),
                // SizedBox(width:5),
                // Text('${item['dayValue']}',
                //     style: TextStyle(
                //       color:Colors.black87,
                //       fontWeight: FontWeight.bold,
                //       fontSize: smallFontSize,
                //     )
                // ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Container(
            height: 24,
            width: screenWidth - 10,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Employee: ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: smallFontSize,
                    )),
                SizedBox(width: 2),
                Text('${item['hcpName']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: smallFontSize,
                    )),
              ],
            ),
          ),
          SizedBox(width: 10),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Row(children: [
              Text('Discipline: ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  )),
              Text('${item['disciplineName']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  )),
              SizedBox(width: 12),
              Text('Rate: ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  )),
              SizedBox(width: 12),
              Text('\$' + getPayrateAsString(item['payRate']),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  )),
            ]),
          ),
          SizedBox(height: 5),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text('Client: ${item['clientName']}',
                  maxLines: 2,
                  style: TextStyle(
                    color: color2,
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  )),
            ]),
          ),
          SizedBox(height: 10),
          item['addressLine1'] != ''
              ? Container(
                  alignment: Alignment.centerLeft,
                  height: 24,
                  child: Text('Address: ${item['addressLine1']}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                )
              : SizedBox(),
          SizedBox(height: 10),
          Container(
            height: 24,
            alignment: Alignment.centerLeft,
            child: Text(
                'City/State: ${getCityState(item['clientCity'], item['state'])}',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ),
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Text(
              'Department: ${item['departmentName']}',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text('Shift: ${item['shiftCode']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  )),
              SizedBox(width: 12),
              Text('Start: ${item['startTime']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  )),
              SizedBox(width: 4),
              Text('End: ${item['endTime']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  )),
            ]),
          ),
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth - 10,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                  'Hours: ${utilitiesServices.getHours(item['startTime'], item['endTime'], item['meals'])}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  )),
              SizedBox(width: 12),
              Text('Meals: ${item['meals'].toString()}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  )),
            ]),
          ),
          SizedBox(height: 5),
          Center(
            child: Container(
              height: 40,
              width: screenWidth - 10,
              decoration: BoxDecoration(
                  color: flagPublishedButtonDisabled == false
                      ? Colors.white
                      : disabledColor,
                  border: Border.all(color: Color.fromARGB(255, 19, 125, 103)),
                  borderRadius: BorderRadius.circular(12)),
              child: TextButton(
                onPressed: () async {
                  if (selectedCancelReasonValue == null) {
                    setState(() {
                      flagShowRed = true;
                    });
                    return;
                  }
                  item['shiftCancellationNote'] = selectedCancelReasonValue;
                  item['shiftCanceledActionDate'] =
                      Timestamp.fromDate(DateTime.now());
                  localButtonPressed(item, widget.ctx);
                  setState(() {
                    flagPublishedButtonDisabled = false;
                  });
                },
                child: flagPublishedButtonDisabled == false
                    ? Text(
                        'Press to Cancel Shift',
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
          ),
        ],
      ),
    );
  }
}
