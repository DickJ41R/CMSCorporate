import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:intl/intl.dart';
//import 'package:hcp_app/models/client_models/client_work_order_campaign.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
//import 'package:hcp_app/pages/home/home.dart';
import 'package:cms_web/features/hcpapp/views/hcp_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/utils/routerConstants.dart';

class ProcessHCPAvailableShifts extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessHCPAvailableShifts({super.key, required this.args});

  @override
  _ProcessHCPAvailableShiftsState createState() =>
      _ProcessHCPAvailableShiftsState();
}

class _ProcessHCPAvailableShiftsState extends State<ProcessHCPAvailableShifts> {
  // late User currentUser;
  // late RealmResults<ClientWorkOrderCampaign> allItems;
  ClientWorkOrderCampaignService clw = ClientWorkOrderCampaignService();
  HCPTimeCardService tcs = HCPTimeCardService();

  //late HCPTimeCard tms;

  _ProcessHCPAvailableShiftsState();

  dynamic mph;
  String? gEmail = '';
  bool haveAllItems = false;
  Users? user;
  dynamic currentUser;
  AuthService authService = AuthService();
  HCPServices hst = HCPServices();
  Map<String, dynamic>? hcpUser;
  int? hcpId;

  void getHCPUserX() async {
    debugPrint('line 44 in get usrx');
    await getHCPUser();
  }

  Future<Map<String, dynamic>> getHCPUser() async {
    debugPrint('line 50 gethcpuser available shfts: $hst');
    try {
      Map<String, dynamic>? lm = await hst.getHCPUser(hcpId!);
      debugPrint('line 54: $lm');
      if (lm.isEmpty) {
        debugPrint('line 54 lm i septy');
        return lm;
      }
      debugPrint('line 57 in available shifts gethcpuser $lm');
      fullName = lm['legalName'];
      return lm;
    } catch (e) {
      debugPrint('line 63 error: $e');
      throw Exception(e.toString());
    }
  }

