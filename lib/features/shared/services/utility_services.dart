import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UtilitiesServices {
  UtilitiesServices();

  // AuthService authServices = AuthService();
  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dte);
    return formatted;
  }

  String convertDateFromUnknown(dynamic t) {
    print('line 18: in convert from unknown $t');
    try {
      if (t == null) {
        DateTime d = new DateTime(1970, 1, 1);
        int itt = d.millisecondsSinceEpoch;
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(itt);
        String ss = getFormattedDate(dateTime);
        print('line 24: $ss');
        return ss;
      } else if (t is String) {
        print('line 27: $t');
        return t;
      } else if (t is Timestamp) {
        DateTime date = t.toDate();
        String s = getFormattedDate(date);
        print('line 32: $s');
        return s;
      } else {
        print('line 35 null');
        return "";
      }
    } catch (e) {
      print('line 40 error ${e.toString()}');
      throw Exception('line 41 error in cvt from ukn');
    }
  }

  String convertFromTimestamp(Timestamp? t) {
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

  double getHours(String sT, String eT, int meals) {
    try {
      int idx = sT.indexOf('AM');
      if (idx == -1) {
        idx = sT.indexOf('PM');
        if (idx == -1) {
          return -1;
        }
      }
      idx = eT.indexOf('AM');
      if (idx == -1) {
        idx = eT.indexOf('PM');
        if (idx == -1) {
          return -1;
        }
      }

      String char = String.fromCharCode(8239);
      String startTime = sT.replaceAll(char, ' ');
      String endTime = eT.replaceAll(char, ' ');
      print('line 1059: $startTime $endTime');
      List<String> sts = startTime.split(' ');
      List<String> ets = endTime.split(' ');
      double dmeals = meals.toDouble();
      dmeals /= 60;
      print('line 49: $sts $ets $dmeals');
      String sDmeals = dmeals.toStringAsFixed(2);
      dmeals = double.parse(sDmeals);
      String st = sts[0];
      String et = ets[0];
      List<String> stl = st.split(':');
      List<String> etl = et.split(':');
      double dsh = double.parse(stl[0]);
      double dsm = double.parse(stl[1]);
      double esh = double.parse(etl[0]);
      double esm = double.parse(etl[1]);
      print('line 61: $dsh $dsm $esh $esm');

      double th = 0;
      double tm = 0;
      if (sts[1].toLowerCase() == 'pm') {
        //pm am  11:00 pm to 7:00 am
        if (ets[1].toLowerCase() == 'am') {
          //11pm to 7:00am = 1 + 7 = 8;
          if (esh == 12) {
            //11:00pm to 12:00 am
            th = (12 + (12 - dsh));
          } else {
            //pm am with esh not = 12
            if (dsh >= esh) {
              //10:00 pm to 8:00 am
              th = (12 - dsh) + esh;
            } else {
              //dsh < esh. pm am 3:00 pm 12:00 am
              //pm to am  3:00 pm to 11:00 am
              th = 12 + (esh - dsh);
            }
          }
        } else if (ets[1].toLowerCase() == 'pm') {
          //pm to pm
          // 11:00 pm to 3:00 pm
          print('line 84: $dsh $esh');
          if (dsh == 12) {
            th = esh;
          } else if (dsh > esh) {
            //11:00 pm to 3:00 pm
            double xv = esh + 12.0;
            th = 12 + (xv - dsh);
          } else {
            //dsh < esh.   3:00 pm to 11:00 pm
            th = esh - dsh;
          }
        }
      } else {
        //dsh = am
        if (ets[1].toLowerCase() == 'am') {
          //am to am
          if (dsh == 12) {
            //12:00am to 3:00am
            th = esh;
          } else if (dsh <= esh) {
            // 3:00 am to 11:00 am
            th = esh - dsh;
          } else {
            //dsh > esh
            //11:00 am to 3:00 am
            th = 12 + ((12 - dsh) + esh);
          }
        } else {
          //am to pm
          esh += 12;
          if (dsh == 12) {
            //12:00am to 4:00 pm
            th = 12 + esh;
          } else {
            //3:00 am to 11:00 pm
            th = esh - dsh;
          }
        }
      }
      double thm = esm - dsm;
      th *= 60; //convert to minutes
      th += thm;
      print('line 120: $th $dmeals');

      th /= 60; //back to hours;
      if (dmeals < th) {
        th -= dmeals;
      }
      print('line 1107: $th');
      if (th > 0) {
        th = double.parse(th.toStringAsFixed(3));
        String ths = th.toStringAsFixed(3);
        print('line 97: $ths');
        th = double.parse(ths);
      } else {
        th = 0.0;
      }
      return th;
    } catch (e) {
      print('line 1131 error: $e');
      throw Exception(e.toString());
    }
  }

  int getCorrectOffset(DateTime dt1, DateTime dt2) {
    String zt1 = dt1.timeZoneName;
    String zt2 = dt2.timeZoneName;

    print('line 94: $zt1 $zt2');
    //1st one will be client
    //we subtract emplyee from client
    Duration of1 = dt1.timeZoneOffset;
    Duration of2 = dt2.timeZoneOffset;
    int hr1 = of1.inHours;
    int hr2 = of2.inHours;

    int of3 = hr1 - hr2;
    return of3;
  }

  // Future<void> sendEmailFromGMail(List<String> tos, String from,
  //     String fromUserName, String subject, String text) async {
  //   print('line 252 tuil send an gmail.');
  //   // String username = 'noreply@consolidatedmedicalstaffing.com';
  //   // String password = 'Rainyday@1634!';
  //   // String username = 'rrovinelli@consolidatedmedicalstaffing.com';
  //   // String password = 'Rainyday*4311!';
  //
  //   String username = dotenv.env['GMAIL_USERNAME']!;
  //   String password = dotenv.env['GMAIL_PASSWORD']!;
  //
  //   final smtpServer = await SmtpServer('smtp.office365.com',
  //       username: username, password: password, port: 587, ssl: false);
  //   final message = Message()
  //     ..from = Address(from, fromUserName)
  //     //  ..recipients.add('blee@consolidatedstaffing.com')
  //     ..recipients = tos
  //     //  ..ccRecipients.addAll(['jsturgill@consolidatedstaffing.com'])
  //     //  ..bccRecipients.add(Address('dickj41r@gmail.com'))
  //     ..subject = subject + ' ::' + '${DateTime.now()}'
  //     ..text = text;
  //   // ..html =
  //   //     "<h1>Test</h1>\n<p> Here\'s <h1 style=\"background-color:DodgerBlue;\">HTML</h1> content</p>";
  //
  //   try {
  //     print('line 206 sendanemail');
  //     final sendReport = await send(message, smtpServer);
  //     print('line 209 Message sent: ' + sendReport.toString());
  //   } on MailerException catch (e) {
  //     print('line 211 Message not sent. $e');
  //     for (var p in e.problems) {
  //       print('Problem: ${p.code}: ${p.msg}');
  //     }
  //   } catch (e) {
  //     print('line 215: $e');
  //   }
  // }

  Future<dynamic>? getToken() async {
    var client = http.Client();
    var url = Uri.https('api.stafferlink.com', 'asm/authenticate');
    print('url:  $url');
    var orgId = dotenv.env['ASM_DB2'];
    Map data = {
      'key': '30c39597a9604a979e9430ee5794fab6',
      'secret': 'a594b1ede33b48e7bed9418c6fd50e43',
      'orgId': orgId
    };
    var body = json.encode(data);
    print('body: $body');
    // headers: {"Content-Type": "application/json"},
    try {
      http.Response response = await client.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        String data = response.body;
        var jsonDecodedData = json.decode(data);
        print('jsonDecodedData with access token: $jsonDecodedData');
        var token = jsonDecodedData['accessToken'];
        print('Data:  $token');
        return token;
      } else {
        throw Exception('Non 200 status code returned');
      }
    } catch (e) {
      print('line 37: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<bool> putAnyData(dynamic jsonObject, String url) async {
    bool bl = false;
    String? token = await getToken();
    print('line 351: $token');
    Map<String, String>? hdrs = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    try {
      String? dte;
      String? nbsp;
      if (jsonObject['Conf_Emp_Time'] != null) {
        dte = jsonObject['Conf_Emp_Time'];
        dte = dte!.replaceAll(String.fromCharCode(8239), ' ');
        jsonObject['Conf_Emp_Time'] = dte;
        nbsp = String.fromCharCode(0x00A0);
        dte = dte.replaceAll(nbsp, ' ');
        jsonObject['Conf_Emp_Time'] = dte;
      }
      if (jsonObject['Conf_Cli_Time'] != null) {
        dte = jsonObject['Conf_Cli_Time'];
        dte = dte!.replaceAll(String.fromCharCode(8239), ' ');
        jsonObject['Conf_Cli_Time'] = dte;
        nbsp = String.fromCharCode(0x00A0);
        dte = dte.replaceAll(nbsp, ' ');
        jsonObject['Conf_Cli_Time'] = dte;
      }
      print('line 369: ${jsonEncode(jsonObject)}');
      print('line 370 just before put: $url');
      final response = await http.put(Uri.parse(url),
          headers: hdrs, body: jsonEncode(jsonObject));
      print('line 379: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        bl = true;
      } else {
        bl = false;
      }
      return bl;
    } catch (er) {
      print('line 377 error: $er');
      return bl;
    }
  }

  DateTime getValidDate(String dte) {
    int index = dte.indexOf('-');
    if (index != -1) {
      dte = dte.replaceAll('-', '/');
    }
    DateTime? tempDate;
    List<String> sts = dte.split('/');
    if (sts[0].length == 4) {
      tempDate = new DateFormat("yyyy/MM/dd").parse(dte);
    } else {
      tempDate = new DateFormat("MM/dd/yyyy").parse(dte);
    }
    return tempDate;
  }

  int getMinutes(String vtm) {
    print('line 64: $vtm');
    if (vtm.contains(' ') == false) {
      return 0;
    }
    if (vtm.contains(':') == false) {
      return 0;
    }
    List<String> vtms = vtm.split(' ');

    String vts = vtms[0];
    List<String> vtss = vts.split(':');
    print('line 75: ${vtss[0]} ${vtss[1]}');
    int vhours = int.parse(vtss[0]);
    print('line 77: $vhours');
    int vminutes = int.parse(vtss[1]);
    print('Line 79: $vminutes');
    if (vtms[1] == 'PM') {
      vhours += 12;
    }
    int vTMinutes = 60 * vhours + vminutes;
    print('line 84: $vTMinutes');
    return vTMinutes;
  }

  String getHoursString(String sT, String eT) {
    try {
      String char = String.fromCharCode(8239);
      String startTime = sT.replaceAll(char, ' ');
      String endTime = eT.replaceAll(char, ' ');
      print('line 1059: $startTime $endTime');
      List<String> sts = startTime.split(' ');
      List<String> ets = endTime.split(' ');
      print('line 49: $sts $ets');
      String st = sts[0];
      String et = ets[0];
      List<String> stl = st.split(':');
      List<String> etl = et.split(':');
      double dsh = double.parse(stl[0]);
      double dsm = double.parse(stl[1]);
      double esh = double.parse(etl[0]);
      double esm = double.parse(etl[1]);
      print('line 61: $dsh $dsm $esh $esm');
      dsm = dsm;
      esm = esm;

      double th = 0;
      double tm = 0;
      if (sts[1].toLowerCase() == 'pm') {
        //pm am  11:00 pm to 7:00 am
        if (ets[1].toLowerCase() == 'am') {
          //11pm to 7:00am = 1 + 7 = 8;
          if (esh == 12) {
            //11:00pm to 12:00 am
            th = (12 + (12 - dsh));
          } else {
            //pm am with esh not = 12
            if (dsh >= esh) {
              //10:00 pm to 8:00 am
              th = (12 - dsh) + esh;
            } else {
              //dsh < esh. pm am 3:00 pm 12:00 am
              //pm to am  3:00 pm to 11:00 am
              th = 12 + (esh - dsh);
            }
          }
        } else if (ets[1].toLowerCase() == 'pm') {
          //pm to pm
          // 11:00 pm to 3:00 pm
          print('line 84: $dsh $esh');
          if (dsh == 12) {
            th = esh;
          } else if (dsh >= esh) {
            //11:00 pm to 3:00 pm
            th = 12 - ((12 - dsh) + esh);
          } else {
            //dsh < esh.   3:00 pm to 11:00 pm
            th = esh - dsh;
          }
        }
      } else {
        //dsh = am
        if (ets[1].toLowerCase() == 'am') {
          //am to am
          if (dsh == 12) {
            //12:00am to 3:00am
            th = esh;
          } else if (dsh <= esh) {
            // 3:00 am to 11:00 am
            th = esh - dsh;
          } else {
            //dsh > esh
            //11:00 am to 3:00 am
            th = 12 + ((12 - dsh) + esh);
          }
        } else {
          //am to pm
          if (dsh == 12) {
            //12:00am to 4:00 pm
            th = 12 + esh;
          } else if (dsh < -esh) {
            //3:00 am to 11:00 pm
            th = 12 + (esh - dsh);
          } else {
            // 11:00 am to 3:00 pm
            th = (12 - dsh) + esh;
          }
        }
      }
      double thm = esm - dsm;
      thm = thm.abs();
      String thms = thm.toString(); //convert to minutes
      String ths = th.toString();
      print('line 120: $th ');
      String tls = ths + '.' + thms;
      List<String> stz = tls.split('.');
      String xt = stz[1];
      String vt = stz[0];
      int i = xt.length;
      while (i < 2) {
        xt += '0';
        i += 1;
      }
      tls = vt + '.' + xt;
      return tls;
    } catch (e) {
      print('line 1131 error: $e');
      throw Exception(e.toString());
    }
  }

  String checkTimeValidation(String st) {
    print('line 401: $st');
    String hst = st;
    int idx;
    if (st.length < 5) {
      return '';
    }
    st = st.replaceAll(';', ':');
    st = st.replaceAll(',', ':');
    if (st.contains(':') == false && st.length > 3) {
      return '';
    }
    st = st.toUpperCase();
    if (st.contains('AM') == false && st.contains('PM') == false) {
      return 'Invalid Time Entry';
    }
    bool flagIsPM = false;
    if (st.contains('PM') == true) {
      flagIsPM = true;
    }
    if (st.indexOf(' ') == -1) {
      idx = st.indexOf('AM');
      if (idx == -1) {
        idx = st.indexOf('PM');
      }
      if (idx == -1) {
        return "Invalid Time Entry.";
      }
      st = st.substring(0, idx) + ' ' + st.substring(idx);
    }

    print('line 442: $st');
    if (st.indexOf(':') == -1) {
      return "Invalid Time Entry.";
    }
    List<String> lstr = st.split(':');
    int hr = int.parse(lstr[0]);

    if (flagIsPM == true && hr > 12) {
      return "Invalid Time Entry";
    }
    List<String> svs = lstr[1].split(' ');
    if (int.tryParse(svs[0]) == null) {
      return "Invalid Time Entry";
    }
    int svi = int.parse(svs[0]);
    if (svi > 59) {
      return "Invalid Time Entry";
    }

    int reti = getMinutes(hst);
    print('line 445: $reti');
    if (reti < 0) {
      print('line 464: $reti');
      return "Invalid Time Entry!";
    }
    return st;
  }

  Map<String, dynamic> getHoursMinutes(String sm) {
    Map<String, dynamic>? mp;
    String char = String.fromCharCode(8239);
    String theTime = sm.replaceAll(char, ' ');
    List<String> lst = theTime.split(' ');
    //gives us  [7:30, PM]
    List<String> tsp = lst[0].split(':');
    int hours = int.parse(tsp[0]);
    int minutes = int.parse(tsp[1]);
    if (lst[1].toLowerCase() == 'pm') {
      if (hours != 12) {
        hours += 12;
      }
    } else {
      if (hours == 12) {
        hours = 24;
      }
    }
    mp = {'hours': hours, 'minutes': minutes};
    return mp;
  }
//end of clientapp

  Map<String, dynamic> getStartAndEndTimesActual(String sT, String eT) {
    try {
      String char = String.fromCharCode(8239);
      String startTime = sT.replaceAll(char, ' ');
      String endTime = eT.replaceAll(char, ' ');
      print('line 1059: $startTime $endTime');
      List<String> sts = startTime.split(' ');
      List<String> ets = endTime.split(' ');

      String st = sts[0];
      String et = ets[0];
      List<String> stl = st.split(':');
      List<String> etl = et.split(':');
      double dsh = double.parse(stl[0]);
      double dsm = double.parse(stl[1]);
      double esh = double.parse(etl[0]);
      double esm = double.parse(etl[1]);
      dsm = dsm / 60;
      esm = esm / 60;
      dsh += dsm;
      esh += esm;
      double th = 0;
      double tm = 0;
      int idv = 0;
      if (sts[1].toLowerCase() == 'pm') {
        if (dsh != 12) {
          dsh += 12;
        }
        if (dsh > 6 || dsh > 18) {
          idv = 1;
        }
        //pm am  11:00 pm to 7:00 am
        if (ets[1].toLowerCase() == 'am') {
          //11pm to 7:00am = 1 + 7 = 8;
          if (esh == 12) {
            esh = 0;
          }
        } else {
          if (esh != 12) {
            esh += 12;
          }
        }
      } else {
        if (dsh == 12) {
          dsh = 0;
        }
        if (ets[1].toLowerCase() == 'am') {
          if (esh == 12) {
            esh = 0;
          }
        } else {
          if (esh != 12) {
            esh += 12;
          }
        }
      }
      DateTime dt = DateTime.now();
      dt = dt.subtract(Duration(
          hours: dt.hour,
          minutes: dt.minute,
          seconds: dt.second,
          microseconds: dt.microsecond,
          milliseconds: dt.millisecond));
      int dshm = dsh.toInt();
      int dsmm = dsm.toInt();
      int eshm = esh.toInt();
      int esmm = esm.toInt();

      DateTime dt1 = dt;
      print('line 170: $dshm $dsmm $eshm $esmm');
      print('line 171: $sT $eT');
      dt = dt.add(Duration(hours: dshm, minutes: dsmm));
      if (eshm == 0) {
        idv = 1;
      }
      dt1 = dt1.add(Duration(days: idv, hours: eshm, minutes: esmm));
      Timestamp tms = Timestamp.fromDate(dt);
      Timestamp ems = Timestamp.fromDate(dt1);
      int idt = tms.millisecondsSinceEpoch;
      int iet = ems.millisecondsSinceEpoch;
      Map<String, dynamic> mp = {
        "startTime": dt,
        "endTime": dt1,
        'timeStampStartTime': idt,
        'timeStampEndTime': iet
      };
      return mp;
    } catch (e) {
      print('line 1131 error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> checkWeeklyHours(
      int hcpId, Timestamp shiftDate, String weekStartDay) async {
    print('line 610 checkweek: $hcpId $shiftDate $weekStartDay');
    List<String> listDays = [
      'offset',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    int counter = 0;

    Map<String, dynamic> tvs = {
      'dailyScheduledMinutes': 0,
      'weeklyScheduledMinutes': 0
    };
    try {
      int dayIndex = listDays.indexOf(weekStartDay);
      DateTime cdt = shiftDate.toDate();
      print('line 630: $cdt');
      int currentDay = cdt.day;
      int scheduledMinutes = 0;
      int month = cdt.month;
      int year = cdt.year;
      int day = cdt.day;
      int weekday = cdt.weekday;
      DateTime ndt = DateTime(year, month, day);
      print('line 641: $ndt');
      int startWeek = 1;
      int ndays = weekday - startWeek;
      print('line 643: $year $month $day $weekday $startWeek');
      List<DateTime> listOfDates = [];
      DateTime std = ndt.subtract(Duration(days: ndays));
      DateTime curd = std;
      print('line 649: $startWeek $std $ndays');
      for (int i = startWeek; i <= weekday; i++) {
        //  curd = curd.subtract(Duration(hours: curd.hour));
        print('line 651: $curd');
        listOfDates.add(curd);
        curd = curd.add(Duration(days: 1));
      }
      DateTime startDate = listOfDates[0];
      DateTime endDate = listOfDates[listOfDates.length - 1];
      List<Map<String, dynamic>> listASMs = [];
      print('line 658: $startDate $endDate');
      await FirebaseFirestore.instance
          .collection('ClientASMWorkOrder')
          .where('hcpId', isEqualTo: hcpId)
          .where('statusId', isEqualTo: 'S')
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> obj = docSnapshot.data();
          //  String shiftDateString = obj['shiftDate'];
          Timestamp dtx = obj['shiftDate'];
          print('line 669: $dtx');
          DateTime cdt = dtx.toDate();
          print('line 671: $cdt');
          print(
              'line 677 ${startDate.millisecondsSinceEpoch} ${cdt.millisecondsSinceEpoch} ${endDate.millisecondsSinceEpoch}');

          if (startDate.millisecondsSinceEpoch <= cdt.millisecondsSinceEpoch &&
              cdt.millisecondsSinceEpoch <= endDate.millisecondsSinceEpoch) {
            print(
                'line 681 ${startDate.millisecondsSinceEpoch} ${cdt.millisecondsSinceEpoch} ${endDate.millisecondsSinceEpoch}');
            bool skipThisInstance =
                await getTransactions(obj['OrderId'], counter);
            if (skipThisInstance == true) {
              print('line 685 skipping');
              continue;
            }
            print('line 688 keeping asms');
            listASMs.add(obj);
          }
        }
      });
      print('line 686 check ${listASMs.length}');
      int dailyMinutes = 0;
      int weeklyMinutes = 0;
      if (listASMs.length > 0) {
        for (int i = 0; i < listASMs.length; i++) {
          Map<String, dynamic> obj = listASMs[i];
          String startTime = obj['startTime'];
          String endTime = obj['endTime'];
          print('line 688: $startTime $endTime');
          int sMin = getMinutes(startTime);
          int eMin = getMinutes(endTime);
          print('line 690: $sMin $eMin');
          if (sMin >= 720 && eMin >= 720) {
            // 13:00 to 23:00
            scheduledMinutes += (eMin - sMin);
          } else if (sMin >= 720 && sMin > eMin) {
            //13:00 to 7:00
            eMin += 1440;
            scheduledMinutes += (eMin + sMin);
          } else if (sMin < 720) {
            //7:00 am to 15:00
            scheduledMinutes += (eMin - sMin);
          }
          Timestamp shiftDateTs = obj['shiftDate'];
          DateTime cdt = shiftDateTs.toDate();

          print(
              'line 718: ${cdt.millisecondsSinceEpoch} ${endDate.millisecondsSinceEpoch}');

          if (cdt.millisecondsSinceEpoch >= endDate.millisecondsSinceEpoch &&
              cdt.millisecondsSinceEpoch <= endDate.millisecondsSinceEpoch) {
            dailyMinutes += scheduledMinutes;
          } else {
            weeklyMinutes += scheduledMinutes;
          }
        }
        tvs['dailyScheduledMinutes'] = dailyMinutes;
        tvs['weeklyScheduledMinutes'] = weeklyMinutes;
      }
      print('line  720: $tvs');
      return tvs;
    } catch (e) {
      print('line 723 error: ${e.toString()}');
      return tvs;
    }
  }

  Future<bool> getTransactions(int orderId, int counter) async {
    var token = null;
    var client = http.Client();
    bool flagSkip = false;
    if (counter % 300 == 0) {
      token = getToken();
    }
    Map<String, String>? hdrs = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    try {
      bool flagSkip = false;
      String url =
          "https://api.stafferlink.com/asm/Orders/${orderId}/transactions";
      print('url: $url');
      http.Response response2 = await client.get(
        Uri.parse(url),
        headers: hdrs,
        // headers: {
        //   HttpHeaders.authorizationHeader: 'Bearer $token',
        // },
      );
      if (response2.statusCode == 200) {
        String data = response2.body;
        var jsonDecodedData = json.decode(data);
        print('jsonDecodedData with access token: $jsonDecodedData');
        var actionDesc = jsonDecodedData['actionDesc'];
        if (actionDesc == 'Canceled' || actionDesc == 'Deleted') {
          flagSkip = true;
        } else {
          flagSkip = false;
        }
      }
      return flagSkip;
    } catch (e) {
      print('line 733 error: ${e.toString()}');
      return false;
    }
  }

  Future<int> getDayBeforeMinutes(int hcpId, DateTime ctd) async {
    int month = ctd.month;
    int year = ctd.year;
    int day = ctd.day - 1;
    int priorMinutes = 0;
    try {
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftCode', whereIn: ['2', '3', 'PA'])
          .where('shiftStatus', isEqualTo: 'Closed')
          .get()
          .then((querySnapshot) async {
            for (var docSnapshot in querySnapshot.docs) {
              var obj = docSnapshot.data();
              Timestamp stm = obj['dates']['shiftDateInfo']['shiftDate'];
              print('line 902: $stm');
              DateTime std = stm.toDate();
              int stdMonth = std.month;
              int stdYear = std.year;
              int stdDay = std.day;

              if (day == stdDay && year == stdYear && month == stdMonth) {
                int sMin = getMinutes(obj['startTime']);
                int eMin = getMinutes(obj['endTime']);
                print('line 807: $sMin $eMin');
                if (sMin >= 720 && sMin > eMin) {
                  eMin += 1440;
                  priorMinutes += (eMin - sMin);
                } else if (sMin >= 720 && eMin >= 720) {
                  // 13:00 to 23:00
                  priorMinutes += (eMin - sMin);
                } else if (sMin >= 720 && eMin < 720) {
                  //13:00 to 7:00
                  priorMinutes += eMin;
                } else if (sMin < 720) {
                  //7:00 am to 15:00
                  priorMinutes += (eMin - sMin);
                }
              }
            }
          });
      return priorMinutes;
    } catch (e) {
      print('line 827 error: ${e.toString()}');
      return 0;
    }
  }

  Future<int> checkTimeLimits(int clientId, int hcpId, int meals,
      String clientWorkOrderUuid, Timestamp shiftDate) async {
    int scheduledHours = 0;
    print('line 882: $hcpId $shiftDate');
    try {
      DateTime dtm = shiftDate.toDate();
      dtm = dtm.subtract(Duration(
          hours: dtm.hour,
          minutes: dtm.minute,
          seconds: dtm.second,
          microseconds: dtm.microsecond,
          milliseconds: dtm.millisecond));
      int totalMinutes = 0;
      int lmeals = 0;
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('hcpId', isEqualTo: hcpId)
          .where('uuid', isNotEqualTo: clientWorkOrderUuid)
          .where('shiftStatus', isEqualTo: 'Closed')
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          var obj = docSnapshot.data();
          Timestamp stm = obj['dates']['shiftDateInfo']['shiftDate'];
          print('line 902: $stm');
          DateTime std = stm.toDate();
          std = std.subtract(Duration(
              hours: std.hour,
              minutes: std.minute,
              seconds: std.second,
              microseconds: std.microsecond,
              milliseconds: std.millisecond));
          print(
              'line 909: ${dtm.millisecondsSinceEpoch} ${std.millisecondsSinceEpoch}');
          if (dtm.millisecondsSinceEpoch == std.millisecondsSinceEpoch) {
            String startTime =
                obj['dates']['rates']['rateDetails']['startTime'];
            String endTime = obj['dates']['rates']['rateDetails']['endTime'];
            print('line 916: $startTime $endTime');
            lmeals = obj['meals'];
            int sMin = getMinutes(startTime);
            int eMin = getMinutes(endTime);
            print('line 918: $sMin $eMin');
            if (sMin >= 720 && sMin > eMin) {
              eMin += 1440;
              totalMinutes += (eMin - sMin);
            } else if (sMin >= 720 && eMin >= 720) {
              // 13:00 to 23:00
              totalMinutes += (eMin - sMin);
            } else if (sMin >= 720 && eMin < 720) {
              //13:00 to 7:00
              totalMinutes += eMin;
            } else if (sMin < 720) {
              //7:00 am to 15:00
              totalMinutes += (eMin - sMin);
            }
          }
        }
      });
      totalMinutes -= lmeals;
      if (totalMinutes < 0) {
        totalMinutes = 0;
      }
      return totalMinutes;
    } catch (e) {
      print('line 926 $e');
      return 0;
    }
  }

  Query buildDynamicQuery(Map<String, dynamic> arg) {
    Query? query;
    //check search criteria
    //all
    print('line 926 $arg');
    try {
      Map<String, String>? baseArg;
      bool flagHaveBaseArgument = true;
      String stringBranchId = arg['branchValue'];
      if (stringBranchId == '0') {
        flagHaveBaseArgument = false;
      }
      CollectionReference contentsRef =
          FirebaseFirestore.instance.collection(arg['searchCollection']!);

      if (arg['searchCriteria'] == 'All') {
        print('line 938');
        return contentsRef;
      }
      //isequalto
      print('line 942');
      if (arg['searchCriteria'] == 'Is Equal To') {
        if (arg['searchField']!.indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']!);
          print('line 84: $value ${arg['searchField']}');
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isEqualTo: value);
          } else {
            query = contentsRef.where(arg['searchField']!, isEqualTo: value);
          }
        } else {
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isEqualTo: arg['searchValue']);
          } else {
            query = contentsRef.where(arg['searchField']!,
                isEqualTo: arg['searchValue']);
          }
        }
      }
      //less than
      print('line 968');
      if (arg['searchCriteria'] == 'Is Less Than') {
        if (arg['searchField']!.indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']!);
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            ;
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isLessThan: value);
          } else {
            query = contentsRef.where(arg['searchField']!, isLessThan: value);
          }
        } else {
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isLessThan: arg['searchValue']!);
          } else {
            query = contentsRef.where(arg['searchField']!,
                isLessThan: arg['searchValue']);
          }
        }
      }
      //greater than
      print('line 994');
      if (arg['searchCriteria'] == 'Is Greater Than') {
        if (arg['searchField']!.indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']!);
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isGreaterThan: value);
          } else {
            query =
                contentsRef.where(arg['searchField']!, isGreaterThan: value);
          }
        } else {
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isGreaterThan: arg['searchValue']);
          } else {
            query = contentsRef.where(arg['searchField']!,
                isGreaterThan: arg['searchValue']);
          }
        }
      }
      // Is greater Than or Equal To,
      print('line 1020');
      if (arg['searchCriteria'] == 'Is Greater Than Or Equal To') {
        if (arg['searchField']!.indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']!);
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isGreaterThanOrEqualTo: value);
          } else {
            query = contentsRef.where(arg['searchField']!,
                isGreaterThanOrEqualTo: value);
          }
        } else {
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef.where('branchId', isEqualTo: branchId).where(
                arg['searchField']!,
                isGreaterThanOrEqualTo: arg['searchValue']);
          } else {
            query = contentsRef.where(arg['searchField']!,
                isGreaterThanOrEqualTo: arg['searchValue']);
          }
        }
      }

      //Is less Than or Equal To",
      if (arg['searchCriteria'] == 'Is Less Than Or Equal To') {
        if (arg['searchField']!.indexOf('Id') != -1) {
          int value = int.parse(arg['searchValue']!);
          int branchId = int.parse(stringBranchId);
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isLessThanOrEqualTo: value);
          } else {
            query = contentsRef.where(arg['searchField']!,
                isLessThanOrEqualTo: value);
          }
        } else {
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef.where('branchId', isEqualTo: branchId).where(
                arg['searchField']!,
                isLessThanOrEqualTo: arg['searchValue']);
          } else {
            query = contentsRef.where(arg['searchField']!,
                isLessThanOrEqualTo: arg['searchValue']);
          }
        }
      }
      //Is Between (Include Edges)",
      if (arg['searchCriteria'] ==
          'Is Between (Edges, colon separated fields)') {
        if (arg['searchField']!.indexOf('Id') != -1) {
          List<String> lst = arg['searchValue']!.split(':');
          List<int> values = [];
          for (int i = 0; i < lst.length; i++) {
            values.add(int.parse(lst[i]));
          }
          print('line 143: $values');
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isGreaterThanOrEqualTo: values[0])
                .where(arg['searchField']!, isLessThanOrEqualTo: values[1]);
          } else {
            query = contentsRef
                .where(arg['searchField']!, isGreaterThanOrEqualTo: values[0])
                .where(arg['searchField']!, isLessThanOrEqualTo: values[1]);
          }
        } else {
          List<String> lst = arg['searchValue']!.split(':');
          List<String> values = [];

          for (int i = 0; i < lst.length; i++) {
            values.add(lst[i]);
          }
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isGreaterThanOrEqualTo: values[0])
                .where(arg['searchField']!, isLessThanOrEqualTo: values[1]);
          } else {
            query = contentsRef
                .where(arg['searchField']!, isGreaterThanOrEqualTo: values[0])
                .where(arg['searchField']!, isLessThanOrEqualTo: values[1]);
          }
        }
      }
      // Is Between (Do not Include Edges)",
      if (arg['searchCriteria'] ==
          'Is Between (No Edges, colon separated fields)') {
        if (arg['searchField']!.indexOf('Id') != -1) {
          List<String> lst = arg['searchValue']!.split(':');
          List<int> values = [];
          for (int i = 0; i < lst.length; i++) {
            values.add(int.parse(lst[i]));
          }
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isGreaterThan: values[0])
                .where(arg['searchField']!, isLessThan: values[1]);
          } else {
            query = contentsRef
                .where(arg['searchField']!, isGreaterThan: values[0])
                .where(arg['searchField']!, isLessThan: values[1]);
          }
        } else {
          List<String> lst = arg['searchValue']!.split(':');
          List<String> values = [];
          for (int i = 0; i < lst.length; i++) {
            values.add(lst[i]);
          }
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg['searchField']!, isGreaterThan: values[0])
                .where(arg['searchField']!, isLessThan: values[1]);
          }
        }
      }

      if (arg['searchCriteria'] == 'Is In (colon separated list)') {
        String sx = arg['searchValue']!.replaceAll(',', ':');
        List<String> lsx = sx.split(':');
        print('line 1046 $lsx');
        if (arg['searchField']!.indexOf('Id') != -1) {
          List<int> lvalues = [];
          for (int i = 0; i < lsx.length; i++) {
            String sv = lsx[i];
            lvalues.add(int.parse(sv));
          }
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg!['searchField']!, whereIn: lvalues);
          } else {
            query = contentsRef.where(arg!['searchField']!, whereIn: lvalues);
          }
        } else {
          List<String> svalues = [];
          for (int i = 0; i < lsx.length; i++) {
            String sv = lsx[i];
            svalues.add(sv);
          }
          if (flagHaveBaseArgument == true) {
            int branchId = int.parse(stringBranchId);
            query = contentsRef
                .where('branchId', isEqualTo: branchId)
                .where(arg!['searchField']!, whereIn: svalues);
          } else {
            query = contentsRef.where(arg['searchField']!, whereIn: svalues);
          }
        }
      }
      print('line 1183 $query');
      return query!;
    } catch (e) {
      print('line 1186: ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
