import 'package:flutter/material.dart';
//import 'package:hcp_app/pages/home/home.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/hcpapp/services/hcp_user_services.dart';
import 'package:cms_web/features/hcpapp/services/hcp_services.dart';
import 'package:cms_web/features/hcpapp/views/hcp_menu.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ProcessHCPProfileEducationData extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessHCPProfileEducationData({super.key, required this.args});

  @override
  State<ProcessHCPProfileEducationData> createState() =>
      _ProcessHCPProfileEducationDataState();
}

class _ProcessHCPProfileEducationDataState
    extends State<ProcessHCPProfileEducationData> {
  _ProcessHCPProfileEducationDataState();
  var hcpContact;
  bool hasData = false;
  dynamic currentUser;
  Users? user;
  String? email;
  Map<String, dynamic>? hcpUser;
  AuthService authService = AuthService();
  HCPUserServices hcpUserServices = HCPUserServices();
  HCPServices hcpServices = HCPServices();

  int? hcpId;

  Future<List<Map<String, dynamic>>> _getHCPProfileEducationData(
      BuildContext context) async {
    print('line 33 in _getHCPEducation Date');
    try {
      List<Map<String, dynamic>>? list =
          await hcpServices.getHCPEducation(hcpId!);
      if (list!.length > 0) {
        for (int i = 0; i < list.length; i++) {
          Map<String, dynamic> obj = list[i];
          obj['city'] ?? 'NP';
          obj['state'] ?? 'NP';
          obj['zip'] ?? 'NP';
          obj['address1'] ?? 'NP';
          print('line 49 $obj');
          obj['graduationDate'] = DateTime.tryParse(obj['graduationDate']);
          list[i] = obj;
        }
      }
      return list;
    } catch (e) {
      print('line 69 error gettin contacts: $e');
      throw Exception(e.toString());
    }
  }

  String? fullName;
  Future<Map<String, dynamic>> getHCPUser() async {
    Map<String, dynamic> lm = await hcpUserServices.getHCPUser(hcpId!);
    hcpId = lm['hcpId'];
    fullName = lm['legalName'];
    return lm;
  }

  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    hcpId = arguments!['hcpId'];
    print('line 66 initstate: $hcpId');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('line 63 didchange');

    getHCPUser();
    ;
  }

  DateFormat formatter = DateFormat('yyyy/MM/dd');
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;

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
    double smallFontSize = 16;
    smallFontSize /= h;
    return Scaffold(
      appBar: AppBar(
        title: Text("HCP Profile Education",
            style: TextStyle(
              fontSize: fontSize,
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
            // final navigator = Navigator.of(context);
            // navigator.pushReplacement(
            //     MaterialPageRoute(builder: (BuildContext context) {
            //   return HCPMenu();
            // }));
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       try {
        //         final navigator = Navigator.of(context);
        //         navigator.pushReplacement(
        //             MaterialPageRoute(builder: (BuildContext context) {
        //               return Home();
        //             }));
        //       } catch (error) {
        //         print("Error during logout ${error}");
        //         throw Exception('Error logging out. ${error.toString()}');
        //       }
        //     },
        //     icon: const Icon(
        //       Icons.close,
        //       size: 30,
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40,
              width: screenWidth! - 10,
              child: Center(
                child: Text(
                  'Profile Education Information',
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 700,
              width: screenWidth! - 10,
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait([_getHCPProfileEducationData(context)]),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(
                          height: 50,
                          width: 50,
                          child: const CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<dynamic> data = snapshot.data![0];
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, index) {
                        final item = data[index];
                        return Container(
                          height: 350,
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 5),
                          width: screenWidth! - 10,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.black87),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                  height: 30,
                                  width: screenWidth! - 10,
                                  child: Row(
                                    children: [
                                      Text(
                                        'hcpId: : ${item['hcpId']}',
                                        style: TextStyle(
                                          fontSize: smallFontSize,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Name: $fullName',
                                        style: TextStyle(
                                          fontSize: smallFontSize,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )),

                              const SizedBox(height: 10),
                              Container(
                                height: 30,
                                width: screenWidth! - 10,
                                child: Text(
                                  'School: ${item['schoolName']}',
                                  style: TextStyle(
                                    fontSize: smallFontSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // SizedBox(height: 10),
                              // Container(
                              //   height: 30,
                              //   width: screenWidth! - 10,
                              //   child:
                              //       Text(
                              //         'Address: ${item['address1']}',
                              //         style: const TextStyle(
                              //           fontSize: 16,
                              //           color: Colors.black,
                              //           fontWeight: FontWeight.bold,
                              //
                              //         ),
                              //       ),
                              // ),
                              //  SizedBox(height:10),
                              // Container(
                              //   height: 30,
                              //   width: screenWidth! - 10,
                              //   child:
                              //   Text(
                              //    'Loc: ${item[index]['city']} ${item['state']} ${item[index]['zip']}',
                              //
                              //     style: const TextStyle(
                              //       fontSize: 16,
                              //       color: Colors.black,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: 10),
                              Container(
                                height: 30,
                                width: screenWidth! - 10,
                                child: Text(
                                  'Degree: ${item['degree']}',
                                  style: TextStyle(
                                    fontSize: smallFontSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 30,
                                width: screenWidth! - 10,
                                child: Row(
                                  children: [
                                    Text(
                                      'Major: ${item['major']}',
                                      style: TextStyle(
                                        fontSize: smallFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Graduated:  ${formatter.format(item['graduationDate'])}',
                                      style: TextStyle(
                                        fontSize: smallFontSize,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
