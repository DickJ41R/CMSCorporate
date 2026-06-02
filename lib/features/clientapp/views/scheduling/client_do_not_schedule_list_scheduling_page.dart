//Client Do not Schedule List Scheduling Page
import 'package:cms_web/features/clientapp/models/client_work_order_campaign.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_work_order_campaign_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'package:intl/intl.dart';

class ClientDoNotScheduleListSchedulingPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientDoNotScheduleListSchedulingPage({super.key, required this.args});

  @override
  State<ClientDoNotScheduleListSchedulingPage> createState() =>
      _ClientDoNotScheduleListSchedulingPageState();
}

class _ClientDoNotScheduleListSchedulingPageState
    extends State<ClientDoNotScheduleListSchedulingPage> {
  _ClientDoNotScheduleListSchedulingPageState();

  ClientWorkOrderCampaignService clw = ClientWorkOrderCampaignService();
  Map<String, dynamic>? cwo;
  bool allItemsIsEmpty = false;
  HCPTimeCardService hts = HCPTimeCardService();
  ClientServices clientServices = ClientServices();

  Map<String, dynamic>? client;
  late int? clientId;
  bool? foundShifts = false;
  late List<Map<String, dynamic>>? tcms;
  bool noData = true;
  String? email;
  late int? userId;
  Future<List<dynamic>>? listHCPs;

  AuthService authService = AuthService();

  Future<void> _getClient() async {
    try {
      client = await clientServices.getClient(clientId!);
      return;
    } catch (e) {
      print('line 133 gethcps error: $e');
      throw Exception('line 67 error gethcps: $e');
    }
  }

  Future<List<dynamic>> _getDNUs(BuildContext ctx) async {
    print('line 86 enterig gethcps: ');
    List<dynamic> lst = [];
    try {
      //hanged for app 5/27/2025 switch next 2 lines
      //  lst = await clientServices.getDNUForClients(clientId!, ctx);
      lst = await clientServices.getDNUForClients(clientId!);

      return lst;
    } catch (e) {
      print('line 133 gethcps error: $e');
      throw Exception('line 67 error gethcps: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    clientId = arguments!['clientId'];
    if (authService.clientMap == null) {
      _getClient();
    }
    print('line 39:  $clw');
    print('lint 55: $clientId');

    foundShifts = true;
  }

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double fontSize = 16;
  double? appWidth;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    print('line 40 in showavailashifts');
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    appWidth = screenWidth / 2;
    fontSize = 16;
    fontSize /= h;
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: const Text("List of Client DNUs"),
        leading: GestureDetector(
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(clientSchedulingMenu, arguments: arguments!);
              }),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: Future.wait([_getDNUs(context)]),
            builder: (context, snapshot) {
              print('line 144: ${snapshot.connectionState}');
              // if (snapshot.connectionState == ConnectionState.done) {
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
                          'There are no \"DO NOT SCHEDULE\" for this client.',
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
                List<dynamic> listH = snapshot.data![0]; // cast to List<Marker>
                print('line 111 ${listH.length}');
                if (listH.length == 0) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        height: 110,
                        width: screenWidth - 10,
                        child: Text(
                            'There are no \"DO NOT SCHEDULE\" for this client.',
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
                  List<dynamic> listH = snapshot.data![0];
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
                      return ClientDNUTile(itemm: item);
                    },
                  );
                }
              }
            }),
      ),
    );
  }
}

class ClientDNUTile extends StatefulWidget {
  final dynamic itemm;

  const ClientDNUTile({required this.itemm});
  @override
  State<ClientDNUTile> createState() => ClientDNUTileState();
}

class ClientDNUTileState extends State<ClientDNUTile> {
  ClientDNUTileState();

  late dynamic item;
  String? dnuDate;
  String? whichDNU;
  Color color1 = const Color.fromARGB(255, 19, 125, 103);
  Color color2 = const Color.fromARGB(255, 77, 176, 178);
  @override
  initState() {
    super.initState();
    item = widget.itemm;
    // if (item.flagClientDNU == true) {
    //   dnuDate = formatter.format(item.clientDNUDate);
    //   whichDNU = 'Client';
    // } else {
    //   dnuDate = formatter.format(item.hcpDNUDate);
    //   whichDNU = "HCP";
    // }
  }

  String getType(bool rgs) {
    if (rgs == true) {
      return "HCP";
    } else {
      return "Client";
    }
  }

  DateFormat formatter = DateFormat('MM-dd-yyyy');
  double fontSize = 18;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }

    fontSize = 18 / h;

    print('line 98 in tile building');
    return Container(
      width: screenWidth - 10,
      height: 240,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(color: Color.fromARGB(255, 19, 125, 103), width: 4),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(height: 5),
        Container(
          height: 30,
          width: screenWidth - 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('HCP: ${item['hcpId']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text('${item['hcpName']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 30,
          width: screenWidth - 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Dep Id: ${item['departmentId']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text('Client DNU ${item['flagDNU']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ),
            ],
          ),
        ),
        SizedBox(width: 5),
        Container(
          height: 160,
          width: screenWidth - 10,
          child: Text('${item['comments']}',
              maxLines: 10,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              )),
        ),
      ]),
    );
  }
}
