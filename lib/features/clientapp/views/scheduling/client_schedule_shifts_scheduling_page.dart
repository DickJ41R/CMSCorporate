//Client Schedule Shifts Scheduling Page
import 'package:cms_web/features/shared/utils/dropdown_codes.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
//import 'package:client_app/models/client_user.dart';
import 'package:cms_web/features/shared/services/cmsbranch/branch_services.dart';
//import 'package:cms_web/features/clientapp/views/scheduling/show_client_file_scheduling_menu.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//import 'package:client_app/screens/process_client_get_request_shifts.dart';
import 'package:cms_web/features/clientapp/views/scheduling/process_client_data_grid_shifts.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

final dio = Dio();


String globalBranchName = '';

class ProcessClientRequestSchedule extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessClientRequestSchedule({super.key,required this.args});

  @override
  ProcessClientRequestScheduleState createState() =>
      ProcessClientRequestScheduleState();
}

class ProcessClientRequestScheduleState
    extends State<ProcessClientRequestSchedule> {
  String? dropDownValue;
  DropDownCodes dropDownCodes = DropDownCodes();
  ClientServices clientServices = ClientServices();
  AuthService authService = AuthService();

  // TextEditingController _dateController = TextEditingController();
  int? clientId;
  String? userEmail;
  int? clientUserId;
  List<String>? listDepartments;
  List<String>? listOfDepartments;
  dynamic selectedDepartmentValue = null;

  List<TextEditingController> listDisciplinesControllers = [];

  BranchServices branchServices = BranchServices();
  UtilitiesServices util = UtilitiesServices();
  Color blankColor = Colors.grey.shade200;
  int departmentId = -1;
  int focusShift = -1;
  List<bool>? checkAllData;
  Map<String, dynamic> selectedDepartment = {};
  int selectedDepartmentIndex = -1;
  int selectedDepartmentId = -1;
  List<String>? listOfClientTokens;
  Color enableColor = Colors.green.shade200;
  Color disableColor = Colors.grey.shade200;
  bool hasDates = false;
  List<String> stringShiftDates = []; //'2024-04-26','2024-04-27','2024-05-02'];
  dynamic schedulingRate;
  List<String> listOfPnRates = [];
  List<dynamic> listShowShifts = [];
  List<dynamic> listOfDates = [];
  List<dynamic> listOfDatesWithShifts = [];
  int currentShiftIndex = -1;
  int currentSelectionIndex = -1;
  int selectedDisciplineIndex = -1;
  dynamic selectedDisciplineValue = null;
  int selectedPNRateIndex = -1;
  dynamic selectedPNRateValue = null;
  List<ShiftClass>? listOfShiftData;
  bool? flagAllData;
  bool flagPublishedButtonDisabled = false;
  String? scheduleNotes;
  TextEditingController pushNotificationFrequencyRate = TextEditingController();
  TextEditingController _popUpController = TextEditingController();
  List<TextEditingController> _textControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  int schedulerId = -1;
  List<Map<String, dynamic>> listOfHolidays = [];
  String schedulerName = '';
  List<Map<String, dynamic>> listClientDisciplines = [];
  List<Map<String, dynamic>> listClientDepartments = [];
  List<Map<String, dynamic>> listClientRates = [];
  List<Map<String, dynamic>> clientRateGroups = [];
  int? selectedDisciplineId;
  DateRangePickerSelectionMode _selectionMode =
      DateRangePickerSelectionMode.multiple;
  Map<String, dynamic>? currentUser;
  Map<String, dynamic>? clientUser;
  bool haveShifts = false;
  List<Map<String, dynamic>> listOfDisciplines = [];
  final _formKey = GlobalKey<FormState>();
  late List<Map<String, dynamic>> clientFCMToken;
  Color disabledTextColor = Colors.white;
  Color disabledColor = Color.fromARGB(255, 19, 125, 103);
  List<Map<String, dynamic>>? listOfShifts;
  List<Map<String, dynamic>>? holdListOfShifts;
  bool selectedDisciplineHasChanged = false;
  List<String> validShiftCodes = ['1', '2', '3', 'AP', 'PA'];
  List<Map<String, dynamic>>? listOfMapPnRates;
  void setPNRates() {
    listOfMapPnRates = [
      {"pnRateName": "All", "pnRateValue": "All"},
      {"pnRateName": "First", "pnRateValue": "First"},
      {"pnRateName": "Every 5th", "pnRateValue": "Every 5th"},
      {"pnRateName": "Every 10th", "pnRateValue": "Every 10th"},
      {"pnRateName": "None", "pnRateValue": "None"},
    ];
    listOfPnRates = ["All", "First", "Every 5th", "Every 10th", "None"];

    selectedPNRateValue = listOfPnRates[0];
  }

  Future<void> _getListOfHolidays(int clientId) async {
    List<Map<String, dynamic>>? lm =
    await clientServices.getListOfHolidays(clientId);
    if (lm != null) {
      listOfHolidays = lm;
    }
    print('line 135: ${listOfHolidays.length}');
  }

  bool hasDepartment = false;
  bool hasDiscipline = false;
  List<String>? holdSts = null;

  Future<List<String>> _getClientDepartments(int clientId) async {
    List<String> sts = [];
    try {
      List<Map<String, dynamic>> dps =
      await clientServices.getClientDepartment(clientId);
      print(' 137: $departmentIds $dps');
      if (dps.isNotEmpty) {
        listClientDepartments = dps;
        for (int i = 0; i < dps.length; i++) {
          var ob = dps[i];
          String st = ob[
          'departmentName']; // + '(' + ob['departmentId'].toString() + ')';
          sts.add(st);
          departmentIds.add(ob['departmentId']);
        }
        sts.sort((a, b) => (a.compareTo(b)));
        holdSts = sts;
      } else {
        throw Exception('line 156 no departments returned');
      }

      checkAllData![1] = false;
      return holdSts!;
    } catch (e) {
      print('line 145: error $e');
      throw Exception('Error getting client departments: ${e.toString()}');
    }
  }

  Map<String, dynamic>? arguments;

  List<DateTime> dateTimeList = [];
  @override
  void initState() {
    super.initState();
//    sendAnEmail();
    print('line 172 initstate: ');
    arguments = widget.args;
    print('line 174 initstate: $arguments');
    clientId = arguments!['clientId'];
    currentUser = authService.currentUser;

    print('line 176 in init schedule shifts');
    listOfClientTokens = [];
    if (currentUser!['iosFcmToken'] != null &&
        currentUser!['iosFcmToken'] != 'Placeholder') {
      listOfClientTokens!.add(currentUser!['iosFcmToken']);
    }
    if (currentUser!['iosFcmTabletToken'] != null &&
        currentUser!['iosFcmTabletToken'] != 'Placeholder') {
      listOfClientTokens!.add(currentUser!['iosFcmTabletToken']);
    }
    if (currentUser!['androidFcmToken'] != null &&
        currentUser!['androidFcmToken'] != 'Placeholder') {
      listOfClientTokens!.add(currentUser!['androidFcmToken']);
    }
    if (currentUser!['androidFcmTabletToken'] != null &&
        currentUser!['androidFcmTabletToken'] != 'Placeholder') {
      listOfClientTokens!.add(currentUser!['androidFcmTabletToken']);
    }

    flagAllData = false;
    checkAllData = [false, false, false, false, false];
    // clientId = ref
    //     .read(clientUserNotifierProvider.notifier)
    //      .fromClientId;
    print('line 246: $clientId');

    print('line 194 in didchange');
    setPNRates();
    _getListOfHolidays(clientId!);
    print('line 208 end of initstate');
  }

  Future<dynamic> _showDialog(
      BuildContext context, String title, String? description) async {
    print('line 398 showdialog');
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.of(context).pop(); // Close the dialog
    // });
    double fontSize = 18;
    if (MediaQuery.of(context).size.width >= 800) {
      fontSize = 24;
    }
    ;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text(title),
              content: Text(description!),
              contentTextStyle: TextStyle(
                color: Colors.black,
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
                    onPressed: () {
                      Navigator.of(ctx, rootNavigator: true).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 125, 103),
                      ),
                    )),
              ],
            ),
          );
        });
  }

  bool checkIsWeekend(int dayValue) {
    if (dayValue == 6 || dayValue == 7) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIsHoliday(
      DateTime date, Map<String, dynamic> shm, Map<String, dynamic> ehm) {
    print('line 80 data is a holiday: ${listOfHolidays.length}');
    try {
      DateTime shiftStartDate = date.subtract(Duration(
          hours: date.hour,
          minutes: date.minute,
          seconds: date.second,
          microseconds: date.microsecond,
          milliseconds: date.millisecond));
      DateTime shiftEndDate = date;
      shiftStartDate = shiftStartDate
          .add(Duration(hours: shm['hours'], minutes: shm['minutes']));
      shiftEndDate = shiftEndDate
          .add(Duration(hours: ehm['hours'], minutes: ehm['minutes']));
      bool isHoliday = false;
      for (int i = 0; i < listOfHolidays.length; i++) {
        Map<String, dynamic> hl = listOfHolidays[i];
        String sdt = hl['startDate'];

        if (sdt.indexOf('\/') != -1) {
          sdt = sdt.replaceAll('\/', '\-');
        }
        List<String> lsdt = sdt.split('-');
        String dte = lsdt[2] + '-' + lsdt[0] + '-' + lsdt[1];
        print('line 323: $dte');
        DateTime ndt = DateTime.parse(dte);
        print('line 325: ${date.year} ${date.month} ${date.day}');
        print(
            'line 326: ${hl['duration'].toString()} ${ndt.year} ${ndt.month} ${ndt.day}');
        int duration = int.parse(hl['duration'].toStringAsFixed(0));
        Map<String, dynamic> jhm = util.getHoursMinutes(hl['startTime']);
        print('line 330: $jhm');
        ndt = ndt.subtract(Duration(
            hours: ndt.hour,
            minutes: ndt.minute,
            seconds: ndt.second,
            microseconds: ndt.microsecond,
            milliseconds: ndt.millisecond));
        DateTime endt = ndt;
        endt = endt.add(Duration(hours: duration));
        print(
            'line 340: ${shiftStartDate.millisecondsSinceEpoch} ${ndt.millisecondsSinceEpoch} ${shiftEndDate.millisecondsSinceEpoch} ${endt.millisecondsSinceEpoch}');
        if (shiftStartDate.millisecondsSinceEpoch >=
            ndt.millisecondsSinceEpoch &&
            shiftEndDate.millisecondsSinceEpoch < endt.millisecondsSinceEpoch) {
          isHoliday = true;
          break;
        }
      }
      print('line 328: $isHoliday');
      return isHoliday;
    } catch (e) {
      print('line 347 error: ${e.toString()}');
      throw Exception('line 348 error date is a holiday: ${e.toString()}');
    }
  }

  bool toggleDaySelection = true;
  final valueListenableDiscipline = ValueNotifier<String?>(null);
  final valueListenableDepartment = ValueNotifier<String?>(null);
  final valueListenablePNRate = ValueNotifier<String?>(null);

  Future<bool> _presentGetShift(BuildContext ctx, dynamic dtm) async {
    print('line 331 presentgetshift: $dtm');
    if (dtm == null) {
      return false;
    }
    if (selectedDisciplineIndex == -1) {
      String title = 'Department/Discipline Error';
      String description = 'You must a select a discipline.';
      await _showDialog(context, title, description);
      return false;
    }
    try {
      print('line 314: $selectedDisciplineHasChanged $listOfShifts');
      if (selectedDisciplineHasChanged == true || listOfShifts == null) {
        print('line 315 getting listof shifts ${listOfShifts!.length}');
        listOfShifts = await _getRateAndShiftsByClientAndDiscipline(ctx);
        holdListOfShifts = [];
        for (int i = 0; i < listOfShifts!.length; i++) {
          Map<String, dynamic> mp = Map.from(listOfShifts![i]);
          holdListOfShifts!.add(mp);
        }
      }
      listOfShifts = [];
      int shiftIndex = -1;
      print('line 326');
      bool flagGotHit = false;
      //  int hcpId =0;
      if (listOfDatesWithShifts.length > 0) {
        for (int i = 0; i < listOfDatesWithShifts.length; i++) {
          dynamic lm = listOfDatesWithShifts[i];
          print('line 355: ${lm}');
          print('line 356: ${lm['date']} ${dtm}');
          if (lm['date'] == dtm) {
            shiftIndex = i;
            //  hcpId = lm['date']['hcpId'];
            flagGotHit = true;
            break;
          }
        }
      }
      Map<String, dynamic>? losd;
      if (shiftIndex != -1) {
        losd = listOfDatesWithShifts[shiftIndex];
      }
      print('line 363 $losd');
      for (int i = 0; i < holdListOfShifts!.length; i++) {
        Map<String, dynamic> mp = Map.from(holdListOfShifts![i]);
        if (losd != null) {
          List<dynamic> rd = losd['rate']['rateDetails'];
          print('line 368: ${rd}');
          for (int j = 0; j < rd.length; j++) {
            if (rd[j]['shiftCode'] == mp['shiftCode']) {
              mp['shiftCount'] = rd[j]['shiftCount'];
              //  mp['hcpId'] = hcpId;
              break;
            }
            print('line 413: $i $mp');
          }
        }
        listOfShifts!.add(mp);
      }
    } catch (e) {
      print('line 362 error getting rates from disiplines');
      await _showDialog(ctx, "Discipline Rate",
          "There are no valid discipline rates for the client.");
      Navigator.of(ctx).pop();
    }
    try {
      //
      //  List<Map<String,dynamic>> lmap = await Navigator.push(
      // context,
      // MaterialPageRoute(
      //  builder: (context) => ProcessClientGetRequestShifts(
      //  ctx: context,
      //  listOfHolidays: listOfHolidays,
      //  dateTime: dtm,
      //   discipline: selectedDisciplineValue,
      // listOfData: listOfShifts!,
      // fontSize: fontSize)));
      double sfontSize = 14;
      sfontSize /= h!;
      print('line 351 check');
      List<Map<String, dynamic>>? lmap = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProcessShiftDataGrid(
                  ctx: context,
                  listOfHolidays: listOfHolidays,
                  dateTime: dtm,
                  discipline: selectedDisciplineValue,
                  listOfData: listOfShifts!)));
      print('line 407: ${lmap}');
      if (lmap == null) {
        print('line 409 error no data returned from shift screen');
        throw Exception('No data returned from shfit screen.');
      }
      int i = 0;

      int shiftCounts = 0;

      int j = 0;
      List<Map<String, dynamic>> holdList = [];
      while (i < listOfShifts!.length) {
        dynamic jbj = listOfShifts![i];
        bool flagGotHit = false;
        j = 0;
        while (j < lmap.length) {
          Map<String, dynamic> obj = lmap[j];
          print('line 386: ${obj['shiftCode']} ${jbj['shiftCode']}');
          if (obj['shiftCode'] == jbj['shiftCode']) {
            jbj['shiftCount'] = int.parse(obj['shiftCount'].toString());
            print('line 426: ${obj['shiftCount']} ${jbj['shiftCount']}');
            if (jbj['shiftCount'] > 0) {
              shiftCounts += 1;
            }
//              listOfShifts![i] = jbj;
            holdList.add(Map.from(jbj));
            flagGotHit = true;
            break;
          }
          j += 1;
        }
        i += 1;
      }
      i = 0;
      if (shiftCounts == 0) {
        print('line 429 error no shifts picked up.');
        throw Exception('No shifts picked up.');
      }
      listOfShifts = holdList;
      print('line 441: ${listOfShifts!.length} ${listOfShifts![0]}');
      List<dynamic> newList = holdList;
      if (newList.length == 0) {
        //throw Exception('Error: No counts returned from schedule!');
        return false;
      }
      listOfShifts = [];
      for (int q = 0; q < newList.length; q++) {
        Map<String, dynamic> lbj = {
          'shiftCode': newList[q]['shiftCode'],
          'startTime': newList[q]['startTime'],
          'endTime': newList[q]['endTime'],
          'shiftCount': newList[q]['shiftCount'],
          // 'hcpId': newList[q]['hcpId']
        };
        listOfShifts!.add(lbj);
      }

      print('line 459: $newList');
      print('line 450: ${listOfShifts![0]}');

      List<dynamic> rates = clientRate!['rates'];
      print('line 452: ${listOfShifts!.length} $rates');
      rates[0]['scheduleRateDetails'] = newList;
      List<dynamic> rateDetails = rates[0]['rateDetails'];
      print('line 469: $rateDetails ${rates[0]['rateDetails'].length}');
      int s = 0;
      int r = 0;
      print('line 496 check ${rateDetails.length} ${listOfShifts!.length} ');
      //print('line 500: $newList');

      dynamic clientRateMap = rates[0];
      print('line 513 ${clientRateMap}');
      List<dynamic> newDetails = [];
      for (int z = 0; z < newList.length; z++) {
        for (int j = 0; j < rateDetails.length; j++) {
          if (rateDetails[j]['shiftCode'] == newList[z]['shiftCode']) {
            rateDetails[j]['shiftCount'] = newList[z]['shiftCount'];
            rateDetails[j]['shiftDate'] = dtm;
            bool isHoliday = false;
            bool isWeekend = false;
            Map<String, dynamic> shm =
            util.getHoursMinutes(newList[z]['startTime']);
            Map<String, dynamic> ehm =
            util.getHoursMinutes(newList[z]['endTime']);
            isHoliday = checkIsHoliday(dtm, shm, ehm);
            rateDetails[j]['isAHoliday'] = isHoliday;
            if (dtm.weekday == 6 || dtm.weekday == 7) {
              rateDetails[j]['isAWeekend'] = true;
            } else {
              rateDetails[j]['isAWeekend'] = false;
            }
            newDetails.add(rateDetails[j]);
            break;
          }
        }
        // rateDetails[z]['payRate'] = 0.0;
        // rateDetails[z]['payRateWE'] = 0.0;
        // rateDetails[z]['billRate'] = 0.0;
        // rateDetails[z]['billRateWE'] = 0.0;
      }
      for (int z = 0; z < newDetails.length; z++) {
        print('line 543: $z ${newDetails[z]}');
      }
      Map<String, dynamic> rateMap = {
        "branchId": clientRateMap!['branchId'],
        "branchName": clientRateMap!['branchName'],
        "rateGroupId": clientRateMap!['rateGroupId'],
        "rateId": clientRateMap!['rateId'],
        "disciplineId": selectedDisciplineId,
        "disciplineName": selectedDisciplineValue,
        "billDblRate": clientRateMap!['billDblRate'],
        "billDblPlusRate": clientRateMap!['billDblPlusRate'],
        "billHolidayPlusRate": clientRateMap!['billHolidayPlusRate'],
        "billHolidayRate": clientRateMap!['billHolidayRate'],
        "billMaxPlusRate": clientRateMap!['billMaxPlusRate'],
        "billMaxRate": clientRateMap!['billMaxRate'],
        "billOTPlusRate": clientRateMap!['billOTPlusRate'],
        "billOTRate": clientRateMap!['billOTRate'],
        "overridePayModifiers": clientRateMap!['overridePayModifiers'],
        "overrideBillModifiers": clientRateMap!['overrideBillModifiers'],
        "payDblPlusRate": clientRateMap!['payDblPlusRate'],
        "payDblRate": clientRateMap!['payDblRate'],
        "payHolidayPlusRate": clientRateMap!['payHolidayPlusRate'],
        "payHolidayRate": clientRateMap!['payHolidayRate'],
        "payMaxPlusRate": clientRateMap!["payMaxPlusRate"],
        "payMaxRate": clientRateMap!['payMaxRate'],
        "payOTPlusRate": clientRateMap!["payOTPlusRate"],
        "payOTRate": clientRateMap!['payOTRate'],
        "rateDetails": newDetails
      };
      print('line 525: $rateMap');

      Map<String, dynamic>? clientMap =
      await clientServices.getClient(clientId!);
      if (clientMap!.isEmpty) {
        throw Exception('Unable to get a client while setting rate data');
      }
      rates[0]['overtimeRule'] = clientMap['overtimeRule'];
      rates[0]['payHoliday'] = clientMap['payHolidayRate'];
      rates[0]['payHolidayPlus'] = clientMap['payHolidayRate'];
      rates[0]['payMaxRate'] = clientMap['payMaxRate'];
      rates[0]['payDbPlus'] = clientMap['payMaxRate'];
      rates[0]['payDbl'] = clientMap['payMaxRate'];
      rates[0]['payMax'] = clientMap['payMaxRate'];
      rates[0]['payMaxPlus'] = clientMap['payMaxRate'];
      rates[0]['payOT'] = 1.5;
      rates[0]['payOTPlus'] = 1.5;
      print('line 488: ${clientMap['clientId']}');
      print('line 489: $selectedDepartmentIndex $selectedDisciplineIndex');
      print(
          'line 490: ${listClientDepartments.length} ${listOfDisciplines.length}');
      Map<String, dynamic> department =
      listClientDepartments[selectedDepartmentIndex];
      Map<String, dynamic> discipline =
      listOfDisciplines[selectedDisciplineIndex];
      print(
          'line 493: ${department['departmentId']} ${discipline['disciplineId']}');
      List<String> stringDays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      bool isHoliday = false;

      Timestamp tms = Timestamp.fromDate(dtm);
      print('line 535: $clientUser');
      int schedulerId = clientUser!['genId'];
      String fullName =
          clientUser!['firstName'] + ' ' + clientUser!['lastName'];
      schedulerName = fullName;
      print('line 506 $rateMap');
      int q = 0;
      while (q < listOfDatesWithShifts.length) {
        if (listOfDatesWithShifts[q]['date'] == dtm) {
          listOfDatesWithShifts.removeAt(q);
          break;
        }
        q += 1;
      }
      print('line 537: $department');

      Map<String, dynamic> dm = {
        "date": dtm,
        "color": null,
        "dateTime": dtm,
        "dayValue": dtm.weekday,
        "dayValueString": stringDays[dtm.weekday - 1],
        "timeStamp": tms,
        "departmentId": department['departmentId'],
        "departmentName": department['departmentName'],
        "departmentIds": [department['departmentId']],
        "departmentNames": [department['departmentName']],
        "disciplineId": discipline['disciplineId'],
        "disciplineIds": [discipline['disciplineId']],
        "disciplineName": discipline['disciplineName'],
        "disciplineNames": discipline['disciplineName'],
        "holiday": isHoliday,
        "weekend": checkIsWeekend(dtm.weekday),
        "schedulerId": schedulerId,
        "schedulerName": schedulerName,
        "billDblPlusRate": clientRateMap!['billDblPlusRate'],
        "billDblRate": clientRateMap!['billDblRate'],
        "billHolidayPlusRate": clientRateMap!['billHolidayPlusRate'],
        "billHolidayRate": clientRateMap!['billHolidayRate'],
        "billMaxPlusRate": clientRateMap!['billMaxPlusRate'],
        "billMaxRate": clientRateMap!['billMaxRate'],
        "billOTPlusRate": clientRateMap!['billOTPlusRate'],
        "billOTRate": clientRateMap!['billOTRate'],
        "branchId": clientRateMap!['branchId'],
        "branchName": clientRateMap!['branchName'],
        "burden": clientRateMap!['burden'],
        "clientId": clientRateMap!['clientId'],
        "clientName": clientRateMap!['clientName'],
        "contract": clientRateMap!['contract'],
        "contractTemplateName": clientRateMap!['contractTemplateName'],
        "departments": [department],
        "disciplines": [discipline],
        "expirationDate": clientRateMap!['expirationDate'],
        "hcpId": 0,
        "hcpName": '',
        "lastModifiedDate": clientRateMap!['lastModifiedDate'],
        "nationalClient": clientRateMap!['nationalClient'],
        "orderId": clientRateMap!['orderId'],
        "overrideBillModifiers": clientRateMap!["overrideBillModifiers"],
        "overridePayModifiers": clientRateMap!['overridePayModifiers'],
        "payDblPlusRate": clientRateMap!['payDblPlusRate'],
        "payDblRate": clientRateMap!['payDblRate'],
        "payHolidayPlusRate": clientRateMap!['payHolidayPlusRat'],
        "payHolidayRate": clientRateMap!['payHolidayRate'],
        "payMaxPlusRate": clientRateMap!['payMaxPlusRate'],
        "payMaxRate": clientRateMap!['payMaxPlusRate'],
        "payOTPlusRate": clientRateMap!['payOTPlusRate'],
        "payOTRate": clientRateMap!['oatOTRate'],
        "quoteId": clientRateMap!['quoteId'],
        "rateGroupId": clientRateMap!['rateGroupId'],
        "rateGroupTypeCodeId": clientRateMap!['rateGroupTypeCodeId'],
        "rateGroupTypeName": clientRateMap!['rateGroupTypeName'],
        "rateGroupTypeValue": clientRateMap!['rateGroupTypeValue'],
        "rateType": clientRate!['rateType'],
        "rateTypeCodeId": clientRate!['rateTypeCodeId'],
        "rateTypeDescription": clientRate!['rateTypeDescription'],
        "rate": rateMap,
        "clientLatitude": clientMap['latitude'],
        "clientLongitude": clientMap['longitude'],
        "clientTimeZoneOffset": null,
        "workersCompCodeId": clientRate!['workersCompCodeId'],
        "workersCompType": clientRate!['workersCompType']
      };
      print('line 606: ${dm['workersCompCodeId']}');

      listOfDatesWithShifts.add(dm);
      print('line 609: ${listOfDatesWithShifts.length}');
      return true;
    } catch (e) {
      print('line 612 error: $e');
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<void> _showSnackBar(String text) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating, // This is key
        margin: EdgeInsets.only(
          bottom:
          MediaQuery.of(context).size.height * 0.05, // Adjust for tablet
          left: 10,
          right: 10,
        ),
        content: Text(text,
            style: TextStyle(
                fontSize: fontSize,
                color: Colors.blue,
                fontWeight: FontWeight.bold))));
  }

  Future<bool> _publishShiftInformation(context) async {
    print(
        'line 297 in publish shift information $scheduleNotes ${_textControllers[0].text}');
    int i = 0;
    String title = '';
    if (flagPublishedButtonDisabled) {
      return false;
    }
    try {
      String description = '';
      if (selectedDisciplineValue == null) {
        print('line 478 error');
        title = 'Discipline Error';
        description = 'You have not selected a discipline.';
        await _showDialog(context, title, description);
        return false;
      }
      if (selectedDepartmentValue == null) {
        print('line 485 error');
        title = 'Department Error';
        description = 'You have not selected a department.';
        await _showDialog(context, title, description);
        return false;
      }
      if (listOfDatesWithShifts.isEmpty) {
        print('line 492 error');
        title = 'Shifts Error';
        description = 'You must enter at least one shift.';
        await _showDialog(context, title, description);
        // await _showSnackBar(description);
        //print('line 727');
        return false;
      }
      selectedPNRateValue = valueListenablePNRate.value;
      if (selectedPNRateValue == 'All') {
        checkAllData![0] = true;
      }
      if (selectedPNRateValue == null) {
        print('line 524 error');
        title = 'Push Notification Error';
        description = 'You have not selected a push notification frequency.';
        await _showDialog(context, title, description);
        return false;
      }
      // if (checkAllData!.contains(false) == true) {
      //   print('line 528 error" $checkAllData');
      //   title = 'Data Error Error';
      //   description = 'You have not completed all required fields.';
      //   await _showDialog(context, title,  description);
      //   return;
      //
      // }

      // print('line 499: publish: $selectedDisciplineValue $checkBoxValue, $listDates');
      // print('line 500: ${selectedDisciplineValue.runtimeType}');
      // print('line 501: ${selectedDepartmentValue.runtimeType}');
      // print('line 502: ${schedulerId.runtimeType}');
      // print('line 503: ${schedulerName.runtimeType}');
      // print('line 504: ${checkBoxValue.runtimeType}');
      // print('line 506: ${_popUpController.text.runtimeType}');
      // print('line 507: ${ clientUser['userId'].runtimeType}');
      // print('line 508: ${ pushNotificationFrequencyRate.text.runtimeType}');
      // print('line 509: ${ user!.fcmToken.runtimeType}');
      // print('line 510: ${ testerFcmToken.runtimeType}');
      setState(() {
        disabledTextColor = Colors.white;
        disabledColor = Colors.orange;
        flagPublishedButtonDisabled = true;
      });
      bool premiumRate = false; //premiumRateCheckBox.checked;
      if (scheduleNotes == null || scheduleNotes!.isEmpty) {
        scheduleNotes = 'None';
      }
      print('line 697: ${listOfDatesWithShifts.length}');
      bool flagGoOn = false;
      for (int i = 0; i < listOfDatesWithShifts.length; i++) {
        Map<String, dynamic> mpd = listOfDatesWithShifts[i];
        print('line 782: $i $mpd');
        List<dynamic> listDetails = mpd['rate']['rateDetails'];
        print('line 684 ${listDetails.length}');
        flagGoOn = false;
        for (int j = 0; j < listDetails.length; j++) {
          dynamic ld = listDetails[j];
          print('line 688 $j $ld ${ld['shiftCount']}');
          if (ld['shiftCount'] == null) {
            ld['shiftCount'] = 0;
            continue;
          }
          if (ld['shiftCount'] > 0) {
            flagGoOn = true;
            break;
          }
        }
      }

      if (flagGoOn == false) {
        print('line 700 error No Shift counts for one of your shifts.');
        throw Exception(('line 701 No shift counts'));
      }

      print('line 806 $scheduleNotes, $clientId');
      List<dynamic>? count = await clientServices.createSchedulingWorkOrder(
          listOfDatesWithShifts,
          scheduleNotes!,
          selectedPNRateValue,
          clientId!,
          listOfClientTokens!,
          premiumRate,
          clientUserId!,
          context);
      print('line 809 true: ${count}');
      title = 'Shift Publication';
      double ctn = 0;
      if (count != []) {
        ctn = count![0];
      }
      if (ctn > 0) {
        description =
        'You have successfully published employee(s) for your shift(s).  You will receive a notification when there are responses.';
      } else {
        description =
        'No HCPs were scheduled. If you cannot determine the cause, contact your CMS coordinator.';
      }
      await _showDialog(context, title, description);
      return true;
    } catch (e) {
      print('line 736 $e');
      // String te = e.toString();
      // te = te.replaceAll('Exception: Exception:', 'Exception:');
      // title = 'Shift Publication';
      // description =
      //     'You have not published your shift(s). There were errors: ' + te;
      // await _showDialog(context, title, description);
      return false;
    }
  }

  List<dynamic> listShowDates = [];
  int listOfDateType = 1;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();

    // Dispose of the focus node when the widget is removed from the widget tree
    //  ref.read(disciplineNotifierProvider.notifier).disposeFocusNodes();
  }

  bool enabled = true;
  int _getPNRateIndex(dynamic value) {
    checkAllData![4] = true;
    int ii = -1;
    for (int i = 0; i < listOfPnRates.length; i++) {
      if (value == listOfPnRates[i]) {
        ii = i;
        break;
      }
    }
    return ii;
  }

  Future<int> _getDisciplineIndex(BuildContext ctx, dynamic value) async {
    print('line 714 in getdicipindex $value');
    try {
      // int idx = value.indexOf('(');
      // String val = value.toString().substring(0, idx).trim();
      // String stx = value.substring(idx);
      // stx = stx.replaceAll('(', '');
      // stx = stx.replaceAll((')'), '');
      print('line 721: $value');
      bool flagGotHit = false;
      selectedDisciplineHasChanged = false;
      int sel = 0;
      for (int j = 0; j < listOfDisciplines.length; j++) {
        dynamic tb = listOfDisciplines[j];
        print('line 726: ${tb['disciplineId']} $value ${tb['disciplineName']}');
        if (tb['disciplineDescription'] == value) {
          selectedDisciplineId = tb['disciplineId'];
          selectedDisciplineValue = value;
          flagGotHit = true;
          selectedDisciplineIndex = j;
          sel = j;
          selectedDisciplineHasChanged = true;
          break;
        }
      }
      print('line 734 ${listOfDisciplines[sel]}');
      checkAllData![0] = true;
      listOfShiftData = [];
      listOfDatesWithShifts = [];
      departmentIds = [];
      listOfShifts = await _getRateAndShiftsByClientAndDiscipline(ctx);
      if (listOfShifts == null || listOfShifts!.length == 0) {
        throw Exception('No Valid rate data for client and discipline.');
      }
      print('line 737: ${listOfShifts!.length}');
      for (int i = 0; i < listOfShifts!.length; i++) {
        print('line 740: $i ${listOfShifts![i]}');

        dynamic sb = ShiftClass.fromJson(listOfShifts![i]);

        print('line 742: $listOfShiftData $sb');
        listOfShiftData!.add(sb);
      }
      print('line 892: ${clientRate}');
      listOfDepartments = await _getClientDepartments(clientId!);
      print('line 850: ${listOfDepartments}');
      for (int i = 0; i < clientRate!['departments'].length; i++) {
        int depId = -1;
        if (clientRate!['departments'][i]['departmentId'] == null) {
          for (int j = 0; j < listClientDepartments.length; j++) {
            String dpn = listClientDepartments[j]['departmentName'];
            if (dpn.contains(clientRate!['departments'][i]['departmentName'])) {
              depId = listClientDepartments[j]['departmentId'];
              break;
            }
          }
          if (depId == -1) {
            depId = i + 1;
          }
          clientRate!['departments'][i]['departmentId'] = depId;
          departmentIds.add(clientRate!['departments'][i]['departmentId']);
        }
      }

      print('line 870 dept length: ${departmentIds.length}');
      print('line 889 deparmentids: $selectedDisciplineIndex ${departmentIds}');
      return selectedDisciplineIndex;
    } catch (e) {
      print('line 876 error: $e');
      throw Exception('line 479 error: ${e.toString()}');
    }
  }

  int _getDepartmentIndex(dynamic value) {
    // int idx = value.indexOf('(');
    //String val = value.substring(0, idx).trim();
    int ii = -1;
    for (int i = 0; i < listClientDepartments.length; i++) {
      if (value == listClientDepartments[i]['departmentName']) {
        selectedDepartmentId = listClientDepartments[i]['departmentId'];
        selectedDepartmentValue = listClientDepartments[i]['departmentName'];
        print('line 818: $i $selectedDepartmentId $selectedDepartmentValue');
        checkAllData![1] = true;
        hasDepartment = true;
        ii = i;
        break;
      }
    }

    return ii;
  }

  Map<String, dynamic>? clientRateMap;
  List<Map<String, dynamic>> listDisciplinesMap = [];
  Map<String, dynamic>? clientRate;
  List<int> departmentIds = [];

  Future<List<Map<String, dynamic>>>? _getRateAndShiftsByClientAndDiscipline(
      BuildContext ctx) async {
    print('line 842 getratedisciplines $selectedDisciplineValue');
    try {
      Map<String, dynamic> sm = listOfDisciplines[selectedDisciplineIndex];
      print('line 858: ${sm}');
      clientRate = await clientServices.getShiftsByClientAndDiscipline(
          clientId!, selectedDisciplineValue, sm['rateGroupId']);
      print('line 846: $clientRate!');

      List<dynamic> rateDetails = clientRate!['rates'][0]['rateDetails'];
      listOfShifts = [];
      print('line 850:  ${rateDetails.length} $rateDetails');
      for (int i = 0; i < rateDetails.length; i++) {
        if (rateDetails[i]['startTime'] == null) {
          continue;
        }
        if (rateDetails[i]['endTime'] == null) {
          continue;
        }
        Map<String, dynamic> shift = {
          "shiftCode": rateDetails[i]['shiftCode'],
          "startTime": rateDetails[i]['startTime'] == null
              ? ""
              : rateDetails[i]['startTime'],
          "endTime": rateDetails[i]['endTime'] == null
              ? ""
              : rateDetails[i]['endTime'],
          "shiftCount": 0,
        };
        listOfShifts!.add(shift);
      }
      print('line 870: ${listOfShifts!.length} ${listOfShifts![0]}');
      return listOfShifts!;
    } catch (e) {
      print('line 873 no valid discipline with rates returned $e');
      await _showDialog(ctx, "Discipline Rate",
          "There are no valid rate data for the client's discpline");
      Navigator.of(ctx).pop();
      return [];
    }
  }

  final DateRangePickerController _controller = DateRangePickerController();
  DateTime? selectedDate;
  List<DateTime> selectedDates = [];
  bool checkBoxValue = false;
  List<String>? listStsHold = null;
  List<String>? listStringDisciplines;

  Future<List<String>> getDisciplinesForDropDown() async {
    print('line 1030 in get disciplines for dropdonw');

    try {
      List<Map<String, dynamic>>? lst;
      if (listStsHold == null) {
        lst = await clientServices.getDisciplinesFromClientRates(clientId!);
        listStringDisciplines = [];
        for (int i = 0; i < lst!.length; i++) {
          Map<String, dynamic> dm = lst[i];
          // if (i == 0) {
          //   selectedDisciplineId = dm['disciplineId'];
          // }
          String st = dm[
          'disciplineDescription']; //' (' + dm['disciplineId'].toString() + ')';
          if (listStringDisciplines!.contains(st) == false) {
            listStringDisciplines!.add(st);
          }
        }
        listOfDisciplines = lst;
        listStsHold = listStringDisciplines;
        //    selectedDisciplineValue = listStringDisciplines![0];
        //    selectedDisciplineIndex = 0;
      }
      checkAllData![0] = false;
      return listStringDisciplines!;
    } catch (e) {
      print('line 858 error getting disciplines: $e');
      return [];
    }
  }

  void _checkData() {
    flagAllData = false;
    if (selectedDisciplineValue != null) {
      checkAllData![0] = true;
    }
  }

  double? screenAreaHeight;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;
  double? h;
  @override
  Widget build(BuildContext context) {
    print('line 103 in showaccepted ashifts');
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 16;
    fontSize /= h!;
    double height = 30;
    screenAreaHeight = 220;
    if (screenWidth! > 400 && screenWidth! <= 600) {
      height = 32;
      fontSize = 18;
    } else if (screenWidth! > 600 && screenWidth! < 800) {
      height = 36;
      fontSize = 22;
      screenAreaHeight = 200;
    } else if (screenWidth! >= 800) {
      fontSize = 26;
      height = 45;
      screenAreaHeight = 270;
    }
    height = 30;
    double smallFontSize = 14;
    smallFontSize /= h!;
    print('line 1124: $h $fontSize $screenWidth! $screenHeight $h');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color2,
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
        title: Text("Publish Shift - ${clientId!}",
            style: TextStyle(
              fontSize: fontSize < 18 ? 18 : fontSize,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight! - 90,
            width: screenWidth! - 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Container(
                    height: 100,
                    width: screenWidth! - 10,
                    child: FutureBuilder(
                        future: Future.wait([
                          getDisciplinesForDropDown(),
                        ]),
                        builder:
                            (context, AsyncSnapshot<List<dynamic>> snapshot) {
                          debugPrint(
                              'line 1076 building FB ${snapshot.connectionState}');
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Container(
                                  height: 100,
                                  child: Text('Error: ${snapshot.error}',
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            );
                          } else if (snapshot.data == [[]] &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Container(
                                  height: 100,
                                  //  width: screenWidth! - 10,
                                  child: Text(
                                      overflow: TextOverflow.visible,
                                      'There are no disciplines for this client.',
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          color: color2,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            );
                          } else {
                            List<String> listH = snapshot.data![0];
                            print('line 111 ${listH.length}');
                            if (listH.length == 0) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Container(
                                    height: 100,
                                    //    width: screenWidth! - 10,
                                    child: Text(
                                        'There are no disciplines for this client.',
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                            fontSize: fontSize,
                                            color: color2,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              );
                            } else {
                              List<String> listD = snapshot.data![0]!;
                              print('line 1156: ${listD.length}');
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: height,
                                      width: screenWidth! - 10,
                                      decoration: BoxDecoration(
                                          color: color1,
                                          border: Border.all(
                                              color: Colors.black87, width: 3),
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<dynamic>(
                                            isExpanded: true,
                                            hint: Container(
                                              height: height,
                                              width: screenWidth! - 10,
                                              child: Text(
                                                'Select Discipline',
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87),
                                              ),
                                            ),
                                            items: listD
                                                .map((String item) =>
                                                DropdownItem<String>(
                                                  value: item,
                                                  height: height,
                                                  child: Text(
                                                    maxLines: 1,
                                                    item,
                                                    style: TextStyle(
                                                      fontSize: fontSize,
                                                    ),
                                                  ),
                                                ))
                                                .toList(),
                                            valueListenable:
                                            valueListenableDiscipline,
                                            onChanged: (newValue) async {
                                              print(
                                                  'line 1189: $selectedDisciplineValue $newValue');
                                              int idx = await _getDisciplineIndex(
                                                  context, newValue);
                                              setState(() {
                                                checkAllData![0] = true;
                                                selectedDisciplineIndex = idx;
                                                selectedDisciplineValue = newValue;
                                                valueListenableDiscipline.value =
                                                    newValue;
                                                listDepartments = listOfDepartments;
                                              });
                                              print(
                                                  'line 1202: ${listDepartments}');
                                            },
                                          )),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  selectedDisciplineIndex != -1
                                      ? Expanded(
                                    child: Container(
                                      height: height,
                                      width: screenWidth! - 4,
                                      decoration: BoxDecoration(
                                          color: color1,
                                          border: Border.all(
                                              color: Colors.black87,
                                              width: 3),
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<dynamic>(
                                          isExpanded: true,
                                          hint: Container(
                                            height: height,
                                            width: screenWidth! - 10,
                                            child: Text(
                                              'Select Department',
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          items: listDepartments!
                                              .map((String item) =>
                                              DropdownItem<String>(
                                                value: item,
                                                height: height,
                                                child: Text(
                                                  item,
                                                  style: TextStyle(
                                                    fontSize:
                                                    fontSize,
                                                  ),
                                                  overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                                ),
                                              ))
                                              .toList(),
                                          valueListenable:
                                          valueListenableDepartment,
                                          onChanged: (value) {
                                            valueListenableDepartment
                                                .value = value;
                                            selectedDepartmentIndex =
                                                _getDepartmentIndex(
                                                    value);
                                            print(
                                                'line 1128: $selectedDepartmentIndex');
                                            setState(() {
                                              selectedDepartmentValue =
                                                  value;
                                              checkAllData![1] = true;
                                            });
                                          },
                                        ),
                                      ),
                                      //    )
                                    ),
                                  )
                                      : Container()
                                ],
                              );
                            }
                          }
                        })),
                Container(
                  height: 32,
                  width: screenWidth! - 10,
                  child: Text('Select Schedule Dates',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                (selectedDepartmentIndex != -1 && selectedDisciplineIndex != -1)
                    ? SafeArea(
                  child: Container(
                    height: screenAreaHeight,
                    width: screenWidth! - 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Container(
                              height: screenAreaHeight,
                              width: screenWidth! - 10,
                              child: SfDateRangePicker(
                                showActionButtons: false,
                                onSelectionChanged:
                                    (DateRangePickerSelectionChangedArgs
                                args) async {
                                  print(
                                      'line 1310: ${dateTimeList.length} ${args} ${args.value}');
                                  if (selectedDisciplineIndex == -1 ||
                                      selectedDepartmentIndex == -1) {
                                    _showDialog(context, "Missing Data",
                                        "You must select both a discipline and a department before adding shifts.");
                                    return;
                                  }
                                  bool flagFoundMatch = true;
                                  List<int> keyValues = [];
                                  if (dateTimeList.length > 0) {
                                    for (int i = 0;
                                    i < dateTimeList.length;
                                    i++) {
                                      flagFoundMatch = false;
                                      for (int j = 0;
                                      j < args.value.length;
                                      j++) {
                                        if (dateTimeList[i] ==
                                            args.value[j]) {
                                          flagFoundMatch = true;
                                          keyValues.add(i);
                                          keyValues.add(j);
                                          flagFoundMatch = true;
                                          break;
                                        }
                                      }
                                      if (keyValues.length > 0) {
                                        break;
                                      }
                                    }
                                  }

                                  print(
                                      'line 1343: $flagFoundMatch ${args.value} ${dateTimeList}');
                                  DateTime? dateTimeObj;
                                  if (flagFoundMatch == false &&
                                      args.value.length > 0) {
                                    dateTimeList.add(args
                                        .value[args.value.length - 1]);
                                    dateTimeObj =
                                    args.value[args.value.length - 1];
                                  } else if (args.value.length > 0) {
                                    dateTimeObj =
                                    args.value[args.value.length - 1];
                                  }
                                  if (args.value.length > 0) {
                                    print(
                                        'line 1357: ${dateTimeObj.toString()}');
                                    bool? bl = await _presentGetShift(
                                        context, dateTimeObj);
                                    //   }
                                  }
                                },
                                controller: _controller,
                                showNavigationArrow: true,
                                allowViewNavigation: true,
                                view: DateRangePickerView.month,
                                headerStyle: DateRangePickerHeaderStyle(
                                    backgroundColor: color1,
                                    textAlign: TextAlign.center,
                                    textStyle: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: fontSize,
                                        letterSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                monthCellStyle:
                                DateRangePickerMonthCellStyle(
                                  todayTextStyle: TextStyle(
                                    color: color2,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textStyle: TextStyle(
                                    color: color2,
                                    fontSize: fontSize,
                                  ),
                                  cellDecoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black87,
                                        width: 3), //Border.all
                                    shape: BoxShape.rectangle,
                                  ),
                                  // trailingDatesDecoration: BoxDecoration(
                                  //     shape: BoxShape.rectangle),
                                  // leadingDatesDecoration: BoxDecoration(
                                  //     shape: BoxShape.rectangle),
                                ),
                                yearCellStyle:
                                DateRangePickerYearCellStyle(
                                  textStyle: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  disabledDatesTextStyle: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  todayTextStyle: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  leadingDatesTextStyle: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                enablePastDates: false,
                                toggleDaySelection: toggleDaySelection,
                                todayHighlightColor: color1,
                                selectionMode: _selectionMode,
                                monthViewSettings:
                                DateRangePickerMonthViewSettings(
                                    firstDayOfWeek: 1,
                                    showTrailingAndLeadingDates:
                                    true),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    : Container(),
                //end of datepicker
                SizedBox(height: 10),
                (selectedDepartmentIndex != -1 && selectedDisciplineIndex != -1)
                    ? SizedBox(
                  height: 40,
                  width: screenWidth! -10,
                  child: Container(
                    // child: Column(
                    //   children: [
                    //     Container(
                    //       height: 32,
                    //       width: screenWidth! - 10,
                    //       child: Text('Select Push Notification Frequency',
                    //           style: TextStyle(
                    //             fontSize: fontSize,
                    //             fontWeight: FontWeight.bold,
                    //           )),
                    //     ),
                    //     Expanded(

                      height: height,
                      width: screenWidth! - 10,
                      decoration: BoxDecoration(
                        color: color1,
                        border:
                        Border.all(width: 3, color: Colors.black87),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<dynamic>(
                          isExpanded: true,
                          hint: Container(
                            height: height,
                            width: screenWidth! - 10,
                            child: Text(
                              'Select Push Notification Frequency',
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                          items: listOfPnRates
                              .map((String item) => DropdownItem<String>(
                            value: item,
                            height: height,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: fontSize,
                              ),
                            ),
                          ))
                              .toList(),
                          valueListenable: valueListenablePNRate,
                          onChanged: (value) {
                            print('line 455: $selectedPNRateValue $value');
                            selectedPNRateIndex = _getPNRateIndex(value);
                            pushNotificationFrequencyRate.text = value;
                            setState(() {
                              valueListenablePNRate.value = value;

                              selectedPNRateValue = value;
                              checkAllData![4] = true;
                            });
                          },
                        ),
                      )

                    //     ],
                    //   ),
                  ),
                )
                    : Container(),
                Container(
                  height: 1,
                  child: SizedBox(height: 10),
                ),
                (selectedDepartmentIndex != -1 && selectedDisciplineIndex != -1)
                    ? Expanded(
                  child: Container(
                    height: height,
                    width: screenWidth! - 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: disabledColor),
                          onPressed: (flagPublishedButtonDisabled
                              ? null
                              : () async {
                            Navigator.pop(context);
                          }),
                          child: Container(
                              height: height,
                              width: 100,
                              child: Center(
                                child: Text(
                                    flagPublishedButtonDisabled
                                        ? "Wait..."
                                        : "Cancel",
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: disabledTextColor,
                                    )),
                              )),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: disabledColor),
                          onPressed: (() async {
                            _checkData();
                            // if (flagAllData == true) {
                            bool result =
                            await _publishShiftInformation(context);
                            if (result == true) {
                              Navigator.pop(context);
                            }
                          }),
                          child: Container(
                              height: height,
                              width: 100,
                              // decoration: BoxDecoration(
                              //     color: Colors.grey[200],
                              //     border: Border.all(color: Colors.black87),
                              //     borderRadius: BorderRadius.circular(12)
                              // ),
                              child: Center(
                                child: Text(
                                    flagPublishedButtonDisabled
                                        ? "Wait..."
                                        : "Publish",
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: disabledTextColor)),
                              )),
                        ),
                      ],
                    ),
                  ),
                )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:cms_web/features/shared/utils/routerconstants.dart';
// import 'package:flutter/material.dart';
// import 'package:cms_web/features/shared/utils/dropdown_codes.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
// import 'package:cms_web/features/clientapp/models/client_user.dart';
// import 'package:cms_web/features/branchcorporateapp/services/branch_services.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// //import 'package:client_app/screens/process_client_get_request_shifts.dart';
// import 'package:cms_web/features/clientapp/views/scheduling/process_client_data_grid_shifts.dart';
// import 'package:dio/dio.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cms_web/features/shared/utils/utilities.dart';
// import 'package:cms_web/features/authentication/services/auth_service.dart';
//
// class ClientScheduleShiftsSchedulingPage extends StatefulWidget {
//   final Map<String, dynamic> args;
//   const ClientScheduleShiftsSchedulingPage({super.key, required this.args});
//
//   @override
//   State<ClientScheduleShiftsSchedulingPage> createState() =>
//       _ClientScheduleShiftsSchedulingPageState();
// }
//
// final dio = Dio();
//
// final DropDownCodes dropDownCodes = DropDownCodes();
// final ClientServices clientServices = ClientServices();
//
// String globalBranchName = '';
//
// class _ClientScheduleShiftsSchedulingPageState
//     extends State<ClientScheduleShiftsSchedulingPage> {
//   String? dropDownValue;
//
//   // TextEditingController _dateController = TextEditingController();
//   late int? clientId;
//   late String? userEmail;
//   List<dynamic> listDepartments = [];
//   List<dynamic> listOfDepartments = [];
//   dynamic selectedDepartmentValue = null;
//
//   List<TextEditingController> listDisciplinesControllers = [];
//   ClientServices clientServices = ClientServices();
//   BranchServices branchServices = BranchServices();
//   UtilitiesServices util = UtilitiesServices();
//   AuthService authServices = AuthService();
//
//   Color blankColor = Colors.grey.shade200;
//   int departmentId = -1;
//   int focusShift = -1;
//   List<bool>? checkAllData;
//   Map<String, dynamic> selectedDepartment = {};
//   int selectedDepartmentIndex = -1;
//   int selectedDepartmentId = -1;
//   Color enableColor = Colors.green.shade200;
//   Color disableColor = Colors.grey.shade200;
//   bool hasDates = false;
//   List<String> stringShiftDates = []; //'2024-04-26','2024-04-27','2024-05-02'];
//   dynamic schedulingRate;
//   List<dynamic> listOfPnRates = [];
//   List<dynamic> listShowShifts = [];
//   List<dynamic> listOfDates = [];
//   List<dynamic> listOfDatesWithShifts = [];
//   int currentShiftIndex = -1;
//   int currentSelectionIndex = -1;
//   int selectedDisciplineIndex = -1;
//   dynamic selectedDisciplineValue = null;
//   int selectedPNRateIndex = -1;
//   dynamic selectedPNRateValue = null;
//   List<ShiftClass>? listOfShiftData;
//   Map<String, dynamic>? clientFCMToken;
//   Map<String, dynamic>? testerFCMToken;
//
//   bool? flagAllData;
//   bool flagPublishedButtonDisabled = false;
//   int? testerUserId;
//   String? scheduleNotes;
//   TextEditingController pushNotificationFrequencyRate = TextEditingController();
//   TextEditingController _popUpController = TextEditingController();
//   List<TextEditingController> _textControllers = [
//     TextEditingController(),
//     TextEditingController(),
//     TextEditingController(),
//     TextEditingController(),
//     TextEditingController()
//   ];
//
//   int schedulerId = -1;
//   List<Map<String, dynamic>> listOfHolidays = [];
//   String schedulerName = '';
//   List<Map<String, dynamic>> listClientDisciplines = [];
//   List<Map<String, dynamic>> listClientDepartments = [];
//   List<Map<String, dynamic>> listClientRates = [];
//   List<Map<String, dynamic>> clientRateGroups = [];
//   int? selectedDisciplineId;
//   DateRangePickerSelectionMode _selectionMode =
//       DateRangePickerSelectionMode.multiple;
//   bool haveShifts = false;
//   List<Map<String, dynamic>> listOfDisciplines = [];
//   final _formKey = GlobalKey<FormState>();
//   Color disabledTextColor = Colors.white;
//   Color disabledColor = Color.fromARGB(255, 19, 125, 103);
//   List<Map<String, dynamic>>? listOfShifts;
//   List<Map<String, dynamic>>? holdListOfShifts;
//   bool selectedDisciplineHasChanged = false;
//   List<String> validShiftCodes = ['1', '2', '3', 'AP', 'PA'];
//   void _checkData() {
//     flagAllData = false;
//     if (selectedDisciplineValue != null) {
//       checkAllData![0] = true;
//     }
//   }
//
//   void setPNRates() {
//     listOfPnRates = [
//       {"pnRateName": "All", "pnRateValue": "All"},
//       {"pnRateName": "First", "pnRateValue": "First"},
//       {"pnRateName": "Every 5th", "pnRateValue": "Every 5th"},
//       {"pnRateName": "Every 10th", "pnRateValue": "Every 10th"},
//     ];
//     selectedPNRateValue = listOfPnRates[0]['pnRateName'];
//   }
//
//   Future<void> _getListOfHolidays(int clientId) async {
//     List<Map<String, dynamic>>? lm =
//         await clientServices.getListOfHolidays(clientId);
//     if (lm != null) {
//       listOfHolidays = lm;
//     }
//     print('line 135: ${listOfHolidays.length}');
//   }
//
//   bool hasDepartment = false;
//   bool hasDiscipline = false;
//   List<String>? holdSts = null;
//   Future<List<String>> _getClientDepartments(List<int> departmentIds) async {
//     List<String> sts = [];
//     int departmentId = 0;
//
//     try {
//       if (holdSts == null) {
//         List<Map<String, dynamic>> dps =
//             await clientServices.getClientDepartment(clientId!);
//         print('line 145: $departmentIds $dps');
//         if (dps.isNotEmpty) {
//           listClientDepartments = dps;
//           for (int i = 0; i < dps.length; i++) {
//             var ob = dps[i];
//             String st = ob[
//                 'departmentName']; // + '(' + ob['departmentId'].toString() + ')';
//             sts.add(st);
//           }
//           sts.sort((a, b) => (a.compareTo(b)));
//           holdSts = sts;
//         } else {
//           throw Exception('line 156 no departments returned');
//         }
//         // sts.insert(0, "Not Specified");
//         //selectedDepartmentIndex = 0;
//         //  selectedDepartmentValue = sts[0];
//         // selectedDepartmentId = 0;
//       }
//       checkAllData![1] = false;
//       return holdSts!;
//     } catch (e) {
//       print('line 145: error $e');
//       throw Exception('Error getting client departments: ${e.toString()}');
//     }
//   }
//
//   Map<String, dynamic>? clientUserMap;
//   Map<String, dynamic>? arguments;
//   List<DateTime> dateTimeList = [];
//   Map<String, dynamic>? clientMap;
//
//   void _getClientX(BuildContext context) async {
//     print('line 173 _getClientX');
//     await _getClient(context);
//     print('line 175');
//   }
//
//   Future<void> _getClient(BuildContext context) async {
//     print('line 178 _getClientUsers');
//     try {
//       Map<String, dynamic>? cmp = await clientServices.getClient(clientId!);
//       if (cmp == null) {
//         throw Exception('No client returned from query');
//       }
//       if (cmp!.containsKey('clientId') == false) {
//         throw Exception('No client returned from query');
//       }
//       clientMap = cmp;
//       print('line 205');
//       return;
//     } catch (e) {
//       print('line 210 error: ${e.toString()}');
//       //exit
//       Navigator.of(context)
//           .pushNamed(clientSchedulingMenu, arguments: arguments!);
//     }
//   }
//
//   void _getClientUsersX(BuildContext context) async {
//     print('line 173 _getClientUsersX');
//     await _getClientUsers(context);
//     print('line 175');
//   }
//
//   Future<void> _getClientUsers(BuildContext context) async {
//     print('line 178 _getClientUsers');
//     try {
//       print('line 214: ${authServices}');
//       print('line 215: ${authServices.clientUserMap}');
//       if (authServices.clientUserMap == null) {
//         print('line 217 ${authServices}');
//         clientUserMap = await clientServices.getASingleClientUser(clientId!);
//         print('line 219: $clientUserMap');
//         authServices.clientUserMap = clientUserMap;
//       } else {
//         clientUserMap = authServices.clientUserMap!;
//       }
//       print('line 224 $clientUserMap');
//
//       if (clientUserMap!.containsKey('fcmToken') == true) {
//         clientFcmToken = clientUserMap!['fcmToken'];
//         clientFCMToken = clientUserMap!['fcmTokens'][0];
//         testerFCMToken = clientUserMap!['fcmTokens'][0];
//       }
//       userEmail = clientUserMap!['email'];
//       print('line 231: $clientUserMap');
//       return;
//     } catch (e) {
//       print('line 231 error: ${e.toString()}');
//       //exit
//       Navigator.of(context)
//           .pushNamed(clientSchedulingMenu, arguments: arguments!);
//     }
//   }
//
//   String? clientFcmToken;
//   @override
//   void initState() {
//     super.initState();
// //    sendAnEmail();
//     print('line 154 initstate');
//     arguments = widget.args;
//     clientId = arguments!['clientId'];
//     flagAllData = false;
//     checkAllData = [false, false, false, false, false];
//     // clientId = ref
//     //     .read(clientUserNotifierProvider.notifier)
//     //      .fromClientId;
//     print('line 203: $clientId');
//     clientMap = authServices.clientMap!;
//     _getClientUsersX(context);
//
//     print('line 208 in didchange');
//     setPNRates();
//     _getListOfHolidays(clientId!);
//     print('line 211 end of initstate');
//   }
//
//   Future<dynamic> _showDialog(
//       BuildContext context, String title, String? description) async {
//     print('line 398 showdialog');
//     // Future.delayed(Duration(seconds: 3), () {
//     //   Navigator.of(context).pop(); // Close the dialog
//     // });
//     await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: Text(title),
//               content: Text(description!),
//               contentTextStyle: TextStyle(
//                 color: color1,
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//               ),
//               titleTextStyle: TextStyle(
//                   color: Colors.black87,
//                   fontSize: fontSize,
//                   fontWeight: FontWeight.bold),
//               actions: <Widget>[
//                 // TextButton(
//                 //   onPressed: () => Navigator.pop(context, 'Cancel'),
//                 //   child: const Text('Cancel'),
//                 // ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context)
//                         .pushNamed(clientMenu, arguments: arguments!);
//                   },
//                   child: Text(
//                     'OK',
//                     style: TextStyle(
//                         fontSize: fontSize,
//                         fontWeight: FontWeight.bold,
//                         color: color2),
//                   ),
//                 )
//               ],
//             ));
//     return;
//   }
//
//   bool checkIsWeekend(int dayValue) {
//     if (dayValue == 6 || dayValue == 7) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   bool checkIsHoliday(
//       DateTime date, Map<String, dynamic> shm, Map<String, dynamic> ehm) {
//     print('line 80 data is a holiday: ${listOfHolidays.length}');
//     try {
//       DateTime shiftStartDate = date.subtract(Duration(
//           hours: date.hour,
//           minutes: date.minute,
//           seconds: date.second,
//           microseconds: date.microsecond,
//           milliseconds: date.millisecond));
//       DateTime shiftEndDate = date;
//       shiftStartDate = shiftStartDate
//           .add(Duration(hours: shm['hours'], minutes: shm['minutes']));
//       shiftEndDate = shiftEndDate
//           .add(Duration(hours: ehm['hours'], minutes: ehm['minutes']));
//       bool isHoliday = false;
//       for (int i = 0; i < listOfHolidays.length; i++) {
//         Map<String, dynamic> hl = listOfHolidays[i];
//         String sdt = hl['startDate'];
//
//         if (sdt.indexOf('\/') != -1) {
//           sdt = sdt.replaceAll('\/', '\-');
//         }
//         List<String> lsdt = sdt.split('-');
//         String dte = lsdt[2] + '-' + lsdt[0] + '-' + lsdt[1];
//         print('line 323: $dte');
//         DateTime ndt = DateTime.parse(dte);
//         print('line 325: ${date.year} ${date.month} ${date.day}');
//         print(
//             'line 326: ${hl['duration'].toString()} ${ndt.year} ${ndt.month} ${ndt.day}');
//         int duration = int.parse(hl['duration'].toStringAsFixed(0));
//         Map<String, dynamic> jhm = util.getHoursMinutes(hl['startTime']);
//         print('line 330: $jhm');
//         ndt = ndt.subtract(Duration(
//             hours: ndt.hour,
//             minutes: ndt.minute,
//             seconds: ndt.second,
//             microseconds: ndt.microsecond,
//             milliseconds: ndt.millisecond));
//         DateTime endt = ndt;
//         endt = endt.add(Duration(hours: duration));
//         print(
//             'line 340: ${shiftStartDate.millisecondsSinceEpoch} ${ndt.millisecondsSinceEpoch} ${shiftEndDate.millisecondsSinceEpoch} ${endt.millisecondsSinceEpoch}');
//         if (shiftStartDate.millisecondsSinceEpoch >=
//                 ndt.millisecondsSinceEpoch &&
//             shiftEndDate.millisecondsSinceEpoch < endt.millisecondsSinceEpoch) {
//           isHoliday = true;
//           break;
//         }
//       }
//       print('line 328: $isHoliday');
//       return isHoliday;
//     } catch (e) {
//       print('line 347 error: ${e.toString()}');
//       throw Exception('line 348 error date is a holiday: ${e.toString()}');
//     }
//   }
//
//   bool toggleDaySelection = true;
//
//   Future<bool> _presentGetShift(BuildContext ctx, dynamic dtm) async {
//     print('line 331 presentgetshift: $dtm');
//     if (dtm == null) {
//       return false;
//     }
//     if (selectedDisciplineIndex == -1) {
//       String title = 'Department/Discipline Error';
//       String description = 'You must a select a discipline.';
//       await _showDialog(context, title, description);
//       return false;
//     }
//     try {
//       print('line 314: $selectedDisciplineHasChanged $listOfShifts');
//       if (selectedDisciplineHasChanged == true || listOfShifts == null) {
//         print('line 315 getting listof shifts ${listOfShifts!.length}');
//         listOfShifts = await _getRateAndShiftsByClientAndDiscipline(ctx);
//         holdListOfShifts = [];
//         for (int i = 0; i < listOfShifts!.length; i++) {
//           Map<String, dynamic> mp = Map.from(listOfShifts![i]);
//           holdListOfShifts!.add(mp);
//         }
//       }
//       listOfShifts = [];
//       int shiftIndex = -1;
//       print('line 326');
//       bool flagGotHit = false;
//       //  int hcpId =0;
//       if (listOfDatesWithShifts.length > 0) {
//         for (int i = 0; i < listOfDatesWithShifts.length; i++) {
//           dynamic lm = listOfDatesWithShifts[i];
//           print('line 355: ${lm}');
//           print('line 356: ${lm['date']} ${dtm}');
//           if (lm['date'] == dtm) {
//             shiftIndex = i;
//             //  hcpId = lm['date']['hcpId'];
//             flagGotHit = true;
//             break;
//           }
//         }
//       }
//       Map<String, dynamic>? losd;
//       if (shiftIndex != -1) {
//         losd = listOfDatesWithShifts[shiftIndex];
//       }
//       print('line 363 $losd');
//       for (int i = 0; i < holdListOfShifts!.length; i++) {
//         Map<String, dynamic> mp = Map.from(holdListOfShifts![i]);
//         if (losd != null) {
//           List<dynamic> rd = losd['rate']['rateDetails'];
//           print('line 368: ${rd}');
//           for (int j = 0; j < rd.length; j++) {
//             if (rd[j]['shiftCode'] == mp['shiftCode']) {
//               mp['shiftCount'] = rd[j]['shiftCount'];
//               //  mp['hcpId'] = hcpId;
//               break;
//             }
//           }
//         }
//         listOfShifts!.add(mp);
//       }
//     } catch (e) {
//       print('line 362 error getting rates from disiplines');
//       await _showDialog(ctx, "Discipline Rate",
//           "There are no valid discipline rates for the client.");
//       Navigator.of(ctx).pop();
//     }
//     try {
//       //
//       //  List<Map<String,dynamic>> lmap = await Navigator.push(
//       // context,
//       // MaterialPageRoute(
//       //  builder: (context) => ProcessClientGetRequestShifts(
//       //  ctx: context,
//       //  listOfHolidays: listOfHolidays,
//       //  dateTime: dtm,
//       //   discipline: selectedDisciplineValue,
//       // listOfData: listOfShifts!,
//       // fontSize: fontSize)));
//       double sfontSize = 14;
//       sfontSize /= h!;
//       print('line 351 check');
//       List<Map<String, dynamic>>? lmap = await Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ProcessShiftDataGrid(
//                   ctx: context,
//                   listOfHolidays: listOfHolidays,
//                   dateTime: dtm,
//                   discipline: selectedDisciplineValue,
//                   listOfData: listOfShifts!)));
//       print('line 407: ${lmap}');
//       if (lmap == null) {
//         print('line 409 error no data returned from shift screen');
//         throw Exception('No data returned from shfit screen.');
//       }
//       int i = 0;
//
//       int shiftCounts = 0;
//
//       int j = 0;
//       List<Map<String, dynamic>> holdList = [];
//       while (i < listOfShifts!.length) {
//         dynamic jbj = listOfShifts![i];
//         bool flagGotHit = false;
//         j = 0;
//         while (j < lmap.length) {
//           Map<String, dynamic> obj = lmap[j];
//           print('line 386: ${obj['shiftCode']} ${jbj['shiftCode']}');
//           if (obj['shiftCode'] == jbj['shiftCode']) {
//             jbj['shiftCount'] = int.parse(obj['shiftCount'].toString());
//             print('line 426: ${obj['shiftCount']} ${jbj['shiftCount']}');
//             shiftCounts += 1;
// //              listOfShifts![i] = jbj;
//             holdList.add(Map.from(jbj));
//             flagGotHit = true;
//             break;
//           }
//           j += 1;
//         }
//         i += 1;
//       }
//       i = 0;
//       if (shiftCounts == 0) {
//         print('line 429 error no shifts picked up.');
//         throw Exception('No shifts picked up.');
//       }
//       listOfShifts = holdList;
//       print('line 441: ${listOfShifts!.length} ${listOfShifts![0]}');
//       List<dynamic> newList = holdList;
//       if (newList.length == 0) {
//         //throw Exception('Error: No counts returned from schedule!');
//         return false;
//       }
//       listOfShifts = [];
//       for (int q = 0; q < newList.length; q++) {
//         Map<String, dynamic> lbj = {
//           'shiftCode': newList[q]['shiftCode'],
//           'startTime': newList[q]['startTime'],
//           'endTime': newList[q]['endTime'],
//           'shiftCount': newList[q]['shiftCount'],
//           // 'hcpId': newList[q]['hcpId']
//         };
//         listOfShifts!.add(lbj);
//       }
//
//       print('line 459: $newList');
//       print('line 450: ${listOfShifts![0]}');
//
//       List<dynamic> rates = clientRate!['rates'];
//       print('line 452: ${listOfShifts!.length} $rates');
//       rates[0]['scheduleRateDetails'] = newList;
//       List<dynamic> rateDetails = rates[0]['rateDetails'];
//       print('line 469: $rateDetails ${rates[0]['rateDetails'].length}');
//       int s = 0;
//       int r = 0;
//       print('line 496 check ${rateDetails.length} ${listOfShifts!.length} ');
//       //print('line 500: $newList');
//
//       dynamic clientRateMap = rates[0];
//       print('line 513 ${clientRateMap}');
//       List<dynamic> newDetails = [];
//       for (int z = 0; z < newList.length; z++) {
//         for (int j = 0; j < rateDetails.length; j++) {
//           if (rateDetails[j]['shiftCode'] == newList[z]['shiftCode']) {
//             rateDetails[j]['shiftCount'] = newList[z]['shiftCount'];
//             rateDetails[j]['shiftDate'] = dtm;
//             bool isHoliday = false;
//             bool isWeekend = false;
//             Map<String, dynamic> shm =
//                 util.getHoursMinutes(newList[z]['startTime']);
//             Map<String, dynamic> ehm =
//                 util.getHoursMinutes(newList[z]['endTime']);
//             isHoliday = checkIsHoliday(dtm, shm, ehm);
//             rateDetails[j]['isAHoliday'] = isHoliday;
//             if (dtm.weekday == 6 || dtm.weekday == 7) {
//               rateDetails[j]['isAWeekend'] = true;
//             } else {
//               rateDetails[j]['isAWeekend'] = false;
//             }
//             newDetails.add(rateDetails[j]);
//             break;
//           }
//         }
//         // rateDetails[z]['payRate'] = 0.0;
//         // rateDetails[z]['payRateWE'] = 0.0;
//         // rateDetails[z]['billRate'] = 0.0;
//         // rateDetails[z]['billRateWE'] = 0.0;
//       }
//       for (int z = 0; z < newDetails.length; z++) {
//         print('line 543: $z ${newDetails[z]}');
//       }
//       Map<String, dynamic> rateMap = {
//         "branchId": clientRateMap!['branchId'],
//         "branchName": clientRateMap!['branchName'],
//         "rateGroupId": clientRateMap!['rateGroupId'],
//         "rateId": clientRateMap!['rateId'],
//         "disciplineId": selectedDisciplineId,
//         "disciplineName": selectedDisciplineValue,
//         "billDblRate": clientRateMap!['billDblRate'],
//         "billDblPlusRate": clientRateMap!['billDblPlusRate'],
//         "billHolidayPlusRate": clientRateMap!['billHolidayPlusRate'],
//         "billHolidayRate": clientRateMap!['billHolidayRate'],
//         "billMaxPlusRate": clientRateMap!['billMaxPlusRate'],
//         "billMaxRate": clientRateMap!['billMaxRate'],
//         "billOTPlusRate": clientRateMap!['billOTPlusRate'],
//         "billOTRate": clientRateMap!['billOTRate'],
//         "overridePayModifiers": clientRateMap!['overridePayModifiers'],
//         "overrideBillModifiers": clientRateMap!['overrideBillModifiers'],
//         "payDblPlusRate": clientRateMap!['payDblPlusRate'],
//         "payDblRate": clientRateMap!['payDblRate'],
//         "payHolidayPlusRate": clientRateMap!['payHolidayPlusRate'],
//         "payHolidayRate": clientRateMap!['payHolidayRate'],
//         "payMaxPlusRate": clientRateMap!["payMaxPlusRate"],
//         "payMaxRate": clientRateMap!['payMaxRate'],
//         "payOTPlusRate": clientRateMap!["payOTPlusRate"],
//         "payOTRate": clientRateMap!['payOTRate'],
//         "rateDetails": newDetails
//       };
//       print('line 525: $rateMap');
//
//       Map<String, dynamic>? clientMap =
//           await clientServices.getClient(clientId!);
//       if (clientMap!.isEmpty) {
//         throw Exception('Unable to get a client while setting rate data');
//       }
//       rates[0]['overtimeRule'] = clientMap['overtimeRule'];
//       rates[0]['payHoliday'] = clientMap['payHolidayRate'];
//       rates[0]['payHolidayPlus'] = clientMap['payHolidayRate'];
//       rates[0]['payMaxRate'] = clientMap['payMaxRate'];
//       rates[0]['payDbPlus'] = clientMap!['payMaxRate'];
//       rates[0]['payDbl'] = clientMap['payMaxRate'];
//       rates[0]['payMax'] = clientMap['payMaxRate'];
//       rates[0]['payMaxPlus'] = clientMap['payMaxRate'];
//       rates[0]['payOT'] = 1.5;
//       rates[0]['payOTPlus'] = 1.5;
//       print('line 488: ${clientMap['clientId']}');
//       print('line 489: $selectedDepartmentIndex $selectedDisciplineIndex');
//       print(
//           'line 490: ${listClientDepartments.length} ${listOfDisciplines.length}');
//       Map<String, dynamic> department =
//           listClientDepartments[selectedDepartmentIndex];
//       Map<String, dynamic> discipline =
//           listOfDisciplines[selectedDisciplineIndex];
//       print(
//           'line 493: ${department['departmentId']} ${discipline['disciplineId']}');
//       List<String> stringDays = [
//         'Monday',
//         'Tuesday',
//         'Wednesday',
//         'Thursday',
//         'Friday',
//         'Saturday',
//         'Sunday'
//       ];
//       bool isHoliday = false;
//
//       Timestamp tms = Timestamp.fromDate(dtm);
//       print('line 535: $clientUserMap');
//       int schedulerId = clientUserMap!['genId'];
//       String fullName =
//           clientUserMap!['firstName'] + ' ' + clientUserMap!['lastName'];
//       schedulerName = fullName;
//       print('line 506 $rateMap');
//       int q = 0;
//       while (q < listOfDatesWithShifts.length) {
//         if (listOfDatesWithShifts[q]['date'] == dtm) {
//           listOfDatesWithShifts.removeAt(q);
//           break;
//         }
//         q += 1;
//       }
//       print('line 537: $department');
//
//       Map<String, dynamic> dm = {
//         "date": dtm,
//         "color": null,
//         "dateTime": dtm,
//         "dayValue": dtm.weekday,
//         "dayValueString": stringDays[dtm.weekday - 1],
//         "timeStamp": tms,
//         "departmentId": department['departmentId'],
//         "departmentName": department['departmentName'],
//         "departmentIds": [department['departmentId']],
//         "departmentNames": [department['departmentName']],
//         "disciplineId": discipline['disciplineId'],
//         "disciplineIds": [discipline['disciplineId']],
//         "disciplineName": discipline['disciplineName'],
//         "disciplineNames": discipline['disciplineName'],
//         "holiday": isHoliday,
//         "weekend": checkIsWeekend(dtm.weekday),
//         "schedulerId": schedulerId,
//         "schedulerName": schedulerName,
//         "billDblPlusRate": clientRateMap!['billDblPlusRate'],
//         "billDblRate": clientRateMap!['billDblRate'],
//         "billHolidayPlusRate": clientRateMap!['billHolidayPlusRate'],
//         "billHolidayRate": clientRateMap!['billHolidayRate'],
//         "billMaxPlusRate": clientRateMap!['billMaxPlusRate'],
//         "billMaxRate": clientRateMap!['billMaxRate'],
//         "billOTPlusRate": clientRateMap!['billOTPlusRate'],
//         "billOTRate": clientRateMap!['billOTRate'],
//         "branchId": clientRateMap!['branchId'],
//         "branchName": clientRateMap!['branchName'],
//         "burden": clientRateMap!['burden'],
//         "clientId": clientRateMap!['clientId'],
//         "clientName": clientRateMap!['clientName'],
//         "contract": clientRateMap!['contract'],
//         "contractTemplateName": clientRateMap!['contractTemplateName'],
//         "departments": [department],
//         "disciplines": [discipline],
//         "expirationDate": clientRateMap!['expirationDate'],
//         "hcpId": 0,
//         "hcpName": '',
//         "lastModifiedDate": clientRateMap!['lastModifiedDate'],
//         "nationalClient": clientRateMap!['nationalClient'],
//         "orderId": clientRateMap!['orderId'],
//         "overrideBillModifiers": clientRateMap!["overrideBillModifiers"],
//         "overridePayModifiers": clientRateMap!['overridePayModifiers'],
//         "payDblPlusRate": clientRateMap!['payDblPlusRate'],
//         "payDblRate": clientRateMap!['payDblRate'],
//         "payHolidayPlusRate": clientRateMap!['payHolidayPlusRat'],
//         "payHolidayRate": clientRateMap!['payHolidayRate'],
//         "payMaxPlusRate": clientRateMap!['payMaxPlusRate'],
//         "payMaxRate": clientRateMap!['payMaxPlusRate'],
//         "payOTPlusRate": clientRateMap!['payOTPlusRate'],
//         "payOTRate": clientRateMap!['oatOTRate'],
//         "quoteId": clientRateMap!['quoteId'],
//         "rateGroupId": clientRateMap!['rateGroupId'],
//         "rateGroupTypeCodeId": clientRateMap!['rateGroupTypeCodeId'],
//         "rateGroupTypeName": clientRateMap!['rateGroupTypeName'],
//         "rateGroupTypeValue": clientRateMap!['rateGroupTypeValue'],
//         "rateType": clientRate!['rateType'],
//         "rateTypeCodeId": clientRate!['rateTypeCodeId'],
//         "rateTypeDescription": clientRate!['rateTypeDescription'],
//         "rate": rateMap,
//         "clientLatitude": clientMap['latitude'],
//         "clientLongitude": clientMap['longitude'],
//         "clientTimeZoneOffset": null,
//         "workersCompCodeId": clientRate!['workersCompCodeId'],
//         "workersCompType": clientRate!['workersCompType']
//       };
//       print('line 606: ${dm['workersCompCodeId']}');
//
//       listOfDatesWithShifts.add(dm);
//       print('line 609: ${listOfDatesWithShifts}');
//       return true;
//     } catch (e) {
//       print('line 612 error: $e');
//       throw Exception('Error: ${e.toString()}');
//     }
//   }
//
//   Future<void> _publishShiftInformation(context) async {
//     print(
//         'line 297 in publish shift information $scheduleNotes ${_textControllers[0].text}');
//     int i = 0;
//     String title = '';
//     if (flagPublishedButtonDisabled) {
//       return;
//     }
//     String description = '';
//     if (selectedDisciplineValue == null) {
//       print('line 478 error');
//       title = 'Discipline Error';
//       description = 'You have not selected a discipline.';
//       await _showDialog(context, title, description);
//       return;
//     }
//     if (selectedDepartmentValue == null) {
//       print('line 485 error');
//       title = 'Department Error';
//       description = 'You have not selected a department.';
//       await _showDialog(context, title, description);
//       return;
//     }
//     if (listOfDatesWithShifts.isEmpty) {
//       print('line 492 error');
//       title = 'Shifts Error';
//       description = 'You must enter at least one shift.';
//       await _showDialog(context, title, description);
//       return;
//     }
//     if (selectedPNRateValue == 'All') {
//       checkAllData![4] = true;
//     }
//     if (selectedPNRateValue == null) {
//       print('line 524 error');
//       title = 'Push Notification Error';
//       description = 'You have not selected a push notification frequency.';
//       await _showDialog(context, title, description);
//       return;
//     }
//     // if (checkAllData!.contains(false) == true) {
//     //   print('line 528 error" $checkAllData');
//     //   title = 'Data Error Error';
//     //   description = 'You have not completed all required fields.';
//     //   await _showDialog(context, title,  description);
//     //   return;
//     //
//     // }
//
//     try {
//       // print('line 499: publish: $selectedDisciplineValue $checkBoxValue, $listDates');
//       // print('line 500: ${selectedDisciplineValue.runtimeType}');
//       // print('line 501: ${selectedDepartmentValue.runtimeType}');
//       // print('line 502: ${schedulerId.runtimeType}');
//       // print('line 503: ${schedulerName.runtimeType}');
//       // print('line 504: ${checkBoxValue.runtimeType}');
//       // print('line 506: ${_popUpController.text.runtimeType}');
//       // print('line 507: ${ clientUser['userId'].runtimeType}');
//       // print('line 508: ${ pushNotificationFrequencyRate.text.runtimeType}');
//       // print('line 509: ${ user!.fcmToken.runtimeType}');
//       // print('line 510: ${ testerFcmToken.runtimeType}');
//       setState(() {
//         disabledTextColor = Colors.white;
//         disabledColor = Colors.orange;
//         flagPublishedButtonDisabled = true;
//       });
//       bool premiumRate = false; //premiumRateCheckBox.checked;
//       if (scheduleNotes == null) {
//         scheduleNotes = 'None';
//       }
//       print('line 697: ${listOfDatesWithShifts.length}');
//       bool flagGoOn = false;
//       for (int i = 0; i < listOfDatesWithShifts.length; i++) {
//         Map<String, dynamic> mpd = listOfDatesWithShifts[i];
//         List<dynamic> listDetails = mpd['rate']['rateDetails'];
//         print('line 684 ${listDetails.length}');
//         flagGoOn = false;
//         for (int j = 0; j < listDetails.length; j++) {
//           dynamic ld = listDetails[j];
//           print('line 688 ${ld['shiftCount']}');
//           if (ld['shiftCount'] == null) {
//             ld['shiftCount'] = 0;
//             continue;
//           }
//           if (ld['shiftCount'] > 0) {
//             flagGoOn = true;
//             break;
//           }
//         }
//       }
//       if (flagGoOn == false) {
//         print('line 700 error No Shift counts for one of your shifts.');
//         throw Exception(('line 701 No shift counts'));
//       }
//
//       List<double> count = await clientServices.createSchedulingWorkOrder(
//           listOfDatesWithShifts,
//           scheduleNotes!,
//           pushNotificationFrequencyRate.text,
//           authServices!.clientMap!['clientId'],
//           [],
//           [],
//           premiumRate,
//           context);
//       print('line 730 true: $count');
//       title = 'Shift Publication';
//       if (count.length > 0 && count[0] > 0) {
//         description =
//             'You have successfully published employee(s) for your shift(s).  You will receive a notification when there are responses.';
//       } else {
//         description = 'PROBLEM: No employees were scheduled.';
//       }
//       await _showDialog(context, title, description);
//     } catch (e) {
//       print('line 736 $e');
//       String te = e.toString();
//       te = te.replaceAll('Exception: Exception:', 'Exception:');
//       title = 'Shift Publication';
//       description =
//           'You have not published your shift(s). There were errors: ' + te;
//       await _showDialog(context, title, description);
//     }
//   }
//
//   List<dynamic> listShowDates = [];
//   int listOfDateType = 1;
//
//   @override
//   void dispose() {
//     super.dispose();
//     // Dispose of the focus node when the widget is removed from the widget tree
//     //  ref.read(disciplineNotifierProvider.notifier).disposeFocusNodes();
//   }
//
//   bool enabled = true;
//   int _getPNRateIndex(dynamic value) {
//     checkAllData![4] = true;
//     int ii = -1;
//     for (int i = 0; i < listOfPnRates.length; i++) {
//       if (value == listOfPnRates[i]['pnRateValue']) {
//         ii = i;
//         break;
//       }
//     }
//     return ii;
//   }
//
//   Future<int> _getDisciplineIndex(BuildContext ctx, dynamic value) async {
//     print('line 714 in getdicipindex $value');
//     try {
//       // int idx = value.indexOf('(');
//       // String val = value.toString().substring(0, idx).trim();
//       // String stx = value.substring(idx);
//       // stx = stx.replaceAll('(', '');
//       // stx = stx.replaceAll((')'), '');
//       print('line 721: $value');
//       bool flagGotHit = false;
//       selectedDisciplineHasChanged = false;
//       int sel = 0;
//       for (int j = 0; j < listOfDisciplines.length; j++) {
//         dynamic tb = listOfDisciplines[j];
//         print('line 726: ${tb['disciplineId']} $value ${tb['disciplineName']}');
//         if (tb['disciplineDescription'] == value) {
//           selectedDisciplineId = tb['disciplineId'];
//           selectedDisciplineValue = value;
//           flagGotHit = true;
//           selectedDisciplineIndex = j;
//           sel = j;
//           selectedDisciplineHasChanged = true;
//           break;
//         }
//       }
//       print('line 734 ${listOfDisciplines[sel]}');
//       checkAllData![0] = true;
//       listOfShiftData = [];
//       listOfDatesWithShifts = [];
//       departmentIds = [];
//       listOfShifts = await _getRateAndShiftsByClientAndDiscipline(ctx);
//       if (listOfShifts == null || listOfShifts!.length == 0) {
//         throw Exception('No Valid rate data for client and discipline.');
//       }
//       print('line 737: ${listOfShifts!.length}');
//       for (int i = 0; i < listOfShifts!.length; i++) {
//         print('line 740: $i ${listOfShifts![i]}');
//
//         dynamic sb = ShiftClass.fromJson(listOfShifts![i]);
//
//         print('line 742: $listOfShiftData $sb');
//         listOfShiftData!.add(sb);
//       }
//       departmentIds = [];
//       for (int i = 0; i < clientRate!['departments'].length; i++) {
//         departmentIds.add(clientRate!['departments'][i]['departmentId']);
//       }
//       print('line 799: ${departmentIds.length}');
//       print('line 801 ${listOfShiftData!.length} ${listOfShiftData![0]}');
//       listOfDepartments = await _getClientDepartments(departmentIds);
//
//       print('line 802: ${listOfDepartments[0]}');
//       return selectedDisciplineIndex;
//     } catch (e) {
//       print('line 805 error: $e');
//       throw Exception('line 479 error: ${e.toString()}');
//     }
//   }
//
//   int _getDepartmentIndex(dynamic value) {
//     // int idx = value.indexOf('(');
//     //String val = value.substring(0, idx).trim();
//     int ii = -1;
//     for (int i = 0; i < listClientDepartments.length; i++) {
//       if (value == listClientDepartments[i]['departmentName']) {
//         selectedDepartmentId = listClientDepartments[i]['departmentId'];
//         selectedDepartmentValue = listClientDepartments[i]['departmentName'];
//         print('line 818: $i $selectedDepartmentId $selectedDepartmentValue');
//         checkAllData![1] = true;
//         hasDepartment = true;
//         ii = i;
//         break;
//       }
//     }
//
//     return ii;
//   }
//
//   Map<String, dynamic>? clientRateMap;
//   List<Map<String, dynamic>> listDisciplinesMap = [];
//   Map<String, dynamic>? clientRate;
//   List<int> departmentIds = [];
//
//   Future<List<Map<String, dynamic>>>? _getRateAndShiftsByClientAndDiscipline(
//       BuildContext ctx) async {
//     print('line 842 getratedisciplines $selectedDisciplineValue');
//     try {
//       Map<String, dynamic> sm = listOfDisciplines[selectedDisciplineIndex];
//       print('line 858: ${sm}');
//       //   String selectedDisciplineName = sm['disciplineName'];
//       clientRate = await clientServices.getShiftsByClientAndDiscipline(
//           clientId!, selectedDisciplineValue, sm['rateGroupId']);
//       print('line 846: $clientRate!');
//
//       List<dynamic> rateDetails = clientRate!['rates'][0]['rateDetails'];
//       listOfShifts = [];
//       print('line 850:  ${rateDetails.length} $rateDetails');
//       for (int i = 0; i < rateDetails.length; i++) {
//         if (rateDetails[i]['startTime'] == null) {
//           continue;
//         }
//         if (rateDetails[i]['endTime'] == null) {
//           continue;
//         }
//         Map<String, dynamic> shift = {
//           "shiftCode": rateDetails[i]['shiftCode'],
//           "startTime": rateDetails[i]['startTime'] == null
//               ? ""
//               : rateDetails[i]['startTime'],
//           "endTime": rateDetails[i]['endTime'] == null
//               ? ""
//               : rateDetails[i]['endTime'],
//           "shiftCount": 0,
//         };
//         listOfShifts!.add(shift);
//       }
//       print('line 870: ${listOfShifts!.length} ${listOfShifts![0]}');
//       return listOfShifts!;
//     } catch (e) {
//       print('line 873 no valid discipline with rates returned $e');
//       await _showDialog(ctx, "Discipline Rate",
//           "There are no valid rate data for the client's discpline");
//       Navigator.of(ctx).pop();
//       return [];
//     }
//   }
//
//   final DateRangePickerController _controller = DateRangePickerController();
//   DateTime? selectedDate;
//   List<DateTime> selectedDates = [];
//   bool checkBoxValue = false;
//   List<String>? listStsHold = null;
//   List<String>? listStringDisciplines;
//   Future<List<String>> getDisciplinesForDropDown() async {
//     print('line 1030 in get disciplines for dropdonw');
//
//     try {
//       List<Map<String, dynamic>>? lst;
//       if (listStsHold == null) {
//         lst = await clientServices.getDisciplinesFromClientRates(clientId!);
//         listStringDisciplines = [];
//         for (int i = 0; i < lst!.length; i++) {
//           Map<String, dynamic> dm = lst[i];
//           // if (i == 0) {
//           //   selectedDisciplineId = dm['disciplineId'];
//           // }
//           String st = dm[
//               'disciplineDescription']; //' (' + dm['disciplineId'].toString() + ')';
//           if (listStringDisciplines!.contains(st) == false) {
//             listStringDisciplines!.add(st);
//           }
//         }
//         listOfDisciplines = lst;
//         listStsHold = listStringDisciplines;
//         //    selectedDisciplineValue = listStringDisciplines![0];
//         //    selectedDisciplineIndex = 0;
//       }
//       checkAllData![0] = false;
//       return listStringDisciplines!;
//     } catch (e) {
//       print('line 858 error getting disciplines: $e');
//       return [];
//     }
//   }
//
//   Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
//   Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
//   Color color3 = Colors.grey.shade200;
//   double? screenWidth;
//   double? screenHeight;
//   double fontSize = 18;
//   double? h;
//   @override
//   Widget build(BuildContext context) {
//     print('line 103 in showaccepted ashifts');
//     screenWidth = MediaQuery.of(context).size.width;
//     screenHeight = MediaQuery.of(context).size.height;
//     h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
//     if (h! < 1.0) {
//       h = 1.0;
//     }
//     fontSize = 18;
//     fontSize /= h!;
//     double smallFontSize = 14;
//     smallFontSize /= h!;
//     print('line 1124: $fontSize $screenWidth! $screenHeight $h');
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: color1,
//       appBar: AppBar(
//         backgroundColor: color2,
//         leading: GestureDetector(
//           child: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios_new_outlined,
//                 size: 20,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 Navigator.of(context)
//                     .pushNamed(clientSchedulingMenu, arguments: arguments!);
//               }),
//         ),
//         title: Text("Publish Shift - ${clientId!}",
//             style: TextStyle(
//               fontSize: fontSize < 18 ? 18 : fontSize,
//               fontWeight: FontWeight.bold,
//             )),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Center(
//             child: Container(
//               height: screenHeight! - 150,
//               width: screenWidth! / 2,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 10),
//                   Container(
//                       height: 90,
//                       width: screenWidth! / 1,
//                       child: FutureBuilder(
//                           future: Future.wait([
//                             getDisciplinesForDropDown(),
//                           ]),
//                           builder:
//                               (context, AsyncSnapshot<List<dynamic>> snapshot) {
//                             debugPrint(
//                                 'line 417 building FB ${snapshot.connectionState}');
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const CircularProgressIndicator();
//                             } else if (snapshot.hasError) {
//                               return Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 30),
//                                   child: Container(
//                                     height: 110,
//                                     child: Text('Error: ${snapshot.error}',
//                                         style: TextStyle(
//                                             fontSize: fontSize,
//                                             color: Colors.red,
//                                             fontWeight: FontWeight.bold)),
//                                   ),
//                                 ),
//                               );
//                             } else if (snapshot.data == [[]] &&
//                                 snapshot.connectionState ==
//                                     ConnectionState.done) {
//                               return Center(
//                                 child: Padding(
//                                   padding: EdgeInsets.only(bottom: 30),
//                                   child: Container(
//                                     height: 100,
//                                     //  width: screenWidth! - 10,
//                                     child: Text(
//                                         overflow: TextOverflow.visible,
//                                         'There are no disciplines for this client.',
//                                         style: TextStyle(
//                                             fontSize: fontSize,
//                                             color: color2,
//                                             fontWeight: FontWeight.bold)),
//                                   ),
//                                 ),
//                               );
//                             } else {
//                               List<dynamic> listH = snapshot.data![0];
//                               print('line 111 ${listH.length}');
//                               if (listH.length == 0) {
//                                 return Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(bottom: 30),
//                                     child: Container(
//                                       height: 100,
//                                       //    width: screenWidth! - 10,
//                                       child: Text(
//                                           'There are no disciplines for this client.',
//                                           overflow: TextOverflow.visible,
//                                           style: TextStyle(
//                                               fontSize: fontSize,
//                                               color: color2,
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 List<dynamic> listD = snapshot.data![0]!;
//                                 return Container(
//                                   height: 80,
//                                   width: screenWidth! - 10,
//                                   child: Column(
//                                     children: [
//                                       DropdownButtonHideUnderline(
//                                           child: Container(
//                                         height: 36,
//                                         width: screenWidth! - 10,
//                                         decoration: BoxDecoration(
//                                             color: color1,
//                                             border: Border.all(
//                                                 color: Colors.black87,
//                                                 width: 3),
//                                             borderRadius:
//                                                 BorderRadius.circular(12)),
//                                         child: DropdownButton2<dynamic>(
//                                           isExpanded: true,
//                                           hint: Container(
//                                             height: 36,
//                                             width: screenWidth! - 10,
//                                             child: Text(
//                                               'Select Discipline',
//                                               style: TextStyle(
//                                                   fontSize: fontSize,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.black87),
//                                             ),
//                                           ),
//                                           items: listD
//                                               .map((dynamic item) =>
//                                                   DropdownMenuItem<dynamic>(
//                                                     value: item,
//                                                     child: Container(
//                                                       height: item.length >= 28
//                                                           ? 64
//                                                           : 30,
//                                                       width: screenWidth! - 10,
//                                                       child: Text(
//                                                         maxLines: 2,
//                                                         item,
//                                                         style: TextStyle(
//                                                           fontSize: fontSize,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ))
//                                               .toList(),
//                                           value: selectedDisciplineValue,
//                                           onChanged: (dynamic newValue) async {
//                                             print(
//                                                 'line 1083: $selectedDisciplineValue $newValue');
//                                             await _getDisciplineIndex(
//                                                 context, newValue);
//                                             setState(() {
//                                               checkAllData![0] = true;
//                                               selectedDisciplineValue =
//                                                   newValue;
//                                               listDepartments =
//                                                   listOfDepartments;
//                                             });
//                                             print(
//                                                 'line 1091: ${listDepartments}');
//                                           },
//                                         ),
//                                       )),
//                                       SizedBox(height: 10),
//                                       selectedDisciplineIndex != -1
//                                           ? DropdownButtonHideUnderline(
//                                               child: Container(
//                                                 height: 36,
//                                                 width: screenWidth! - 4,
//                                                 decoration: BoxDecoration(
//                                                     color: color1,
//                                                     border: Border.all(
//                                                         color: Colors.black87,
//                                                         width: 3),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             12)),
//                                                 child: DropdownButton2<dynamic>(
//                                                   isExpanded: true,
//                                                   hint: Container(
//                                                     height: 36,
//                                                     width: screenWidth! - 10,
//                                                     child: Text(
//                                                       'Select Department',
//                                                       style: TextStyle(
//                                                         fontSize: fontSize,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.black87,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   items: listDepartments
//                                                       .map((dynamic item) =>
//                                                           DropdownMenuItem<
//                                                               dynamic>(
//                                                             value: item,
//                                                             child: Text(
//                                                               item,
//                                                               style: TextStyle(
//                                                                 fontSize:
//                                                                     fontSize,
//                                                               ),
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                             ),
//                                                           ))
//                                                       .toList(),
//                                                   value:
//                                                       selectedDepartmentValue,
//                                                   onChanged: (dynamic value) {
//                                                     selectedDepartmentIndex =
//                                                         _getDepartmentIndex(
//                                                             value);
//                                                     print(
//                                                         'line 1128: $selectedDepartmentIndex');
//                                                     setState(() {
//                                                       selectedDepartmentValue =
//                                                           value;
//                                                       checkAllData![1] = true;
//                                                     });
//                                                   },
//                                                 ),
//                                               ),
//                                               //    )
//                                             )
//                                           : Container()
//                                     ],
//                                   ),
//                                 );
//                               }
//                             }
//                           })),
//                   Container(
//                     height: 32,
//                     width: screenWidth! / 2,
//                     child: Text('Select Schedule Dates',
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                         )),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: SafeArea(
//                       child: Container(
//                         height: 270,
//                         width: screenWidth! / 2,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                             Center(
//                               child: Container(
//                                 height: 270,
//                                 width: screenWidth! - 10,
//                                 child: SfDateRangePicker(
//                                   showActionButtons: false,
//                                   onSelectionChanged:
//                                       (DateRangePickerSelectionChangedArgs
//                                           args) async {
//                                     print(
//                                         'line 1216: ${dateTimeList.length} ${args} ${args.value}');
//                                     if (selectedDisciplineIndex == -1 ||
//                                         selectedDepartmentIndex == -1) {
//                                       _showDialog(context, "Missing Data",
//                                           "You must select both a discipline and a department before adding shifts.");
//                                       return;
//                                     }
//                                     bool flagFoundMatch = true;
//                                     List<int> keyValues = [];
//                                     if (dateTimeList.length > 0) {
//                                       for (int i = 0;
//                                           i < dateTimeList.length;
//                                           i++) {
//                                         flagFoundMatch = false;
//                                         for (int j = 0;
//                                             j < args.value.length;
//                                             j++) {
//                                           if (dateTimeList[i] ==
//                                               args.value[j]) {
//                                             flagFoundMatch = true;
//                                             keyValues.add(i);
//                                             keyValues.add(j);
//                                             flagFoundMatch = true;
//                                             break;
//                                           }
//                                         }
//                                         if (keyValues.length > 0) {
//                                           break;
//                                         }
//                                       }
//                                     }
//
//                                     print(
//                                         'line 1237: $flagFoundMatch ${args.value} ${dateTimeList}');
//                                     DateTime? dateTimeObj;
//                                     if (flagFoundMatch == false &&
//                                         args.value.length > 0) {
//                                       dateTimeList.add(
//                                           args.value[args.value.length - 1]);
//                                       dateTimeObj =
//                                           args.value[args.value.length - 1];
//                                     } else if (args.value.length > 0) {
//                                       dateTimeObj =
//                                           args.value[args.value.length - 1];
//                                     }
//                                     if (args.value.length > 0) {
//                                       print(
//                                           'line 1218: ${dateTimeObj.toString()}');
//                                       bool? bl = await _presentGetShift(
//                                           context, dateTimeObj);
//                                       //   }
//                                     }
//                                   },
//                                   controller: _controller,
//                                   showNavigationArrow: true,
//                                   allowViewNavigation: true,
//                                   view: DateRangePickerView.month,
//                                   headerStyle: DateRangePickerHeaderStyle(
//                                       backgroundColor: color1,
//                                       textAlign: TextAlign.center,
//                                       textStyle: TextStyle(
//                                           fontStyle: FontStyle.normal,
//                                           fontSize: fontSize,
//                                           letterSpacing: 5,
//                                           color: Colors.black87)),
//                                   monthCellStyle: DateRangePickerMonthCellStyle(
//                                     todayTextStyle: TextStyle(
//                                       color: color2,
//                                       fontSize: fontSize,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textStyle: TextStyle(
//                                       color: color2,
//                                       fontSize: fontSize,
//                                     ),
//                                     cellDecoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: Colors.black87,
//                                           width: 3), //Border.all
//                                       shape: BoxShape.rectangle,
//                                     ),
//                                     // trailingDatesDecoration: BoxDecoration(
//                                     //     shape: BoxShape.rectangle),
//                                     // leadingDatesDecoration: BoxDecoration(
//                                     //     shape: BoxShape.rectangle),
//                                   ),
//                                   yearCellStyle: DateRangePickerYearCellStyle(
//                                     textStyle: TextStyle(
//                                         fontSize: fontSize,
//                                         color: Colors.black),
//                                     disabledDatesTextStyle: TextStyle(
//                                         fontSize: fontSize,
//                                         color: Colors.black),
//                                     todayTextStyle: TextStyle(
//                                         fontSize: fontSize,
//                                         color: Colors.black),
//                                     leadingDatesTextStyle: TextStyle(
//                                         fontSize: fontSize,
//                                         color: Colors.black),
//                                   ),
//                                   enablePastDates: false,
//                                   toggleDaySelection: toggleDaySelection,
//                                   todayHighlightColor: color1,
//                                   selectionMode: _selectionMode,
//                                   monthViewSettings:
//                                       DateRangePickerMonthViewSettings(
//                                           firstDayOfWeek: 1,
//                                           showTrailingAndLeadingDates: true),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   //end of datepicker
//                   // SizedBox(height: 10),
//                   Container(
//                     height: 32,
//                     width: screenWidth! / 2,
//                     child: Text('Select Push Notification Frequency',
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                         )),
//                   ),
//                   DropdownButtonHideUnderline(
//                       child: Container(
//                     height: 50,
//                     width: screenWidth! / 2,
//                     decoration: BoxDecoration(
//                         color: color1,
//                         border: Border.all(color: Colors.black87),
//                         borderRadius: BorderRadius.circular(12)),
//                     child: DropdownButton2<dynamic>(
//                       isExpanded: true,
//                       hint: Container(
//                         height: 50,
//                         width: screenWidth! / 2,
//                         child: Text(
//                           'Select Push Notification Frequency',
//                           style: TextStyle(
//                             fontSize: fontSize,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).hintColor,
//                           ),
//                         ),
//                       ),
//                       items: listOfPnRates
//                           .map((dynamic item) => DropdownMenuItem<dynamic>(
//                                 value: item['pnRateValue'],
//                                 child: Container(
//                                   height: 24,
//                                   width: screenWidth! - 10,
//                                   child: Text(
//                                     item['pnRateValue'],
//                                     style: TextStyle(
//                                       fontSize: fontSize,
//                                     ),
//                                   ),
//                                 ),
//                               ))
//                           .toList(),
//                       value: selectedPNRateValue,
//                       onChanged: (dynamic value) {
//                         print('line 455: $selectedPNRateValue $value');
//                         selectedPNRateIndex = _getPNRateIndex(value);
//                         setState(() {
//                           selectedPNRateValue = value;
//                           checkAllData![4] = true;
//                         });
//                       },
//                     ),
//                   )),
//                   SizedBox(height: 10),
//                   Container(
//                     height: 32,
//                     width: screenWidth! / 2,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: disabledColor),
//                           onPressed: (flagPublishedButtonDisabled
//                               ? null
//                               : () async {
//                                   Navigator.pop(context);
//                                 }),
//                           child: Container(
//                               height: 32,
//                               width: 80,
//                               child: Center(
//                                 child: Text(
//                                     flagPublishedButtonDisabled
//                                         ? "Wait..."
//                                         : "Cancel",
//                                     style: TextStyle(
//                                       fontSize: fontSize,
//                                       fontWeight: FontWeight.bold,
//                                       color: disabledTextColor,
//                                     )),
//                               )),
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: disabledColor),
//                           onPressed: (() async {
//                             _checkData();
//                             // if (flagAllData == true) {
//                             await _publishShiftInformation(context);
//                             Navigator.of(context).pushNamed(
//                                 clientSchedulingMenu,
//                                 arguments: arguments!);
//
//                             //      }
//                           }),
//                           child: Container(
//                               height: 32,
//                               width: 80,
//                               // decoration: BoxDecoration(
//                               //     color: Colors.grey[200],
//                               //     border: Border.all(color: Colors.black87),
//                               //     borderRadius: BorderRadius.circular(12)
//                               // ),
//                               child: Center(
//                                 child: Text(
//                                     flagPublishedButtonDisabled
//                                         ? "Wait..."
//                                         : "Publish",
//                                     style: TextStyle(
//                                         fontSize: fontSize,
//                                         fontWeight: FontWeight.bold,
//                                         color: disabledTextColor)),
//                               )),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
