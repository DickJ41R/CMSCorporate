import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ProcessHCPShowConfirmedShifts extends StatefulWidget {
  final Map<String,dynamic>args;
  const ProcessHCPShowConfirmedShifts({super.key,required this.args});

  @override
  _ProcessHCPShowConfirmedShiftsState createState() =>
      _ProcessHCPShowConfirmedShiftsState();
}

class _ProcessHCPShowConfirmedShiftsState
    extends State<ProcessHCPShowConfirmedShifts> {

  AuthService authService = AuthService();
  HCPTimeCardService hcpTimeCardService = HCPTimeCardService();
  HCPServices hcpServices = HCPServices();


  ClientWorkOrderCampaignService clw = ClientWorkOrderCampaignService();
  int? hcpId;
  String? gEmail;

  bool haveAllItems = false;
  _ProcessHCPShowConfirmedShiftsState();

  Future<List<Map<String, dynamic>>> _getAllConfirmedShifts() async {
    debugPrint('line 38 getAll approved shiftgs $hcpId');
    try {
      List<Map<String, dynamic>>? lm =
          await clw.getWorkOrderCampaignsApprovedConfirmed(hcpId!);
      debugPrint('line 41in get all confirmed');
      if (lm == null) {
        return [];
      }

      return lm;
    } catch (e) {
      debugPrint('line 66 erro in cancel shifts: $e');
      throw Exception(e.toString());
    }
  }

  void getHCPUserX() async {
    debugPrint('line 44 in get usrx');
    await getHCPUser();
  }

  Future<Map<String, dynamic>> getHCPUser() async {
    debugPrint('line 50 gethcpuser available shfts: $hcpServices');
    try {
      Map<String, dynamic>? lm = await hcpServices.getHCPUser(hcpId!);

      if (lm.isEmpty) {
        debugPrint('line 54 lm i septy');
        return lm;
      }
      debugPrint('line 57 in available shifts gethcpuser $lm');
      fullName = lm['legalName'];
      return lm;
    } catch (e) {
      debugPrint('line 63 error: $e');
      throw Exception(e.toString());
    }
  }
  Map<String,dynamic>? currentHCPMap;
  String? fullName;
  Map<String,dynamic>?arguments;
  @override
  void initState() {
    super.initState();
     arguments = widget.args;
     hcpId = arguments!['hcpId'];
    currentHCPMap = authService.currentHCPMap;
    gEmail = currentHCPMap!['email'];
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('line 63 didchange');

    getHCPUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double? screenWidth;
  double? screenHeight;
  double fontSize = 14;
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
    fontSize = 18;
    fontSize /= h;
    debugPrint('line 40 in show confirmed shifts');
    return Scaffold(
      appBar: AppBar(
        title: Text("Scheduled Shifts",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            )),
        leading: GestureDetector(
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(hcpSchedulingMenu, arguments: arguments!);
              }
          ),
              ),
        ),
      body: FutureBuilder<List<dynamic>>(
          future: Future.wait([_getAllConfirmedShifts()]),
          builder: (context, snapshot) {
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
                  child: Text('There are no scheduled shifts.',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize! /
                              h!,
                          color: Colors.green,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else {
              List<dynamic> data = snapshot.data![0];
              debugPrint('line 111 ${data.length}');
              if (data.length == 0) {
                return Center(
                  child: Container(
                    height: 100,
                    child: Text('There are no scheduled shifts.',
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize! /
                                h!,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              } else {
                List<dynamic> listH = snapshot.data![0];
                return ListView.builder(
                  restorationId: 'ClientCampaignListView',
                  itemCount: listH.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = listH[index];
                    return ClientCampaignTile(itemm: item);
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

  const ClientCampaignTile({required this.itemm});

  @override
  State<ClientCampaignTile> createState() => _ClientCampaignTileState();
}

class _ClientCampaignTileState extends State<ClientCampaignTile> {
  _ClientCampaignTileState();

  late Map<String, dynamic> item;

  @override
  initState() {
    super.initState();
    item = widget.itemm;
  }

  String convertFromTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    int tms = date.millisecondsSinceEpoch;

    DateTime dt = DateTime.fromMillisecondsSinceEpoch(tms + 18000);
    String sdt = formatter.format(dt);
    debugPrint('line 186: $sdt');
    return sdt;
  }

  String getPayrateAsString(dynamic pr) {
    String prs = pr.toString();
    debugPrint('line 254: $pr $prs');
    double prd = double.parse(prs);
    prs = prd.toStringAsFixed(2);

    return prs;
  }

  DateFormat formatter = DateFormat('MM-dd-yyyy');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double height = size.height;
    // debugPrint('line 98 in tile building');
    // String hoursString = (item.decimalHours - (item.meals/60)).toStringAsFixed(2);
    // hoursString = '7.50';
    return Container(
      width: screenWidth - 10,
      height: 350,
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
            height: 36,
            width: screenWidth - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Date:  ${convertFromTimestamp(item['shiftDate'])}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                // SizedBox(width:5),
                // Text(' Day: ${item['dayValue']}',
                //     style: TextStyle(
                //       color:Colors.black87,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 16,
                //     )
                // ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 36,
            width: screenWidth - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Shift: ${item['shiftCode']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                SizedBox(width: 12),
                Text('Status: ${item['shiftStatus']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 32,
            width: screenWidth - 10,
            child: Text('${item['hcpName']}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          ),
          SizedBox(height: 5),
          Container(
            height: 32,
            width: screenWidth - 10,
            child: Row(children: [
              Text('Discipline: ${item['disciplineName']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              SizedBox(width: 12),
              Text('Rate: \$' + getPayrateAsString(item['payRate']),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ]),
          ),
          SizedBox(height: 5),
          Container(
            height: 32,
            width: screenWidth - 10,
            child: Text('Client: ${item['clientName']}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color.fromARGB(255, 19, 125, 103),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          ),
          SizedBox(height: 5),
          Container(
            height: 32,
            width: screenWidth - 10,
            child: Text('Dept: ${item['departmentName']}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color.fromARGB(255, 19, 125, 103),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
          ),
          SizedBox(height: 5),
          Container(
            height: 32,
            width: screenWidth - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("FullAddress: ${item['clientCity']}, ${item['state']}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 19, 125, 103),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                //   SizedBox(width:4),
                //   Text("State: ${item['state']}",
                //       style: TextStyle(
                //        ` color:Color.fromARGB(255, 19, 125, 103),
                //         fontWeight: FontWeight.bold,
                //         fontSize: 16,
                //       )
                //   ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 32,
            width: screenWidth - 10,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text('Start: ${item['startTime']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              SizedBox(width: 5),
              Text('End: ${item['endTime']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ]),
          ),
          SizedBox(height: 5),
          Container(
            height: 32,
            width: screenWidth - 10,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text('Hours: ${item['decimalHours'].toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              SizedBox(width: 5),
              Text('Meals: ${item['meals'].toString()}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
