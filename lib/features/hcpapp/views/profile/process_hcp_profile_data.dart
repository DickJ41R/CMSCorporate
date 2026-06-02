//import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cms_web/features/hcpapp/models/users.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:cms_web/features/shared/services/hcpapp/hcp_services.dart';
import 'package:cms_web/features/hcpapp/views/hcp_menu.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';

class ProcessHCPProfileData extends StatefulWidget {
  final Map<String, dynamic> args;
  const ProcessHCPProfileData({super.key, required this.args});

  @override
  _ProcessHCPProfileDataState createState() => _ProcessHCPProfileDataState();
}

final _formKey = GlobalKey<FormState>();

class _ProcessHCPProfileDataState extends State<ProcessHCPProfileData> {
  var hcpAddress;
  AuthService authService = AuthService();
  HCPServices hcpServices = HCPServices();
  UtilitiesServices utilitiesServices = UtilitiesServices();

  int? hcpId;
  Map<String, dynamic>? hcpMap;
  Future<void> _getHCProfessional() async {
    print('line 32 in getHcpProfesssional $hcpId');
    try {
      print('line 34 in get hcp professionals');
      Map<String, dynamic>? lm =
          await hcpServices.getHCProfessionalByHCPId(hcpId!);
      print('line 37: $lm');
      hcpMap = lm!;
      setControllerData();
      return;
    } catch (e) {
      print('line 39 _getHCProfessional error: $e');
      throw Exception('Error hcp profile data: $e');
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
    _getHCProfessional();
  }

  void setControllerData() {
    print('line 72 in setcontroller data ${hcpMap}');
    try {
      allowDailyPayController.text =
          hcpMap!['allowDailyPay'] == true ? 'Yes' : 'No';
      birthDateController.text =
          utilitiesServices.convertDateFromUnknown(hcpMap!['birthDate']);

      branchNameController.text = hcpMap!['branchName'];
      coordinatorController.text = hcpMap!['coordinator'];
      createdDateController.text =
          utilitiesServices.convertDateFromUnknown(hcpMap!['createdDate']);

      credsWillWarnController.text =
          hcpMap!['credsWillWarn'] == true ? 'Yes' : 'No';

      credsWillWarnDateController.text = utilitiesServices
          .convertDateFromUnknown(hcpMap!['credsWillWarnDate']);
      defaultCheckTypeController.text = hcpMap!['defaultCheckType'];
      disciplineController.text = hcpMap!['disciplineName'];
      emailController.text = hcpMap!['email'];
      employeeIdController.text = hcpMap!['employeeId'];
      firstNameController.text = hcpMap!['firstName'];

      firstWorkedController.text =
          utilitiesServices.convertDateFromUnknown(hcpMap!['firstWorked']);
      genderController.text = hcpMap!['genderCodeDescription'];
      isEmployeeController.text = hcpMap!['isEmployee'] == true ? 'Yes' : 'No';
      lastNameController.text = hcpMap!['lastName'];
      hcpIdController.text = hcpMap!['hcpId'].toString();
      lastWorkedController.text =
          utilitiesServices.convertDateFromUnknown(hcpMap!['lastWorked']);
      print('line 101 check');
      payCheckFullAddressController.text = hcpMap!['paycheckFullAddress'];
      ssnController.text = hcpMap!['SSN'];
      statusController.text = hcpMap!['status'];
      print('line 105 check');
      usernameController.text = hcpMap!['username'];
      workerTypeController.text = hcpMap!['workerType'];
    } catch (e) {
      print('line 107 error: ${e.toString()}');
      throw Exception('line 108 error: ${e.toString()}');
    }
  }

  //editing controllers
  TextEditingController allowDailyPayController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController coordinatorController = TextEditingController();
  TextEditingController createdDateController = TextEditingController();
  TextEditingController credsWillWarnController = TextEditingController();
  TextEditingController credsWillWarnDateController = TextEditingController();
  TextEditingController defaultCheckTypeController = TextEditingController();
  TextEditingController disciplineController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController firstWorkedController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController isEmployeeController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController hcpIdController = TextEditingController();
  TextEditingController lastWorkedController = TextEditingController();
  TextEditingController payCheckFullAddressController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController ssnController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController workerTypeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    allowDailyPayController.dispose();
    birthDateController.dispose();
    branchNameController.dispose();
    coordinatorController.dispose();
    createdDateController.dispose();
    credsWillWarnController.dispose();
    credsWillWarnDateController.dispose();
    defaultCheckTypeController.dispose();
    disciplineController.dispose();
    emailController.dispose();
    employeeIdController.dispose();
    firstNameController.dispose();
    firstWorkedController.dispose();
    genderController.dispose();
    isEmployeeController.dispose();
    lastNameController.dispose();
    hcpIdController.dispose();
    lastWorkedController.dispose();
    payCheckFullAddressController.dispose();
    ssnController.dispose();
    statusController.dispose();
    usernameController.dispose();
    workerTypeController.dispose();
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
        title: Text("HCP Profile Data",
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! / h,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            height: screenHeight! - 150,
            width: 600,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 36,
                      width: 250,
                      child: TextFormField(
                        controller: hcpIdController,
                        decoration: InputDecoration(label: Text('HCP Id')),
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      height: 36,
                      width: 250,
                      child: TextFormField(
                        controller: ssnController,
                        decoration: InputDecoration(label: Text('SSN')),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(children: [
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(label: Text('First Name')),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(label: Text('Last Name')),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: statusController,
                      decoration: InputDecoration(label: Text('Status')),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(label: Text('User Name')),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: branchNameController,
                      decoration: InputDecoration(label: Text('Branch Name')),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: coordinatorController,
                      decoration: InputDecoration(label: Text('Coordinator')),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: createdDateController,
                      decoration: InputDecoration(label: Text('Created Date')),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: birthDateController,
                      decoration: InputDecoration(label: Text('Birth Date')),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: firstWorkedController,
                      decoration: InputDecoration(label: Text('First Worked')),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: lastWorkedController,
                      decoration: InputDecoration(label: Text('Last Worked')),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: credsWillWarnController,
                      decoration:
                          InputDecoration(label: Text('Warn on Credentials')),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: credsWillWarnDateController,
                      decoration:
                          InputDecoration(label: Text('Credentials Warn Date')),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: disciplineController,
                      decoration: InputDecoration(label: Text('Discipline')),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: genderController,
                      decoration: InputDecoration(label: Text('Gender')),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(label: Text('Email')),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: defaultCheckTypeController,
                      decoration:
                          InputDecoration(label: Text('Default Check Type')),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: allowDailyPayController,
                      decoration:
                          InputDecoration(label: Text('Allow Daily Pay')),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: isEmployeeController,
                      decoration: InputDecoration(label: Text('Employee?')),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: employeeIdController,
                      decoration: InputDecoration(label: Text('Employee Id')),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 40,
                    width: 250,
                    child: TextFormField(
                      controller: workerTypeController,
                      decoration: InputDecoration(label: Text('Worker Type')),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Container(
                  height: 40,
                  width: 600,
                  child: TextFormField(
                    maxLines: 5,
                    controller: payCheckFullAddressController,
                    decoration:
                        InputDecoration(label: Text('Paycheck FUll Address')),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 40,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      final navigator = Navigator.of(context)
                          .pushNamed(hcpMenu, arguments: arguments!);
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
        ),
      ),
    );
  }
}
