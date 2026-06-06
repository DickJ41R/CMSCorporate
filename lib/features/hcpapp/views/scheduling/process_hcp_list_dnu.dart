import 'package:cms_web/features/shared/utils/dropdown_codes.dart';
import 'package:flutter/material.dart';

import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
//import 'package:hcp_app/pages/home/home.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

final DropDownCodes dropDownCodes = DropDownCodes();

String globalBranchName = '';

class ProcessHCPDNU extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessHCPDNU({super.key, required this.args});

  @override
  ProcessClientDNUState createState() => ProcessClientDNUState();
}

class ProcessClientDNUState extends State<ProcessHCPDNU> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final _fieldKey = GlobalKey<FormFieldState>();

  AuthService authService = AuthService();
  HCPServices hcpServices = HCPServices();
  HCPTimeCardService hcpTimeCardService = HCPTimeCardService();

  List<int> clientIds = [];
  late Future<List<String>> futureClients;
  int selectedClientId = -1;
  dynamic selectedClient;
  Future<List<dynamic>>? listClients;
  //final TextEditingController _setTextController = TextEditingController();
  String selectedValueClient = '';
  //TextEditingController _commentTextController = TextEditingController();
  bool check1 = false;

  int? hcpId;
  String? fullName;
  Map<String, dynamic>? hcProfessional;
  void getHCPUserX() async {
    debugPrint('line 44 in get usrx');
    hcProfessional = await getHCPUser();
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
      hcpId = lm['hcpId'];
      return lm;
    } catch (e) {
      debugPrint('line 63 error: $e');
      throw Exception(e.toString());
    }
  }

  Map<String, dynamic>? arguments;
  @override
  void initState() {
    // _loggedInUser = ref.read(globalUserModel.notifier).state;
    // debugPrint('line 54: $_loggedInUser ${ref.read(globalUserModel.notifier).state}');
    super.initState();
    arguments = widget.args;
    hcpId = arguments!['hcpId'];
    getHCPUserX();
  }

  Future<List<Map<String, dynamic>>> _getHCPDNUs() async {
    try {
      List<Map<String, dynamic>>? dnus =
          await hcpTimeCardService.getHCPTimeCardsWithClients(hcpId!);
      return dnus!;
    } catch (e) {
      debugPrint('line 94 error: $e');
      throw Exception(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('line 63 didchange');

    getHCPUser();
  }

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;
  @override
  Widget build(context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double? h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    fontSize = 16;
    fontSize /= h;
    debugPrint('line 136');
    return SafeArea(
      child: Scaffold(
        backgroundColor: color1,
        appBar: AppBar(
          title: Text("HCP DNU Setting",
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
                final navigator = Navigator.of(context)
                    .pushNamed(hcpMenu, arguments: arguments!);
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 5),
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      child: Text(
                        'Select An HCP',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: Future.wait([_getHCPDNUs()]),
                        builder:
                            (context, AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ),
                            );
                          } else if (snapshot.data == [[]] &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            return Center(
                              child: Container(
                                height: 100,
                                width: screenWidth! - 10,
                                child: Text(
                                    'THere were no dnus for the selected hcp.',
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        color: color2,
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
                                  width: screenWidth! - 10,
                                  child: Text(
                                      'THere were no dnus for the selected hcp.',
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          color: color2,
                                          fontWeight: FontWeight.bold)),
                                ),
                              );
                            } else {
                              List<Map<String, dynamic>> listH =
                                  snapshot.data![0];
                              debugPrint(
                                  'line 255: $selectedValueClient ${listH.length}');
                              return ListView.builder(
                                restorationId: 'HCPDNUListView',
                                itemCount: listH.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = listH[index];
                                  return HCPDNUTile(itemm: item);
                                },
                              );
                            }
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HCPDNUTile extends StatefulWidget {
  final Map<String, dynamic> itemm;

  const HCPDNUTile({required this.itemm});

  @override
  State<HCPDNUTile> createState() => _HCPDNUTileState();
}

class _HCPDNUTileState extends State<HCPDNUTile> {
  _HCPDNUTileState();

  late Map<String, dynamic> item;

  @override
  initState() {
    super.initState();
    item = widget.itemm;
  }

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;

  DateFormat formatter = DateFormat('MM-dd-yyyy');
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
    var dnuDate = item['flagHCPDNU'] == true
        ? formatter.format(item['ncpDNUDate'])
        : formatter.format(item['clientDNUDate']);
    var dnuSetter = item['flagHCPDNU'] == true ? "NCP" : "Clienbt";
// debugPrint('line 98 in tile building');
// String hoursString = (item.decimalHours - (item.meals/60)).toStringAsFixed(2);
// hoursString = '7.50';
    return Container(
      width: screenWidth! - 10,
      height: 400,
      decoration: BoxDecoration(
          color: color1,
          border: Border.all(color: color2, width: 4),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: screenWidth! - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Text('Id: ${item['clientId']}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
                SizedBox(
                  width: 5,
                ),
                Text('Id: ${item['clientName']}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize)),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 36,
            width: screenWidth! - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Text('Setter: $dnuSetter',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
                SizedBox(
                  width: 5,
                ),
                Text('Date: $dnuDate',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    )),
              ],
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 96,
            width: screenWidth! - 10,
            child: Text('comments : ${item["comments"]}',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                )),
          ),
        ],
      ),
    );
  }
}
