//Client Contact Profile Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/clientapp//models/client_user.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ClientCreditProfilePage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientCreditProfilePage({super.key, required this.args});

  @override
  State<ClientCreditProfilePage> createState() =>
      _ClientCreditProfilePageState();
}

class _ClientCreditProfilePageState extends State<ClientCreditProfilePage> {
  late dynamic currentUser;

  late int? clientId;
  ClientUser? clientUser;
  Map<String, dynamic>? clientCredit;

  ClientServices clientServices = ClientServices();

  String? email;

  @override
  void dispose() {
    super.dispose();
  }

  Future<Map<String, dynamic>> _getClientCredit() async {
    try {
      debugPrint('line 46 $clientId');
      if (clientId == null) {
        return {};
      }
      Map<String, dynamic> ccl =
          await clientServices.getClientCredit(clientId!);
      clientCredit = ccl['clientCredit'];
      totalCurrentBalance = ccl['totalCurrentBalance'];
      agingData = ccl['agingData'];
      return clientCredit!;
    } catch (e) {
      debugPrint('line 52 error: $e');
      throw Exception('line 53 error: $e');
    }
  }

  List<Map<String, dynamic>>? agingData;
  Map<String, dynamic>? arguments;

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    // clientUser = ref.read(clientUserNotifierProvider.notifier).fromClientUser;
    clientId = arguments!['clientId'];
    // try {
    //   setUpAsyncVariables(clientId!,context,clw,htc);
    //   debugPrint('ine 49: $clientId');
    // } catch(e) {
    //   debugPrint('line 133 error: $e');
    //
    // }
  }

  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double totalCurrentBalance = 0.0;
  double h = 1.0;
  double fontSize = 16;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    double? hh = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    h = hh!;
    if (h < 1.0) {
      h = 1.0;
    }
    fontSize = 16;
    fontSize /= h;
    debugPrint('line 75 in showaccepted ashifts');
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: Text("Client Credit",
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
                  .pushNamed(clientMenu, arguments: arguments!);
            },
          ),
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: Future.wait(
            [_getClientCredit()],
          ),
          builder: (context, snapshot) {
            debugPrint(
                'line 129: ${snapshot.data}  ${snapshot.connectionState} ${snapshot.hasData}');
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
                          fontSize: fontSize,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else if (snapshot.data == [[]] &&
                snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Container(
                  height: 100,
                  width: screenWidth - 10,
                  child: Text('There are no credit data for this client.',
                      style: TextStyle(
                          fontSize: fontSize,
                          color: color2,
                          fontWeight: FontWeight.bold)),
                ),
              );
            } else {
              dynamic ccl = snapshot.data[0]; // cast to List<Marker>
              debugPrint('line 147: $ccl');
              if (ccl == null) {
                return Center(
                  child: Container(
                    height: 100,
                    child: Text('There are no credit data for this client',
                        style: TextStyle(
                            fontSize: fontSize,
                            color: color2,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Container(
                      height: 28,
                      width: screenWidth - 10,
                      child: Center(
                        child: Text(
                          'Limit: ${ccl['creditLimit'].toStringAsFixed(2)}',
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
                      height: 28,
                      child: Text(
                        'Total Current Balance: ${totalCurrentBalance}',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        height: 28,
                        child: Center(
                            child: Text(
                          'Balance Aging Data',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                    SizedBox(height: 5),
                    Container(
                        height: 28,
                        child: Center(
                            child: Text(
                          '${agingData![0]['label']} : ${agingData![0]['balance']}',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                    SizedBox(height: 5),
                    Container(
                        height: 28,
                        child: Center(
                            child: Text(
                          '${agingData![1]['label']} : ${agingData![1]['balance']}',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                    SizedBox(height: 5),
                    Container(
                        height: 28,
                        child: Center(
                            child: Text(
                          '${agingData![2]['label']} : ${agingData![2]['balance']}',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                    SizedBox(height: 5),
                    Container(
                        height: 28,
                        child: Center(
                            child: Text(
                          '${agingData![3]['label']} : ${agingData![3]['balance']}',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                    SizedBox(height: 5),
                    Container(
                        height: 28,
                        child: Center(
                            child: Text(
                          '${agingData![4]['label']} : ${agingData![4]['balance']}',
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                  ],
                );
              }
            }
          }),
    );
  }
}
