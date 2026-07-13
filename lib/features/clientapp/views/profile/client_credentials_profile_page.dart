import 'package:cms_web/features/shared/utils/dropdown_codes.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cms_web/features/shared//widgets/show_hcp_document_pdf.dart';
import 'package:cms_web/features/shared/widgets/show_hcp_document_img.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_timecard_service.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'dart:typed_data';

final DropDownCodes dropDownCodes = DropDownCodes();

String globalBranchName = '';

class ProcessClientHCPDocumentation extends StatefulWidget {
  final Map<String, String> args;
  const ProcessClientHCPDocumentation({super.key,required this.args});

  @override
  ProcessClientHCPDocumentationState createState() =>
      ProcessClientHCPDocumentationState();
}

class ProcessClientHCPDocumentationState
    extends State<ProcessClientHCPDocumentation> {

  final DropDownCodes dropDownCodes = DropDownCodes();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? clientId;

  Map<String, dynamic>? currentUser;
  Map<String, dynamic>? clientUser;
  HCPServices hcpServices = HCPServices();
  HCPTimeCardService hcpTimecardService = HCPTimeCardService();
  AuthService authService = AuthService();
  dynamic listDocuments;
  String selectedValue = '';
  String selectedValueDoc = '';
  dynamic selectedValueHCP = null;
  int selectedHCPId = -1;
  List<dynamic>? listHcps;
  dynamic selectedValueCredentialCategory;
  int selectedCredentialCodeId = -1;
  late Future<List<String>> futureHCPS;
  late List<String> hcpDocumentationCategories;
  late Future<List<String>> fhcpDocumentationCategories;
  bool _hasDocuments = false;
  Future<List<dynamic>>? listHCPs;
  List<dynamic> listD = []; //snapshot.data![2];
  String selectedItem = '';
  late int hcpId;
  late String hcpName;
  late String userEmail;
  List<dynamic> listOfCredentials = [];
  List<dynamic> listOfCredentialCategories = [];

  Future<List<dynamic>> _getCredentialCategories() async {
    debugPrint('line 61 get credentials categories list');
    listOfCredentialCategories =
    await dropDownCodes.getHCPDocumentationCategories();
    List<dynamic> lst = [];
    for (int i = 0; i < listOfCredentialCategories.length; i++) {
      // debugPrint('line 66 ${listOfCredentialCategories[i]}');
      lst.add(listOfCredentialCategories[i]['description']);
    }
    return lst;
  }

  Future<void> _getHCPDocument(context) async {
    try {
      debugPrint('line 72 gethcpdocs: $selectedHCPId ');
      if (selectedHCPId == -1 || selectedHCPId == 0) {
        return;
      }
      dynamic obj = await hcpServices.getHCPDocuments(
          selectedHCPId, selectedCredentialCodeId);

      debugPrint('line 79 $obj');
      if (obj == null) {
        _showDialog(
            context, "Credentials", "No Credential $selectedCredentialCodeId");
        return;
      }
      Uint8List imageData = obj['imageData'];
      String route = obj['route'];
      if (imageData.isEmpty) {
        await _showDialog(context, "No Data",
            "The requested document does not exist for the current professional");
        Navigator.pop(context);
      }
      debugPrint('line 58 get docs:$route ${imageData.length}');
      if (route == 'image') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowHCPDocumentImage(imageData: imageData),
            ));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowHCPDocumentPDF(imageData: imageData),
            ));
      }
      _hasDocuments = true;
      return;
    } catch (e) {
      debugPrint('line 98 gethcps error: $e');
      throw Exception('line 67 error gethcps: $e');
    }
  }

  List<dynamic> listOfHcps = [];

  Future<List<dynamic>> _getHCPs(context) async {
    debugPrint('line 104 ethcps: $clientId');

    try {

      List<Map<String, dynamic>>? lst =
      await hcpTimecardService.getHCPs(clientId!);
      //  selectedValueHCP = lst[0]['id'];
      if (lst!.isEmpty) {
        await _showDialog(context, "No Data",
            "There are no HC Professionals scheduled for today");
        Navigator.pop(context);
        return [];
      }
      List<int> dups = [];
      int i = 0;
      while (i < lst.length) {
        if (dups.indexOf(int.parse(lst[i]['hcpId'].toString())) != -1) {
          lst.removeAt(i);
          i = 0;
          continue;
        }
        dups.add(lst[i]['hcpId']);
        i += 1;
      }
      debugPrint('line 127: ${lst.length}');
      //  selectedValueHCP = lst[0]['hcpName'];
      //  selectedHCPId = int.parse(lst[0]['hcpId'].toString());

      List<dynamic> listx = [];
      listOfHcps = lst;
      for (int i = 0; i < lst.length; i++) {
        listx.add(lst[i]['hcpName']);
      }
      hasHCPData = true;
      return listx;
    } catch (e) {
      debugPrint('line 152 gethcps docs error: $e');
      throw Exception('line 131 error gethcps: $e');
    }
  }

  int getHcpId(dynamic itm) {
    debugPrint('line 160: $itm');
    int hcpId = -1;
    for (int i = 0; i < listOfHcps.length; i++) {
      debugPrint(
          'line 164: ${listOfHcps[i]['hcpName']} ${listOfHcps[i]['hcpId']} $itm');
      if (itm == listOfHcps[i]['hcpName']) {
        hcpId = listOfHcps[i]['hcpId'];
        break;
      }
    }
    return hcpId;
  }

  TextEditingController editingController = TextEditingController();

  Future<void> _showDialog(
      BuildContext context, String title, String? description) async {
    debugPrint('line 12 showdialog');
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.of(context).pop(); // Close the dialog
    // });
    await showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          title: Text(title),
          content: Text(description!),
          contentTextStyle: TextStyle(
            color: color2,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
          titleTextStyle: TextStyle(
              color: color2,
              fontSize: fontSize,
              fontWeight: FontWeight.bold),
          actions: <Widget>[
            // TextButton(
            //   onPressed: () => Navigator.pop(context, 'Cancel'),
            //   child: const Text('Cancel'),
            // ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'OK'),
              child: Text(
                'OK',
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: color2),
              ),
            )
          ],
        ));
    return;
  }
  Map<String,String>? arguments;
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    clientId = int.parse(arguments!['clientId'].toString());
    //  clientId = ref.read(clientUserNotifierProvider.notifier).fromClientId;
    currentUser = authService.currentUser;
    clientUser = currentUser;
    userEmail = currentUser!['email'];
  }

  bool hasHCPData = false;

  int _getDocumentCodeId(dynamic value) {
    int codeId = 0;
    for (int j = 0; j < listOfCredentialCategories.length; j++) {
      debugPrint('line 407 $j ${listOfCredentialCategories[j]['codeId']}');
      if (value == listOfCredentialCategories[j]['description']) {
        codeId = listOfCredentialCategories[j]['codeId'];
        break;
      }
    }
    return codeId;
  }

  dynamic holdSelectedHCP = null;
  int holdSelectedHCPid = 0;

  List<dynamic> selectedItems = [];
  bool value = false;
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 16;
  double? smallFontSize;

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
    smallFontSize = 14 / h;
    debugPrint('line 136');
    return SafeArea(
      child: Scaffold(
        backgroundColor: color1,
        appBar: AppBar(
          leading: null,
          backgroundColor: color2,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  //getMessageStream();
                  Navigator.pop(context);
                }),
          ],
          title: Text("HCP Credentials",
              style: TextStyle(
                fontSize:
                Theme.of(context).textTheme.headlineSmall!.fontSize! / h,
              )),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    height: 32,
                    width: screenWidth! - 10,
                    child: Center(
                      child: Text(
                        'Select HC Professional',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: getHCPDataList(),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 32,
                    width: screenWidth! - 10,
                    child: Center(
                      child: Text(
                        'Select HC Professional',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: getCredentialCategoriesList(),
                  ),
                  const SizedBox(height: 20),
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 240,
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: color1,
                            border: Border.all(width: 3, color: color2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                //onPressed for button 1
                                debugPrint('line 367:  $selectedItems');
                                _getHCPDocument(context);
                              },
                              child: Text('Get Documentation',
                                  style: TextStyle(
                                      fontSize: fontSize, color: Colors.black87
                                    //   backgroundColor: color2,
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCredentialCategoriesList() {
    // if (selectedValueHCP == null) {
    return FutureBuilder(
      future: Future.wait(
        [_getCredentialCategories()],
      ),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        debugPrint(
            'line 324 building FB  ${snapshot.hasData} ${snapshot.connectionState}');
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 50,
              width: 50,
              child: Center(child: CircularProgressIndicator()));
        }
        debugPrint('line 332: ${snapshot.data} ${snapshot.data![0]}');
        List<dynamic> listD = snapshot.data![0];
        return Container(
          height: 50,
          child: DropdownButtonHideUnderline(
            child: Container(
              height: 50,
              width: screenWidth! - 8,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.black87),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButton2<dynamic>(
                isExpanded: true,
                hint: Text(
                  'Select Credential Category',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                items: listD
                    .map(
                      (dynamic item) => DropdownItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                          fontSize: smallFontSize, color: Colors.black87),
                    ),
                  ),
                )
                    .toList(),
                valueListenable: selectedValueCredentialCategory,
                onChanged: (dynamic value) {
                  setState(() {
                    selectedValueCredentialCategory = value!;
                    selectedCredentialCodeId = _getDocumentCodeId(value);
                    //  });
                  });
                },
              ),
            ),
          ),
        );
      },
    );
    // } else {
    //   return Container();
    // }
  }

  Widget getHCPDataList() {
    return FutureBuilder(
      // future: Future.wait([
      //   futureHCPS,
      //   hcpDocumentationCategories
      // ]),
        future: Future.wait(
          [_getHCPs(context)],
        ),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          debugPrint(
              'line 398 building FB  ${snapshot.hasData} ${snapshot.connectionState}');
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator()));
          } else {
            debugPrint('line 406: ${snapshot.data} ${snapshot.data![0]}');
            //   debugPrint('line 165: ${snapshot.data![1]}');
            //  debugPrint('line 201: ${snapshot.data![2]}');
            List<dynamic> listH = snapshot.data![0];
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Container(
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      height: 50,
                      width: screenWidth! - 8,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(12)),
                      child: DropdownButton2<dynamic>(
                        isExpanded: true,
                        hint: Text(
                          'Select HC Professional',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: listH
                            .map(
                              (dynamic item) => DropdownItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                            .toList(),
                        valueListenable: selectedValueHCP,
                        onChanged: (dynamic value) {
                          debugPrint('line 349: $value');
                          setState(() {
                            selectedValueHCP = value!;
                            selectedHCPId = getHcpId(value);
                            //         debugPrint('line 454: $selectedValueHCP $selectedHCPId');
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }
}

//ignore: must_be_immutable
class _CheckBoxWidget extends StatefulWidget {
  final Widget child;
  bool? isSelected;
  ValueChanged<bool?>? onChanged;

  _CheckBoxWidget({required this.child});

  @override
  CheckBoxState createState() => CheckBoxState();
}

class CheckBoxState extends State<_CheckBoxWidget> {
  bool? isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant _CheckBoxWidget oldWidget) {
    if (widget.isSelected != isSelected) isSelected = widget.isSelected;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0x88F44336),
            Colors.blue,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Select: '),
              Checkbox(
                  value: isSelected,
                  tristate: true,
                  onChanged: (bool? v) {
                    v ??= false;
                    setState(() {
                      isSelected = v;
                      if (widget.onChanged != null) widget.onChanged!(v);
                    });
                  }),
            ],
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
