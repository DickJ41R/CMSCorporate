// import 'package:hcp_app/models/client_models/client_address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hcp_app/models/client_models/client_data.dart';
// import 'package:hcp_app/models/client_models/client_rate.dart';
// import 'package:hcp_app/services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
// import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class UtilitiesServices {
  UtilitiesServices();


  String getHoursString(String sT, String eT) {
    try {
      print('line 416: $sT $eT');
      String char = String.fromCharCode(8239);
      String startTime = sT.replaceAll(char, ' ');
      String endTime = eT.replaceAll(char, ' ');
      print('line 418: $startTime $endTime');
      List<String> sts = startTime.split(' ');
      List<String> ets = endTime.split(' ');
      print('line 421: $sts $ets');
      String st = sts[0];
      String et = ets[0];
      List<String> stl = st.split(':');
      List<String> etl = et.split(':');
      double dsh = double.parse(stl[0]);
      double dsm = double.parse(stl[1]);
      double esh = double.parse(etl[0]);
      double esm = double.parse(etl[1]);
      print('line 430: $dsh $dsm $esh $esm');
      dsm = dsm;
      esm = esm;

      double th = 0;
      double tm = 0;
      if (sts[1].toLowerCase() == 'pm') {
        //pm am  11:00 pm to 7:00 am
        if (ets[1].toLowerCase() == 'am') {
          //11pm to 7:00am = 1 + 7 = 8;  7:00 pm to 7:00 am
          if (esh == 12) {
            //11:00pm to 12:00 am
            th = (12 + (12 - dsh));
          } else {
            //pm am with esh not = 12
            if (dsh >= esh) {
              //10:00 pm to 8:00 am or 7:00pm to 7:00 am
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
          print('line 457: $dsh $esh');
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
      String xt = '';
      String vt = '';
      String tls = '';
      if (thm != 0) {
        print('line 502: $thm');
        thm = thm.abs();
        String thms = thm.toString(); //convert to minutes
        String ths = th.toString();
        print('line 505: $th $ths');
        tls = ths + '.' + thms;
        List<String> stz = tls.split('.');
        xt = stz[1];
        vt = stz[0];
        int i = xt.length;
        while (i < 2) {
          xt += '0';
          i += 1;
        }
      } else {
        print('line 517: $thm');
        xt = '00';
        vt = th.toString();
        int idx = vt.indexOf('.');
        if (idx != -1) {
          vt = vt.substring(0, idx);
        }
      }
      tls = vt + '.' + xt;
      print('line 519: $tls $vt $xt');
      return tls;
    } catch (e) {
      print('line 521 error: $e');
      throw Exception(e.toString());
    }
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
         print('line 61: $startTime $endTime');
         List<String> sts = startTime.split(' ');
         List<String> ets = endTime.split(' ');
         double dmeals = meals.toDouble();
         dmeals /= 60;
         print('line 66: $sts $ets $dmeals');
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
         print('line 77: $dsh $dsm $esh $esm');

         double th = 0;
         double tm = 0;

         if (sts[1].toLowerCase() == 'pm') {
           //pm am  11:00 pm to 7:00 am
           if (sts[0] == 12) {
              dsh = 12;
           }
           if (ets[1].toLowerCase() == 'am') {
             if (ets[0] == 12) {
               th = 12;
               tm = esm - dsm;
             } else {
               //pm am with esh not = 12
                //11:00 to 7:00 am
               if (dsh >= esh) {
                 dsh += 12;
                 esh += 24;
                th =  esh - dsh;
               } else {
                 //dsh < esh. pm am 3:00 pm 12:00 am
                 //pm to am  3:00 pm to 11:00 am
                  dsh+=12;
                  esh +=24;
                 th = esh - dsh;
               }
             }
           } else if (ets[1].toLowerCase() == 'pm') {
             //pm to pm
             // 3:00 pm to 11:00 pm
             print('line 102: $dsh $esh');
             if (dsh == 12  && esh == 12) {
                if (dsm == 0 && esm == 0) {
                  return -1;
                }
               if (dsm > esm) {
                 return -1;
               }
               th = 0;
             } else if (dsh > esh) {
               //11:00 pm to 3:00 pm
               dsh += 12;
               esh += 12;
               if (esh - dsh > 16) {
                   return -1;
               }
               th = esh - dsh;
             } else {
               //dsh < esh.   3:00 pm to 11:00 pm
                th = esh - dsh;
             }
           }
         } else {
           //dsh = am
           print('line 88 starttime is am');
           if (ets[1].toLowerCase() == 'am') {
             print('line 90 endtime is am');
             //am to am
             if (dsh == 12 && esh == 12) {
                return -1;
             }
             if (dsh > esh) {
               // 3:00 am to 2:00 am
               esh += 24;
             th = esh - dsh;
               if (th > 16) {
                 return -1;
               }
             } else if (dsh == 12) {
               dsh = 0;
               //12:00am to 3:00am
               th = esh;
             } else if (dsh <= esh) {
               // 3:00 am to 11:00 am
               th = esh - dsh;
             }
           } else {
             //am to pm

            print('line endtiem is pm');
            if (dsh == 12 && esh == 12) {
              th = 12;
            } else {
             esh += 12;
              th  = esh - dsh;
              if (th > 16) {
                return -1;
              }
             if (dsh == 12) {
               //12:00am to 4:00 pm
               th = 12 + esh;
             } else {
               //3:00 am to 11:00 pm
               th = esh - dsh;
             }
           }
         }
         }

         double thm = esm - dsm;
         print('line 123: $th $thm');
         th *= 60; //convert to minutes
         th += thm;

         print('line 120: $th $dmeals');

         th /= 60; //back to hours;
       if (th > dmeals) {
           th -= dmeals;
         }
         print('line 150: $th');
         if (th > 0) {
           th = double.parse(th.toStringAsFixed(3));
           String ths = th.toStringAsFixed(3);
           print('line 154: $ths');
           th = double.parse(ths);
         } else {
           th = 0.0;
         }
         print('line 159 $th');
         return th;
       } catch (e) {
         print('line 162 error: $e');
         throw Exception(e.toString());
       }
     }

  int getMinutes(String ts) {
    print('line 355 in getminutes: $ts');
    try {
      String char = String.fromCharCode(8239);
      String startTime = ts.replaceAll(char, ' ');
      //  print('line 361 getminutes: $startTime');
      List<String> sts = startTime.split(' ');
      String st = sts[0];
      List<String> stl = st.split(':');
      int ish = int.parse(stl[0]);
      int ism = int.parse(stl[1]);
      //  print('line 367 getminutes: $ish $ism');
      if (sts[1].toLowerCase() == 'pm') {
        //pm am  11:00 pm to 7:00 am
        ish += 12;
      }
      ish *= 60;
      ish += ism;
      //   print('line 374: $ish');
      return ish;
    } catch (e) {
      print('line 376 error $e');
      return 0;
    }
  }

  int calculateShiftHours(
      int sMin, int eMin, String startTime, String endTime, dynamic mealss) {
    print('line 381 Calculate Hours: $sMin $eMin $startTime $endTime $mealss');
    int eDiff = 0;
//  638 1845 PA 1:15 PM 1:30 PM 795 810: ** 15
    try {
      int meals = int.parse(mealss.toString());
      List<String> sts = startTime.split(' ');
      List<String> ets = endTime.split(' ');
      List<String> shs = sts[0].split(':');
      List<String> ehs = ets[0].split(':');
      if (sts[1] == ets[1]) {
        //am to am or pm to pm
        //1. one of the times is a 12
        //12:00 am to 12:00 am
        if (shs[0] == '12' && ehs[0] == '12') {
          eDiff = -1;
          // eDiff = 1440;
          // int sm = int.parse(shs[1]);
          // int em = int.parse(ehs[1]);
          // int tm = em - sm;
          // eDiff += tm;
        } else if (shs[0] == '12') {
          //12:30 am to 8:00 am
          //12:00 pm to 6:00 pm
          //12:00 pm to 1:00 pm;
          if (sts[1] == 'pm') {
            int s1 = int.parse(shs[0]);
            int s2 = int.parse(ehs[0]);
            eDiff = eMin - sMin;
            if ((s1 - s2).abs() <= 1) {
//            eDiff += (s1 - s2) * 60;
            } else {
              int sm = int.parse(shs[1]);
              int em = int.parse(ehs[1]);
              int tm = em - sm;
              eDiff += tm;
            }
            if (eDiff > 1000) {
              eDiff = -1;
            }
          } else {
            int s1 = int.parse(shs[0]);
            int s2 = int.parse(ehs[0]);
            s2 += 12;
            eDiff = eMin;
            if ((s1 - s2).abs() <= 1) {
              eDiff += 1440;
            } else {
              int sm = int.parse(shs[1]);
              int em = int.parse(ehs[1]);
              int tm = em - sm;
              eDiff += tm;
            }
            if (eDiff > 1000) {
              eDiff = -1;
            }
          }
        } else if (ehs[0] == '12') {
          //6:00 am to 12:00 pm
          //6:30 pm to 12:30 am
          if (ets[1] == 'AM') {
            eMin = 1440;
          } else {
            eMin = 720;
          }
          eDiff = eMin - sMin;
          int sm = int.parse(shs[1]);
          int em = int.parse(ehs[1]);
          int tm = em - sm;
          eDiff += tm;
          if (eDiff > 1000) {
            eDiff = -1;
          }
        } else if (shs[0] == ehs[0]) {
          int sm = int.parse(shs[1]);
          int em = int.parse(ehs[1]);
          int tm = em - sm;
          eDiff = 1440;
          eDiff += tm;
          if (eDiff > 1000) {
            eDiff = -1;
          }
        } else if (sMin < eMin) {
          //2. starting time is < ending time
          //3:00 pm to 11:00 pm
          int s1 = int.parse(shs[0]);
          int s2 = int.parse(ehs[0]);
          if ((s1 - s2).abs() <= 1) {
            eDiff = 1440 + (s1 - s2).abs() * 60;
          } else {
            eDiff = eMin - sMin;
          }
          if (eDiff > 1000) {
            eDiff = -1;
          }
        } else if (sMin > eMin) {
          //3. starting time is > ending time
          //11:00 pm to 7:00 pm
          eMin += 1440;
          eDiff = eMin - sMin;
          if (eDiff > 1000) {
            eDiff = -1;
          }
          //4. starting time is = ending time (not counting seconds)
          //1:15 PM to 1:00 PM
        } else {
          eDiff = -1;
        }
      } else {
        //am to pm or pm to am
        //1. one of the times is a 12
        if (shs[0] == '12' && ehs[0] == '12') {
          //12:00 am to 12:00 pm
          eDiff = 720;
          int sm = int.parse(shs[1]);
          int em = int.parse(ehs[1]);
          int tm = em - sm;
          eDiff += tm;
          if (eDiff > 1000) {
            return -1;
          }
        } else if (shs[0] == '12') {
          //12:00 am to 1:00 pm
          if (sts[1] == 'pm') {
            int s1 = int.parse(shs[0]);
            int s2 = int.parse(ehs[0]);
            s2 += 12;
            eDiff = eMin - sMin;
            if ((s1 - s2).abs() == 1) {
              eDiff += 1440;
            } else {
              int sm = int.parse(shs[1]);
              int em = int.parse(ehs[1]);
              int tm = em - sm;
              eDiff += tm;
            }
            if (eDiff > 1000) {
              eDiff = -1;
            }
          } else {
            eDiff = eMin;
            int sm = int.parse(shs[1]);
            int em = int.parse(ehs[1]);
            int tm = em - sm;
            eDiff += tm;
          }
        } else if (ehs[0] == '12') {
          //7:00 am to 12:00 pm
          if (ets[1] == 'AM') {
            eDiff = 1440 - sMin;
            // int s1 = int.parse(shs[1]);
            // eDiff -= s1 * 2; //already added in
          } else {
            eDiff = eMin - sMin;
          }
          if (eDiff > 1000) {
            eDiff = -1;
          }
        } else if (shs[0] == ehs[0]) {
          //4. starting time is = ending time  (not counting seconds)
          int sm = int.parse(shs[1]);
          int em = int.parse(ehs[1]);
          int tm = em - sm;
          eDiff = 720;
          eDiff += tm;
        } else if (sMin < eMin) {
          //2. starting time is < endingtime
          //7:00 AM to 3:00 pm
          eDiff = eMin - sMin;
          if (eDiff > 1000) {
            eDiff = -1;
          }
        } else if (sMin > eMin) {
          //3. starting time is > endingtime
          //11:00 pm to 7:00 am
          eMin += 1440;
          eDiff = eMin - sMin;
          if (eDiff > 1000) {
            eDiff = -1;
          }
        } else {
          eDiff = -1;
        }
      }
      if (eDiff > 29) {
        eDiff = eDiff - meals;
      }
      print('line 567: $meals $eDiff');
      return eDiff;
    } catch (e) {
      print('line 569: error->${e.toString()}');
      throw Exception('line 570 error->${e.toString()}');
    }
  }

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

  Future<void> sendAGenericEmailFromHCP(Map<String, dynamic> item,
      String subject, String text, String html, String templateId) async {
    try {
      Map<String, dynamic>? clu;
      await FirebaseFirestore.instance
          .collection('ClientUser')
          .where('clientId', isEqualTo: item['clientId'])
          .get()
          .then((querySnapshot) {
        for (var snp in querySnapshot.docs) {
          var obj = snp.data();
          for (int j = 0; j < obj['roles'].length; j++) {
            if (obj['roles'][j] == 'ClientAdmin' ||
                obj['roles'][j] == 'ClientDON' ||
                obj['roles'][j] == 'ClientADON' ||
                obj['roles'][j] == 'ClientAccount') {
              clu = obj;
              break;
            }
          }
        }
      });
      String firstName = '';
      String lastName = '';
      String email = item['email'];
      String sname = 'No HCP Name';
      if (item['hcpName'] != null && item['hcpName'] != '') {
        int idx = item['hcpName'].indexOf(',');
        if (idx != -1) {
          lastName = item['hcpName'].substring(0, idx);
          firstName =
              item['hcpName'].substring(idx + 1, item['hcpName'].length);
        }
      }
      List<String> tos = [];
      if (clu != null) {
        tos.add(clu!['email']);
      }
      if (item['email'] != null && item['email'] != '') {
        tos.add(item['email']);
      }
      // if (tos.length == 0) {
      //   tos.add('blee@consolidatedstaffing.com');
      //  tos.add('jsturgill@consolidatedstaffing.com');
      tos.add('rrovinelli@consolidatedstaffing.com');

      // }

      var uuid = Uuid();
      var xuuid = uuid.v4();
      Timestamp ts = item['shiftDate'];
      Map<String, dynamic> genericMail = {
        "subject": subject,
        "text": text,
        "html": html,
        "branchId": item['branchId'],
        "branchName": item['branchName'],
        "clientId": item['clientId'],
        "clientName": item['clientName'],
        "departmentId": item['departmentId'],
        "departmentName": item['departmentName'],
        "disciplineId": item['disciplineCodes'],
        "disciplineName": item['disciplineName'],
        "endTime": item['endTime'],
        "hcpId": item['hcpId'],
        'firstName': firstName,
        'lastName': lastName,
        "hcpName": item['hcpName'],
        "shiftCode": item['shiftCode'],
        "shiftDate": ts,
        "startTime": item['startTime'],
        "statusId": item['shiftStatus'],
        "templateId": templateId,
        "tos": tos,
        "uuid": xuuid,
      };
      FirebaseFirestore.instance
          .collection('GenericEmailMessage')
          .doc(xuuid)
          .set(genericMail);
      return;
    } catch (e) {
      print('line 576 error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<bool> sendEmailFromGMail() async {
    // Future<void> sendEmailFromGMail(List<String> tos, String from,
    //     String fromUserName, String subject, String text) async {
    //   print('line 252 tuil send an gmail.');
    //   String username = dotenv.env['GMAIL_USERNAME']!;
    //   String password = dotenv.env['GMAIL_PASSWORD']!;
    //   //final outlookSmtp =
    //   ///   hotmail(dotenv.env["OUTLOOK_EMAIL"]!, dotenv.env['OUTLOOK_PASSWORD']!);
    //   //  final smtpServer = SmtpServer('smtp.office365.com'
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
    //     print('line 215 error: $e');
    //   }
    return true;
  }

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

  Future<dynamic>? getToken() async {
    var client = http.Client();
    var url = Uri.https('api.stafferlink.com', 'asm/authenticate');
    var orgId = dotenv.env['ASM_DB1'];
    print('line 550 url:  $url $orgId');
    Map data = {
      'key': '30c39597a9604a979e9430ee5794fab6',
      'secret': 'a594b1ede33b48e7bed9418c6fd50e43',
      'orgId': orgId
    };
    var body = json.encode(data);
    print('line 557 body: $body');
    // headers: {"Content-Type": "application/json"},
    try {
      http.Response response = await client.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
      print('line 562 ${response.statusCode}');
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
      print('line 574: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<bool> putAnyData(
      dynamic jsonObject, String url, int asmWorkOrderId) async {
    String url =
        "https://api.stafferlink.com/asm/Orders/${asmWorkOrderId}/Cancel";

    bool bl = false;
    String? token = await getToken();
    print('line 571: $token');
    Map<String, String>? hdrs = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    try {
      String dte = jsonObject['Conf_Emp_Time'];
      dte = dte.replaceAll(String.fromCharCode(8239), ' ');
      jsonObject['Conf_Emp_Time'] = dte;
      String nbsp = String.fromCharCode(0x00A0);
      dte = dte.replaceAll(nbsp, ' ');
      jsonObject['Conf_Emp_Time'] = dte;
      dte = jsonObject['Conf_Cli_Time'];
      dte = dte.replaceAll(String.fromCharCode(8239), ' ');
      jsonObject['Conf_Cli_Time'] = dte;
      dte = dte.replaceAll(nbsp, ' ');
      jsonObject['Conf_Cli_Time'] = dte;
      print('line 577: ${jsonEncode(jsonObject)}');
      print('line 578 just before put: $url');
      final jsn = jsonEncode(jsonObject);
      print('line 581: $jsn');
      await http.put(Uri.parse(url), headers: hdrs, body: jsn).then((response) {
        print('line 583: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          bl = true;
        } else {
          bl = false;
        }
      });
      return bl;
    } catch (er) {
      print('line 576 error: $er');
      return bl;
    }
  }

//FIRST DAY OF THE WEEK
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    int nf = -1;
    switch (dateTime.weekday) {
      case 1:
        nf = 0;
        break;
      case 2:
        nf = 1;
        break;
      case 3:
        nf = 2;
        break;
      case 4:
        nf = 3;
        break;
      case 5:
        nf = 4;
        break;
      case 6:
        nf = 5;
        break;
      case 7:
        nf = 6;
        break;
      default:
        throw Exception('Bad value for subtraction factor fo days of week;');
    }
    return dateTime.subtract(Duration(days: nf));
  }

  //LAST DAY OF THE WEEK
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }
  //LAST DAY OF THE MONTH

  DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0);
  }
  //FIRST DAY OF THE MONTH

  DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }
  //LAST DAY OF THE YEAR

  DateTime findLastDateOfTheYear(DateTime dateTime) {
    return DateTime(dateTime.year, 12, 31);
  }
  // FIRST DAY OF THE YEAR

  DateTime findFirstDateOfTheYear(DateTime dateTime) {
    return DateTime(dateTime.year, 1, 1);
  }

  Future<Map<String, dynamic>> checkWeeklyHours(int hcpId, String weekStartDay,
      DateTime targetDate, int clientId, Timestamp createdShiftDate) async {
    print('line 1086 checkweek: $hcpId  $weekStartDay $targetDate');
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
    //build date list
    targetDate = targetDate.subtract(Duration(
        hours: targetDate.hour,
        minutes: targetDate.minute,
        seconds: targetDate.second,
        microseconds: targetDate.microsecond,
        milliseconds: targetDate.millisecond));
    Timestamp tsd = Timestamp.fromDate(targetDate);
    int wkd = targetDate.weekday;
    int nf = -1;
    switch (wkd) {
      case 1:
        nf = 0;
        break;
      case 2:
        nf = 1;
        break;
      case 3:
        nf = 2;
        break;
      case 4:
        nf = 3;
        break;
      case 5:
        nf = 4;
        break;
      case 6:
        nf = 5;
        break;
      case 7:
        nf = 6;
        break;
    }
    DateTime fdate = targetDate.subtract(Duration(days: nf));
    List<DateTime> listOfDates = [];
    listOfDates.add(fdate);
    for (int i = 1; i < 7; i++) {
      fdate = fdate.add(Duration(days: 1));
      listOfDates.add(fdate);
    }
    Timestamp startD = Timestamp.fromDate(listOfDates[0]);
    Timestamp endD = Timestamp.fromDate(listOfDates[6]);

    Map<String, dynamic> tvs = {
      'dailyScheduledMinutes': [],
      'weeklyScheduledMinutes': 0,
      'listOfDates': [],
      'shiftData': []
    };
    try {
      int dayIndex = listDays.indexOf(weekStartDay);
      int scheduledMinutes = 0;

      int startWeek = 1;
      int ndays = 7;
      DateTime fdate = listOfDates[0];
      DateTime edate = listOfDates[6];
      fdate = fdate.subtract(Duration(
          hours: fdate.hour,
          minutes: fdate.minute,
          seconds: fdate.second,
          microseconds: fdate.microsecond,
          milliseconds: fdate.millisecond));
      Timestamp ts = Timestamp.fromDate(fdate);
      edate = edate.subtract(Duration(
          hours: edate.hour,
          minutes: edate.minute,
          seconds: edate.second,
          microseconds: edate.microsecond,
          milliseconds: edate.millisecond));
      Timestamp tse = Timestamp.fromDate(edate);
      print('line 1159: $startWeek  $ndays ${targetDate.weekday}');
      // if (targetDate.weekday == 1) {
      //   fdate = targetDate.subtract(Duration(days: 1));
      // }
      print('line 1163 fdate: $fdate');
      List<int> listOfScheduledMinutes = [0, 0, 0, 0, 0, 0, 0];
      List<Map<String, dynamic>> listOfDaysAndMinutes = [];
      DateTime startDate = listOfDates[0];
      DateTime endDate = listOfDates[listOfDates.length - 1];
      int meals = 30;
      print('line 1169: $startDate $ts $endDate $tse $listOfDates');
      List<Map<String, dynamic>> listASMs = [];
      await FirebaseFirestore.instance
          .collection('HCPTimeCard')
          .where('hcpId', isEqualTo: hcpId)
          .where('shiftDate', isGreaterThanOrEqualTo: ts)
          .where('shiftDate', isLessThanOrEqualTo: tse)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> obj = docSnapshot.data();
          //  String shiftDateString = obj['shiftDate'];

          print('line 1182 keeping asms');
          listASMs.add(obj);
        }
      });
      print('line 1186 check ${listASMs.length}');
      tvs['dailyScheduledMinutes'] = [0, 0, 0, 0, 0, 0, 0];
      tvs['weeklyScheduledMinutes'] = 0;
      tvs['shiftData'] = [];
      tvs['listOfDates'] = listOfDates;
      if (listASMs.length > 0) {
        for (int i = 0; i < listASMs.length; i++) {
          Map<String, dynamic> obj = listASMs[i];
          print('line 1205: ${obj}');
          String? startTime;
          String? endTime;
          String? woShiftCode;
          Timestamp? shiftDateTs;
          woShiftCode = obj['shiftCode'];
          shiftDateTs = obj['shiftDate'];
          DateTime shiftDate = shiftDateTs!.toDate();
          DateTime sfDate = shiftDate.subtract(Duration(
              hours: shiftDate.hour,
              minutes: shiftDate.minute,
              seconds: shiftDate.second,
              microseconds: shiftDate.microsecond,
              milliseconds: shiftDate.millisecond));
          int nday = -1;

          for (int q = 0; q < listOfDates.length; q++) {
            Timestamp txs = obj['shiftDate'] as Timestamp;
            print('line 1223: ${txs.millisecondsSinceEpoch} ${sfDate.millisecondsSinceEpoch}');
            if (txs.millisecondsSinceEpoch ==
                sfDate.millisecondsSinceEpoch) {
              nday = q;
              break;
            }
          }
          print('line 1216 $nday');
          if (nday == -1) {

            throw Exception('line 1217 invalid nday value');
          }
                print('line 1275 ${obj['shiftStatus']} ${obj['signedOutInitialDecimalHoursChanged']}');
          if (obj['shiftStatus'] == 'SignedOut') {
            scheduledMinutes = int.parse(
                (60 * obj['signedOutInitialDecimalHoursChanged'])
                    .round()
                    .toString());
            if (scheduledMinutes > obj['meals']) {
              scheduledMinutes -= int.parse(obj['meals'].toString());
            }
            print('line 1284 $sfDate $scheduledMinutes, $woShiftCode $nday');
            Map<String, dynamic> mp = {
              'shiftDate': sfDate,
              'minutes': scheduledMinutes,
              'shiftCode': woShiftCode,
              'nDay': nday
            };
            listOfDaysAndMinutes.add(mp);
            listOfScheduledMinutes[nday] += scheduledMinutes;
          } else {
          print('line 1296');
            startTime = obj['shiftStartTime'];
            endTime = obj['shiftEndTime'];
            print('line 1252: $woShiftCode $startTime $endTime');
            int sMin = getMinutes(startTime!);
            int eMin = getMinutes(endTime!);
            print('line 1255: $sMin $eMin');
            scheduledMinutes =
                calculateShiftHours(sMin, eMin, startTime, endTime, meals);
            Map<String, dynamic> mp = {
              'shiftDate': sfDate,
              'minutes': scheduledMinutes,
              'shiftCode': woShiftCode,
              'nDay': nday
            };
            print('line 1263: $sMin $eMin $scheduledMinutes');
            listOfDaysAndMinutes.add(mp);
            listOfScheduledMinutes[nday] += scheduledMinutes;
          }
        }
        tvs['dailyScheduledMinutes'] = listOfScheduledMinutes;
        int weeklyMinutes = 0;
        for (int i = 0; i < listOfScheduledMinutes.length; i++) {
          weeklyMinutes += listOfScheduledMinutes[i];
        }
        tvs['weeklyScheduledMinutes'] = weeklyMinutes;
        tvs['shiftData'] = listOfDaysAndMinutes;
      }
      tvs['listOfDates'] = listOfDates;
      print('line  1277: $tvs');

      return tvs;
    } catch (e) {
      print('line 1282 error: ${e.toString()}');
      throw Exception('line 1283 error in checkweekly hours');
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
    print('line 880: $hcpId $ctd');
    int month = ctd.month;
    int year = ctd.year;
    int day = ctd.day;
    int priorMinutes = 0;
    int pmin = ctd.millisecondsSinceEpoch;
    pmin -= (24 * 60 * 60 * 1000);
    print('line 887: $pmin');
    try {
      await FirebaseFirestore.instance
          .collection('ClientWorkOrder')
          .where('hcpId', isEqualTo: hcpId)
          .where('dates.rates.rateDetails.shiftCode', whereIn: ['3', 'PA'])
          .where('shiftStatus', isEqualTo: 'Closed')
          .get()
          .then((querySnapshot) async {
            for (var docSnapshot in querySnapshot.docs) {
              var obj = docSnapshot.data();
              Timestamp stm = obj['dates']['shiftDateInfo']['shiftDate'];
              print('line 897: $stm');
              print('line 898 ${stm.millisecondsSinceEpoch} $pmin');
              if ((stm.millisecondsSinceEpoch >= pmin &&
                      pmin <=
                          stm.millisecondsSinceEpoch + (24 * 60 * 60 * 1000)) ||
                  (pmin >= stm.millisecondsSinceEpoch &&
                      stm.millisecondsSinceEpoch <=
                          pmin + (24 * 60 * 60 * 1000))) {
                int sMin = getMinutes(
                    obj['dates']['rates']['rateDetails']['startTime']);
                int eMin =
                    getMinutes(obj['dates']['rates']['rateDetails']['endTime']);
                print('line 908: $sMin $eMin');
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
      print('line 925: $priorMinutes');
      return priorMinutes;
    } catch (e) {
      print('line 928 error: ${e.toString()}');
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
            print('line 916: $startTime $endTime ${obj['meals']}');
            lmeals = obj['meals'];
            print('line 965 $lmeals');
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

  DateTime getValidDate(String dte) {
    print('line 825: $dte');
    try {
      int index = dte.indexOf('-');
      if (index != -1) {
        dte = dte.replaceAll('-', '/');
      }
      DateTime? tempDate;
      List<String> sts = dte.split('/');
      print('line 832: $sts');
      if (sts[0].length == 4) {
        tempDate = new DateFormat("yyyy/MM/dd").parse(dte);
      } else {
        tempDate = new DateFormat("MM/dd/yyyy").parse(dte);
      }
      print('line 839: template');
      return tempDate;
    } catch (e) {
      print('line 843: ${e.toString()}');
      return new DateFormat("yyyy/MM/dd").parse('1970/1/1');
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

  String getPayRate(
      dynamic pr, dynamic dayValue, dynamic prwe, dynamic payOTRate,dynamic payHolidayRate,bool holiday, bool sOT) {
    String? val;
    if (dayValue == 0) {
      dayValue = 7;
    }
    try {
    print('line 1427: $pr $dayValue $prwe $payOTRate $sOT');
    List<String> listOfDays = ['00', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    print('line 1565 getpayrate: $pr $dayValue');
    double rePr = 0.0;
    if (holiday == true) {
      if (dayValue == 6 || dayValue == 7) {
         rePr = double.parse(prwe.toString()) * double.parse(payHolidayRate.toString());
      } else {
        rePr = double.parse(pr.toString()) * double.parse(payHolidayRate.toString());
      }
    } else if (sOT == true) {
       if (dayValue == 6 || dayValue == 7) {
           rePr = double.parse(prwe.toString()) * double.parse(payOTRate.toString());
       } else {
               rePr = double.parse(pr.toString()) * double.parse(payOTRate.toString());
       }
  } else {
      if (dayValue == 6 || dayValue == 7) {
        rePr = double.parse(prwe.toString());
      } else {
        rePr = double.parse(pr.toString());
      }
    }
 val = '\$' + rePr.toStringAsFixed(2);
 print('line 1449: $val');
      return val;
 } catch (e) {
      print('line 1590: $dayValue ${e.toString()}');
        double dbl = 0.0;
        val = '\$' + dbl.toStringAsFixed(2);

    }
    print('line 1465 in error routine: $val');
    return val;
  }

  String getPriorScheduledHours(int sph) {
    double dsph = sph.toDouble();
    dsph /= 60;
    return dsph.toStringAsFixed(2);
  }

  String getOvertimeString(bool? value) {
    print('line 450: $value');
    String str = 'No';
    if (value == null) {
      return str;
    }
    if (value == true) {
      str = 'Yes';
    }
    print('line 457: $str');
    return str;
  }

  String getRegularMinutes(dynamic sphh, dynamic rphh) {
    try {
      // String ssp = getOTHours(sph);
      // double otHours = double.parse(ssp);
      // double decMin = rph.toDouble();
      // double decHours = double.parse((decMin / 60).round().toString());
      // decMin = decMin % 60;
      // decMin = double.parse((decMin / 60).toStringAsFixed(2));
      // double sdph = decHours + decMin;
      // if (otHours > sdph) {
      print('line 1641 othours: $sphh $rphh');
      if (rphh == null) {
        return '0.0';
      }
      double rph = double.parse(rphh.toString());
      // double sph = double.parse(sphh.toString());
      if (rph == 0) {
        return '0.0';
      }
      double regHours = rph;
      String sRegHours = (regHours / 60).toStringAsFixed(2);
      return sRegHours;
    } catch (e) {
      print('line 1501 error: ${e.toString()}');
      throw Exception('Error: ${e.toString()}');
    }
  }

  String getOTHours(dynamic sphh) {
    print('line 1486 getOTHours: ${sphh}');
    if (sphh == null) {
      return '0.0';
    }
    double sph = double.parse(sphh.toString());
    try {
      String sdsph = '';
      if (sph == 0) {
        sdsph = '0.0';
        return sdsph;
      }

      double decMin = sph;
      String sDecHours = (decMin / 60).toStringAsFixed(2);
      return sDecHours;
    } catch (e) {
      print('line 1501 error: ${e.toString()}');
      throw Exception('Error: ${e.toString()}');
    }
  }

  String getShiftHoursAsString(dynamic value) {
    if (value == null) {
      return '0.00';
    }
    double val = double.parse(value.toString());
    String str = val.toStringAsFixed(2);
    print('line 466: $str');
    return str;
  }

  String getOTInfo(bool bl) {
    if (bl == false) {
      return "No";
    }
    return "Yes";
  }

  String getRegularHours(dynamic sphh, dynamic decimalHourss) {
    print('line 1560: $sphh $decimalHourss');
    try {
      if (sphh == null) {
        double dech = double.parse(decimalHourss.toString());
        String dechs = dech.toStringAsFixed(2);
        return dechs;
      }
      int sph = int.parse(sphh.toString());
      double decimalHours = double.parse(decimalHourss.toString());
      if (sph == 0) {
        return '0.0';
      }
      if (sph > 2400) {
        return '40';
      }
      int decMin = (60 * decimalHours).toInt();
      sph += decMin;
      if (sph > 2400) {
        return '40';
      }
      int tmd = sph % 60;
      double drg = sph.toDouble();
      drg = double.parse((drg / 60).toStringAsFixed(2));
      double dmd = tmd.toDouble();
      if (dmd > 0) {
        dmd = double.parse((dmd / 60).toStringAsFixed(2));
      }
      drg += dmd;
      print('line 1588 ${drg.toStringAsFixed(2)}');
      return drg.toStringAsFixed(2);
    } catch (e) {
      print('line 1590 error: ${e.toString()}');
      throw Exception('line 1592 error: ${e.toString()}');
    }
  }
  Future<Map<String,dynamic>> checkForOvertime(
    int hcpId, int clientId, String shiftCode, Timestamp shiftDate,
    Timestamp shiftCreatedDate, int sDiff,List<String>listOfStatuses,int meals) async  {
      print('line 1774: in checkforovertime $hcpId, $clientId');
      try {
        //get beginning and ending of week dates
        DateTime date = shiftDate.toDate();
        listOfStatuses = ['Accepted','Approved', 'Confirmed', 'SignedIn', 'SignedOut'];
        int weekDay = date.weekday;
        int sval = weekDay - 1;
        DateTime startDate = date.subtract(Duration(days: sval));
        sval = 7 - weekDay;
        DateTime endDate = date.add(Duration(days: sval));
        startDate = startDate.subtract(Duration(hours: startDate.hour,
            minutes: startDate.minute,
            seconds: startDate.second,
            microseconds: startDate.microsecond,
            milliseconds: startDate.millisecond));
        endDate = endDate.subtract(Duration(hours: endDate.hour,
            minutes: endDate.minute,
            seconds: endDate.second,
            microseconds: endDate.microsecond,
            milliseconds: endDate.millisecond));
        DateTime sts = shiftDate.toDate();
        sts = sts.subtract(Duration(hours: sts.hour,
            minutes: sts.minute,
            seconds: sts.second,
            microseconds: sts.microsecond,
            milliseconds: sts.millisecond));
        DateTime ets = sts.add(Duration(days: 1));
        Timestamp tsts = Timestamp.fromDate(sts);
        Timestamp tets = Timestamp.fromDate(ets);
        print('line 1793: $sts $ets $tsts $tets $listOfStatuses');
        double otHours = 0;
        double totalHours = 0;
        double forwardHours = 0;
        double currentHours = 0;
        double regularHours = 0;
        List<int>listOfClientIds = [];
        List<Map<String, dynamic>>listOfOtData = [];
        Map<String, dynamic>hoursMap = {
          'clientId': 0,
          'otHours': 0,
          'forwardHours': 0.0,
          'regularHours': 0.0,
          'totalHours': 0.0,
          'shiftOvertime': false,
        };
        print('line 1811 ${hoursMap}');
        await FirebaseFirestore.instance
            .collection('ClientWorkOrderCampaign')
            .where('hcpId', isEqualTo: hcpId)
            .where('clientId', isEqualTo: clientId)
            .where('shiftDate', isGreaterThanOrEqualTo: tsts)
            .where('shiftDate', isLessThanOrEqualTo: tets)
            .where('shiftStatus', whereIn: listOfStatuses)
            .orderBy("shiftCreatedDate", descending: false)
            .orderBy("shiftCode", descending: false)
            .get()
            .then((querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            for (var docSnapshot in querySnapshot.docs) {
              Map<String, dynamic> obj = docSnapshot.data();
              print('line 1822: ${obj}');
              //  String shiftDateString = obj['shiftDate'];
              Timestamp ts = obj['shiftDate'] as Timestamp;
              DateTime dts = ts.toDate();
              dts = dts.subtract(Duration(hours: dts.hour,
                  minutes: dts.minute,
                  seconds: dts.second,
                  microseconds: dts.microsecond,
                  milliseconds: dts.millisecond));

              if (clientId == obj['clientId'] &&
                  (dts.microsecondsSinceEpoch >= sts.microsecondsSinceEpoch &&
                      sts.microsecondsSinceEpoch <= ets.microsecondsSinceEpoch)
                  && obj['shiftCode'] == shiftCode) {
                continue;
              }
              int index = listOfClientIds.indexOf(obj['clientId']);
              if (index == -1) {
                listOfClientIds.add(obj['clientId']);
              }
              print('line 1843: $index');
              int sMin = getMinutes(obj['startTime']);
              int eMin = getMinutes(obj['endTime']);
              if (sMin > eMin) {
                eMin += 1440;
              }
              double seMin = double.parse(eMin.toString()) -
                  double.parse(sMin.toString());
              seMin -= double.parse(obj['meals'].toString());
              currentHours = double.parse((seMin / 60).toStringAsFixed(2));
              totalHours += currentHours;
              forwardHours += currentHours;
              if (forwardHours > 40.0) {
                otHours = forwardHours - 40;
                regularHours = currentHours - otHours;
                forwardHours = 40;
              } else {
                otHours = 0.0;
                regularHours = currentHours;
              }
              print('line 1862: $otHours $regularHours $totalHours');
              if (index == -1) {
                hoursMap['clientId'] = obj['clientId'];
                hoursMap['regularHours'] = regularHours;
                hoursMap['forwardHours'] = forwardHours;
                hoursMap['totalHours'] = totalHours;
                if (otHours > 0) {
                  hoursMap['shiftOvertime'] = true;
                } else {
                  hoursMap['shiftOvertime'] = false;
                }
                listOfOtData.add(hoursMap);
              } else {
                Map<String, dynamic>genMap = listOfOtData[index];
                genMap['regularHours'] += regularHours;
                genMap['forwardHours'] = forwardHours;
                genMap['totalHours'] = totalHours;
                if (otHours > 0) {
                  genMap['shiftOvertime'] = true;
                } else {
                  genMap['shiftOvertime'] = false;
                }
                listOfOtData[index] = genMap;
              }
            }
          } else {
            print('line 1892 no data');
          }
        });

        int index = listOfClientIds.length - 1;
        if (index != -1) {
           hoursMap = listOfOtData[index];
        }
        double hcpOtHours = 0;

        double hcpForwardHours = hoursMap['forwardHours'];
        double hcpRegularHours = hoursMap['regularHours'];
        double dDiff = double.parse(sDiff.toString());
        dDiff = dDiff /60.0;
        double hcpCurrentHours = double.parse(dDiff.toStringAsFixed(2));
        hcpForwardHours += hcpCurrentHours;
        if (hcpForwardHours > 40) {
          hcpOtHours = hcpForwardHours - 40;
          hcpRegularHours =hcpCurrentHours - hcpOtHours;
          hoursMap['clientId'] = clientId;
          hoursMap['regularHours'] = hcpRegularHours;
          hoursMap['otHours'] = hcpOtHours;
          hoursMap['forwardHours'] = 40;
          hoursMap['shiftOvertime'] = true;
          hoursMap['totalHours'] += hcpCurrentHours;
        } else {
          hcpRegularHours =hcpCurrentHours;
          hoursMap['clientId'] = clientId;
          hoursMap['regularHours'] = hcpRegularHours;
          hoursMap['otHours'] = 0;
          hoursMap['forwardHours'] = hcpForwardHours;
          hoursMap['shiftOvertime'] = false;
          hoursMap['totalHours'] += hcpCurrentHours;
        }
          print('line 1862: $hoursMap');
          return hoursMap;
      } catch(e) {

        print('line 1917 error: ${e.toString()}');
        throw Exception('Error: ${e.toString()}');
      }

  }  //shift minutes
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
        int value = int.parse(arg['searchValue']!);
        int branchId = int.parse(stringBranchId);
        if (branchId == 0) {
          query = contentsRef
              .where(arg['searchField']!, isGreaterThanOrEqualTo: value);
       } else {
          query = contentsRef
              .where('branchId', isEqualTo: branchId)
              .where(arg['searchField']!, isGreaterThanOrEqualTo: value);
        }
        return query;
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
