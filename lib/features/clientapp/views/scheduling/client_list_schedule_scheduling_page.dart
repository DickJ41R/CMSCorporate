//Client List Schedule  Scheduling Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/utils/dropdown_codes.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/branchcorporateapp/models/cms_user.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

final DropDownCodes dropDownCodes = DropDownCodes();

String globalBranchName = '';

class ClientListScheduleSchedulingPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientListScheduleSchedulingPage({super.key, required this.args});

  @override
  State<ClientListScheduleSchedulingPage> createState() =>
      _ClientListScheduleSchedulingPageState();
}

class _ClientListScheduleSchedulingPageState
    extends State<ClientListScheduleSchedulingPage> {
  int listLength = -1;
  final DropDownCodes dropDownCodes = DropDownCodes();
  late int? clientId;
  Map<String, dynamic>? client;
  String? userEmail;
  late Future<List<Map<String, dynamic>>>? futureAllItems;
  ClientServices clientServices = ClientServices();
  ClientWorkOrderCampaignService clw = ClientWorkOrderCampaignService();
  AuthService authService = AuthService();

  Future<List<Map<String, dynamic>>> _getAllScheduledShifts() async {
    print('line 40 in getallscheduleshifts asm and mobile');
    List<Map<String, dynamic>>? lm =
        await clw.getClientWorkOrdersAll(clientId!);
    listLength = lm!.length;
    return lm;
  }

  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    print('line 51: $arguments');
    clientId = arguments!['clientId'];
    client = authService.clientMap!;
    userEmail = client!['email'];
  }

  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo

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
    print('line 73 in build list schedule $screenWidth $screenHeight');
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("Complete Schedule",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        leading: GestureDetector(
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 24,
                color: Colors.black,
              ),
              onPressed: () {
                print('line 92 in list schedule: $clientSchedulingMenu');
                Navigator.of(context)
                    .pushNamed(clientSchedulingMenu, arguments: arguments!);

                // final navigator = Navigator.of(context);
                // navigator.pushReplacement(
                //     MaterialPageRoute(builder: (BuildContext context) {
                //       return ClientSchedulingMenu(
                //           ctx: context, clientId: clientId!);
                //     }));
              }),
        ),
      ),
      body: FutureBuilder(
          future: Future.wait([_getAllScheduledShifts()]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            // print(
            //     'line 91: ${snapshot.data}  ${snapshot.connectionState} ${snapshot.hasData}');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  height: 100,
                  child: Text('Error: ${snapshot.error}',
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize! /
                              h!,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else if (snapshot.data == [[]] &&
                snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Container(
                  height: 100,
                  child: Text(
                      'There are no mobile or SL Work Orders for this client.',
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
              // if (!snapshot.hasData ||
              //     snapshot.connectionState ==
              //         ConnectionState.waiting) {
              //   return const SizedBox(
              //       height: 50,
              //       width: 50,
              //       child:
              //       Center(child: CircularProgressIndicator()));
              // }
              List<dynamic> listH = snapshot.data![0];
              print('line 111 ${listH.length}');
              if (listH.length == 0) {
                return Center(
                  child: Container(
                    height: 100,
                    child: Text(
                        'There are no mobile Work Orders for this client.',
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
                //  List<dynamic> listD = snapshot.data![1];
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // number of items in each row
                    mainAxisSpacing: 2.0, // spacing between rows
                    crossAxisSpacing: 8.0, // spacing between columns
                  ),
                  padding: EdgeInsets.all(8.0), // padding around the grid
                  restorationId: 'ClientCampaignListView',
                  itemCount: listH.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = listH[index];
                    return ClientScheduleTile(itemm: item);
                  },
                );
              }
            }
          }),
    );
  }
}

class ClientScheduleTile extends StatefulWidget {
  final Map<String, dynamic> itemm;
  const ClientScheduleTile({required this.itemm});

  @override
  State<ClientScheduleTile> createState() => _ClientScheduleTileState();
}

class _ClientScheduleTileState extends State<ClientScheduleTile> {
  _ClientScheduleTileState();

  late Map<String, dynamic> item;
  UtilitiesServices utilitiesServices = UtilitiesServices();
  @override
  initState() {
    super.initState();
    item = widget.itemm;
    print('line 215: ${item} ${item['hcpId']}  ${item['shiftStatus']}');
  }