  String? fullName;
  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    // currentUser = ref.read(appServicesNotifierProvider.notifier).fromCurrentUser!;
    arguments = widget.args;
    hcpId = arguments!['hcpId'];
    getHCPUserX();
    debugPrint('line 80 check');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('line 63 didchange');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, dynamic> convertItemToMap(dynamic item, int orderId) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String stringShiftDate = formatter.format(item.shiftDate);
    Map<String, dynamic> mpp = {
      "ShiftDate": stringShiftDate,
      "DeptID": item.departmentId,
      "AreaID": null,
      "Caller": "CMS",
      "PurchaseOrderID": null,
      "DisciplineID": item.disciplineId,
      "SpecialtyID": null,
      "RegID": item.hcpId,
      "RateTypeCodeID": item.rateTypeCodeId,
      "ShiftCode": item.shiftCode,
      "WorkersCompCodeID": item.workersCompCodeId,
      "Charge": false,
      "StartTime": item.shiftStartTime,
      "EndTime": item..shidtEndTiem,
      "Meals": item.meals,
      "Orientation": false,
      "InternalNote": "OrderId: " + orderId.toString(),
      "InvoiceNote": "Invoice test for API Add Timecard",
      "OverrideRates": item.overrideRates,
      "PayRegRate": item.payRate,
      "BillRegRate": 0.0,
    };
    return mpp;
  }

  Future<List<Map<String, dynamic>>> _getAllAvailableShifts() async {
    debugPrint('line 122 in getAvailable shiftgs ${hcpId!}');
    try {
      //    Map<String,dynamic>?hcp = await hst.getSingleHCProfessional(hcpId!);
      //  String disciplineName = hcp!['disciplineName'];
      List<Map<String, dynamic>>? lm = [];
      lm = await clw.getWorkOrderCampaignsAllOpenAccepted(hcpId!);
      debugPrint('line 127 $lm');
      if (lm == null) {
        return [];
      }

      return lm;
    } catch (e) {
      debugPrint('line 128 erro in gtavailable shifts: $e');
      throw Exception(e.toString());
    }
  }

  void onButtonPressed(
      Map<String, dynamic> item, int el, BuildContext ctx) async {
    debugPrint(
        'line 144 in onButtonPressed: ${item['id']} ${item['shiftDate']} ${item['shiftCode']}');

    String statusText = "Accepted";
    if (el == 1) {
      statusText = "Confirmed";
    }
    DateTime currentDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
    item['shiftAcceptedActionDate'] = myTimeStamp;
    Timestamp? shiftAcceptedDate = item['shiftAcceptedActionDate'];
    bool shiftAccepted = false;
    bool shiftConfirmed = item['shiftConfirmed'];
    Timestamp? shiftConfirmedDate = item['shiftConfirmedActionDate'];
    item['shiftAcceptedActionDate'] = myTimeStamp;
    shiftAcceptedDate = myTimeStamp;
    shiftAccepted = true;
    item['shiftAccepted'] = true;
    shiftConfirmed = false;
    statusText = 'Accepted';
    Map<String, dynamic> data = {
      "shiftStatus": statusText,
      "shiftAccepted": shiftAccepted,
      "shiftAcceptedActionDate": shiftAcceptedDate,
      "shiftConfirmed": false,
      "shiftConfirmedActionDate": null,
    };
    await clw.updateClientWorkOrderCampaignAccepted(item, data, ctx);
    setState(() {});
    //_showToast('Shift Was Confirmed');
    //  Future.delayed(const Duration(seconds: 2)).then((val) {
    //    Navigator.of(context).pop();
    //  });
  }

  bool isMobilePortrait = false;
  bool isMobileLandscape = false;
  bool isTabletPortrait = false;
  bool isTabletLandscape = false;
  bool isDesktop = false;
  bool isShowLogo = false;
  double? screenWidth;
  double? screenHeight;
  double? fontSize;
  double? containerHeight;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  int gridAxisCount = 1;
  @override
  Widget build(BuildContext context) {
    debugPrint('line 180 in showavailashifts');
    final windowSize = MediaQuery.sizeOf(context);
    screenWidth = windowSize.width;
    screenHeight = windowSize.height;

    double? h = windowSize.aspectRatio;
    if (h! < 1.0) {
      h = 1.0;
    }
    debugPrint('line 201: $h $screenWidth $screenHeight');
    if (screenWidth! <= 650 || screenHeight! <= 650) {
      //portrait mode
      if (screenWidth! < screenHeight!) {
        fontSize = 14;
        containerHeight = 42;
        isMobilePortrait = true;
      } else {
        fontSize = 14;
        containerHeight = 42;
        isMobileLandscape = true;
        gridAxisCount = 2;
      }
    } else if (screenWidth! > 650 && screenWidth! < 1200) {
      //tablet
      if (screenWidth! < screenHeight!) {
        fontSize = 18;
        containerHeight = 50;
        isTabletPortrait = true;
        gridAxisCount = 3;
      } else {
        fontSize = 16;
        containerHeight = 40;
        isTabletLandscape = true;
        gridAxisCount = 5;
      }
    } else {
      //desktop
      fontSize = 20;
      containerHeight = 60;
      isDesktop = true;
      gridAxisCount = 6;
    }
    double imageHeight = 50;
    if (imageHeight > containerHeight!) {
      imageHeight = containerHeight!;
    }
    debugPrint('line 240: $gridAxisCount');
    return Scaffold(
      backgroundColor: color1,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Available Shifts",
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
      body: //haveAllItems == false ?
          // CircularProgressIndicator() :
          FutureBuilder<List<dynamic>>(
              future: Future.wait([_getAllAvailableShifts()]),
              builder: (context, AsyncSnapshot snapshot) {
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
                              fontSize: fontSize,
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
                      child: Text('There are no available shifts.',
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
                  );
                } else {
                  List<Map<String, dynamic>> data = snapshot.data![0];
                  debugPrint('line 111 ${data.length}');
                  if (data.length == 0) {
                    return Center(
                      child: Container(
                        height: 100,
                        width: screenWidth! - 10,
                        child: Text('There are no available shifts.',
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
                    );
                  } else {
                    List<dynamic> listH = snapshot.data![0];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      restorationId: 'ClientCampaignListView',
                      itemCount: listH.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = listH[index];
                        return item['shiftStatus'] == 'Open'
                            ? ClientCampaignTile(
                                itemm: item,
                                fontSize: fontSize!,
                                ctx: context,
                                onButtonPressed: onButtonPressed)
                            : ClientCampaignTile1(
                                itemm: item,
                                fontSize: fontSize!,
                                ctx: context,
                                onButtonPressed: onButtonPressed);
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
  @override
  initState() {
    super.initState();
    item = widget.itemm;
    fontSize = widget.fontSize;
    ctx = widget.ctx;
  }

  UtilitiesServices util = UtilitiesServices();
  String getSpecialRequirements(String? spm) {
    if (spm == null || spm == '') {
      return "None";
    }
    return spm;
  }

  // String convertFromTimestamp(Timestamp timestamp) {
  //   DateTime date = timestamp.toDate();
  //   int tms = date.millisecondsSinceEpoch;
  //
  //   DateTime dt = DateTime.fromMillisecondsSinceEpoch(tms + 18000);
  //   String sdt = formatter.format(dt);
  //   debugPrint('line 186: $sdt');
  //   return sdt;
  // }

  bool flagPublishedButtonDisabled = false;
  DateFormat formatter = DateFormat('MM-dd-yyyy');
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color disabledTextColor = Colors.white;
  Color disabledColor = Colors.orange;
  void localButtonPressed(int el, dynamic item) {
    setState(() {
      flagPublishedButtonDisabled = true;
    });
    widget.onButtonPressed(item, 1, context);
  }

  String getCityState(dynamic city, dynamic state) {
    String cty = city + ', ' + state;
    return cty;
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

  Widget build(BuildContext context) {
    debugPrint('line 323 in tile building: ${item['shiftStatus']}');
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double tileHeight = 380;
    return SafeArea(
      child: Container(
        width: screenWidth - 10,
        height: tileHeight,
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
              height: 20,
              width: screenWidth - 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    child: Text(
                        'Date: ${util.convertFromTimestamp(item['shiftDate'])}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              height: 20,
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
              height: 20,
              width: screenWidth - 10,
              child: item['hcpId'] == 0
                  ? Text(
                      'Open',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    )
                  : Text(
                      'Employee: ${item['hcpName']}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  child: Text('Shift: ${item['shiftCode']}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                ),
                SizedBox(width: 20),
                Container(
                  height: 20,
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
            SizedBox(height: 5),
            Container(
              height: 20,
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
              height: 20,
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
              height: 20,
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
              height: 20,
              width: screenWidth - 10,
              child: Text("Dept: ${item['departmentName']}",
                  style: TextStyle(
                    color: Color.fromARGB(255, 19, 125, 103),
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
            ),
            SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 20,
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
                height: 20,
                width: (screenWidth - 16) / 2,
                child: Text('End: ${item['endTime']}',
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
                  child:
                      Text('Hours: ${item['decimalHours'].toStringAsFixed(2)}',
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
                  child: Text('Meals: ${item['meals'].toString()}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                ),
              ],
            ),
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
            SizedBox(height: 8),
            Container(
              height: 20,
              width: screenWidth - 10,
              child: Text(
                'Spec Req: ${getSpecialRequirements(item['specialRequirements'])}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Container(
                height: 50,
                width: 240,
                decoration: BoxDecoration(
                    color: flagPublishedButtonDisabled == false
                        ? Colors.white
                        : disabledColor,
                    border: Border.all(
                      color: color2,
                      width: 3,
                      style: BorderStyle.solid,
                    ),
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
                          'Press to Accept Shift',
                          style: TextStyle(
                            color: color2,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          ''
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
      ),
    );
  }
}

class ClientCampaignTile1 extends StatefulWidget {
  final Map<String, dynamic> itemm;
  final double fontSize;
  final BuildContext ctx;
  final void Function(Map<String, dynamic>, int, BuildContext) onButtonPressed;

  const ClientCampaignTile1(
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
  @override
  initState() {
    super.initState();
    item = widget.itemm;
    fontSize = widget.fontSize;
    ctx = widget.ctx;
  }

  String getSpecialRequirements(String? spm) {
    if (spm == null || spm == '') {
      return "None";
    }
    return spm;
  }

  String convertFromTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    int tms = date.millisecondsSinceEpoch;

    DateTime dt = DateTime.fromMillisecondsSinceEpoch(tms + 18000);
    String sdt = formatter.format(dt);
    debugPrint('line 186: $sdt');
    return sdt;
  }

  bool flagPublishedButtonDisabled = false;
  DateFormat formatter = DateFormat('MM-dd-yyyy');
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color disabledTextColor = Colors.white;
  Color disabledColor = Colors.orange;
  void localButtonPressed(int el, dynamic item) {
    setState(() {
      flagPublishedButtonDisabled = true;
    });
    widget.onButtonPressed(item, 1, context);
  }

  String getCityState(dynamic city, dynamic state) {
    String cty = city + ', ' + state;
    return cty;
  }

  Widget build(BuildContext context) {
    debugPrint('line 323 in tile building');
    final windowSize = MediaQuery.sizeOf(context);
    double screenWidth = windowSize.width;
    return SafeArea(
      child: Container(
        width: screenWidth - 10,
        height: 160,
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
                  Container(
                    height: 24,
                    child:
                        Text('Date: ${convertFromTimestamp(item['shiftDate'])}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                            )),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 24,
                    child: Text('Shift: ${item['shiftCode']}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              height: 24,
              width: screenWidth - 10,
              child: Text(
                'Employee: ${item['hcpName']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
            SizedBox(height: 5),
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
            SizedBox(height: 4),
            Container(
              height: 50,
              width: screenWidth - 10,
              decoration: BoxDecoration(
                  color: flagPublishedButtonDisabled == false
                      ? Colors.white
                      : disabledColor,
                  border: Border.all(
                    color: Colors.red,
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Text(
                  'Shift awaiting approval.',
                  style: TextStyle(
                      color: color2,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
