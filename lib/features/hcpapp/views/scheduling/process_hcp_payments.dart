
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/hcpapp/views/scheduling/show_hcp_payment_details_screen.dart';
import 'package:cms_web/features/shared/services/hcpapp/payment_api_request.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


import '../../../shared/utils/routerconstants.dart';

class ProcessHCPPayments extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessHCPPayments({super.key, required this.args});

  @override
  State<ProcessHCPPayments> createState() => _ProcessHCPPaymentsState();
}

class _ProcessHCPPaymentsState extends State<ProcessHCPPayments> {
  _ProcessHCPPaymentsState();

  //TextEditingController _startDateController = TextEditingController();
  List<dynamic> listOfDates = [];
  List<dynamic> listShowDates = [];
  int listOfDateType = -1;
  bool hasDates = false;
  Users? user;
  dynamic currentUser;
  String? gEmail;
  AuthService authService = AuthService();
  HCPServices hcpServices = HCPServices();
  ClientServices clientServices = ClientServices();

  String fromDate = '';
  String toDate = '';
  late dynamic hcpUser;
  late int hcpId;
  int? clientId;
  late HCPPaymentDataService paymentService;
  TextEditingController _selectionDateController = TextEditingController();
  late List<dynamic> paymentDate;
  String? orgId;
  Future<List<dynamic>> _getHCPPaymentData(BuildContext ctx) async {
    debugPrint('line 42 in _getHCPPaymentDate $fromDate $toDate');
    List<dynamic>? list =
        await paymentService.getPaymentData(fromDate, toDate, hcpId, ctx);
    return list;
  }

  Future<void> _onSubmit() async {
    //  String dte = _selectionDateController.text;
    debugPrint('line 139 on submit: ${dateTimeList}');
    fromDate = dateTimeList[0].toString();
    toDate = dateTimeList[1].toString();

    //use hcpid to restict findings in gethcppayme;nt
    debugPrint('line 106: $fromDate $toDate');
    //  paymentDate = await _getHCPPaymentData();
    setState(() {
      hasDates = true;
    });
  }

  List<Map<String, dynamic>>? listOfHolidays;

  Future<void> getHCPHolidays() async {
    List<Map<String, dynamic>>? listD;
//        await paymentService.getListOfHCPHolidays();
    listD = await clientServices.getClientHolidays(clientId!);
    debugPrint('line 177: $listD');
    // listD.then((item) {
    //   item.forEach((element) {
    //     listOfHolidays.add(element);
    //   });
    // });
    listOfHolidays = listD!;
    debugPrint('line 111: $listOfHolidays');
    // }
  }

