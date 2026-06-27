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

  List<dynamic>? lstApts;
  bool flagHaveData = false;
  // Future<void> getRawDataForDataSourceX(int hcpId, BuildContext ctx) async {
  //   await getRawDataForDataSource(hcpId, ctx);
  // }

  Future<void> getRawDataForDataSource(BuildContext context) async {
    debugPrint('line 37 in getrawdatasource');
    try {
      bool working = false;

      lstApts = await hcpServices.getHCPWorkOrderCampaigns(hcpId!,context);

      if (lstApts!.isEmpty) {
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

      } else if (lstApts!.isNotEmpty) {
        working = true;
        debugPrint('line 36: ${lstApts![0]}');
        setState(() {
          flagHaveData = true;
          dataSource = getCalendarDataSource();
        });
      }
      debugPrint('line 47 just before return');
      return;
    } catch (e) {
      debugPrint('line 46 error: ${e.toString()}');
      return null;
    }
  }
  int? hcpId;
  Map<String,dynamic>? currentHCPMap;
  Map<String,dynamic>?arguments;
  UtilitiesServices utilitiesServices = UtilitiesServices();
  @override
  void initState() {
    // TODO: implement initState

    arguments = widget.args;
    hcpId = arguments!['hcpId'];

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
    debugPrint('line 32 setorientationprefx');
    if (c == 0) {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }
  }
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery
        .maybeOf(context)
        ?.textScaler
        .scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    double fontSize = 16;
    fontSize /= h;
    debugPrint('line 40 after setorientation pref: $flagHaveData');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Work Schedule'),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.arrow_back),
          //     onPressed: () {
          //       debugPrint('line 41: in onpressed back');
          //       calendarController.backward!();
          //     },
          //   ),
          //   IconButton(
          //     icon: Icon(Icons.arrow_forward),
          //     onPressed: () {
          //       debugPrint('line 48 in onpressed forward');
          //
          //       calendarController.forward!();
          //     },
          //   ),
          // ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: Future.wait([getRawDataForDataSource(context)]),
          builder: (context, snapshot) {
// debugPrint(
//     'line 211: ${snapshot.hasError} ${snapshot.hasData} ${ConnectionState} ');
            if ( snapshot.connectionState  == ConnectionState.waiting) {
              return  Center (
                  child : Container(
                    height: 50,
                    width: 50,
                    child:
                    CircularProgressIndicator(),
                  ),
                );
            } else if (snapshot.hasError) {
              return Center(
                child : Container(
                    height:  100,
                    width:screenWidth -10,
                    child: Text('Error: ${snapshot.error}',
                        overflow:TextOverflow.visible,
                        style: TextStyle(
                            fontSize:Theme.of(context).textTheme.headlineSmall!.fontSize! /h!,
                            color:Colors.red,
                            fontWeight:FontWeight.bold
                        )
                    ),
                  ),
                );
            } else if (snapshot.data == [[]] && snapshot.connectionState == ConnectionState.done) {
              return Center(
                  child:Container(
                    height: 100,
                    width: screenWidth - 10,
                    child:Text('There are no clients to list.',
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize!/h!,
                            color: color2,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                );
            }else {
              List<dynamic>data = snapshot.data![0];
//  debugPrint('line 292 ${data.length}');
              if(data.length == 0) {
                return Center(
                    child:Container(
                      height: 100,
                      width: screenWidth - 10,
                      child: Text('There are no clients to list.',
                          style: TextStyle(
                              fontSize : Theme.of(context).textTheme.headlineSmall!.fontSize! /h!,
                              color:color2,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                  );
              } else {
                List<Map<String,dynamic>>listH = snapshot.data![0];
                return Column(
                    children: [
                      Expanded(
                        child:SfCalendar(
                          view:CalendarView.month,
                          dataSource:dataSource,
                          initialSelectedDate: DateTime.now().add(
                              const Duration(days:-1)
                          ),
                          onSelectionChanged: selectionChanged,
                          onTap: calendarTapped,
                        ),
                      ),
                      Expanded(
                          child:Container(
                              color:Colors.black12,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(2),
                                separatorBuilder:(BuildContext context,int index) =>const Divider(
                                   height:5),
                                itemCount: _appointmentDetails.length,
                                itemBuilder:(BuildContext context, int index) {

                                  return Container(
                                        padding: EdgeInsets.all(2),
                                        height:80,
                                        color:_appointmentDetails[index].color,
                                        child: ListTile(
                                            leading:Column(
                                              children :<Widget>[
                                                Text( _appointmentDetails[index].isAllDay ? '' : '${DateFormat
                                                  ('hh:mm a').format(_appointmentDetails[index].startTime)}',
                                                  textAlign:TextAlign.center,
                                                  style:TextStyle(
                                                      fontWeight:FontWeight.w600,
                                                      color:Colors.white,
                                                      height:1.7
                                                  ),
                                                ),
                                                Text(_appointmentDetails[index].isAllDay ? 'All day'
                                                  : '',
                                                  style:TextStyle(
                                                      height:0.5,
                                                      color:Colors. white
                                                  ),
                                                ),
                                                Text(_appointmentDetails[index].isAllDay ?
                                                      '${DateFormat('hh:mm a').format(
                                                   _appointmentDetails[index].endTime)}' : '',
                                                  textAlign:TextAlign.center,
                                                  style:TextStyle(
                                                      fontWeight:FontWeight.w600,
                                                      color:Colors.white
                                                  ),
                                                ),
                                              ],
                                            ),
// trailing: Container(
//     child: getIcon(
//         _appointmentDetails[index]
//             .subject)),
                                            title:Container(
                                                width:screenWidth - 100,
                                                child:Text('${_appointmentDetails[index].subject}',
                                                    textAlign:TextAlign.center,
                                                    style:TextStyle(
                                                        fontWeight:FontWeight.w600,
                                                        fontSize:10,
                                                        color:Colors.white
                                                    ),
                                                )
                                            ),
                                            subtitle:Container(width:screenWidth - 100,
                                                child:Text('${_appointmentDetails[index].notes}',
                                                    textAlign:TextAlign.left,
                                                    style:TextStyle(
                                                        fontWeight:FontWeight.w600,
                                                        fontSize:10,
                                                        color:Colors.white
                                                    ),
                                                )
                                            )
                                        )
                                    );
                                },

                              )
                          )
                      )
                    ],
                  );
              }
            }
          },
        ),
      ),
    );
  }


  void selectionChanged(CalendarSelectionDetails calendarSelectionDetails) {
    getSelectedDateAppointments(calendarSelectionDetails.date);
  }

  void getSelectedDateAppointments(DateTime? selectedDate) {
    debugPrint('line 259: $selectedDate');

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

        debugPrint(
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
      debugPrint('line 290: buildapt $obj');
      int secs = obj['shiftDate']['_seconds'];
      secs *= 1000;
      DateTime dtm = DateTime.fromMillisecondsSinceEpoch(secs);
      debugPrint('line 299: $secs');
      Timestamp stm = Timestamp.fromDate(dtm);
      debugPrint('line 301: $stm');
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
      debugPrint('line 318: $st $et');
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
      debugPrint('line 463: $sts');
      statuses = obj['shiftStatuses'][0];
      int index = disciplines.indexOf(obj['disciplineName']);
      debugPrint('line 329: $clN $subjectText ${index.toString()}');
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
      // debugPrint('line 329: $subjectText ${index.toString()}');
      // Appointment apt = Appointment(
      //     startTime: st,
      //     endTime: et,
      //     subject: subjectText,
      //     //      location: locationText,
      //     color: colors[index],
      //     notes: 'Statuses: ' + statuses);
      return apt;
    } catch (e) {
      debugPrint('line 333 error: ${e.toString()}');
      throw Exception('line 334 errro: ${e.toString()}');
    }
  }

  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    debugPrint('line 313 in getCalendarDataSource');
    try {
      for (int i = 0; i < lstApts!.length; i++) {
        var obj = lstApts![i];
        debugPrint('line 346: $obj');
        Appointment apt = buildAppointment(obj);
        appointments.add(apt);
      }
      return _DataSource(appointments);
    } catch (e) {
      debugPrint('line 405 error: ${e.toString()}');
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
//     debugPrint('line 217: $index');
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
