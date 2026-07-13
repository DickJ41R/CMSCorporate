import 'package:flutter/material.dart';
import 'package:cms_web/features/hcpapp/models/hcp_credential.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/hcpapp/views/profile/hcp_show_credential_details_screen.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
//import 'package:hcp_app/pages/home/home.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/hcpapp/views/process_hcp_profile_menu.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';

final dio = Dio();

class ProcessHCPCredential extends StatefulWidget {
  final Map<String, String> args;
  const ProcessHCPCredential({super.key, required this.args});

  void initState() {

  }

  dynamic getCredentiald() {
    dynamic credentialId;
    return credentialId;
  }

  dynamic getHCPCredentials() {
    dynamic hcpCredentials;
    return hcpCredentials;
  }

  @override
  State<ProcessHCPCredential> createState() => _ProcessHCPCredentialState();
}

class _ProcessHCPCredentialState extends State<ProcessHCPCredential> {
  int? hcpId;
  late dynamic hcpUser;
  dynamic currentUser;
  Users? user;

  AuthService authService = AuthService();
  HCPServices hcpServices = HCPServices();
  UtilitiesServices utilityServices = UtilitiesServices();
  String? gEmail;
  Map<String, String>? arguments;
  @override
  void initState() {
    // _loggedInUser = ref.read(globalUserModel.notifier).state;
    // debugPrint('line 54: $_loggedInUser ${ref.read(globalUserModel.notifier).state}');
    super.initState();
    arguments = widget.args;
    hcpId = int.parse(arguments!['hcpId'].toString());
  }

  String? fullName;
  void getHCPUserX() async {
    await getHCPUser();
  }

  Future<Map<String, dynamic>> getHCPUser() async {
    debugPrint('line 38 gethcpuser CREDENGTIALS: $hcpServices');
    Map<String, dynamic> lm = await hcpServices.getHCPUser(hcpId!);
    if (lm.isEmpty) {
      return lm;
    }
    hcpId = lm['hcpId'];
    fullName = lm['legalName'];
    return lm;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('line 63 didchange');
    getHCPUserX();
  }

  List<dynamic> hcpCredentialsHold = [];
  HCPCredential? hcpCredential;
  List<HCPCredential> hcpCredentials = [];
  int trials = 0;
  // Custom widget functions for different layouts
  String getWillExpire(bool? bl) {
    String bls = 'No';
    if (bl == null) {
      return bls;
    }
    if (bl == true) {
      bls = 'Yes';
    }
    return bls;
  }

  Future<List<Map<String, dynamic>>> _getHCPCredentials() async {
    debugPrint('line 62 _getHCPcredentials');

    try {
      List<Map<String, dynamic>>? lm =
          await hcpServices.getHCPCredentials(hcpId!);
      return lm!;
    } catch (e) {
      debugPrint('line 69 _getClientInvoice error: $e');
      rethrow;
      //rethrow
      //throw Exception('Error getting client invoices: $e');
    }
  }

  // DateTime _getDateTime(dynamic timestamp) {
  //   var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  //   // String dts = 'Post Date: : ' + date.toString();
  //   return date;
  // }

  String getFormattedDate(dynamic dte) {
    debugPrint('line 96: $dte');
    if (dte == null) {
      return 'No Date';
    }
    String dts = dte.toString();
    dts = dts.substring(0, 10);
    return dts;
    // DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(dte);
    // return formatted;
  }

  String getStringData(String? st) {
    if (st == null) {
      return "No Data";
    }
    if (st.length > 30) {
      st = st.substring(0, 30);
    }
    return st;
  }

  DateFormat formatter = DateFormat('yyyy-MM-dd');
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      height: screenHeight - 10,
      width: screenWidth - 10,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          title: const Text("Credential List"),
        ),
        body: FutureBuilder<List<dynamic>>(
            future: Future.wait(
              [_getHCPCredentials()],
            ),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Container(
                  height: 72,
                  width: screenWidth - 10,
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                //    debugPrint('line 321 ${snapshot.data!}');
                List<dynamic> listH = snapshot.data![0];
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // number of items in each row
                      mainAxisSpacing: 2.0, // spacing between rows
                      crossAxisSpacing: 2.0, // spacing between columns
                      childAspectRatio: (screenWidth / screenHeight),
                    ),
                    padding: EdgeInsets.all(2.0), // padding around the grid
                    restorationId: 'ClientCredentialsGridView',
                    itemCount: listH.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = listH[index];
                      return Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: color1,
                          border: Border.all(width: 3, color: color2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            Container(
                              height: 36,
                              width: screenWidth -10,
                              padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Id: ${item['credentialId']}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Code: ${getStringData(item['codeId'])}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 36,
                              width: screenWidth -10,
                              padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      'Desc: ${getStringData(item['credentialDescription'])}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                      flex: 1,
                                    child: Text(
                                      'Type: ${item['credentialType']}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 36,
                              width: screenWidth - 10,
                              padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                              child: Row(
                                children: [
                                  Text(
                                    'Expire?: ${utilityServices.convertDateFromUnknown(item['useExpirationDate'])}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Expiry: ${utilityServices.convertDateFromUnknown(item['credExpirationDate'])}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 24,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 13, 125, 103))),
                              child: ElevatedButton(
                                onPressed: () {
                                  Map<String, dynamic> cim = item;
                                  //  HCPCredential HCPCredential = snapshot.data[index];
                                  Map<String, dynamic> credentialItem = {
                                    'credentialId': cim['credentialId'],
                                    'codeId': cim['codeId'],
                                    'credentialDescription':
                                        cim['credentialDescription'],
                                    'credentialType': cim['credentialType'],
                                    'credAcquiredDate': cim['credAcquiredDate'],
                                    'credExpirationDate':
                                        cim['credExpirationDate'],
                                    'credVerifiedBy': cim['credVerifiedBy'],
                                    'employeeVerifiedDate':
                                        cim['employeeVerifiedDate'],
                                    'credPass': cim['credPass'],
                                    'credWarn': cim['credWarn'],
                                    'credWillFail': cim['credWillFail'],
                                    'credWillWarn': cim['credWillWarn'],
                                    'useExpirationDate':
                                        cim['useExpirationDate'],
                                    'credWillWarnDate':
                                        cim['credWillWarnDate'],
                                    'agencyRequired': cim['agencyRequired'],
                                    'yesNoLabel': cim['yesNoLabel'],
                                    'index': index
                                  };
                                  debugPrint('line 247: $credentialItem');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShowHCPCredentialDetailsScreen(
                                                  hcpCredential: credentialItem,
                                                  ctx: context)));
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "Display Credential Details",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
