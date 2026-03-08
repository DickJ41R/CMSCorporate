// import 'package:client_app/models/client_models/client_address.dart';
// import 'package:client_app/models/client_models/client_data.dart';
// import 'package:client_app/models/client_models/client_rate.dart';
// import 'package:client_app/services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:uuid/uuid.dart';
// import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UtilitiesServices {
  UtilitiesServices();

  // AuthService authServices = AuthService();
  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dte);
    return formatted;
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

  Future<void> sendEmailFromGMail(List<String> tos, String from,
      String fromUserName, String subject, String text) async {
    print('line 252 tuil send an gmail.');
    // String username = 'noreply@consolidatedmedicalstaffing.com';
    // String password = 'Rainyday@1634!';
    // String username = 'rrovinelli@consolidatedmedicalstaffing.com';
    // String password = 'Rainyday*4311!';
    String username = dotenv.env['GMAIL_USERNAME']!;
    String password = dotenv.env['GMAIL_PASSWORD']!;

    final smtpServer = await SmtpServer('smtp.office365.com',
        username: username, password: password, port: 587, ssl: false);
    final message = Message()
      ..from = Address(from, fromUserName)
      //  ..recipients.add('blee@consolidatedstaffing.com')
      ..recipients = tos
      //  ..ccRecipients.addAll(['jsturgill@consolidatedstaffing.com'])
      //  ..bccRecipients.add(Address('dickj41r@gmail.com'))
      ..subject = subject + ' ::' + '${DateTime.now()}'
      ..text = text;
    // ..html =
    //     "<h1>Test</h1>\n<p> Here\'s <h1 style=\"background-color:DodgerBlue;\">HTML</h1> content</p>";

    try {
      print('line 206 sendanemail');
      final sendReport = await send(message, smtpServer);
      print('line 209 Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('line 211 Message not sent. $e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('line 215: $e');
    }
  }

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
}
