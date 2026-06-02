//Client Cannot Be Scheduled Profile Page
import 'package:cms_web/features/clientapp/models/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/clientapp/models/client_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ClientCannotBeScheduledProfilePage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientCannotBeScheduledProfilePage({super.key, required this.args});

  @override
  State<ClientCannotBeScheduledProfilePage> createState() =>
      _ClientCannotBeScheduledProfilePageState();
}

class _ClientCannotBeScheduledProfilePageState
    extends State<ClientCannotBeScheduledProfilePage> {
  int? clientId;
  List<dynamic>? allItems;
  ClientServices clientServices = ClientServices();

  Future<List<Map<String, dynamic>>> getAllItems() async {
    try {
      print('line 30 in getall items');
      List<Map<String, dynamic>> clients =
          await clientServices.getCannotBeScheduledData(clientId!);
      return clients;
      //_clients = clients;
    } catch (e) {
      print('line 160 _processhcp error: $e');
      rethrow;
//rethrow
//throw Exception('Error getting client invoices: $e');
    }
  }

  int? selectedId;
  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    clientId = arguments!['clientId'];
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

    print('line 128 in client cannot be scheduled $screenWidth $screenHeight');
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
              onPressed: () {}),
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: Future.wait([
            getAllItems(),
          ]),
          builder: (context, snapshot) {
            print(
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
              print('line 111 ${allItems!.length}');
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
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // number of items in each row
                    mainAxisSpacing: 2.0, // spacing between rows
                    crossAxisSpacing: 8.0, // spacing between columns
                  ),
                  padding: EdgeInsets.all(8.0), // padding around the grid
                  restorationId: 'ClientCampaignListView',
                  itemCount: allItems!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = allItems![index];
                    return ClientCampaignTile(itemm: item, fontSize: fontSize);
                  },
                );
              }
            }
          }),
    );
  }
}

class ClientCampaignTile extends StatefulWidget {
  final Map<String, dynamic> itemm;
  final double fontSize;

  ClientCampaignTile({
    required this.itemm,
    required this.fontSize,
  });

  @override
  State<ClientCampaignTile> createState() => _ClientCampaignTileState();
}

class _ClientCampaignTileState extends State<ClientCampaignTile> {
  _ClientCampaignTileState();

  late Map<String, dynamic> item;
  late double fontSize;
  late BuildContext ctx;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  UtilitiesServices utilitiesServices = UtilitiesServices();

  @override
  initState() {
    super.initState();
    item = widget.itemm;
    fontSize = widget.fontSize;
  }

  String getFormattedDate(DateTime dte) {
    DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dte);
    return formatted;
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

  String getShiftHoursAsString(dynamic value) {
    if (value == null) {
      return '0.00';
    }
    double val = double.parse(value.toString());
    String str = val.toStringAsFixed(2);
    print('line 466: $str');
    return str;
  }

  String _convertFromTimestamp(Timestamp? t) {
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

  bool isShiftApproved = false;
  DateFormat formatter = DateFormat('MM-dd-yyyy');
  double? screenWidth;
  double? screenHeight;
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
    double height = 300; // * (screenHeight! / 800);
    print('line 98 in tile building');
    return Container(
      width: screenWidth! - 10,
      height: height,
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
            height: 24,
            width: screenWidth! - 10,
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
            width: screenWidth! - 10,
            child: Text('Dept# : ${item['departmentId']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Date: ${_convertFromTimestamp(item['date'])}',
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
          SizedBox(
            height: 10,
          ),
          Row(
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
          SizedBox(
            height: 10,
          ),
          Row(
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
          SizedBox(
            height: 10,
          ),
          Row(children: [
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
          SizedBox(height: 10),
          Container(
            height: 24,
            width: screenWidth! - 10,
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
    );
  }
}