  Future<dynamic> _showDialog(
      BuildContext context, String title, String? description) async {
    debugPrint('line 68 showdialog');
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

  Future<void>getHCPUser() async {
    currentHCPMap = await hcpServices.getHCPUser(hcpId!);
    gEmail = currentHCPMap!['email'];
    DateTime cd = DateTime.now();
    startDate = new DateTime(cd.year, cd.month, 1);
    endDate = getLastDayOfMonth(cd);
    debugPrint('line 129: $startDate $endDate');
    debugPrint('line 130: ${orgId!}');
    return;
  }

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;
  bool hasData = false;

  Map<String, dynamic>? arguments;
  DateTime getLastDayOfMonth(DateTime date) {
    // Create a DateTime object for the first day of the *next* month.
    // Dart's DateTime constructor handles month overflow automatically,
    // so if the current month is December (12), month + 1 will become January of the next year.
    final firstDayOfNextMonth = DateTime(date.year, date.month + 1, 1);

    // Subtract one day from the first day of the next month.
    // This will result in the last day of the original month.
    return firstDayOfNextMonth.subtract(Duration(days: 1));
  }

  Map<String, dynamic>? currentHCPMap;
  @override
  void initState() {
    super.initState();
    paymentService = HCPPaymentDataService();
    arguments = widget.args;
    hcpId = arguments!['hcpId'];
    orgId = dotenv.env['ASM_DB1'];
    if (orgId == null) {
      throw Exception('line 162 orgid is null');
    }
    getHCPUser();

    //listOfHolidays = paymentService.getListOfHCPHolidays();
  }

  bool checkIsWeekend(int dayValue) {
    if (dayValue == 6 || dayValue == 7) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIsHoliday(
      DateTime currentDate, int nWeeks, List<List<DateTime>> daysInWeek) {
    //get list of all holidays
    //get list of client holidays;
    //get specific holiday with current date
    //does it clients holidays
    return false;
  }

  bool toggleDaySelection = true;
  final DateRangePickerController _controller = DateRangePickerController();
  DateTime? selectedDate;
  List<DateTime> selectedDates = [];
  DateRangePickerSelectionMode _selectionMode =
      DateRangePickerSelectionMode.range;

  List<DateTime> dateTimeList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('line 63 didchange');

  }

  String getShortDate(String dt) {
    return dt.substring(0, 10);
  }

  double smallFontSize = 12;
  bool allowNavigationMode = true;
  bool showNavigationArrow = true;
  DateTime? startDate;
  DateTime? endDate;
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
    smallFontSize = 12;
    smallFontSize /= h;

    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("HCP Payments Details",
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            )),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                Navigator.of(context)
                    .pushNamed(hcpSchedulingMenu, arguments: arguments!);
              } catch (error) {
                debugPrint("Error during logout ${error}");
                throw Exception('Error logging out. ${error.toString()}');
              }
            },
            icon: const Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            hasDates == false
                ? Container(
                    height: 500,
                    width: screenWidth! - 10,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: screenWidth! - 10,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: color2),
                          ),
                          child: Center(
                            child: Container(
                              height: 24,
                              width: screenWidth! - 10,
                              child: Text(
                                'Select Check Date (Must be >= 2 and <= 7 days)',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: 32,
                          width: screenWidth! - 10,
                          child: Center(
                            child: Text('Select Check Dates',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SafeArea(
                            child: Container(
                              height: 270,
                              width: screenWidth! - 10,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      height: 270,
                                      width: screenWidth! - 10,
                                      child: SfDateRangePicker(
                                        // minDate: startDate,
                                        // maxDate: endDate,
                                        showActionButtons: false,
                                        allowViewNavigation:
                                            allowNavigationMode,
                                        toggleDaySelection: toggleDaySelection,
                                        onViewChanged:
                                            ((DateRangePickerViewChangedArgs
                                                args) {
                                          debugPrint(
                                              'line 315 on view changed ${args.view}');
                                          dateTimeList = [];
                                          _controller.selectedRange = null;
                                        }),
                                        onSelectionChanged:
                                            (DateRangePickerSelectionChangedArgs
                                                args) async {
                                          debugPrint(
                                              'line 387: ${dateTimeList.length} ${args} ${args.value}');
                                          if (args.value is PickerDateRange) {
                                            hasData = false;
                                            final PickerDateRange
                                                selectedRange = args.value;
                                            if (selectedRange.startDate !=
                                                    null &&
                                                selectedRange.endDate != null) {
                                              // A date range has been selected
                                              debugPrint(
                                                  'line 303 Selected range: ${selectedRange.startDate} - ${selectedRange.endDate}');

                                              DateTime start =
                                                  args.value.startDate;
                                              DateTime end = args.value.endDate;
                                              int difference =
                                                  end.difference(start).inDays +
                                                      1;
                                              debugPrint('line 311: $difference');
                                              // if (difference == 1) {
                                              //   return;
                                              // }
                                              if (difference < 2 || difference > 7) {
                                                _showDialog(
                                                    context,
                                                    'Days In Range',
                                                    'Selected range must be >= 2 and <= to 7');
                                                dateTimeList = [];
                                                _controller.selectedRange =
                                                    null;
                                                setState(() {
                                                  allowNavigationMode = true;
                                                  showNavigationArrow = true;
                                                });

                                                return;
                                              }
                                              setState(() {
                                                allowNavigationMode = false;
                                                showNavigationArrow = false;
                                              });
                                              ;
                                              dateTimeList = [];
                                              dateTimeList.add(
                                                  selectedRange.startDate!);
                                              dateTimeList
                                                  .add(selectedRange.endDate!);
                                              hasData = true;
                                            } else {
                                              if (selectedRange.startDate !=
                                                  null) {
                                                setState(() {
                                                  allowNavigationMode = false;
                                                  showNavigationArrow = false;
                                                });
                                              }
                                            }
                                            //   } else if (selectedRange
                                            //           .startDate !=
                                            //       null) {
                                            //     // A single date might be selected
                                            //     debugPrint(
                                            //         'Selected date: ${selectedRange.startDate}');
                                            //   }
                                            //
                                            //   debugPrint(
                                            //       'Selected start date: ${selectedRange.startDate}');
                                            //   debugPrint(
                                            //       'Selected end date: ${selectedRange.endDate}');
                                          }
                                        },
                                        controller: _controller,
                                        showNavigationArrow:
                                            showNavigationArrow,
                                        view: DateRangePickerView.month,
                                        headerStyle: DateRangePickerHeaderStyle(
                                            backgroundColor: color1,
                                            textAlign: TextAlign.center,
                                            textStyle: TextStyle(
                                                fontStyle: FontStyle.normal,
                                                fontSize: fontSize,
                                                letterSpacing: 5,
                                                color: Colors.black87)),
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
                                                width: 1), //Border.all
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
                                              color: Colors.black),
                                          disabledDatesTextStyle: TextStyle(
                                              fontSize: fontSize,
                                              color: Colors.black),
                                          todayTextStyle: TextStyle(
                                              fontSize: fontSize,
                                              color: Colors.black),
                                          leadingDatesTextStyle: TextStyle(
                                              fontSize: fontSize,
                                              color: Colors.black),
                                        ),
                                        enablePastDates: true,
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
                        ), //padding
                        //end of datepicker
                        //need elevated button
                        Flexible(
                          fit: FlexFit.loose,
                          child: Center(
                            child: Container(
                              height: 40,
                              width: screenWidth! - 10,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _onSubmit();
                                        },
                                        child: Center(
                                          child:
                                              Text('Press to Show Payment Data',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : hasDates == true
                    ? Container(
                        height: 550,
                        width: screenWidth! - 10,
                        child: Column(
                          children: [
                            FutureBuilder<List<dynamic>>(
                                future:
                                    Future.wait([_getHCPPaymentData(context)]),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
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
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    );
                                  } else if (snapshot.data == [[]] &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    return Center(
                                      child: Container(
                                        height: 100,
                                        width: screenWidth! - 10,
                                        child: Text(
                                            'There were no payments returned from the dates entered.',
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
                                    List<dynamic> data = snapshot.data![0];
                                    debugPrint('line 111 ${data.length}');
                                    if (data.length == 0) {
                                      return Center(
                                        child: Container(
                                          height: 100,
                                          width: screenWidth! - 10,
                                          child: Text(
                                              'There were no payments returned from the dates entered.',
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
                                      return Container(
                                        height: 500,
                                        width: screenWidth! - 10,
                                        child: ListView.builder(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            itemCount: listH.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final item = listH[index];
                                              return Container(
                                                height: 140,
                                                width: screenWidth! - 10,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    border: Border.all(
                                                        color: Colors.black87),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 5),
                                                    Container(
                                                      height: 30,
                                                      width: screenWidth! - 10,
                                                      child: Text(
                                                        'Chk#: ${item['checkNumber']}',
                                                        style: TextStyle(
                                                            fontSize: fontSize,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Container(
                                                        height: 30,
                                                        width:
                                                            screenWidth! - 10,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'chkDate: ${getShortDate(item['checkDate'])}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              'Period Ending: ${getShortDate(item['periodEnding'])}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Expanded(
                                                      child: Container(
                                                        height: 30,
                                                        width:
                                                            screenWidth! - 10,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'Wages: \$${item['checkAmount']}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              'Gross: \$${item['grossWages']}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Container(
                                                      height: 24,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: color2)),
                                                      child: ElevatedButton(
                                                        onPressed: () {

                                                          dynamic cim =
                                                              listH[index];
                                                          debugPrint(
                                                              'line 681: $cim');
                                                            dynamic paymentItem =
                                                            {
                                                              'checkRegisterId': cim[
                                                              'checkRegisterId'],
                                                              'checkNumber': cim[
                                                              'checkNumber'],
                                                              'checkDate': cim[
                                                              'checkDate'],
                                                              'checkAmount': cim[
                                                              'checkAmount'],
                                                              'grossWages': cim[
                                                              'grossWages'],
                                                              'payPeriodId': cim[
                                                              'payPeriodId'],
                                                              'payPeriodEnding': cim[
                                                              'periodEnding'],
                                                              'use1099':
                                                              cim['use1099'],
                                                              'void': cim['void'],
                                                              'regId':
                                                              cim['regId'],
                                                              'regName':
                                                              cim['regName'],
                                                              'ssn4': cim['ssn4'],
                                                              'employeeId': cim[
                                                              'employeeId'],
                                                              'branchName': cim[
                                                              'branchName'],
                                                              'index': index
                                                            };
                                                            debugPrint(
                                                                'line 713: $paymentItem ');
                                                             debugPrint('line 714: ${orgId!} ');
                                                             debugPrint('line 715: $hcpId ');
                                                             debugPrint('line 715: ${arguments!}');
                                                             debugPrint('ine 717: ${context}');
                                                            Map<String,
                                                                dynamic> mapItem = {
                                                              'paymentItem': paymentItem!,
                                                              'orgId': orgId!,
                                                              'hcpId': hcpId,
                                                              'ctx': context,
                                                              'args': arguments!
                                                            };
                                                            debugPrint('line 722');
                                                            Navigator
                                                                .of(context)
                                                                .pushNamed(
                                                                hcpPaymentDetailsData,
                                                                arguments: mapItem);

                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          elevation: 0,
                                                        ),
                                                        child: Text(
                                                          "Display Payment Details",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  fontSize,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      );
                                    }
                                  }
                                }),
                          ],
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
