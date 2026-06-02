//Client Cancel Shifts Scheduling Page
import 'package:cms_web/features/clientapp/models/client.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
import 'package:cms_web/features/shared/utils/dropdown_codes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ShiftCancel {
  final String shiftDate;
  final String shiftCode;
  final String disciplineName;
  final String shiftName;
  final int hcpId;
  final String id;
  // final String payRate;
  ShiftCancel(this.shiftDate, this.shiftCode, this.disciplineName,
      this.shiftName, this.hcpId, this.id);

  ShiftCancel.fromJson(Map<String, dynamic> json)
      : shiftDate = json['shiftDate'] as String,
        shiftCode = json['shiftCode'] as String,
        disciplineName = json['disciplineName'] as String,
        shiftName = json['shiftName'] == null ? 0 : json['shiftName'],
        hcpId = int.parse(json['hcpId'].toString()),
        id = json['id'] as String;
//        payRate = json['payRate'] as String;,

  Map<String, dynamic> toJson() => {
        'shiftDate': shiftDate,
        'shiftCode': shiftCode,
        'disciplineName': disciplineName,
        'shiftName': shiftName,
        'hcpId': hcpId.toString(),
        'id': id
      };
  ShiftCancel copyWith(
      {String? shiftDate,
      String? shiftCode,
      String? disciplineName,
      String? shiftName,
      int? hcpId,
      String? id}) {
    return ShiftCancel(
        shiftDate ?? this.shiftDate,
        shiftCode ?? this.shiftCode,
        disciplineName ?? this.disciplineName,
        shiftName ?? this.shiftName,
        hcpId ?? this.hcpId,
        id ?? this.id);
  }
}

class ClientCancelShiftsSchedulingPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientCancelShiftsSchedulingPage({super.key, required this.args});

  @override
  State<ClientCancelShiftsSchedulingPage> createState() =>
      _ClientCancelShiftsSchedulingPageState();
}

