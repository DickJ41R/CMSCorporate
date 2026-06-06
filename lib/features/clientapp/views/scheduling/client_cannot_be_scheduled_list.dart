import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/clientapp/models/client_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ClientCannotBeScheduledPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientCannotBeScheduledPage({super.key, required this.args});

  @override
  State<ClientCannotBeScheduledPage> createState() =>
      _ClientCannotBeScheduledPageState();
}

class _ClientCannotBeScheduledPageState
    extends State<ClientCannotBeScheduledPage> {
  int? clientId;
  List<dynamic>? allItems;
  ClientServices clientServices = ClientServices();
  Map<String, dynamic>? client;
  Future<List<Map<String, dynamic>>> getAllItems() async {
    try {
      debugPrint('line 30 in getall items');
      List<Map<String, dynamic>> clients =
          await clientServices.getCannotBeScheduledData(clientId!);
      return clients;
      //_clients = clients;
    } catch (e) {
      debugPrint('line 160 _processhcp error: $e');
      rethrow;
//rethrow
//throw Exception('Error getting client invoices: $e');
    }
  }

  Map<String, dynamic>? arguments;
  int? selectedId;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    clientId = arguments!['clientId'];
    debugPrint('line 75 in initstate $clientId');
  }

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

    debugPrint('line 128 in client cannot be scheduled $screenWidth $screenHeight');
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Stops widgets from being moved by keyboard
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("Client Cannot Be Scheduled",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            )),
        leading: GestureDetector(
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 24,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(clientSchedulingMenu, arguments: arguments!);
              }),
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: Future.wait([
            getAllItems(),
          ]),
          builder: (context, snapshot) {
            debugPrint(
                'line 129: ${snapshot.data}  ${snapshot.connectionState} ${snapshot.hasData}');
            double screenWidth = MediaQuery.sizeOf(context).width;
            if (snapshot.connectionState == ConnectionState.waiting) {
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
                  height: 110,
                  width: screenWidth - 10,
                  child: SizedBox(
                      height: 10,
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize! /
                                  h!,
                              color: Colors.red,
                              fontWeight: FontWeight.bold))),
                ),
              );
            } else if (snapshot.data == [[]] &&
                snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    height: 110,
                    width: screenWidth - 10,
                    child: Text(
                        'There were no hcps who were not scheduled for this client.',
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
                ),
              );
            } else {
              allItems = snapshot.data[0]; // cast to List<Marker>
              debugPrint('line 111 ${allItems!.length}');
              if (allItems!.length == 0) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Container(
                      height: 110,
                      width: screenWidth - 10,
                      child: Text(
                          'There were no hcps who were not scheduled for this client.',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .fontSize! /
                                  h!,
                              color: color2,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              } else {
                return LayoutBuilder(builder: (context, constraints) {
                  if (screenWidth <= 400) {
                    fontSize = 16;
                  } else if (screenWidth > 400 && screenWidth < 960) {
                    fontSize = 20;
                  } else {
                    fontSize = 24;
                  }
                  fontSize /= h!;
                  return ListView.builder(
                    restorationId: 'ClientCannotBeScheduled',
                    itemCount: allItems!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = allItems![index];
                      return ClientNotScheduleTile(
                        itemm: item,
                        fontSize: fontSize,
                      );
                    },
                  );
                });
              }
            }
          }),
    );
  }
}

class ClientNotScheduleTile extends StatefulWidget {
  final Map<String, dynamic> itemm;
  final double fontSize;
  const ClientNotScheduleTile({required this.itemm, required this.fontSize});

  @override
  State<ClientNotScheduleTile> createState() => _ClientNotScheduleTileState();
}

class _ClientNotScheduleTileState extends State<ClientNotScheduleTile> {
  _ClientNotScheduleTileState();

  late Map<String, dynamic> item;
  double? fontSize;
  UtilitiesServices utilitiesServices = UtilitiesServices();
  @override
  initState() {
    super.initState();
    item = widget.itemm;
    fontSize = widget.fontSize;
  }

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

  String getTextName(String? name) {
    String? sname;
    if (name == null) {
      sname = "Not Present";
    } else {
      int fi = name.length;
      if (fi > 20) {
        sname = name.toString().substring(0, 20);
      } else {
        sname = name.toString();
      }
    }
    return sname;
  }

  DateFormat formatter = DateFormat('MM-dd-yyyy');
  double? screenWidth;
  double? screenHeight;
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
    fontSize = 16 / h;
    debugPrint('line 98 in tile building');
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
        height: 500,
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border.all(color: Color.fromARGB(255, 19, 125, 103), width: 4),
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: screenWidth! / 2,
              height: 40,
              child: Text('WO ID: ${item['workOrderId']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
            ),
            SizedBox(height: 10),
            Container(
              height: 24,
              width: 300,
              child: Text('Dept# : ${item['departmentId']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
            ),
            SizedBox(height: 10),
            Container(
              height: 24,
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${utilitiesServices.convertFromTimestamp(item['date'])}',
                    style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text('Shift: ${item['shiftCode']}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 24,
              width: 300,
              child: Row(
                children: [
                  Text('BId: ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                  Text('${item['branchId']}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                  SizedBox(width: 4),
                  Text(getTextName(item['branchName']),
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 24,
              width: 300,
              child: Row(
                children: [
                  Text('CId: ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                  Text('${item['clientId']}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                  SizedBox(width: 4),
                  Text(getTextName(item['clientName']),
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 24,
              width: 300,
              child: Row(children: [
                Text('HId: ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
                Text('${item['hcpId']}',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize)),
                Text('HCP: ${item['hcpName']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ]),
            ),
            SizedBox(height: 10),
            Container(
              height: 24,
              width: 300,
              child: Text(
                'Reason: ${item['reason']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
