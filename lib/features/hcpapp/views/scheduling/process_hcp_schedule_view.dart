//process_hcp_schedule_view
/// Dart import.
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';

class ProcessHCPScheduleView extends StatefulWidget {
  final Map<String, dynamic> args;
  ProcessHCPScheduleView({super.key, required this.args});

  @override
  ProcessHCPScheduleViewState createState() => ProcessHCPScheduleViewState();
}

class ProcessHCPScheduleViewState extends State<ProcessHCPScheduleView> {
  String? dropDownValue;
  CalendarController calendarController = CalendarController();
  final List<Appointment> _appointmentDetails = <Appointment>[];
  HCPServices hcpServices = HCPServices();
  AuthService authService = AuthService();

  late _DataSource dataSource;
  late int hcpId;
  List<dynamic>? lstApts;
  bool flagHaveData = false;
  Future<void> getRawDataForDataSourceX(int hcpId, BuildContext ctx) async {
    await getRawDataForDataSource(hcpId, ctx);
  }

  Future<void> getRawDataForDataSource(int hcpId, BuildContext ctx) async {
    print('line 37 in getrawdatasource');
    try {
      bool working = false;
      Center(
        child: Container(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            value: working == false ? null : 1,
            backgroundColor: Colors.cyanAccent,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        ),
      );
      lstApts = await hcpServices.getHCPWorkOrderCampaigns(hcpId, ctx);
      working = true;
      if (lstApts!.isNotEmpty) {
        print('line 36: ${lstApts![0]}');
        setState(() {
          flagHaveData = true;
          dataSource = getCalendarDataSource();
        });
      }
      print('line 47 just before return');
      return;
    } catch (e) {
      print('line 46 error: ${e.toString()}');
      return null;
    }
  }
  Map<String,dynamic>? currentHCPMap;
  Map<String,dynamic>?arguments;
  UtilitiesServices utilitiesServices = UtilitiesServices();
  @override
  void initState() {
    // TODO: implement initState

    arguments = widget.args;
    hcpId = arguments!['hcpId'];
    getRawDataForDataSourceX(hcpId, context);

    setOrientationPreference(1);
    super.initState();
  }

  @override
  void dispose() {
    calendarController.dispose();
    //setOrientationPreference(1);
    super.dispose();
  }

  Future<void> setOrientationPreference(int c) async {
    await setOrientationPreferenceX(c);
  }