class _ClientCancelShiftsSchedulingPageState
    extends State<ClientCancelShiftsSchedulingPage> {
  final _formKey = GlobalKey<FormState>();

  late int clientId;
  late BuildContext? ctx;
  DropDownCodes dropDownCodes = DropDownCodes();

  List<ShiftCancel> shiftCancels = <ShiftCancel>[];
  HCPTimeCardService hts = HCPTimeCardService();
  UtilitiesServices utilitiesServices = UtilitiesServices();
  ClientServices clientServices = ClientServices();

  late ShiftCancelDataSource shiftCancelDataSource;
  bool flagWaitDisabled = false;
  dynamic currentSelection = SelectionMode.single;
  Color disabledTextColor = Colors.white;
  Color disabledColor = Colors.orange;
  bool flagPublishedButtonDisabled = true;
  double smallFontSize = 14;
  double smallerFontSize = 12;
  ClientWorkOrderCampaignService clw = ClientWorkOrderCampaignService();
  //late ShiftClassDataSource _shiftClassDataSource;
  List<dynamic> listOfShiftCancelData = [];
  DataGridController _dataGridController = DataGridController();
  List<Map<String, dynamic>>? allItemsTemp;
  late Map<String, double> columnWidths = {
    'shiftDate': 100 * multiplicativeFactor,
    'shiftCode': 70 * multiplicativeFactor,
    'disciplineName': 70 * multiplicativeFactor,
    'shiftName': 120 * multiplicativeFactor,
  };
  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yy');
    final String formatted = formatter.format(dte);
    return formatted;
  }

  String _convertFromTimestamp(Timestamp? t) {
    print('line 75: $t');
    if (t == null) {
      DateTime d = new DateTime(1970, 1, 1);
      int itt = d.millisecondsSinceEpoch;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(itt);
      String ss = getFormattedDate(dateTime);
      print('line 81 null date: $ss');
      return ss;
    }
    DateTime date = t.toDate();
    String s = getFormattedDate(date);
    print('line 85: $s');
    return s;
  }

  List<dynamic> listOfClientReasons = [];
  List<Map<String, dynamic>> listOfClientCancelReasons = [];
  dynamic selectedClientCancelReasonValue = null;
  int selectedClientCancelReasonIndex = -1;

  Future<int> getClientReasonIndex(dynamic value) async {
    print('line 458 in getReasonindex');
    for (int i = 0; i < listOfClientReasons.length; i++) {
      if (value == listOfClientReasons[i]) {
        selectedClientCancelReasonIndex = i;
        selectedClientCancelReasonValue = value;
        break;
      }
    }
    flagPublishedButtonDisabled = false;
    print('line 465: $selectedClientCancelReasonIndex');
    return selectedClientCancelReasonIndex;
  }

  Future<List<dynamic>> getClientCancelReasons() async {
    List<Map<String, dynamic>> lstw =
        await dropDownCodes.getClientCancelReasons();
    List<dynamic> lst = [];
    for (int i = 0; i < lstw.length; i++) {
      Map<String, dynamic> mp = lstw[i];
      dynamic st = mp['reason'];
      lst.add(st);
    }
    listOfClientReasons = lst;
    listOfClientCancelReasons = lstw;
    return lst;
  }

  Future<List<dynamic>> getAllItems() async {
    try {
      List<dynamic> lms = [];
      allItemsTemp = await clw.getWorkOrderCancelShifts(clientId);
      print('line 105 ${allItemsTemp!.length} $clientId');
      if (allItemsTemp == null) {
        flagPublishedButtonDisabled = true;
        flagWaitDisabled = false;
        print('line 109 check');
        return lms;
        // throw Exception("No available shifts to cancel");
      }
      if (allItemsTemp!.length == 0) {
        flagPublishedButtonDisabled = true;
        flagWaitDisabled = false;
        // throw Exception("No available shifts to cancel");
        print('line 117 check');
        return lms;
      }

      for (int i = 0; i < allItemsTemp!.length; i++) {
        allItemsTemp![i]['cancel'] = false;
        dynamic obj = allItemsTemp![i];
        print('line 124: ${obj}');
        lms.add(obj);
      }
      print('line 126: ${lms.length} ${lms[0]}');
      listOfShiftCancelData = lms;
      shiftCancels = getShiftCancelData();
      shiftCancelDataSource =
          ShiftCancelDataSource(shiftCancelData: shiftCancels, fontS: fts);
      print('line 131: ${allItemsTemp!.length} ${lms.length}');
      return lms;
    } catch (e) {
      print('line 134 error: $e');
      // //    _showDialog(context, 'Shift Cancellation', 'No shifts to cancel.');
      //   final navigator = Navigator.of(context);
      //   navigator.pushReplacement(
      //       MaterialPageRoute(builder: (BuildContext context) {
      //         return ClientSchedulingMenu(ctx:context,clientId:clientId!);
      //       }));
      return [];
    }
  }

  double fts = 14;
  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    clientId = arguments!['clientId'];
    print('line 98: ${clientId} ');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // for (int i=0; i < rows.length; i++) {
    //   RowWidgetModel row = rows[i];
    //
    // }

    super.dispose();
  }

  List<ShiftCancel> getShiftCancelData() {
    List<ShiftCancel> listC = [];
    for (int i = 0; i < listOfShiftCancelData.length; i++) {
      dynamic obj = listOfShiftCancelData[i];
      String shiftName = '';
      int hcpId = 0;
      String shiftDate =
          _convertFromTimestamp(obj['dates']['shiftDateInfo']['shiftDate']);
      if (obj['hcpId'] == 0) {
        shiftName = "Open";
      } else {
        shiftName = obj['hcpName'];
      }
      Map<String, dynamic> jst = {
        "shiftDate": shiftDate,
        "shiftCode": obj['dates']['shiftDateInfo']['shiftCode'],
        'disciplineName': obj['disciplineName'],
        "shiftName": shiftName,
        'hcpId': obj['hcpId'],
        'id': obj['id']
      };

      ShiftCancel shift = ShiftCancel.fromJson(jst);
      print('line 206: ${shift.id} ${shift.hcpId}');
      listC.add(shift);
    }
    return listC;
  }

  Future<dynamic> _showDialog(
      BuildContext context, String title, String? description) async {
    print('line 398 showdialog');
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.of(context).pop(); // Close the dialog
    // });
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(description!),
              contentTextStyle: TextStyle(
                color: color1,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              titleTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold),
              actions: <Widget>[
                // TextButton(
                //   onPressed: () => Navigator.pop(context, 'Cancel'),
                //   child: const Text('Cancel'),
                // ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: color2),
                  ),
                )
              ],
            ));
    return;
  }
  final valueListenableCancelReason = ValueNotifier<String?>(null);

  Future<void> sendCancelEmail(
      List<Map<String, dynamic>> clientWorkOrders, String reason) async {
    List<int> genIds = [];

    var fromEmail = '';
    var userName = '';
    List<String> tos = [];
    await FirebaseFirestore.instance
        .collection('ClientUser')
        .where('clientId', isEqualTo: clientId)
        .where('roles', arrayContainsAny: [
          'ClientAdmin',
          'ClientSupervisor',
          'ClientScheduler'
        ])
        .get()
        .then((querySnapshot) async {
          for (var docSnapshot in querySnapshot.docs) {
            var obj = docSnapshot.data();
            fromEmail = obj['email'];
            tos.add(fromEmail);
            userName = obj['username'];
            break;
          }
        });
    String from = 'noreply@consolidatedstaffing.com';
    String fromUserName = 'CMS Support';
    String subject = 'Shift Cancellation';
    tos.add('blee@consolidatedstaffing.com');
    for (int i = 0; i < clientWorkOrders.length; i++) {
      Map<String, dynamic> wom = clientWorkOrders[i];
      Future<void> sendClientCancelMessage(
          Map<String, dynamic> wor, List<String> tos, String reason) async {
        await clientServices.sendClientCancelMessage(wom, tos, reason);
      }
    }
    return;
  }

  Future<void> processCanceledShiftsList(
      List<DataGridRow> selList, String reason, BuildContext ctx) async {
    print('line 302 process canceled shifts: $reason ${selList.length}');
    if (selList.length == 0) {
      _showDialog(context, "Process Canceled Shifts",
          "You have not selected any shifts to cancel.");
      return;
    }
    setState(() {
      flagPublishedButtonDisabled = true;
    });
    int cancelReasonCodeId = -1;
    try {
      for (int i = 0; i < listOfClientCancelReasons.length; i++) {
        var mp = listOfClientCancelReasons[i];
        if (mp['reason'] == reason) {
          cancelReasonCodeId = mp['codeId'];
          break;
        }
      }
      print('line 357: $cancelReasonCodeId');
      List<Map<String, dynamic>> canceledShifts = [];
      for (int i = 0; i < selList.length; i++) {
        print('line 322: ${selList[i]}');
        DataGridRow row = selList[i];
        List<DataGridCell> cells = row.getCells();
        Map<String, dynamic> obj = {};
        for (int j = 0; j < cells.length; j++) {
          DataGridCell cell = cells[j];
          switch (j) {
            case 0:
              {
                obj['shiftDate'] = cell.value;
              }
              break;
            case 1:
              {
                obj['shiftCode'] = cell.value;
              }
              break;
            case 2:
              {
                obj['disciplineName'] = cell.value;
              }
              break;
            case 3:
              {
                obj['shiftName'] = cell.value;
              }
            case 4:
              {
                obj['hcpId'] = cell.value;
              }
            case 5:
              {
                obj['id'] = cell.value;
              }
              break;
            default:
              break;
          }
        }
        canceledShifts.add(obj);
      }
      print(
          'line 365 check ${canceledShifts[0]['id']} ${canceledShifts.length}');
      List<Map<String, dynamic>> workOrders = [];
      List<Map<String, dynamic>> clientWorkOrders = [];
      List<String> lsw = [];
      List<String> listWorkOrderIds = [];
      for (int j = 0; j < canceledShifts.length; j++) {
        Map<String, dynamic> csf = canceledShifts[j];
        String dts = csf['shiftDate'];
        List<String> ldts = dts.split('-');
        ldts[2] = '20' + ldts[2];
        dts = ldts[2] + '-' + ldts[0] + '-' + ldts[1];
        print('line 376 $dts ${csf['shiftCode']}');
        DateTime tsm = DateTime.parse(dts);
        for (int i = 0; i < allItemsTemp!.length; i++) {
          Map<String, dynamic> obj = allItemsTemp![i];
          print('line 380: ${obj['id']} ${csf['id']}');
          if (obj['id'] != csf['id']) {
            continue;
          }
          listWorkOrderIds.add(obj['workOrderId']);
          Timestamp tsf = obj['dates']['shiftDateInfo']['shiftDate'];
          DateTime sft = tsf.toDate();
          print('line 423: ${obj['id']} ${csf['id']}');
          print('line 387" $tsf $sft');
          sft = sft.subtract(Duration(
              hours: sft.hour,
              minutes: sft.minute,
              seconds: sft.second,
              microseconds: sft.microsecond,
              milliseconds: sft.millisecond));
          print('line 394 $tsm $sft');
          if (tsm.millisecondsSinceEpoch != sft.millisecondsSinceEpoch) {
            print('line  396 not = $tsm $sft');
            continue;
          }
          print(
              'line 400: ${csf['shiftCode']} ${obj['dates']['shiftDateInfo']['shiftCode']}');
          if (csf['shiftCode'] != obj['dates']['shiftDateInfo']['shiftCode']) {
            print(
                'line 400 shift not = ${csf['shiftCode']} ${obj['dates']['shiftDateInfo']['shiftCode']}');
            continue;
          }
          print('line 406: ${obj['hcpId']} ${csf['hcpId']}');

          obj['cancelReasonCodeId'] = cancelReasonCodeId;
          obj['Conf_Cli_Note'] = reason;
          obj['shiftCancellationType'] =
              'C'; //E = employee, C = client, * = Coordinator
          obj['shiftCancellationReason'] = reason;
          if (obj['workOrderCampaignShiftStatus'] == 'Confirmed' ||
              obj['workOrderCampaignShiftStatus'] == 'SignedIn') {
            clientWorkOrders.add(obj);
          } else {
            workOrders.add(obj);
          }
        }
      }
      print('line 418 check: ${clientWorkOrders.length} ${workOrders.length}');

      if (clientWorkOrders.length > 0) {
        String? message = await hts.cancelConfirmedShiftByClients(
            clientWorkOrders, clientId, "Client", ctx);
        String title = 'Shift Cancellations';
        String description = message!;
        await _showDialog(ctx, title, description);
        if (message.contains('successfully') == true) {
          await sendCancelEmail(
              clientWorkOrders, selectedClientCancelReasonValue);
        }
      }
      print('line 432: ${workOrders.length}');
      if (workOrders.length > 0) {
        String? msg2 =
            await hts.cancelWorkOrdersByClient(workOrders, "Client", ctx);
        if (msg2 != 'Success') {
          String title = 'Shift Cancellations';
          String description = 'You have not canceled any shifts ' + msg2!;
          await _showDialog(ctx, title, description);
        } else {
          await sendCancelEmail(workOrders, selectedClientCancelReasonValue);
        }
      }
      workOrders = [];
      clientWorkOrders = [];
      setState(() {
        largeFontSize = 20;
        selectedList = [];
        flagPublishedButtonDisabled = false;
        flagWaitDisabled = false;
      });
      return;
    } catch (e) {
      print('line 449 error: $e');
      throw Exception('line 450 error: ${e.toString()}');
    }
  }

  List<GridColumn> columnList = [];

  List<GridColumn> getColumnList() {
    columnList = [
      GridColumn(
          width: columnWidths['shiftDate']!,
          columnName: "shiftDate",
          label: Container(
              //padding: EdgeInsets.all(3.0),
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 2, right: 2),
              child: Text('Shift Date',
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)))),
      GridColumn(
          width: columnWidths['shiftCode']!,
          columnName: "shiftCode",
          label: Container(
              //   padding: EdgeInsets.all(3.0),
              padding: EdgeInsets.only(left: 2, right: 2),
              alignment: Alignment.center,
              child: Text('Shift',
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)))),
      GridColumn(
          width: columnWidths['disciplineName']!,
          columnName: "disciplineName",
          label: Container(
              //   padding: EdgeInsets.all(3.0),
              padding: EdgeInsets.only(left: 2, right: 2),
              alignment: Alignment.center,
              child: Text('Disp',
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)))),
      GridColumn(
          width: columnWidths['shiftName']!,
          columnName: "shiftName",
          label: Container(
              // padding: EdgeInsets.all(3.0),
              padding: EdgeInsets.only(left: 2, right: 2),
              alignment: Alignment.centerLeft,
              child: Text('Name',
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)))),
      GridColumn(
          visible: false,
          columnName: "hcpId",
          label: Container(
              // padding: EdgeInsets.all(3.0),
              padding: EdgeInsets.only(left: 2, right: 2),
              alignment: Alignment.centerLeft,
              child: Text('hcpId',
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)))),
      GridColumn(
          visible: false,
          columnName: "id",
          label: Container(
              // padding: EdgeInsets.all(3.0),
              padding: EdgeInsets.only(left: 2, right: 2),
              alignment: Alignment.centerLeft,
              child: Text('id',
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold)))),
    ];
    return columnList;
  }

  bool showCheckboxHeader = false;
  double? appWidth;
  Color color4 = Colors.black87;
  Color color5 = Colors.red;
  double tableHeight = 800;
  double count = 0;
  int? selectedIndex;
  Map<String, List<DataGridRow>> selectedRowsCollection = {};

  //final CustomSelectionManager _customSelectionManager = CustomSelectionManager();
  List<DataGridRow> selectedList = <DataGridRow>[];

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;

  double largeFontSize = 22;
  double? h;
  double multiplicativeFactor = 1;
  bool flagShowRed = false;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    tableHeight = screenHeight! - 250;
    appWidth = screenWidth! / 2;
    if (screenWidth! < 400) {
      multiplicativeFactor = 1.0;
    } else {
      multiplicativeFactor = screenWidth! / 400;
    }
    h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 18;
    fontSize /= h!;
    largeFontSize /= h!;
    // double smallFontSize = 14;
    smallFontSize /= h!;

    print('line 296: $h! $fontSize');

    return Scaffold(
        backgroundColor: color1,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Cancel Shifts",
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineLarge!.fontSize! / h!,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          leading: GestureDetector(
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size:
                      Theme.of(context).textTheme.headlineLarge!.fontSize! / h!,
                  color: Colors.black,
                ),
                onPressed: () {
                  final navigator = Navigator.of(context)
                      .pushNamed(hcpMenu, arguments: arguments!);
                  // final navigator = Navigator.of(context);
                  // navigator.pushReplacement(
                  //     MaterialPageRoute(builder: (BuildContext context) {
                  //   return ClientSchedulingMenu(
                  //       ctx: context, clientId: clientId);
                }),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                height: tableHeight,
                width: appWidth,
                child: FutureBuilder<dynamic>(
                  future: Future.wait([
                    getAllItems(),
                  ]),
                  builder: (context, snapshot) {
                    print(
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
                          height: 100,
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
                          child: Text('There are no shifts to be cancelled.',
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: color2,
                                  fontWeight: FontWeight.bold)),
                        ),
                      );
                    } else {
                      // dynamic ccl = snapshot.data; // cast to List<Marker>
                      // print('line 147: $ccl');
                      List<dynamic> allItems =
                          snapshot.data[0]; // cast to List<Marker>
                      print('line 111 ${allItems.length}');
                      if (allItems.length == 0) {
                        return Center(
                          child: Container(
                            height: 100,
                            child: Text('There are no shifts to be cancelled.',
                                style: TextStyle(
                                    fontSize: fontSize,
                                    color: color2,
                                    fontWeight: FontWeight.bold)),
                          ),
                        );
                      } else {
                        return Container(
                          width: appWidth,
                          height: 450,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Color.fromARGB(255, 19, 125, 103),
                                  width: 4),
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Container(
                                  height: 36,
                                  width: appWidth,
                                  child: FutureBuilder(
                                    future: Future.wait([
                                      getClientCancelReasons(),
                                    ]),
                                    builder: (context,
                                        AsyncSnapshot<List<dynamic>> snapshot) {
                                      debugPrint(
                                          'line 417 building FB ${snapshot.connectionState}');
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 30),
                                            child: Container(
                                              height: 110,
                                              child: Text(
                                                  'Error: ${snapshot.error}',
                                                  style: TextStyle(
                                                      fontSize: fontSize,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        );
                                      } else if (snapshot.data == [[]] &&
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        return Center(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 30),
                                            child: Container(
                                              height: 100,
                                              //  width: screenWidth! - 10,
                                              child: Text(
                                                  overflow:
                                                      TextOverflow.visible,
                                                  'There are no cancellation reasons for this client.',
                                                  style: TextStyle(
                                                      fontSize: fontSize,
                                                      color: color2,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        );
                                      } else {
                                        print(
                                            'line 544: ${snapshot.data![0]} ');
                                        List<dynamic> listH = snapshot.data![0];
                                        if (listH.length == 0) {
                                          print('line 548 check');
                                          return Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 30),
                                              child: Container(
                                                height: 100,
                                                //    width: screenWidth! - 10,
                                                child: Text(
                                                    'There are no cancellations reasons for this client.',
                                                    overflow:
                                                        TextOverflow.visible,
                                                    style: TextStyle(
                                                        fontSize: fontSize,
                                                        color: color2,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                          );
                                        } else {
                                          List<dynamic> listH =
                                              snapshot.data![0]!;
                                          print(
                                              'line 564: $selectedClientCancelReasonValue ${listH[0]}');
                                          return Container(
                                            height: 80,
                                            width: appWidth,
                                            child: DropdownButtonHideUnderline(
                                              child: Container(
                                                height: 36,
                                                width: appWidth! - 4,
                                                decoration: BoxDecoration(
                                                    color: flagShowRed == false
                                                        ? color1
                                                        : Colors.red,
                                                    border: Border.all(
                                                        color: Colors.black87),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: DropdownButton2<dynamic>(
                                                  isExpanded: true,
                                                  hint: Container(
                                                    height: 36,
                                                    width: appWidth! - 10,
                                                    child: Text(
                                                      'Select A Cancellation Reason',
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                  items: listH
                                                      .map((dynamic item) =>
                                                          DropdownItem<
                                                              dynamic>(
                                                            value: item,
                                                            child: Container(
                                                              height: 32,
                                                              width: appWidth! -
                                                                  10,
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  valueListenable:
                                                  valueListenableCancelReason,
                                                  onChanged:
                                                      (dynamic value) async {
                                                        valueListenableCancelReason
                                                            .value = value;
                                                    selectedClientCancelReasonValue =
                                                        value;
                                                    print('line 609: $value');
                                                    selectedClientCancelReasonIndex =
                                                        await getClientReasonIndex(
                                                            value);
                                                    print(
                                                        'line 1128: $selectedClientCancelReasonValue $value $selectedClientCancelReasonIndex ');
                                                    setState(() {
                                                      flagShowRed = false;
                                                      selectedClientCancelReasonValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                              //    )
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  )),
                              SizedBox(height: 10),
                              flagPublishedButtonDisabled == false
                                  ? SfDataGrid(
                                      allowColumnsResizing: true,
                                      onColumnResizeUpdate:
                                          (ColumnResizeUpdateDetails details) {
                                        setState(() {
                                          columnWidths[details.column
                                              .columnName] = details.width;
                                        });
                                        return true;
                                      },
                                      source: shiftCancelDataSource,
                                      columns: getColumnList(),
                                      allowEditing: false,
                                      onQueryRowHeight: (details) {
                                        // Set the row height as 70.0 to the column header row.
                                        return details.rowIndex == 0
                                            ? 70.0
                                            : 40.0;
                                      },
                                      gridLinesVisibility:
                                          GridLinesVisibility.horizontal,
                                      selectionMode: SelectionMode.multiple,
                                      onSelectionChanged:
                                          (addedRows, removedRows) {
                                        // Add newly selected rows to the flag variable.
                                        if (addedRows.isNotEmpty) {
                                          selectedList.addAll(addedRows);
                                        }

                                        // Remove deselected rows from the flag variable.
                                        if (removedRows.isNotEmpty) {
                                          selectedList.removeWhere((row) =>
                                              removedRows.contains(row));
                                        }
                                      },
                                      showCheckboxColumn: true,
                                      checkboxColumnSettings:
                                          DataGridCheckboxColumnSettings(
                                              label: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 3),
                                                child: Text(
                                                  'Can-cel',
                                                  style: TextStyle(
                                                      fontSize: fontSize,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              showCheckboxOnHeader: false),
                                    )
                                  : Container()
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                  height: 50,
                  width: appWidth! - 10,
                  decoration: BoxDecoration(
                      border: Border.all(color: color2),
                      borderRadius: BorderRadius.circular(12)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: flagPublishedButtonDisabled == false
                            ? Colors.white
                            : disabledColor),
                    child: flagPublishedButtonDisabled == false
                        ? Text(
                            'Cancel Selected Shifts',
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
                    onPressed: () async {
                      print('line 753: $flagPublishedButtonDisabled');
                      if (flagPublishedButtonDisabled == true) {
                        flagShowRed = true;
                        return;
                      }
                      print('line 656: ${selectedList}');
                      await processCanceledShiftsList(selectedList,
                          selectedClientCancelReasonValue, context);
                    },
                  )),
              SizedBox(height: 10),
              Container(
                  height: 50,
                  width: appWidth! - 10,
                  decoration: BoxDecoration(
                      // color: flagPublishedButtonDisabled == false ? Colors.white
                      //     : disabledColor,
                      border: Border.all(color: color2),
                      borderRadius: BorderRadius.circular(12)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: flagWaitDisabled == false
                          ? Colors.white
                          : disabledColor,
                    ),
                    child: flagWaitDisabled == false
                        ? Text(
                            'Clear Canceled Shifts and Exit',
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
                    onPressed: () async {
                      print('line 651: $flagPublishedButtonDisabled');
                      if (flagPublishedButtonDisabled == true) {
                        return;
                      }
                      Navigator.of(context).pop();
                    },
                  )),
            ],
          ),
        ));
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class ShiftCancelDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  ShiftCancelDataSource(
      {required List<ShiftCancel> shiftCancelData, required fontS}) {
    //  print('line 501 in constructor shiftcanceldatasource');
    _shiftCancelData = shiftCancelData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'shiftDate', value: e.shiftDate),
              DataGridCell<String>(columnName: 'shiftCode', value: e.shiftCode),
              DataGridCell<String>(
                  columnName: 'disciplineName', value: e.disciplineName),
              DataGridCell<String>(columnName: 'shiftName', value: e.shiftName),
              DataGridCell<int>(columnName: 'hcpId', value: e.hcpId),
              DataGridCell<String>(columnName: 'id', value: e.id),
            ]))
        .toList();
    fontSize = fontS;
  }

  List<DataGridRow> _shiftCancelData = [];
  double fontSize = 8;
  @override
  List<DataGridRow> get rows => _shiftCancelData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: e.columnName == 'shiftName'
            ? Alignment.centerLeft
            : Alignment.center,
        padding: const EdgeInsets.all(1.0),
        child: Text(e.value.toString(),
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: fontSize,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            )),
      );
    }).toList());
  }

  void updateDataGridSource({required RowColumnIndex rowColumnIndex}) {
    // print('line 759: $rowColumnIndex');
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }
}
