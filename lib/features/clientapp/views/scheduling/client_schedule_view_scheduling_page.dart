//Client Schedule View Scheduling Page
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ClientScheduleViewSchedulingPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientScheduleViewSchedulingPage({super.key, required this.args});

  @override
  State<ClientScheduleViewSchedulingPage> createState() =>
      _ClientScheduleViewSchedulingPageState();
}

class _ClientScheduleViewSchedulingPageState
    extends State<ClientScheduleViewSchedulingPage> {
  String? dropDownValue;
  CalendarController calendarController = CalendarController();
  final List<Appointment> _appointmentDetails = <Appointment>[];
  ClientServices clientServices = ClientServices();

  late _DataSource dataSource;

  List<dynamic>? lstApts;
  bool flagHaveData = false;
  double fontSize = 16;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;

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
                      fontSize: 20,
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

  Future<void> getRawDataForDataSource(int clientId, BuildContext ctx) async {
    try {
      lstApts = await clientServices.getClientWorkOrders(clientId, ctx);
      if (lstApts!.isNotEmpty) {
        var mp = lstApts![0];
        debugPrint('line 38: $mp');
        if (mp['error'] == 'No Data') {
          debugPrint('line 40 no data');
          await _showDialog(ctx, "Schedule View Error", 'No Scheduling Data!');
          Navigator.of(context)
              .pushNamed(clientSchedulingMenu, arguments: arguments!);
          return;
        }
        debugPrint('line 43 data: ${lstApts![0]}');
        setState(() {
          flagHaveData = true;
          dataSource = getCalendarDataSource();
        });
      }
      return;
    } catch (e) {
      debugPrint('line 46 error: ${e.toString()}');
      return null;
    }
  }

  UtilitiesServices utilitiesServices = UtilitiesServices();

  Map<String, dynamic>? arguments;
  int? clientId;
  @override
  void initState() {
    // TODO: implement initState
    arguments = widget.args;
    clientId = arguments!['clientId'];
    getRawDataForDataSource(clientId!, context);

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
    debugPrint('line 40 after setorientation pref');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Work Schedule'),
        ),
        body: flagHaveData == false
            ? Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: SfCalendar(
                      view: CalendarView.month,
                      dataSource: dataSource,
                      initialSelectedDate:
                          DateTime.now().add(const Duration(days: -1)),
                      onSelectionChanged: selectionChanged,
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
                                            _appointmentDetails[index].isAllDay
                                                ? ''
                                                : '${DateFormat('hh:mm a').format(_appointmentDetails[index].startTime)}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                height: 1.7),
                                          ),
                                          Text(
                                            _appointmentDetails[index].isAllDay
                                                ? 'All day'
                                                : '',
                                            style: TextStyle(
                                                height: 0.5,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            _appointmentDetails[index].isAllDay
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
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: Colors.white))),
                                      subtitle: Container(
                                          width: screenWidth - 100,
                                          child: Text(
                                              '${_appointmentDetails[index].notes}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
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
      String subjectText = "Shift: " + obj['shiftCode'];
      subjectText += "   Discipline: " + obj['disciplineName'];
      subjectText += "   Count: " + obj['shiftCount'].toString();
      String statuses = '';
      // String sts = '';
      // for (int j = 0; j < obj['shiftStatuses'].length; j++) {
      //   if (j > 0) {
      //     statuses += ', ';
      //   }
      //   sts += obj['shiftStatuses'][j];
      // }
      // debugPrint('line 360: $sts');
      statuses = obj['shiftStatuses'][0];
      int index = disciplines.indexOf(obj['disciplineName']);
      debugPrint('line 329: $subjectText ${index.toString()}');
      Appointment apt = Appointment(
          startTime: st,
          endTime: et,
          subject: subjectText,
          color: colors[index],
          notes: 'Statuses: ' + statuses);
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
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

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