  Future<void> setOrientationPreferenceX(int c) async {
    print('line 32 setorientationprefx');
    if (c == 0) {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    double fontSize = 16;
    fontSize /= h;
    print('line 40 after setorientation pref: $flagHaveData');
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Work Schedule'),
              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(Icons.arrow_back),
              //     onPressed: () {
              //       print('line 41: in onpressed back');
              //       calendarController.backward!();
              //     },
              //   ),
              //   IconButton(
              //     icon: Icon(Icons.arrow_forward),
              //     onPressed: () {
              //       print('line 48 in onpressed forward');
              //
              //       calendarController.forward!();
              //     },
              //   ),
              // ],
            ),
            body: flagHaveData == true
                ? Column(
                    children: [
                      Expanded(
                        child: SfCalendar(
                          view: CalendarView.month,
                          dataSource: dataSource,
                          initialSelectedDate:
                              DateTime.now().add(const Duration(days: -1)),
                          onSelectionChanged: selectionChanged,
                          onTap: calendarTapped,
                          // showNavigationArrow: true,
                          // showDatePickerButton: true,
                          //    dataSource: _DataSource(getAppointments()),
                          // onTap: calendarTapped,
                          // firstDayOfWeek: 1,
                          // view: CalendarView.schedule,
                          // viewHeaderHeight: 0,
                          // viewHeaderStyle: ViewHeaderStyle(
                          //     backgroundColor: Colors.grey,
                          //     dayTextStyle: TextStyle(
                          //         fontSize: 18,
                          //         color: Color(0xFFff5eaea),
                          //         fontWeight: FontWeight.w500),
                          //     dateTextStyle: TextStyle(
                          //         fontSize: 22,
                          //         color: Color(0xFFff5eaea),
                          //         letterSpacing: 2,
                          //         fontWeight: FontWeight.w500)),
                          // // allowViewNavigation: true,
                          // // timeSlotViewSettings:
                          // //     const TimeSlotViewSettings(numberOfDaysInView: 7),
                          // scheduleViewSettings: ScheduleViewSettings(
                          //   hideEmptyScheduleWeek: true,
                          //   appointmentItemHeight: 60,
                          //   appointmentTextStyle: TextStyle(
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.black),
                          //   dayHeaderSettings: DayHeaderSettings(
                          //       dayFormat: 'EEEE',
                          //       width: 70,
                          //       dayTextStyle: TextStyle(
                          //         fontSize: 10,
                          //         fontWeight: FontWeight.w300,
                          //         color: Colors.red,
                          //       ),
                          //       dateTextStyle: TextStyle(
                          //         fontSize: 12,
                          //         fontWeight: FontWeight.w300,
                          //         color: Colors.red,
                          //       )),
                          //   weekHeaderSettings: WeekHeaderSettings(
                          //       startDateFormat: 'dd MMM ',
                          //       endDateFormat: 'dd MMM, yy',
                          //       height: 40,
                          //       textAlign: TextAlign.center,
                          //       backgroundColor: Colors.red,
                          //       weekTextStyle: TextStyle(
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.w400,
                          //         fontSize: 15,
                          //       )),
                          //   monthHeaderSettings: MonthHeaderSettings(
                          //       monthFormat: 'MMMM, yyyy',
                          //       height: 0,
                          //       textAlign: TextAlign.left,
                          //       backgroundColor: Colors.green,
                          //       monthTextStyle: TextStyle(
                          //           color: Colors.red,
                          //           fontSize: 25,
                          //           fontWeight: FontWeight.w400)),
                          // ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                              color: Colors.black12,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(2),
                                itemCount: _appointmentDetails.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      padding: EdgeInsets.all(2),
                                      height: 80,
                                      color: _appointmentDetails[index].color,
                                      child: ListTile(
                                          leading: Column(
                                            children: <Widget>[
                                              Text(
                                                _appointmentDetails[index]
                                                        .isAllDay
                                                    ? ''
                                                    : '${DateFormat('hh:mm a').format(_appointmentDetails[index].startTime)}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    height: 1.7),
                                              ),
                                              Text(
                                                _appointmentDetails[index]
                                                        .isAllDay
                                                    ? 'All day'
                                                    : '',
                                                style: TextStyle(
                                                    height: 0.5,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                _appointmentDetails[index]
                                                        .isAllDay
                                                    ? ''
                                                    : '${DateFormat('hh:mm a').format(_appointmentDetails[index].endTime)}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          // trailing: Container(
                                          //     child: getIcon(
                                          //         _appointmentDetails[index]
                                          //             .subject)),
                                          title: Container(
                                              width: screenWidth - 100,
                                              child: Text(
                                                  '${_appointmentDetails[index].subject}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10,
                                                      color: Colors.white))),
                                          subtitle: Container(
                                              width: screenWidth - 100,
                                              child: Text(
                                                  '${_appointmentDetails[index].notes}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10,
                                                      color: Colors.white)))));
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                  height: 5,
                                ),
                              )))
                    ],
                  )
                : Container()));

    //       Expanded(
    //         child: ListView.separated(
    //           itemCount: _appointmentDetails.length,
    //           itemBuilder: (BuildContext context, int index) {
    //             return Container(
    //                 height: 120,
    //                 width: screenWidth -10,
    //                 padding: EdgeInsets.all(2),
    //                 color: _appointmentDetails[index].color,
    //                 child: ListTile(
    //                   leading: Column(
    //                     children: <Widget>[
    //                       Text(
    //                         _appointmentDetails[index].isAllDay
    //                             ? ''
    //                             : '${DateFormat('hh:mm a').format(_appointmentDetails[index].startTime)}',
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                           fontWeight: FontWeight.w600,
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                       // Text(
    //                       //   _appointmentDetails[index].isAllDay
    //                       //       ? 'All day'
    //                       //       : '',
    //                       //   style: TextStyle(
    //                       //       height: 0.5, color: Colors.white),
    //                       // ),
    //                       Text(
    //                         _appointmentDetails[index].isAllDay
    //                             ? ''
    //                             : '${DateFormat('hh:mm a').format(_appointmentDetails[index].endTime)}',
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.w600,
    //                             color: Colors.white),
    //                       ),
    //                     ],
    //                   ),
    //                   // trailing: Container(
    //                   //     child: getIcon(
    //                   //         _appointmentDetails[index]
    //                   //             .subject)),
    //
    //                   title: Container(
    //                       width: screenWidth - 100,
    //                       padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
    //                       child: Text(
    //                           '${_appointmentDetails[index].subject}',
    //                           textAlign: TextAlign.left,
    //                           style: TextStyle(
    //                               fontWeight: FontWeight.w600,
    //                               fontSize: 10,
    //                               color: Colors.white))),
    //                   subtitle: Container(
    //                     width: screenWidth - 100,
    //                     child: Text(
    //                       '${_appointmentDetails[index].notes}',
    //                       textAlign: TextAlign.left,
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.w600,
    //                           fontSize: 10,
    //                           color: Colors.white),
    //                     ),
    //                   ),
    //                   trailing: Container(
    //                     width: screenWidth - 100,
    //                     child: Text(
    //                       '${_appointmentDetails[index].location}',
    //                       textAlign: TextAlign.left,
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.w600,
    //                           fontSize: 10,
    //                           color: Colors.white),
    //                     ),
    //                   ),
    //                 ));
    //           },
    //           separatorBuilder: (BuildContext context, int index) =>
    //               const Divider(
    //             height: 5,
    //           ),
    //         ),
    //       ),
    //     ],
    //   )
    // : Container()));
  }

  void selectionChanged(CalendarSelectionDetails calendarSelectionDetails) {
    getSelectedDateAppointments(calendarSelectionDetails.date);
  }

  void getSelectedDateAppointments(DateTime? selectedDate) {
    print('line 259: $selectedDate');

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _appointmentDetails.clear();
      });

      if (dataSource.appointments!.isEmpty) {
        return;
      }

      for (int i = 0; i < dataSource.appointments!.length; i++) {
        Appointment appointment = dataSource.appointments![i] as Appointment;

        /// It return the occurrence appointment for the given pattern appointment at the selected date.
        final Appointment? occurrenceAppointment =
            dataSource.getOccurrenceAppointment(appointment, selectedDate!, '');

        print(
            'line 276: $appointment  ${appointment.startTime} ${appointment.startTime.year}');
        if ((DateTime(appointment.startTime.year, appointment.startTime.month,
                    appointment.startTime.day) ==
                DateTime(
                    selectedDate.year, selectedDate.month, selectedDate.day)) ||
            occurrenceAppointment != null) {
          setState(() {
            _appointmentDetails.add(appointment);
          });
        }
      }
    });
  }

  Appointment buildAppointment(dynamic obj) {
    Appointment? apt;
    try {
      print('line 290: buildapt $obj');
      int secs = obj['shiftDate']['_seconds'];
      secs *= 1000;
      DateTime dtm = DateTime.fromMillisecondsSinceEpoch(secs);
      print('line 299: $secs');
      Timestamp stm = Timestamp.fromDate(dtm);
      print('line 301: $stm');
      DateTime st = stm.toDate();
      Color color1 = Colors.pinkAccent; //green from website
      Color color2 = Colors.purpleAccent; //green from logo
      Color color3 = Colors.lightBlue;
      List<Color> colors = [color1, color2, color3];
      List<String> disciplines = ['CNA', 'LPN', 'RN'];
      //clear out all time
      st = st.subtract(Duration(
          hours: st.hour,
          minutes: st.minute,
          seconds: st.second,
          microseconds: st.microsecond,
          milliseconds: st.millisecond));
      DateTime et = st;
      String shiftStart = obj['startTime'];
      String shiftEnd = obj['endTime'];
      Map<String, dynamic> startHoursMinutes =
          utilitiesServices.getHoursMinutes(shiftStart);
      Map<String, dynamic> endHoursMinutes =
          utilitiesServices.getHoursMinutes(shiftEnd);
      st = st.add(Duration(
          hours: startHoursMinutes['hours'],
          minutes: startHoursMinutes['minutes']));
      et = et.add(Duration(
          hours: endHoursMinutes['hours'],
          minutes: endHoursMinutes['minutes']));
      print('line 318: $st $et');
      int fi = obj['clientName'].toString().indexOf(' ');
      if (fi == -1) {
        if (obj['clientName'].toString().length < 8) {
          fi = obj['clientName'].toString().length;
        } else {
          fi = 8;
        }
      } else if (fi > 8) {
        fi = 8;
      }
      String clN = obj['clientName'].toString().substring(0, fi);
      String subjectText = "Shift: " + obj['shiftCode'];
      subjectText += "   Discipline: " + obj['disciplineName'];
      subjectText += "   Count: " + obj['shiftCount'].toString();
      String statuses = '';
      String sts = '';
      for (int j = 0; j < obj['shiftStatuses'].length; j++) {
        if (j > 0) {
          sts += ', ';
        }
        sts += obj['shiftStatuses'][j];
      }
      print('line 463: $sts');
      statuses = obj['shiftStatuses'][0];
      int index = disciplines.indexOf(obj['disciplineName']);
      print('line 329: $clN $subjectText ${index.toString()}');
      String notes = "Statuses: " + statuses;
      notes += ' Client: ' + clN;
      Appointment apt = Appointment(
          startTime: st,
          endTime: et,
          subject: subjectText,
          color: colors[index],
          notes: notes);

      // for (int j = 0; j < obj['shiftStatuses'].length; j++) {
      //   if (obj['shiftStatuses'])
      //   if (j > 0) {
      //     statuses += ', ';
      //   }
      //   statuses += obj['shiftStatuses'][j];
      // }

      // int index = disciplines.indexOf(obj['disciplineName']);
      // print('line 329: $subjectText ${index.toString()}');
      // Appointment apt = Appointment(
      //     startTime: st,
      //     endTime: et,
      //     subject: subjectText,
      //     //      location: locationText,
      //     color: colors[index],
      //     notes: 'Statuses: ' + statuses);
      return apt;
    } catch (e) {
      print('line 333 error: ${e.toString()}');
      throw Exception('line 334 errro: ${e.toString()}');
    }
  }

  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    print('line 313 in getCalendarDataSource');
    try {
      for (int i = 0; i < lstApts!.length; i++) {
        var obj = lstApts![i];
        print('line 346: $obj');
        Appointment apt = buildAppointment(obj);
        appointments.add(apt);
        // DateTime startTime = apt.startTime;
        // DateTime endTime = startTime.add(const Duration(hours: 8));
        //
        // appointments.add(Appointment(
        //   startTime: startTime,
        //   endTime: endTime,
        //   subject: 'CNA',
        //   color: Colors.red,
        // ));
        // appointments.add(Appointment(
        //   startTime: startTime,
        //   endTime: endTime,
        //   subject: 'LPN',
        //   color: Colors.lightBlueAccent,
        // ));
        //
        // appointments.add(Appointment(
        //   startTime: startTime,
        //   endTime: endTime,
        //   subject: 'RN',
        //   color: const Color(0xFFfb21f66),
        // ));
        // startTime = startTime.add(Duration(hours: 8));
        // endTime = startTime.add(Duration(hours: 8));
        // appointments.add(Appointment(
        //   startTime: startTime,
        //   endTime: endTime,
        //   subject: 'CNA',
        //   color: Colors.red,
        // ));
        // appointments.add(Appointment(
        //   startTime: startTime,
        //   endTime: endTime,
        //   subject: 'LPN',
        //   color: Colors.lightBlueAccent,
        // ));
        // appointments.add(Appointment(
        //   startTime: startTime,
        //   endTime: endTime,
        //   subject: 'RN',
        //   color: const Color(0xFFf3282b8),
        // ));
        // startTime = startTime.add(Duration(hours: 8));
        // endTime = startTime.add(Duration(hours: 8));
        // appointments.add(Appointment(
        //   startTime: startTime,
        //   endTime: endTime,
        //   subject: 'CNA',
        //   color: Colors.red,
        // ));
        // appointments.add(Appointment(
        //   startTime: startTime,
        //   endTime: endTime,
        //   subject: 'LPN',
        //   color: Colors.lightBlueAccent,
        // ));
        // appointments.add(Appointment(
        //   startTime: startTime,
        //   endTime: endTime,
        //   subject: 'RN',
        //   color: const Color(0xFFf3282b8),
        // ));
      }
      return _DataSource(appointments);
    } catch (e) {
      print('line 405 error: ${e.toString()}');
      throw Exception('line 406 error: ${e.toString()}');
    }
  }

  ImageIcon getIcon(String subject) {
    if (subject.contains('CNA') == true) {
      return ImageIcon(AssetImage("assets/images/caduceuscna.ico"),
          size: 44, color: Colors.white);
    } else if (subject.contains('LPN') == true) {
      return ImageIcon(
        AssetImage("assets/images/caduceuslpn.ico"),
        size: 44,
        color: Colors.white,
      );
    } else if (subject.contains('RN') == true) {
      return ImageIcon(AssetImage("assets/images/caduceusrn.ico"),
          size: 44, color: Colors.white);
    } else {
      return ImageIcon(AssetImage("assets/images/caduceuscna.ico"),
          size: 44, color: Colors.white);
    }
  }

  void calendarTapped(CalendarTapDetails details) {
    print('line 490: $details');
    // if (details.targetElement == CalendarElement.appointment ||
    //     details.targetElement == CalendarElement.agenda) {
    //   final Appointment appointmentDetails = details.appointments![0];
    //   _subjectText = appointmentDetails.subject;
    //   _dateText = DateFormat('MMMM dd, yyyy')
    //       .format(appointmentDetails.startTime)
    //       .toString();
    //   _startTimeText =
    //       DateFormat('hh:mm a').format(appointmentDetails.startTime).toString();
    //   _endTimeText =
    //       DateFormat('hh:mm a').format(appointmentDetails.endTime).toString();
    //   if (appointmentDetails.isAllDay) {
    //     _timeDetails = 'All day';
    //   } else {
    //     _timeDetails = '$_startTimeText - $_endTimeText';
    //   }
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Container(child: Text('$_subjectText')),
    //           content: Container(
    //             height: 80,
    //             child: Column(
    //               children: <Widget>[
    //                 Row(
    //                   children: <Widget>[
    //                     Text(
    //                       '$_dateText',
    //                       style: const TextStyle(
    //                         fontWeight: FontWeight.w400,
    //                         fontSize: 20,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   children: const <Widget>[
    //                     Text(''),
    //                   ],
    //                 ),
    //                 Row(
    //                   children: <Widget>[
    //                     Text(_timeDetails!,
    //                         style: const TextStyle(
    //                             fontWeight: FontWeight.w400, fontSize: 15)),
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //           actions: <Widget>[
    //             TextButton(
    //                 onPressed: () {
    //                   Navigator.of(context).pop();
    //                 },
    //                 child: const Text('close'))
    //           ],
    //         );
    //       });
    // }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

//   List<Appointment> getAppointments() {
//     List<Appointment> appointments = <Appointment>[];
//     DateTime today = DateTime.now();
//     DateTime startTime = DateTime(today.year, today.month, today.day, 7, 0, 0);
//     DateTime endTime = startTime.add(const Duration(hours: 8));
//
//     appointments.add(Appointment(
//         startTime: startTime,
//         endTime: endTime,
//         subject: 'CNA: Rqd 3  Scd: 2',
//         color: Colors.pink,
//         notes: 'what is this?',
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime,
//         endTime: endTime,
//         subject: 'LPN(1)',
//         color: Colors.green,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime,
//         endTime: endTime,
//         subject: 'RN(1)',
//         color: Colors.blue,
//         isAllDay: false));
//     DateTime startTime1 =
//         DateTime(today.year, today.month, today.day, 15, 0, 0);
//     DateTime endTime1 = startTime1.add(const Duration(hours: 8));
//     appointments.add(Appointment(
//         startTime: startTime1,
//         endTime: endTime1,
//         subject: 'CNA(2)',
//         color: Colors.pink,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime1,
//         endTime: endTime1,
//         subject: 'LPN(1)',
//         color: Colors.green,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime1,
//         endTime: endTime1,
//         subject: 'RN(1)',
//         color: Colors.blue,
//         isAllDay: false));
//     DateTime startTime2 =
//         DateTime(today.year, today.month, today.day, 23, 0, 0);
//     DateTime endTime2 = startTime2.add(const Duration(hours: 8));
//     appointments.add(Appointment(
//         startTime: startTime2,
//         endTime: endTime2,
//         subject: 'CNA(2)',
//         color: Colors.pink,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime2,
//         endTime: endTime2,
//         subject: 'LPN(1)',
//         color: Colors.green,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime2,
//         endTime: endTime2,
//         subject: 'RN(1)',
//         color: Colors.blue,
//         isAllDay: false));
//
//     today = today.add(Duration(days: 1));
//     startTime = DateTime(today.year, today.month, today.day, 7, 0, 0);
//     endTime = startTime.add(const Duration(hours: 8));
//     appointments.add(Appointment(
//         startTime: startTime,
//         endTime: endTime,
//         subject: 'CNA(2)',
//         color: Colors.pink,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime,
//         endTime: endTime,
//         subject: 'LPN(1)',
//         color: Colors.green,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime,
//         endTime: endTime,
//         subject: 'RN(1)',
//         color: Colors.blue,
//         isAllDay: false));
//     startTime1 = DateTime(today.year, today.month, today.day, 15, 0, 0);
//     endTime1 = startTime1.add(const Duration(hours: 8));
//     appointments.add(Appointment(
//         startTime: startTime,
//         endTime: endTime1,
//         subject: 'CNA(2)',
//         color: Colors.pink,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime1,
//         endTime: endTime1,
//         subject: 'LPN(1)',
//         color: Colors.green,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime1,
//         endTime: endTime1,
//         subject: 'RN(1)',
//         color: Colors.blue,
//         isAllDay: false));
//     startTime2 = DateTime(today.year, today.month, today.day, 23, 0, 0);
//     endTime2 = startTime2.add(const Duration(hours: 8));
//     appointments.add(Appointment(
//         startTime: startTime2,
//         endTime: endTime2,
//         subject: 'CNA(2)',
//         color: Colors.pink,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime2,
//         endTime: endTime2,
//         subject: 'LPN(1)',
//         color: Colors.green,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime2,
//         endTime: endTime2,
//         subject: 'RN(1)',
//         color: Colors.blue,
//         isAllDay: false));
//     int day = today.day + 5;
//     DateTime startTime3 = DateTime(today.year, today.month, day, 7, 0, 0);
//     DateTime endTime3 = startTime3.add(const Duration(hours: 8));
//     appointments.add(Appointment(
//         startTime: startTime3,
//         endTime: endTime3,
//         subject: 'CNA(2)',
//         color: Colors.pink,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime3,
//         endTime: endTime3,
//         subject: 'LPN(1)',
//         color: Colors.green,
//         isAllDay: false));
//     appointments.add(Appointment(
//         startTime: startTime3,
//         endTime: endTime3,
//         subject: 'RN(1)',
//         color: Colors.blue,
//         isAllDay: false));
//     return appointments;
//   }
//
//   String? _subjectText = '',
//       _startTimeText = '',
//       _endTimeText = '',
//       _dateText = '',
//       _timeDetails = '';
//
//   void calendarTapped(CalendarTapDetails details) {
//     if (details.targetElement == CalendarElement.appointment ||
//         details.targetElement == CalendarElement.agenda) {
//       final Appointment appointmentDetails = details.appointments![0];
//       _subjectText = appointmentDetails.subject;
//       _dateText = DateFormat('MMMM dd, yyyy')
//           .format(appointmentDetails.startTime)
//           .toString();
//       _startTimeText =
//           DateFormat('hh:mm a').format(appointmentDetails.startTime).toString();
//       _endTimeText =
//           DateFormat('hh:mm a').format(appointmentDetails.endTime).toString();
//       if (appointmentDetails.isAllDay) {
//         _timeDetails = 'All day';
//       } else {
//         _timeDetails = '$_startTimeText - $_endTimeText';
//       }
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Container(child: Text('$_subjectText')),
//               content: Container(
//                 height: 100,
//                 child: Column(
//                   children: <Widget>[
//                     Expanded(
//                       child: Row(
//                         children: <Widget>[
//                           Text(
//                             '$_dateText',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       children: const <Widget>[
//                         Text(''),
//                       ],
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Text(_timeDetails!,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w400, fontSize: 15)),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 Container(
//                   height: 30,
//                   child: TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text('close')),
//                 )
//               ],
//             );
//           });
//     }
//   }
// }
//
// class _DataSource extends CalendarDataSource<Meeting> {
//   _DataSource(List<Appointment> source) {
//     appointments = source;
//   }
//
//   @override
//   DateTime getStartTime(int index) {
//     print('line 217: $index');
//     return appointments![index].from as DateTime;
//   }
//
//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index].to as DateTime;
//   }
//
//   @override
//   String getSubject(int index) {
//     return appointments![index].content as String;
//   }
//
//   @override
//   Color getColor(int index) {
//     return appointments![index].background as Color;
//   }
//
//   @override
//   Meeting convertAppointmentToObject(
//       Meeting customData, Appointment appointment) {
//     return Meeting(
//         from: appointment.startTime,
//         to: appointment.endTime,
//         content: appointment.subject,
//         background: appointment.color,
//         isAllDay: appointment.isAllDay);
//   }
// }
//
class Meeting {
  Meeting(
      {required this.from,
      required this.to,
      this.background = Colors.green,
      this.isAllDay = false,
      this.eventName = '',
      this.startTimeZone = '',
      this.endTimeZone = '',
      this.description = ''});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
}
