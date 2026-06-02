import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/hcpapp/views/hcp_menu.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';

class ProcessHCPProfileAddressData extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessHCPProfileAddressData({super.key, required this.args});

  @override
  _ProcessHCPProfileAddressDataState createState() =>
      _ProcessHCPProfileAddressDataState();
}

class _ProcessHCPProfileAddressDataState
    extends State<ProcessHCPProfileAddressData> {
  var hcpAddress;
  AuthService authService = AuthService();
  HCPServices hcpServices = HCPServices();

  int? hcpId;

  Future<List<Map<String, dynamic>>> _getHCPAddress() async {
    try {
      List<Map<String, dynamic>>? lm =
          await hcpServices.getHCPAddresses(hcpId!);
      return lm!;
    } catch (e) {
      print('line 69 _getClientInvoice error: $e');
      rethrow;
      //rethrow
      //throw Exception('Error getting client invoices: $e');
    }
  }

  void getHCPUserX() async {
    await getHCPUser();
  }

  Future<Map<String, dynamic>> getHCPUser() async {
    print('line 38 gethcpuser address: $hcpServices');
    Map<String, dynamic> lm = await hcpServices.getHCPUser(hcpId!);
    if (lm.isEmpty) {
      return lm;
    }
    fullName = lm['legalName'];
    return lm;
  }

  String? fullName;
  Map<String, dynamic>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    hcpId = arguments!['hcpId'];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('line 51 ADDRESS  didchange');
    getHCPUserX();
  }

  DateFormat formatter = DateFormat('MM-dd-yyyy');
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;

  // ${getFormattedDate(widget.hcpCredential['credAcquiredData'])}'
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
    //   double screenHeight = MediaQuery.sizeOf(context).height;
    print('line 17 screen width: $screenWidth');
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color2,
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
        title: Text("HCP Address",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: Future.wait(
            [_getHCPAddress()],
          ),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              //    print('line 321 ${snapshot.data!}');
              List<dynamic> listH = snapshot.data![0];
              return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: listH.length,
                  itemBuilder: (BuildContext context, index) {
                    final item = listH[index];
                    return Center(
                      child: Container(
                        height: screenHeight! - 150,
                        width: 600,
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              width: 500,
                              color: Colors.green[200],
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 240,
                                    child: Text(
                                      'Id: ${item['addressId']}',
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    height: 40,
                                    width: 240,
                                    child: Text(
                                      'HCP Id: ${item['hcpId']}',
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 40,
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: 500,
                              color: Colors.grey[200],
                              child: Text(
                                'Type:  ${item['addressTypeDescription']}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 40,
                              width: 500,
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              color: Colors.grey[200],
                              child: Text(
                                'Adr1: ${item['address1'].toString()}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            item['address2'] == null
                                ? SizedBox.shrink()
                                : Column(
                                    children: [
                                      SizedBox(height: 6),
                                      Container(
                                        height: 40,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        width: 500,
                                        color: Colors.grey[200],
                                        child: Text(
                                          'Adr2: ${item['address2'].toString()}',
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(height: 8),
                            Container(
                              height: 40,
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: 500,
                              color: Colors.grey[200],
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 240,
                                    child: Text(
                                      'City: ${item['city'].toString()}',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    height: 40,
                                    width: 240,
                                    child: Text(
                                      'County: ${item['county'].toString()}',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 40,
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: 500,
                              color: Colors.grey[200],
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 240,
                                    child: Text(
                                      'State: ${item['state'].toString()}',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Container(
                                    height: 40,
                                    width: 240,
                                    child: Text(
                                      'Zip: : ${item['zip']}',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 40,
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: 500,
                              color: Colors.grey[200],
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 240,
                                    child: Text(
                                      'latitude: ${item['latitude'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    height: 40,
                                    width: 240,
                                    child: Text(
                                      'Longitude: : ${item['longitude'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 40,
                              width: 250,
                              child: ElevatedButton(
                                onPressed: () {
                                  final navigator = Navigator.of(context)
                                      .pushNamed(hcpMenu,
                                          arguments: arguments!);
                                },
                                child: Text(
                                  'Exit',
                                  style: TextStyle(
                                    color: color2,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}

class VerticalSplitView extends StatefulWidget {
  final Widget left;
  final Widget right;
  final double ratio;

  const VerticalSplitView(
      {Key? key, required this.left, required this.right, this.ratio = 0.5});

  @override
  _VerticalSplitViewState createState() => _VerticalSplitViewState();
}

class _VerticalSplitViewState extends State<VerticalSplitView> {
  final _dividerWidth = 16.0;

  double? _ratio;
  double? _maxWidth;

  get _width1 => _ratio! * _maxWidth!;

  get _width2 => (1 - _ratio!) * _maxWidth!;

  @override
  void initState() {
    super.initState();

    _ratio = widget.ratio;
    _ratio = .25;
    print('line 99: $_ratio');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      if (_maxWidth == null) _maxWidth = constraints.maxWidth - _dividerWidth;
      if (_maxWidth != constraints.maxWidth) {
        _maxWidth = constraints.maxWidth - _dividerWidth;
      }

      return SizedBox(
        width: constraints.maxWidth,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: _width1,
              child: widget.left,
            ),
            SizedBox(
              width: _width2,
              child: widget.right,
            ),
          ],
        ),
      );
    });
  }
}