  // String convertFromTimestamp(Timestamp? timestamp) {
  //   if (timestamp == null) {
  //     return "No Date";
  //   }
  //   int ts = timestamp.millisecondsSinceEpoch;
  //   print('line 184: $ts');
  //   DateTime dt = DateTime.fromMillisecondsSinceEpoch(ts);
  //   String sdt = formatter.format(dt);
  //   print('line 186: $sdt');
  //   return sdt;
  // }

  String getHcpId(int? hcpId, String? hcpName) {
    if (hcpId == null) {
      return "Open";
    } else {
      if (hcpId == 0) {
        return "Open";
      }
      return hcpId.toString() + ' ' + hcpName!;
    }
  }

  String getBillRate(dynamic billRate) {
    if (billRate is int) {
      billRate = billRate.toDouble();
    }
    if (billRate == null) {
      return "0.00";
    } else {
      String vs = billRate.toStringAsPrecision(2);
      if (vs.indexOf('\.') == -1) {
        vs = vs + '.00';
      }
      return vs;
    }
  }

  DateFormat formatter = DateFormat('MM-dd-yyyy');
  double? screenWidth;
  double? screenHeight;
  double fontSize = 16;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 16;
    fontSize /= h;
    print('line 98 in tile building');
    return Container(
      width: 300,
      height: 330,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color2, width: 4),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Container(
        width: 300,
        height: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    'Date: ${utilitiesServices.convertFromTimestamp(item['shiftDate'])}',
                    style: TextStyle(
                      color: item['isWeekend'] == true
                          ? Colors.lightBlue
                          : item['isHoliday'] == true
                              ? Colors.red
                              : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
                SizedBox(width: 10),
                Text('Shift: ${item['shiftCode']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 28,
              width: 300,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('Start Time: ${item['startTime']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
                Text(' To: ${item['endTime']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ]),
            ),
            SizedBox(height: 10),
            Container(
              height: 28,
              width: 300,
              child: item['disciplineName'] is String
                  ? Text('Discipline: ${item['disciplineName']}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ))
                  : Text('Discipline: ${item['disciplineName'][0]}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
            ),
            SizedBox(height: 10),
            Container(
              height: 28,
              width: 300,
              child: Row(
                children: [
                  Text('Rate: \$${getBillRate(item['billRate'])}',
                      style: TextStyle(
                        color: item['isWeekend'] == true
                            ? Colors.lightBlue
                            : item['isHoliday'] == true
                                ? Colors.red
                                : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                  //   SizedBox(width: 4),
                  // Text('Day: ${item['dayValue']}',
                  //     style:TextStyle(
                  //       color: Colors.black87,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize:fontSize,
                  //     )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              height: 28,
              width: 300,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('shift Status: ${item['shiftStatus']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 28,
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text('Id: ${item['clientId'].toString()}',
                  //   style: TextStyle(
                  //     fontSize: fontSize,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(width: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${item['clientName']}',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              height: 28,
              width: 300,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${item['departmentName']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              height: 28,
              width: 300,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: item['hcpId'] == 0
                    ? Text(
                        'Open',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                      )
                    : Text(
                        '${item['hcpName']}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 28,
              width: 300,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                    'Hours:  ${utilitiesServices.getHours(item['startTime'], item['endTime'], item['meals']).toStringAsPrecision((2))}', //${getDecimalHours(item['decimalHours'])}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
                SizedBox(width: 12),
                Text('Meals: ${item['meals']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  String getHoursString(String sT, String eT) {
    try {
      String char = String.fromCharCode(8239);
      String startTime = sT.replaceAll(char, ' ');
      String endTime = eT.replaceAll(char, ' ');
      //   print('line 1059: $startTime $endTime');
      List<String> sts = startTime.split(' ');
      List<String> ets = endTime.split(' ');
      //   print('line 49: $sts $ets');
      String st = sts[0];
      String et = ets[0];
      List<String> stl = st.split(':');
      List<String> etl = et.split(':');
      double dsh = double.parse(stl[0]);
      double dsm = double.parse(stl[1]);
      double esh = double.parse(etl[0]);
      double esm = double.parse(etl[1]);
      //   print('line 61: $dsh $dsm $esh $esm');
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
          //     print('line 84: $dsh $esh');
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
      //     print('line 120: $th ');
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
}
