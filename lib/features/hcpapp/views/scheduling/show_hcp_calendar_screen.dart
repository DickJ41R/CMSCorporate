import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';

final dio = Dio();

class ShowHCPCalendarScreen extends StatefulWidget {
  final BuildContext ctx;
  final List<dynamic> listOfHolidays;

  const ShowHCPCalendarScreen(
      {super.key, required this.ctx, required this.listOfHolidays});

  @override
  _ShowHCPCalendarScreenState createState() => _ShowHCPCalendarScreenState();
}

class _ShowHCPCalendarScreenState extends State<ShowHCPCalendarScreen> {
  //dynamic _localRef;
  List<dynamic> listOfDates = [];
  final DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  List<DateTime> listOfTempDates = [];
  int? hcpId;
  String? gEmail;
  Users? user;
  dynamic currentUser;
  AuthService authService = AuthService();
  Map<String, dynamic>? hcpUser;
  HCPServices hcpServices = HCPServices();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print('line 28 onselection chANGED');

    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    print('line 59: $args ${args.value}');
    listOfTempDates = [];
    DateTime rangeEndDate;

    if (args.value is PickerDateRange) {
      final DateTime rangeStartDate = args.value.startDate;
      listOfTempDates.add(rangeStartDate);
      if (args.value.endDate != null) {
        rangeEndDate = args.value.endDate;
      } else {
        rangeEndDate = args.value.startDate;
      }
      listOfTempDates.add(rangeEndDate);
      print('line 42: $listOfTempDates');
    } else if (args.value is DateTime) {
      final DateTime selectedDate = args.value;
      listOfTempDates.add(selectedDate);
      print('line 45: $listOfTempDates');
    } else if (args.value is List<DateTime>) {
      final List<DateTime> selectedDates = args.value;
      listOfTempDates = selectedDates;
      print('line 47: $listOfTempDates');
    } else {
      final List<PickerDateRange> selectedRanges = args.value;
      print('line 49: $selectedRanges');
      for (int i = 0; i < selectedRanges.length; i++) {
        if (selectedRanges[i].startDate != null) {
          listOfTempDates.add(selectedRanges[i].startDate!);
        }
        if (selectedRanges[i].endDate != null) {
          listOfTempDates.add(selectedRanges[i].endDate!);
        }
      }
    }
    print('line 55: $listOfTempDates');
  }

  Future<String> _showDialog(
      BuildContext context, String title, String? description) async {
    print('line `12 showdialog');
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.of(context).pop(); // Close the dialog
    // });
    String val = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(description!),
              contentTextStyle: const TextStyle(
                color: Color.fromARGB(255, 19, 125, 103),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              titleTextStyle: const TextStyle(
                  color: Color.fromARGB(255, 19, 125, 103),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 125, 103)),
                  ),
                )
              ],
            ));
    return val;
  }

  void _onSubmit(dynamic obj) {
    print('line 115: $obj');

    listOfTempDates = [];
    if (obj is PickerDateRange) {
      print('line 118  $obj');
      // final DateTime rangeStartDate = obj.startDate!;
      //  final DateTime rangeEndDate = obj.endDate!;
      //     print('line 49: $selectedRanges');
      DateTime? sdt = obj.startDate;
      DateTime? edt = obj.endDate;
      listOfTempDates.add(sdt!);
      DateTime v = sdt;
      //    print('line 97: $v $sdt $edt');
      if (edt != null) {
        while (v != edt) {
          v = v.add(Duration(days: 1));
          print('line 131: $v');
          listOfTempDates.add(v);
        }
      }
      //     print('line 42: $listOfTempDates');
    } else if (obj is DateTime) {
      print('line 137 ');
      final DateTime selectedDate = obj;
      listOfTempDates.add(selectedDate);
      //    print('line 45: $listOfTempDates');
    } else if (obj is List<DateTime>) {
      print('line 142 ');
      final List<DateTime> selectedDates = obj;
      listOfTempDates = selectedDates;
      //    print('line 47: $listOfTempDates');
    } else {
      print('line 147 ');
    }
    print('line 159: $listOfTempDates');

    //   bool isMultiple = false;
    // dynamic fromDate;
    //  dynamic toDate;
    for (int i = 0; i < listOfTempDates.length; i++) {
      //    print('line 112');
      DateTime dte = listOfTempDates[i];
      Map<String, dynamic> cro = _getColor(dte);
      //     print('line 115');
      String shortDate = getShortStringDate(dte);
      //     print('line 116 $cro $shortDate');

      // if (_selectedValue != 1) {
      //   isMultiple = true;
      //
      // }
      Map<String, dynamic> ob = {
        "date": dte,
        "color": cro['color'],
        "weekend": cro['isWeekendDay'],
        "holiday": cro['isHolidayDay'],
        "shortDate": shortDate,
        "dayValue": cro['dayValue'],
        'dateType': _selectedValue == 1
            ? 'Single'
            : _selectedValue == 2
                ? 'Multiple'
                : '',
        'isMultiple': _selectedValue == 1 ? false : true
      };
      listOfDates.add(ob);
    }
    if (_selectedValue == 2 || _selectedValue == 3) {
      listOfDates.sort((a, b) => a['date'].compareTo(b['date']));
    }
    if (_selectedValue == 3) {
      for (int i = 0; i < listOfDates.length; i++) {
        Map<String, dynamic> ob = listOfDates[i];
        if (i == 0) {
          ob['dateType'] = 'First';
        } else if (i == listOfDates.length - 1) {
          ob['dateType'] = 'Last';
        } else {
          ob['dateType'] = 'Middle';
        }
      }
    }

    print('line 125: $listOfDates');

    //   _localRef.read(appServicesNotifierProvider.notifier).updateListOfDates(listOfTempDates);
    //   _localRef.read(calendarServicesNotifierProvider.notifier).updateListOfDates(listOfTempDates);

    setState(() {
      _dateRangePickerController.selectedDates = listOfTempDates;
    });
  }

  bool isWeekEnd(DateTime dte) {
    bool yesNo = false;
    //  print('line 372: $dte');
    DateFormat formatter = DateFormat('MM/dd/YYYY');
    String stringShiftDate = formatter.format(dte);
    DateTime shiftDate = DateTime.parse(stringShiftDate);
    int saturday = DateTime.saturday;
    int sunday = DateTime.sunday;
    int shiftDay = shiftDate.weekday;
    //  print('line 379: $saturday $sunday $shiftDay');
    if (shiftDay == saturday || shiftDay == sunday) {
      yesNo = true;
    }
    return yesNo;
  }

  bool isHoliday(DateTime shiftDate) {
    bool yesNo = false;
    //   DateFormat formatterx = DateFormat('MM/dd/YYYY');
    // String shortDate = formatterx.format(shiftDate);
    //DateTime ssdte = DateTime.parse(shortDate);
    //   print('line 394: ${widget.listOfHolidays}');

    DateTime cte = DateTime.now();
    String sYear = cte.year.toString();
    //  DateFormat formatter = DateFormat('yyyy-MM-dd');
    yesNo = false;
    //   Map<String,dynamic>? foundMap;
    for (int i = 0; i < widget.listOfHolidays.length; i++) {
      Map<String, dynamic> mp = widget.listOfHolidays[i];
      //    print('line 415: $mp');
      if (mp['type'] == 'specific') {
        String shortDate = mp['holiDate'];
        shortDate = sYear + shortDate.substring(4, 10);
        DateTime hte = DateTime.parse(shortDate);
        if (hte.year == cte.year &&
            hte.month == cte.month &&
            hte.day == cte.day) {
          yesNo = true;
          //   foundMap = mp;
          break;
        }
      } else {
        //derived nned to add derived code
        continue;
      }
    }
    if (yesNo == true) {
      return true;
    } else {
      return false;
    }
  }

  Map<String, dynamic> _getColor(DateTime dte) {
//    print('line 173 get color $dte');
    bool isWeekendDay = isWeekEnd(dte);
    Color cr = Colors.black87;
    if (isWeekendDay == true) {
      cr = Color.fromARGB(255, 240, 86, 45);
    }
    final DateFormat format2 = DateFormat('EEEE');
    String dayValue = format2.format(dte);
    bool isHolidayDay = isHoliday(dte);
    if (isHolidayDay == true) {
      cr = Color.fromARGB(255, 0, 0, 255);
    }
    Map<String, dynamic> obj = {
      "isWeekendDay": isWeekendDay,
      "isHolidayDay": isHolidayDay,
      "color": cr,
      "dayValue": dayValue
    };
    return obj;
  }

  String getShortStringDate(DateTime date) {
    //  print('line 189: in getshortsringdates');

    String dts = date.toString();
    List<String> sda = dts.split(' ');
    dts = sda[0].trim();
    return dts;
  }

  void getHCPUserX() async {
    print('line 44 in get usrx');
    await getHCPUser();
  }

  Future<Map<String, dynamic>> getHCPUser() async {
    print('line 50 gethcpuser available shfts: $hcpServices');
    try {
      Map<String, dynamic>? lm = await hcpServices.getHCPUser(hcpId!);

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
  Map<String,dynamic>?currentHCPMap;
  String? fullName;
  @override
  void initState() {
    super.initState();
    currentHCPMap = authService.currentHCPMap;

    gEmail = currentHCPMap!['email'];
    hcpId =  currentHCPMap!['hcpId'];

    print('check');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('line 63 didchange');

    getHCPUserX();
  }

  int _selectedValue = 1;
  DateRangePickerSelectionMode _selectionMode =
      DateRangePickerSelectionMode.single;
  @override
  Widget build(BuildContext context) {
    //  var _localRef = ref;
    double width = MediaQuery.of(context).size.width;
    //  print('line 54: $width');
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Selection Calendar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(widget.ctx).pop(listOfDates);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                height: 400,
                width: width - 10,
                child: Center(
                  child: SfDateRangePicker(
                    enablePastDates: false,
                    showActionButtons: true,
                    todayHighlightColor: Colors.green,
                    onSubmit: _onSubmit,
                    selectionColor: Color.fromARGB(255, 19, 125, 103),
                    backgroundColor: Colors.grey[200],
                    onSelectionChanged: _onSelectionChanged,
                    selectionTextStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    selectionMode: _selectionMode,
                    view: DateRangePickerView.month,
                    monthViewSettings:
                        DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                  ),
                ),
              ),
              // Button for getting request
              SizedBox(height: 10),
              Center(
                child: Container(
                  height: 120,
                  width: 240,
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        width: 240,
                        child: Text('Date Selection Type'),
                      ),
                      Container(
                        height: 32,
                        width: 240,
                        padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: RadioListTile(
                          title: Text('Single Date'),
                          value: 1, // Assign a value of 1 to this option
                          groupValue:
                              _selectedValue, // Use _selectedValue to track the selected option
                          onChanged: (value) {
                            setState(() {
                              print('line 306 single: $value');
                              _selectionMode =
                                  DateRangePickerSelectionMode.single;
                              _selectedValue =
                                  value!; // Update _selectedValue when option 1 is selected
                            });
                          },
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 240,
                        child: RadioListTile(
                          title: Text(
                              'Multiple Dates'), // Display the title for option 2
                          value: 2, // Assign a value of 2 to this option
                          groupValue:
                              _selectedValue, // Use _selectedValue to track the selected option
                          onChanged: (value) {
                            setState(() {
                              print('line 324 multiple: $value');
                              _selectionMode =
                                  DateRangePickerSelectionMode.multiple;
                              _selectedValue =
                                  value!; // Update _selectedValue when option 2 is selected
                            });
                          },
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 240,
                        child: RadioListTile(
                          title: Text(
                              'Date Range'), // Display the title for option 2
                          value: 3, // Assign a value of 3 to this option
                          groupValue:
                              _selectedValue, // Use _selectedValue to track the selected option
                          onChanged: (value) {
                            setState(() {
                              print('line 339 range: $value');
                              _selectionMode =
                                  DateRangePickerSelectionMode.range;
                              _selectedValue =
                                  value!; // Update _selectedValue when option 2 is selected
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: Container(
                  height: 32,
                  width: 240,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(12)),
                  child: ElevatedButton(
                    onPressed: (() {
                      String str =
                          'Note: Regardless of which approach you use, you cannot select more than 7 days.';
                      _showDialog(context, 'Date Type Instructions', str);
                    }),
                    child: Container(
                      height: 32,
                      width: 240,
                      child: const Center(
                        child: Text('Date Type Information',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
