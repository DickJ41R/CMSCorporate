//Client User Profile Page
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
import 'package:cms_web/features/shared/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_multi_selector/DialogBox/multi_selector_dialog_field.dart';
// import 'package:flutter_multi_selector/Utils/multi_selector_item.dart';
import 'package:cms_web/features/authentication/services/auth_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'dart:math';

class Role {
  final String role;
  final int id;
  bool isselected;
  Role({required this.role, required this.id, required this.isselected});
  set selected(bool value) => isselected = value;
}

class Discipline {
  final String disciplineName;
  final int disciplineId;
  bool isselected;
  Discipline(
      {required this.disciplineName,
        required this.disciplineId,
        required this.isselected});
  set selected(bool value) => isselected = value;
}

class ClientUserProfilePage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientUserProfilePage({super.key, required this.args});

  @override
  State<ClientUserProfilePage> createState() => _ClientUserProfilePageState();
}

class _ClientUserProfilePageState extends State<ClientUserProfilePage> {
  GlobalKey<FormState> formKey = GlobalKey();
  String? documentId;

  UtilitiesServices utilityServices = UtilitiesServices();
  Map<String, dynamic>? gclu;
  Map<String, dynamic>? arguments;
  List<Map<String, dynamic>> listOfClientUsers = [];
  List<Map<String, dynamic>>? menuClientUsers;
  List<DropdownMenuEntry<dynamic>> dropDownMenuEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownMenuOptionEntries = [];
  // List<DropdownItem<Role>>? selectedItems;
  // List<DropdownItem<Discipline>>? selectedDisciplineItems;
  Map<String, dynamic>? client;
  List<String> listOfClientUserItems = [];
  ClientServices clientServices = ClientServices();
  AuthService authService = AuthService();

  Future<List<String>> _getClientUserMenuData() async {
    print('line 30 get client user Dropdownitems ${listOfClientUsers.length}');
    dropDownMenuEntries = [];
    menuClientUsers = [];
    listOfClientUserItems = [];
    try {
      if (listOfClientUsers.length == 0) {
        client = await clientServices.getClient(arguments!['clientId']);
        listOfClientUsers = await clientServices.getClientUsers(arguments!['clientId']);
      }
      int largestId = -1;
      listOfClientUserItems.add('Add New Client User');
      print('line 35: ${listOfClientUsers.length}');
      for (int i = 0; i < listOfClientUsers.length; i++) {
        Map<String, dynamic> clu = listOfClientUsers[i];
        gclu = clu;
        if (clu['clientUserId'] > largestId) {
          largestId = clu['clientUserId'];
        }
        Map<String, dynamic> mclu = {
          'clientUserId': clu['clientUserId'].toString(),
          'fullName': clu['fullName']
        };
        print('line 65: $mclu');
        DropdownMenuEntry me = DropdownMenuEntry(
            value: mclu['clientUserId'], label: mclu['fullName']);
        dropDownMenuEntries.add(me);
        menuClientUsers!.add(mclu);
        String st =
            '(' + clu['clientUserId'].toString() + ') ' + clu['fullName'];
        listOfClientUserItems.add(st);
      }
      if (largestId == -1) {
        nextId = 1;
      } else {
        nextId = largestId + 1;
      }
      print('line 80: $nextId $largestId ${dropDownMenuEntries}');

      return listOfClientUserItems;
    } catch (e) {
      print('line 91: error: ${e.toString()}');
      throw Exception('line 21 error getting dropdown menu items');
    }
  }

  String localTitle = 'Client Users';

  //controllers
  TextEditingController clientUserIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController activeController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController loginCounterController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController dateLastLoggedInController = TextEditingController();
  TextEditingController ssnController = TextEditingController();
  TextEditingController isAdministratorController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController telephoneExtensionController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    clientUserIdController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    fullNameController.dispose();
    activeController.dispose();
    displayNameController.dispose();
    emailController.dispose();
    loginCounterController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    dateLastLoggedInController.dispose();
    menuController.dispose();
    ssnController.dispose();
    isAdministratorController.dispose();
    telephoneController.dispose();
    telephoneExtensionController.dispose();
    departmentController.dispose();
    //myFocusNode.dispose();
  }

  String? currentPassword;
  var listOfDisciplines = [
    {'disciplineName': "CNA", "disciplineId": 558},
    {'disciplineName': "LPN", "disciplineId": 559},
    {'disciplineName': "RN", "disciplineId": 560},
    {'disciplineName': "Other", "disciplineId": 900},
  ];
  List<String> listDisciplines = ['CNA', 'LPN', 'RN', 'Other'];
  List<Map<String, dynamic>> listOfRoles = [
    {"role": "ClientAdmin", "id": 1},
    {"role": "ClientDON", "id": 2},
    {"role": "ClientADON", "id": 3},
    {"role": "ClientScheduler", "id": 4},
    {"role": "ClientSupervisor", "id": 5},
    {"role": "ClientStaff", "id": 6},
    {"role": "ClientAccount", "id": 7},
    {"role": "ClientManager", "id": 8},
  ];
  List<String> listRoles = [
    'Admin',
    'DON',
    'ADON',
    'Scheduler',
    'Supervisor',
    'Staff',
    'Account',
    'Manager'
  ];

  int clientUserIndex = -1;
  dynamic selectedValueClientUser;
  int? selectedClientUserIndex;

  int _getClientUserId(dynamic val) {
    print('line 183: $val');
    int clientUserIndex = -1;
    int idx = val.indexOf(')');
    if (idx == -1) {
      return -1;
    }
    idx += 1;
    String fn = val.substring(idx).trim();
    for (int i = 0; i < listOfClientUsers.length; i++) {
      Map<String, dynamic> clut = listOfClientUsers[i];
      if (fn == clut['fullName']) {
        selectedClientUserIndex = i;
        break;
      }
    }
    print('line 198: $selectedClientUserIndex');
    if (selectedClientUserIndex! != -1) {
      setState(() {
        clientUserIdController.text =
            listOfClientUsers[selectedClientUserIndex!]['clientUserId']
                .toString();
      });
    }
    return selectedClientUserIndex!;
  }

  int? selectedClientUser;
  bool checkForm(List<String> lr, List<String> ld) {
    if (lr.length == 0) {
      return false;
    }
    if (ld.length == 0) {
      return false;
    }
    final form = formKey.currentState!;
    if (form.validate()) {
      print('line 219 form validated');
      return true;
    }
    print('line 222 form did not validate');
    return false;
  }

  Future<void> _submit() async {
    print(
        'line 202 in submit: $roleMultiValueListenable $disciplineMultiValueListenable');
    bool bl = false;
    List<String> lRoles = roleMultiValueListenable.value;
    List<String> lDisciplines = disciplineMultiValueListenable.value;
    print('line 230: $lRoles $lDisciplines ');

    bl = checkForm(lRoles, lDisciplines);
    print('line 235: $bl');
    if (bl == false) {
      return;
    }
    //regex email
    // final bool emailValid = RegExp(
    //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(email);
    String? bls;
    String? title;

    try {
      print('line 221 $currentPassword');

      List<String> disciplineNames = [];
      List<int> disciplineIds = [];
      for (int i = 0; i < lDisciplines.length; i++) {
        String disciplineName = lDisciplines[i];
        for (int j = 0; j < listOfDisciplines.length; j++) {
          Map<String, dynamic> tb = listOfDisciplines[j];
          if (tb['disciplineName'] == disciplineName) {
            disciplineNames.add(disciplineName);
            disciplineIds.add(tb['disciplineId']);
            break;
          }
        }
      }
      List<String> roles = [];
      for (int i = 0; i < lRoles.length; i++) {
        for (int j = 0; j < listRoles.length; j++) {
          if (lRoles[i] == listRoles[j]) {
            String srle = listOfRoles[j]['role'];
            roles.add(srle);
            break;
          }
        }
      }
      print('line 272: $roles');
      String? bls;
      String userType = 'ClientUser';
      firstNameController.text =
      "${firstNameController.text[0].toUpperCase()}${firstNameController.text.substring(1).toLowerCase()}";
      lastNameController.text =
      "${lastNameController.text[0].toUpperCase()}${lastNameController.text.substring(1).toLowerCase()}";
      String displayName = firstNameController.text;
      String userName =
          firstNameController.text[0].toUpperCase() + lastNameController.text;
      if (currentPassword != '**********') {
        Map<String, dynamic> clt = {
          "clientId": clientId,
          "clientUserId": int.parse(clientUserIdController.text),
          "branchId": client!['branchId'],
          "branchName": client!['branchName'],
          "active": isActiveChecked,
          "createdAt": Timestamp.now(),
          "devices": [],
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "fullName": lastNameController.text + ',' + firstNameController.text,
          "displayName": displayName,
          "email": emailController.text.toLowerCase(),
          "fcmToken": "Placeholder",
          "loginCounter": 0,
          "originalPassword": passwordController.text,
          'password': '**********',
          "userName": userNameController.text,
          "dateLastLoggedIn": null,
          "dateLastLogin": null,
          "roles": roles,
          "ssn": ssnController.text,
          "genId": int.parse(clientUserIdController.text),
          "ownerId": int.parse(clientUserIdController.text),
          "hcpId": 0,
          "hcpName": '',
          "iosFcmToken": "Placeholder",
          "iosFcmTokens": [],
          "androidFcmToken": "Placeholder",
          "androidFcmTokens": [],
          "windowFcmToken": "Placeholder",
          "windowFcmTokens": [],
          "isAdministrator": isAdministratorChecked,
          "isEmailVerified": true,
          "securityGroupId": -1,
          "securityGroupName": null,
          "status": isActiveChecked == true ? "Active" : "Inactive",
          "statusId": isActiveChecked == true ? "A" : "I",
          "telephone": telephoneController.text,
          "telephoneExtension": telephoneExtensionController.text,
          "userId": int.parse(clientUserIdController.text),
          "userType": userType,
          "userTypes": null,
          "username": userName,
          "department": departmentController.text,
          "disciplineIds": disciplineIds,
          "disciplineNames": disciplineNames,
          "branchNames": null,
          "branchIds": null,
        };
        bls = await clientServices.insertClientUser(clt, userType);
      } else {
        Map<String, dynamic> clt = {
          "active": isActiveChecked,
          "updatedAt": Timestamp.fromDate(DateTime.now()),
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "fullName": lastNameController.text + ',' + firstNameController.text,
          "userName": userNameController.text,
          "roles": roles,
          "ssn": ssnController.text,
          "isAdministrator": isAdministratorChecked,
          "status": isActiveChecked == true ? "Active" : "Inactive",
          "statusId": isActiveChecked == true ? "A" : "I",
          "telephone": cleanTelephone(telephoneController.text),
          "telephoneExtension": telephoneExtensionController.text,
          "userType": userType,
          "userTypes": gclu!['userTypes'],
          "department": departmentController.text,
          "disciplineIds": disciplineIds,
          "disciplineNames": disciplineNames,
        };
        bls = await clientServices.updateClientUserFromItself(clt, gclu!['id']);
      }
      if (bls!.indexOf('Success') == -1) {
        title = 'Error Submitting Form Data';
        AlertDialog alert = AlertDialog(
          backgroundColor: Colors.yellowAccent,
          title: Text(title),
          content: Text(
            bls!,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        );

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            });
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);
          return 0;
        });
      } else {
        listOfClientUsers.clear();
        await _getClientUserMenuData();
        resetData();
        setState(() {
          flagShowForm = false;
        });
        bl = true;
      }
      return;
    } catch (e) {
      print('line 219 error: ${e.toString()}');
      title = 'Error Submitting Form Data';
      AlertDialog alert = AlertDialog(
        backgroundColor: Colors.yellowAccent,
        title: Text(title),
        content: Text(
          '${e.toString()}',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
        return 0;
      });
      return;
    }
  }

  String reformatTelephone(String tel) {
    String tl = tel;
    tl = tl.replaceAll('(', '');
    tl = tl.replaceAll('(', '');
    tl = tl.replaceAll('(', '');
    tl = tl.replaceAll('(', '');

    tl = '(' +
        tel.substring(0, 3) +
        ') ' +
        tel.substring(3, 6) +
        '-' +
        tel.substring(6, tel.length);
    return tl;
  }

  List<String> _selectedRoles = [];
  List<String> _selectedDisciplines = [];
  final roleMultiValueListenable = ValueNotifier<List<String>>([]);
  final disciplineMultiValueListenable = ValueNotifier<List<String>>([]);
  final valueListenable = ValueNotifier<String?>(null);

  int? nextId;
  int getSelectedClientUser(value) {
    print('line 155 getselected client user index : $value');
    int index = value;
    if (index == -1) {
      setState(() {
        resetData();
        showRightSide = false;
      });
    }
    try {
      // for (int i = 0; i < listOfClientUserItems.length; i++) {
      //   String st = listOfClientUserItems[i];
      //   int idx = st.indexOf(')');
      //   idx += 1;
      //   st = st.substring(idx).trim();
      //   print('line 154: $st $value ');
      //   if (value == st) {
      //     index = i;
      //     break;
      //   }
      // }

      print('line 453: $index ');
      List<Map<String, dynamic>> listOfSelectedDisciplines = [];
      List<String> listOfSelectedRoles = [];

      if (index != -1) {
        print('line 458: $listOfClientUsers');
        Map<String, dynamic> clu = listOfClientUsers[index];
        print('line 459: $clu');
        _selectedDisciplines = [];
        for (int z = 0; z < clu['disciplineNames'].length; z++) {
          _selectedDisciplines.add(clu['disciplineNames'][z]);
          //   int iDisciplineId = clu['disciplineIds'][z];
          //   for (int y = 0; y < disciplineItems.length; y++) {
          //     DropdownItem<Discipline> di = disciplineItems[y];
          //     Discipline disc = di.value;
          //     print('line 387: ${disc.disciplineId} $iDisciplineId');
          //     if (disc.disciplineId == iDisciplineId) {
          //       print('line 389 got hit: ${disc.disciplineId} $iDisciplineId');
          //       // disciplinesController.selectAtIndex(y);
          //       disciplinesController.setSelectedItems([]);
          //     }
          //   }

          Map<String, dynamic> tb = {
            'disciplineId': clu['disciplineIds'][z],
            'disciplineName': clu['disciplineNames'][z]
          };
          listOfSelectedDisciplines.add(tb);
        }
        _selectedRoles = [];
        disciplineMultiValueListenable.value = List.from(_selectedDisciplines);
        for (int z = 0; z < clu['roles'].length; z++) {
          String sRole = clu['roles'][z];
          for (int y = 0; y < listOfRoles.length; y++) {
            Map<String, dynamic> mRole = listOfRoles[y];
            if (sRole == mRole['role']) {
              int ix = mRole['id'] - 1;
              String xRole = listRoles[ix];
              _selectedRoles.add(xRole);
              break;
            }
          }

          listOfSelectedRoles.add(sRole);
        }
        print('line 497: $_selectedRoles');
        roleMultiValueListenable.value = List.from(_selectedRoles);
        _selectedDisciplines = [];
        _selectedRoles = [];
        print('line 500: $listRoles ${roleMultiValueListenable.value}');
        // DateFormat formatter = DateFormat('MM-dd-yyyy');
        String formatted = '';
        if (clu['dateLastLoggedIn'] != null) {
          formatted =
              utilityServices.convertFromTimestamp(clu['dateLastLoggedIn']);
        }
        dateLastLoggedInController.text = formatted;
        print('line 507: $clu');
        documentId = clu['id'];
        currentPassword = clu['password'];
        print('line 510: $documentId ${clu['lastName']}');
        clientUserIdController.text = clu['clientUserId'].toString();
        if (clu['active'] == true) {
          activeController.text = 'true';
          isActiveChecked = true;
        } else {
          activeController.text = 'false';
          isActiveChecked = false;
        }
        print('line 519');
        firstNameController.text = clu['firstName'];
        lastNameController.text = clu['lastName'];
        fullNameController.text = clu['fullName'];
        activeController.text = clu['active'] == false ? 'false' : 'true';
        isActiveChecked = clu['active'] == false ? false : true;
        displayNameController.text =
        clu['displayName'] == null ? "" : clu['displayName'];
        emailController.text = clu['email'];
        loginCounterController.text =
        clu['loginCounter'] == null ? '0' : clu['loginCounter'].toString();
        passwordController.text = clu['password'];
        userNameController.text =
        clu['username'] == null ? '0' : clu['username'];
        String st = '';
        if (clu['ssn'] != null) {
          int idx = clu['ssn'].toString().length;
          idx = idx - 4;
          st = clu['ssn'].substring(idx);
        }
        ssnController.text = st;
        print('line 540 $st');
        isAdministratorController.text = clu['isAdministrator'] == null
            ? "false"
            : clu['isAdministrator'].toString();
        isAdministratorChecked =
        clu['isAdministrator'] == null ? false : clu['isAdministrator'];
        telephoneController.text =
        clu['telephone'] == null ? "" : reformatTelephone(clu['telephone']);
        telephoneExtensionController.text = clu['telephoneExtension'] == null
            ? ""
            : telephoneExtensionController.text;
        departmentController.text =
        clu['department'] == null ? "" : clu['department'];
        print('line 553 ${dateLastLoggedInController.text}');

        print('line 555 ');
        return index;
      } else {
        throw Exception('line 558 did not find a client user');
      }
    } catch (e) {
      print('line 561 error: ${e.toString()}');
      throw Exception('line 562 ${e.toString()}');
    }
  }

  int? selectedClientUserId;

  int? clientId;
  // Future<bool> _submit() async {}
  bool isRolesOpen = false;
  bool isDisciplinesOpen = false;
  // late FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();
    client = authService.client;
    clientId = authService.clientId;
    arguments = widget.args;
    print('line 72 arguments $arguments');
    // myFocusNode = FocusNode();
  }

  void resetData() {
    clientUserIdController.text = nextId.toString();
    activeController.text = 'false';
    isActiveChecked = false;
    firstNameController.text = "";
    lastNameController.text = "";
    fullNameController.text = "";
    activeController.text = "";
    displayNameController.text = "";
    emailController.text = "";
    loginCounterController.text = "";
    passwordController.text = "";
    userNameController.text = "";
    dateLastLoggedInController.text = "";
    ssnController.text = "";
    isAdministratorController.text = 'false';
    isAdministratorChecked = false;
    telephoneController.text = "";
    telephoneExtensionController.text = "";
    departmentController.text = "";
    setState(() {
      _selectedRoles = [];
      _selectedDisciplines = [];
    });
  }

  void insertAddTemplateData() {
    print('line 246: $nextId');
    currentPassword = '';
    clientUserIdController.text = nextId.toString();
    firstNameController.text = "";
    lastNameController.text = "";
    fullNameController.text = "";
    activeController.text = "false";
    isActiveChecked = false;
    displayNameController.text = "";
    emailController.text = "";
    loginCounterController.text = "0";
    passwordController.text = "";
    userNameController.text = "";
    dateLastLoggedInController.text = "";
    ssnController.text = "";
    isAdministratorController.text = 'false';
    isAdministratorChecked = false;
    telephoneController.text = "";
    telephoneExtensionController.text = "";
    departmentController.text = "";
    setState(() {
      showRightSide = true;
    });
  }

  bool checkEmail(value) {
    final bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);
    return emailValid;
  }

  bool checkPassword(value) {
    final bool passwordValid =
    RegExp(r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W)(?!.* ).{8,16}$')
        .hasMatch(passwordController.text);
    return passwordValid;
  }

  String cleanTelephone(String tel) {
    bool bl = false;
    if (tel == '') {
      return tel;
    }
    String st = tel;
    st = st.replaceAll('(', '');
    st = st.replaceAll(')', '');
    st = st.replaceAll(' ', '');
    st = st.replaceAll('-', '');
    return st;
  }

  bool checkTelephone(dynamic value) {
    bool bl = false;
    try {
      if (value == '') {
        return bl;
      }
      String st = value.toString();
      st = st.replaceAll('(', '');
      st = st.replaceAll(')', '');
      st = st.replaceAll(' ', '');
      st = st.replaceAll('-', '');
      if (st.length < 10) {
        return false;
      }
      if (st.length == 11) {
        if (st.substring(0, 1) != '1') {
          return false;
        } else {
          st = st.substring(1, st.length);
        }
      }
      if (st.length != 10) {
        return false;
      }
      print('line 540 $st');
      return true;
    } catch (e) {
      print('line 519 bad telephone value');
      return bl;
    }
  }

  bool flagShowForm = false;
  double? screenHeight;
  double? fontSize;
  String? selectedMenu;
  String? selectedMenuName;
  int? selectedMenuNumber;
  int? selectedMenuIndex;
  bool flagHaveData = false;
  TextEditingController menuController = TextEditingController();
  TextEditingController menuOptionController = TextEditingController();
  bool showRightSide = false;
  bool isActiveChecked = false;
  String genericTitle = '';
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double totalCurrentBalance = 0.0;
  double h = 1.0;
  bool isAdministratorChecked = false;
  bool isDebugCheck = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const title = 'Client User Profile Form';
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    double? hh = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    h = hh!;
    if (h < 1.0) {
      h = 1.0;
    }
    double smallFontSize = 16 / h;
    double vWidth1 = 780;
    double height = 80;
    double height2 = 60;
    double width3 = 740;
    double width2 = 370; //(screenWidth - 10) - vWidth1;
    print('line 672: $vWidth1 $width2 $screenWidth, $screenHeight');
    print(
        'line 700: ${flagShowForm} ${ssnController.text} ${clientUserIdController.text}');
    fontSize = 24 / h;
//    double smallFontSize = 24 / h;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            localTitle,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
          backgroundColor: color1,
          elevation: 0,
          leading: GestureDetector(
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 24,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop(null);
                }),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 8),
            flagShowForm == false
                ? Center(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: Text(
                      'Select Client User',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: Future.wait([_getClientUserMenuData()]),
                      builder: (context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Container(
                              height: 80,
                              width: width3,
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
                              height: 80,
                              child: Text(
                                  'There are no client users for this client.',
                                  style: TextStyle(
                                      fontSize: fontSize,
                                      color: color2,
                                      fontWeight: FontWeight.bold)),
                            ),
                          );
                        } else {
                          List<String> listH = snapshot.data![0];
                          print('line 111 ${listH.length}');
                          if (listH.length == 0) {
                            return Center(
                              child: Container(
                                height: 80,
                                child: Text(
                                    'There are no client users for this client.',
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        color: color2,
                                        fontWeight: FontWeight.bold)),
                              ),
                            );
                          } else {
                            List<String> listX = snapshot.data![0];
                            print('line 331: $listX }');
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: height,
                                  width: screenWidth - 4,
                                  child: DropdownButtonHideUnderline(
                                    child: Container(
                                      height: height,
                                      width: screenWidth - 10,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [color1, color1],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter),
                                      ),
                                      child: DropdownButton2<dynamic>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Select Client User',
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .hintColor,
                                          ),
                                        ),
                                        items: listX //snapshot.data![0]
                                            .map((String item) =>
                                            DropdownItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  color:
                                                  Colors.black87,
                                                ),
                                              ),
                                            ))
                                            .toList(),
                                        valueListenable: valueListenable,
                                        onChanged: (dynamic value) {
                                          print('line 827 $value');
                                          setState(() {
                                            if (value !=
                                                'Add New Client User') {
                                              selectedValueClientUser =
                                              value!;
                                              selectedClientUserId =
                                                  _getClientUserId(
                                                      selectedValueClientUser);
                                              if (selectedClientUserId !=
                                                  -1) {
                                                print(
                                                    'line 851 ${selectedClientUserId}');
                                                getSelectedClientUser(
                                                    selectedClientUserId!);
                                                setState(() {
                                                  flagShowForm = true;
                                                });
                                              } else {
                                                resetData();
                                              }
                                              setState(() {
                                                flagShowForm = true;
                                              });
                                            } else {
                                              resetData();
                                              setState(() {
                                                flagShowForm = true;
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                      }),
                ],
              ),
            )
                : Container(),
            if (flagShowForm == true)
              Container(
                alignment: Alignment.topLeft,
                height: screenHeight - 120,
                width: width3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Form(
                        key: formKey,
                        child: Container(
                          color: color1,
                          child: SingleChildScrollView(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: height,
                                    width: width3,
                                    color: Colors.grey[200],
                                    child: Row(
                                      children: [
                                        Container(
                                          height: height,
                                          width: width2,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: TextFormField(
                                            style: TextStyle(
                                              fontSize: fontSize,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                            controller: clientUserIdController,
                                            maxLength: 10,
                                            decoration: InputDecoration(
                                              // Provides an outlined border
                                                counterText: '',
                                                label: Text(
                                                  'UserId',
                                                  style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                hint: Text('UserId',
                                                    style: TextStyle(
                                                        fontSize: fontSize,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black))),
                                            validator: (value) {
                                              return null;
                                              //'some data' failed validation
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            height: height,
                                            width: width2,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: TextFormField(
                                                textAlign: TextAlign.start,
                                                controller: ssnController,
                                                keyboardType:
                                                TextInputType.none,
                                                maxLength: 4,
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                    counterText: '',
                                                    label: Text(
                                                      'ssn',
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    hint: Text('ssn',
                                                        style: TextStyle(
                                                            fontSize: fontSize,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color:
                                                            Colors.black))),
                                                validator: (value) {
                                                  if (value != null &&
                                                      value.length != 4) {
                                                    return "last 4 digits of ssn";
                                                  } else if (value == null) {
                                                    return "Enter last 4 digits of ssn";
                                                  }
                                                  return null;
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 60,
                                    width: width3,
                                    // child: Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: Container(
                                    //         height: height,
                                    //         width: width2,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border:
                                        Border.all(color: Colors.black)),
                                    child: CheckboxListTile(
                                        title: Text('Status/Active',
                                            style: TextStyle(
                                              fontSize: fontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            )),
                                        value: isActiveChecked,
                                        checkColor: color2,
                                        onChanged: (value) {
                                          setState(() {
                                            print('line 1026 $value');
                                            isActiveChecked = value!;
                                          });
                                        }),
                                  ),
                                  // ),
                                  //     TextFormField(
                                  //    controller:
                                  //        activeController,
                                  //   style: TextStyle(
                                  //        fontSize:
                                  //            smallFontSize,
                                  //        fontWeight:
                                  //            FontWeight
                                  //               .bold,
                                  //       color: Colors
                                  //           .black),
                                  //   // Provides an outlined border
                                  //   decoration:
                                  //       InputDecoration(
                                  //     label: Text(
                                  //       'Status/Active',
                                  //       style:
                                  //           TextStyle(
                                  //         fontSize:
                                  //             smallFontSize,
                                  //         fontWeight:
                                  //             FontWeight
                                  //                 .bold,
                                  //         color: Colors
                                  //             .black,
                                  //       ),
                                  //     ),
                                  //     hint: Text(
                                  //         'Status/Active',
                                  //         style: TextStyle(
                                  //             fontSize:
                                  //                 smallFontSize,
                                  //             fontWeight: FontWeight
                                  //                 .bold,
                                  //             color:
                                  //                 Colors.black)),
                                  //     suffixIcon:
                                  //         Checkbox(
                                  //             value:
                                  //                 isActiveChecked,
                                  //             onChanged:
                                  //                 (value) {
                                  //               setState(() {
                                  //                 isActiveChecked = value!;
                                  //               });
                                  //               activeController.text = value.toString().toLowerCase() == 'true'
                                  //                   ? 'true'
                                  //                   : 'false';
                                  //             }),
                                  //   ),
                                  // )),

                                  SizedBox(height: 8),
                                  Container(
                                    height: 60,
                                    width: width3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border:
                                        Border.all(color: Colors.black)),
                                    child: CheckboxListTile(
                                        title: Container(
                                          height: height,
                                          width: width2,
                                          child: Text('Administrator',
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              )),
                                        ),
                                        value: isAdministratorChecked,
                                        checkColor: color2,
                                        onChanged: (value) {
                                          setState(() {
                                            isAdministratorChecked = value!;
                                          });
                                        }),
                                    // child:
                                    //     TextFormField(
                                    //   controller:
                                    //       isAdministratorController,
                                    //   style: TextStyle(
                                    //     fontSize:
                                    //         smallFontSize,
                                    //     fontWeight:
                                    //         FontWeight
                                    //             .bold,
                                    //     color: Colors
                                    //         .black,
                                    //   ),
                                    //   decoration:
                                    //       InputDecoration(
                                    //     // Provides an outlined border
                                    //     label: Text(
                                    //       'Administrator',
                                    //       style:
                                    //           TextStyle(
                                    //         fontSize:
                                    //             smallFontSize,
                                    //         fontWeight:
                                    //             FontWeight
                                    //                 .bold,
                                    //         color: Colors
                                    //             .black,
                                    //       ),
                                    //     ),
                                    //     hint: Text(
                                    //         'Administrator',
                                    //         style:
                                    //             TextStyle(
                                    //           fontSize:
                                    //               smallFontSize,
                                    //           fontWeight:
                                    //               FontWeight
                                    //                   .bold,
                                    //           color: Colors
                                    //               .black,
                                    //         )),
                                    //     suffixIcon:
                                    //         Checkbox(
                                    //             value:
                                    //                 isAdministratorChecked,
                                    //             onChanged:
                                    //                 (value) {
                                    //               setState(
                                    //                   () {
                                    //                 isAdministratorChecked =
                                    //                     value!;
                                    //               });
                                    //               isAdministratorController
                                    //                   .text = value.toString().toLowerCase() ==
                                    //                       'true'
                                    //                   ? 'true'
                                    //                   : 'false';
                                    //             }),
                                    //   ),
                                    // ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: height,
                                    width: width3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border:
                                        Border.all(color: Colors.black)),
                                    child: TextFormField(
                                        controller: firstNameController,
                                        keyboardType: TextInputType.none,
                                        maxLength: 50,
                                        style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              18.0, // Set your desired font size here
                                            ),
                                            counterText: '',
                                            label: Text('First Name',
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            // Provides an outlined border
                                            hint: Text('First Name',
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black))),
                                        validator: (value) {
                                          if (currentPassword == '**********') {
                                            return null;
                                          }
                                          if (value == null) {
                                            return "You must enter a first name.";
                                          }
                                          return null;
                                        }),
                                  ),

                                  SizedBox(height: 8),
                                  Container(
                                    height: height,
                                    width: width3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border:
                                        Border.all(color: Colors.black)),
                                    child: TextFormField(
                                        controller: lastNameController,
                                        keyboardType: TextInputType.none,
                                        maxLength: 50,
                                        style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              18.0, // Set your desired font size here
                                            ),
                                            counterText: '',
                                            label: Text('Last Name',
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            hint: Text('Last Name',
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black))),
                                        validator: (value) {
                                          if (value == null) {
                                            return "You must enter a last name.";
                                          }
                                          return null;
                                        }),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 80,
                                    width: width3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border:
                                        Border.all(color: Colors.black)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 80,
                                            width: 350,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: TextFormField(
                                                controller: passwordController,
                                                keyboardType:
                                                TextInputType.none,
                                                maxLength: 20,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                enabled: currentPassword ==
                                                    '**********'
                                                    ? false
                                                    : true,
                                                decoration: InputDecoration(
                                                    errorStyle: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize:
                                                      18.0, // Set your desired font size here
                                                    ),
                                                    counterText: '',
                                                    label: Text('Password',
                                                        style: TextStyle(
                                                            fontSize: fontSize,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color:
                                                            Colors.black)),
                                                    hint: Text(
                                                      'Password',
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                validator: (value) {
                                                  if (value == null) {
                                                    return "You must enter a password.";
                                                  }
                                                  if (currentPassword ==
                                                      '**********') {
                                                    return null;
                                                  }
                                                  bool bl =
                                                  checkPassword(value);
                                                  if (bl == false) {
                                                    return 'Invalid password format';
                                                  }
                                                  return null;
                                                }),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            height: 80,
                                            width: 390,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: TextFormField(
                                                controller:
                                                dateLastLoggedInController,
                                                keyboardType:
                                                TextInputType.none,
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                maxLength: 18,
                                                enabled: false,
                                                decoration: InputDecoration(
                                                    errorStyle: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize:
                                                      18.0, // Set your desired font size here
                                                    ),
                                                    counterText: '',
                                                    label: Text(
                                                        'Date Last Login',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color:
                                                            Colors.black)),
                                                    hint: Text(
                                                        'Date Last Login',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color:
                                                            Colors.black))),
                                                validator: (value) {
                                                  return null;
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: height,
                                    width: width3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border:
                                        Border.all(color: Colors.black)),
                                    child: TextFormField(
                                        keyboardType: TextInputType.none,
                                        controller: emailController,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        maxLength: 100,
                                        enabled: passwordController.text ==
                                            '**********'
                                            ? false
                                            : true,
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              18.0, // Set your desired font size here
                                            ),
                                            counterText: '',
                                            label: Text('Email',
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            hint: Text(
                                              'Email',
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            )),
                                        validator: (value) {
                                          if (value == null) {
                                            return "You must enter an email.";
                                          }
                                          bool bl = checkEmail(value);
                                          if (bl == false) {
                                            return 'Invalid email format.';
                                          }
                                          return null;
                                        }),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 80,
                                    width: width3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border:
                                        Border.all(color: Colors.black)),
                                    child: TextFormField(
                                        controller: departmentController,
                                        maxLength: 45,
                                        keyboardType: TextInputType.none,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              18.0, // Set your desired font size here
                                            ),
                                            counterText: '',
                                            label: Text('Department',
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            hint: Text(
                                              'Department',
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            )),
                                        validator: (value) {
                                          return null;
                                        }),
                                  ),

                                  SizedBox(height: 8),
                                  Container(
                                    height: 80,
                                    width: width3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border:
                                        Border.all(color: Colors.black)),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: height,
                                          width: width2,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: TextFormField(
                                              controller: telephoneController,
                                              keyboardType: TextInputType.none,
                                              maxLength: 12,
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                  errorStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                    18.0, // Set your desired font size here
                                                  ),
                                                  counterText: '',
                                                  label: Text('Telephone',
                                                      style: TextStyle(
                                                          fontSize: fontSize,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black)),
                                                  hint: Text(
                                                    '222 333-4444',
                                                    style: TextStyle(
                                                      fontSize: fontSize,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              validator: (value) {
                                                if (value == null) {
                                                  return "You must enter a telephone number.";
                                                }

                                                print('line 1028: $value');
                                                bool isValidTelephone =
                                                checkTelephone(value);
                                                print(
                                                    'line 1031: $isValidTelephone');
                                                if (isValidTelephone == false) {
                                                  return "Invalid telephone format";
                                                }
                                                return null;
                                              }),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            height: 80,
                                            width: width2,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: TextFormField(
                                                controller:
                                                telephoneExtensionController,
                                                maxLength: 20,
                                                keyboardType:
                                                TextInputType.none,
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                decoration: InputDecoration(
                                                    counterText: '',
                                                    errorStyle: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize:
                                                      18.0, // Set your desired font size here
                                                    ),
                                                    label: Text('Extension',
                                                        style: TextStyle(
                                                            fontSize: fontSize,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color:
                                                            Colors.black)),
                                                    hint: Text(
                                                      'Extension',
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                onSaved: (value) {
                                                  print('line 1556 $value');
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: height,
                                    width: width3,
                                    color: Colors.grey[200],
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 100,
                                            width: width2,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text(
                                                  'Select Roles',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                items: listRoles.map((item) {
                                                  print('line 1659: $item');
                                                  return DropdownItem(
                                                    value: item,
                                                    key: Key(Random()
                                                        .nextDouble()
                                                        .toString()),
                                                    height: 40,
                                                    closeOnTap: false,
                                                    child:
                                                    ValueListenableBuilder<
                                                        List<String>>(
                                                      valueListenable:
                                                      roleMultiValueListenable,
                                                      builder: (context,
                                                          multiValue, _) {
                                                        final isSelected =
                                                        multiValue
                                                            .contains(item);
                                                        return Container(
                                                          height:
                                                          double.infinity,
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              8.0),
                                                          child: Row(
                                                            children: [
                                                              if (isSelected)
                                                                const Icon(Icons
                                                                    .check_box_outlined)
                                                              else
                                                                const Icon(Icons
                                                                    .check_box_outline_blank),
                                                              const SizedBox(
                                                                  width: 16),
                                                              Expanded(
                                                                child: Text(
                                                                  item,
                                                                  style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                    24,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }).toList(),
                                                multiValueListenable:
                                                roleMultiValueListenable,
                                                onChanged: (value) {
                                                  final multiValue =
                                                      roleMultiValueListenable
                                                          .value;
                                                  final isSelected = multiValue
                                                      .contains(value);
                                                  if (value == 'All') {
                                                    isSelected
                                                        ? roleMultiValueListenable
                                                        .value = []
                                                        : roleMultiValueListenable
                                                        .value =
                                                        List.from(
                                                            listRoles);
                                                  } else {
                                                    roleMultiValueListenable
                                                        .value =
                                                    isSelected
                                                        ? ([...multiValue]
                                                      ..remove(value))
                                                        : [
                                                      ...multiValue,
                                                      value!
                                                    ];
                                                  }
                                                },
                                                selectedItemBuilder: (context) {
                                                  return listRoles.map(
                                                        (item) {
                                                      return ValueListenableBuilder<
                                                          List<String>>(
                                                          valueListenable:
                                                          roleMultiValueListenable,
                                                          builder: (context,
                                                              multiValue, _) {
                                                            return Container(
                                                              alignment:
                                                              AlignmentDirectional
                                                                  .center,
                                                              child: Text(
                                                                multiValue
                                                                    .where((item) =>
                                                                item !=
                                                                    'All')
                                                                    .join(', '),
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 24,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                ),
                                                                maxLines: 1,
                                                              ),
                                                            );
                                                          });
                                                    },
                                                  ).toList();
                                                },
                                                buttonStyleData:
                                                const ButtonStyleData(
                                                  padding: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  height: 40,
                                                  width: 140,
                                                ),
                                                menuItemStyleData:
                                                const MenuItemStyleData(
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            height: 100,
                                            width: width2,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text(
                                                  'Select Disciplines',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                items:
                                                listDisciplines.map((item) {
                                                  return DropdownItem(
                                                    value: item,
                                                    key: Key(Random()
                                                        .nextDouble()
                                                        .toString()),
                                                    height: 40,
                                                    closeOnTap: false,
                                                    child:
                                                    ValueListenableBuilder<
                                                        List<String>>(
                                                      valueListenable:
                                                      disciplineMultiValueListenable,
                                                      builder: (context,
                                                          multiValue, _) {
                                                        final isSelected =
                                                        multiValue
                                                            .contains(item);
                                                        return Container(
                                                          height:
                                                          double.infinity,
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              16.0),
                                                          child: Row(
                                                            children: [
                                                              if (isSelected)
                                                                const Icon(Icons
                                                                    .check_box_outlined)
                                                              else
                                                                const Icon(Icons
                                                                    .check_box_outline_blank),
                                                              const SizedBox(
                                                                  width: 16),
                                                              Expanded(
                                                                child: Text(
                                                                  item,
                                                                  style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                    24,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }).toList(),
                                                multiValueListenable:
                                                disciplineMultiValueListenable,
                                                onChanged: (value) {
                                                  final multiValue =
                                                      disciplineMultiValueListenable
                                                          .value;
                                                  final isSelected = multiValue
                                                      .contains(value);
                                                  if (value == 'All') {
                                                    isSelected
                                                        ? disciplineMultiValueListenable
                                                        .value = []
                                                        : disciplineMultiValueListenable
                                                        .value =
                                                        List.from(
                                                            listDisciplines);
                                                  } else {
                                                    disciplineMultiValueListenable
                                                        .value =
                                                    isSelected
                                                        ? ([...multiValue]
                                                      ..remove(value))
                                                        : [
                                                      ...multiValue,
                                                      value!
                                                    ];
                                                  }
                                                },
                                                selectedItemBuilder: (context) {
                                                  return listDisciplines.map(
                                                        (item) {
                                                      return ValueListenableBuilder<
                                                          List<String>>(
                                                          valueListenable:
                                                          disciplineMultiValueListenable,
                                                          builder: (context,
                                                              multiValue, _) {
                                                            return Container(
                                                              alignment:
                                                              AlignmentDirectional
                                                                  .center,
                                                              child: Text(
                                                                multiValue
                                                                    .where((item) =>
                                                                item !=
                                                                    'All')
                                                                    .join(', '),
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                ),
                                                                maxLines: 1,
                                                              ),
                                                            );
                                                          });
                                                    },
                                                  ).toList();
                                                },
                                                buttonStyleData:
                                                const ButtonStyleData(
                                                  padding: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  height: 40,
                                                  width: 140,
                                                ),
                                                menuItemStyleData:
                                                const MenuItemStyleData(
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 8),
                                  Container(
                                    height: height2,
                                    width: width3,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: height2,
                                            width: (width3 - 20) / 3,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                print('line 1083 ');

                                                _submit();
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: height,
                                                width: (width3 - 20) / 3,
                                                child: Text(
                                                  'Save Form',
                                                  style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Container(
                                            height: height,
                                            width: (width3 - 20) / 3,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                print('line 662 reset');
                                                resetData();
                                              },
                                              child: Text('Reset Form',
                                                  style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Container(
                                            height: height,
                                            width: (width3 - 20) / 3,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                print('line 2157 cancel');
                                                setState(() {
                                                  flagShowForm = false;
                                                });
                                              },
                                              child: Text('Cancel',
                                                  style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(),
          ],
        ));
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cms_web/features/shared/services/clientapp/client_services.dart';
// import 'package:cms_web/features/shared/utils/utilities.dart';
// import 'package:multi_dropdown/multi_dropdown.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Role {
//   final String role;
//   final int id;
//
//   const Role({required this.role, required this.id});
// }
//
// class ClientUserProfilePage extends StatefulWidget {
//   final Map<String, dynamic> args;
//   const ClientUserProfilePage({super.key, required this.args});
//
//   @override
//   State<ClientUserProfilePage> createState() => _ClientUserProfilePageState();
// }
//
// class _ClientUserProfilePageState extends State<ClientUserProfilePage> {
//   final formKey = GlobalKey<FormState>();
//   String? documentId;
//   ClientServices clientServices = ClientServices();
//   UtilitiesServices utilityServices = UtilitiesServices();
//   Map<String, dynamic>? arguments;
//   List<Map<String, dynamic>> listOfClientUsers = [];
//   List<Map<String, dynamic>>? menuClientUsers;
//   List<DropdownMenuEntry<dynamic>> dropDownMenuEntries = [];
//   List<DropdownMenuEntry<dynamic>> dropDownMenuOptionEntries = [];
//   List<DropdownItem<Role>>? selectedItems;
//   Future<List<dynamic>> _getDropDownMenuItems() async {
//     print('line 30 get client address Dropdownitems');
//     dropDownMenuEntries = [];
//     menuClientUsers = [];
//     try {
//       if (listOfClientUsers.length == 0) {
//         listOfClientUsers =
//             await clientServices.getClientUsers(arguments!['clientId']);
//       }
//       int largestId = -1;
//       print('line 35: ${listOfClientUsers!.length}');
//       if (listOfClientUsers.length > 0) {
//         for (int i = 0; i < listOfClientUsers!.length; i++) {
//           Map<String, dynamic> clu = listOfClientUsers![i];
//           if (clu['clientUserId'] > largestId) {
//             largestId = clu['clientUserId'];
//           }
//           Map<String, dynamic> mclu = {
//             'clientUserId': clu['clientUserId'].toString(),
//             'fullName': clu['fullName']
//           };
//           DropdownMenuEntry me = DropdownMenuEntry(
//               value: mclu['clientUserId'], label: mclu['fullName']);
//           dropDownMenuEntries.add(me);
//           menuClientUsers!.add(mclu);
//         }
//         nextId = largestId + 1;
//         print('line 48: $nextId $largestId ${dropDownMenuEntries}');
//         return dropDownMenuEntries;
//       } else {
//         nextId = 1;
//         insertAddTemplateData();
//         return [];
//       }
//       print('line 49: dropdownentries ${dropDownMenuEntries.length}');
//     } catch (e) {
//       print('line 49: error: ${e.toString()}');
//       throw Exception('line 21 error getting dropdown menu items');
//     }
//   }
//
//   String localTitle = 'Client ClientUsers';
//   final rolesController = MultiSelectController<Role>();
//   //controllers
//   TextEditingController clientUserIdController = TextEditingController();
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController fullNameController = TextEditingController();
//   TextEditingController activeController = TextEditingController();
//   TextEditingController displayNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController loginCounterController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController userNameController = TextEditingController();
//   TextEditingController dateOfLastLoginController = TextEditingController();
//
//   @override
//   void dispose() {
//     super.dispose();
//     clientUserIdController.dispose();
//     firstNameController.dispose();
//     lastNameController.dispose();
//     fullNameController.dispose();
//     activeController.dispose();
//     displayNameController.dispose();
//     emailController.dispose();
//     loginCounterController.dispose();
//     passwordController.dispose();
//     userNameController.dispose();
//     dateOfLastLoginController.dispose();
//     rolesController.dispose();
//     menuController.dispose();
//   }
//
//   Future<bool> _submit() async {
//     print('line 110 in submit');
//     bool bl = false;
//     //regex email
//     // final bool emailValid = RegExp(
//     //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//     //     .hasMatch(email);
//     DateTime dte = DateTime.parse(dateOfLastLoginController.text);
//     List<dynamic> roles = [];
//
//     for (int j = 0; j < selectedItems!.length; j++) {
//       DropdownItem<Role> di = selectedItems![j];
//       if (di.selected == false) {
//         continue;
//       }
//       Role role = di.value;
//       roles.add(role.role);
//     }
//     try {
//       Map<String, dynamic> clt = {
//         "clientId": clientId,
//         "clientUserId": int.parse(clientUserIdController.text),
//         "firstName": firstNameController.text,
//         "lastName": lastNameController.text,
//         "fullName": fullNameController.text,
//         "active": bool.parse(activeController.text),
//         "displayName": displayNameController.text,
//         "email": emailController.text,
//         "loginCounter": int.parse(loginCounterController.text),
//         "password": passwordController.text,
//         "userName": userNameController.text,
//         "dateOfLastLogin": dte,
//         "roles": roles
//       };
//       print('line 142 $clt');
//       await clientServices.insertClientUser(clt);
//       listOfClientUsers.clear();
//       await _getDropDownMenuItems();
//       resetData();
//       return bl;
//     } catch (e) {
//       print('line 148 error: ${e.toString()}');
//       return bl;
//     }
//   }
//
//   int? nextId;
//   int getSelectedMenuIndex(value) {
//     print('line 155 getselected address index : $value');
//     int index = -1;
//     setState(() {
//       resetData();
//       showRightSide = false;
//     });
//     try {
//       for (int i = 0; i < dropDownMenuEntries.length; i++) {
//         DropdownMenuEntry de = dropDownMenuEntries[i];
//         print('line 154: $value ${de.value}');
//         if (value == de.value) {
//           index = i;
//           break;
//         }
//       }
//
//       print('line 167: $index $arguments');
//
//       if (index != -1) {
//         Map<String, dynamic> clu = listOfClientUsers[index];
//         documentId = clu['id'];
//         print('line 172: $documentId ${clu['lastName']}');
//         clientUserIdController.text = clu['clientUserId'].toString();
//         firstNameController.text = clu['firstName'];
//         lastNameController.text = clu['lastName'];
//         fullNameController.text = clu['fullName'];
//         activeController.text = clu['active'] == false ? 'false' : 'true';
//         displayNameController.text =
//             clu['displayName'] == null ? "" : clu['displayName'];
//         emailController.text = clu['email'];
//         loginCounterController.text =
//             clu['loginCounter'] == null ? '0' : clu['loginCounter'].toString();
//         passwordController.text = clu['password'];
//         userNameController.text =
//             clu['username'] == null ? '0' : clu['username'];
//         dateOfLastLoginController.text =
//             utilityServices.convertFromTimestamp(clu['dateOfLastLogin']);
//         print('line 188 ${dateOfLastLoginController.text}');
//         for (int i = 0; i < clu['roles'].length; i++) {
//           String srole = clu['roles'][i];
//           //   print('line 133: ${clu['roles'].length} $srole');
//           for (int j = 0; j < items.length; j++) {
//             DropdownItem di = items[j];
//             Role role = di.value;
//             //   print('line 137: $srole ${role.role}');
//             // if (srole == role.role) {
//             //   //     print('line 139 got hit: $srole $role');
//             //   di.selected = true;
//             // }
//           }
//         }
//         return index;
//       } else {
//         throw Exception('line 196 did not find a client user');
//       }
//     } catch (e) {
//       print('line 206 error: ${e.toString()}');
//       throw Exception('line 207 ${e.toString()}');
//     }
//   }
//
//   var items = [
//     DropdownItem(label: 'Admin', value: Role(role: 'ClientAdmin', id: 1)),
//     DropdownItem(label: 'DON', value: Role(role: 'ClientDON', id: 2)),
//     DropdownItem(label: 'ADON', value: Role(role: 'ClientADON', id: 3)),
//     DropdownItem(
//         label: 'Scheduler', value: Role(role: 'ClientScheduler', id: 4)),
//     DropdownItem(
//         label: 'Shift Supervisor',
//         value: Role(role: 'ClientSupervisor', id: 5)),
//     DropdownItem(label: 'Staff', value: Role(role: 'ClientStaff', id: 6)),
//     DropdownItem(
//         label: 'Accounting', value: Role(role: 'ClientAccount', id: 7)),
//     DropdownItem(label: 'Manager', value: Role(role: 'ClientManager', id: 8)),
//   ];
//   int? clientId;
//   // Future<bool> _submit() async {}
//   @override
//   void initState() {
//     super.initState();
//     arguments = widget.args;
//     clientId = arguments!['clientId'];
//     print('line 72 arguments $arguments');
//   }
//
//   void resetData() {
//     formKey.currentState?.reset();
//     clientUserIdController.text = "";
//     firstNameController.text = "";
//     lastNameController.text = "";
//     fullNameController.text = "";
//     activeController.text = "";
//     displayNameController.text = "";
//     emailController.text = "";
//     loginCounterController.text = "";
//     passwordController.text = "";
//     userNameController.text = "";
//     dateOfLastLoginController.text = "";
//     rolesController.clearAll();
//   }
//
//   void insertAddTemplateData() {
//     print('line 246: $nextId');
//     clientUserIdController.text = nextId.toString();
//     firstNameController.text = "";
//     lastNameController.text = "";
//     fullNameController.text = "";
//     activeController.text = "";
//     displayNameController.text = "";
//     emailController.text = "";
//     loginCounterController.text = "0";
//     passwordController.text = "";
//     userNameController.text = "";
//     dateOfLastLoginController.text = "";
//     setState(() {
//       showRightSide = true;
//     });
//   }
//
//   double? screenHeight;
//   double? fontSize;
//   String? selectedMenu;
//   String? selectedMenuName;
//   int? selectedMenuNumber;
//   int? selectedMenuIndex;
//   bool flagHaveData = false;
//   TextEditingController menuController = TextEditingController();
//   TextEditingController menuOptionController = TextEditingController();
//   bool showRightSide = false;
//   String genericTitle = '';
//   Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
//   Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
//   Color color3 = Colors.grey.shade200;
//   double totalCurrentBalance = 0.0;
//   double h = 1.0;
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     const title = 'Client Address Form';
//     final double screenWidth = MediaQuery.sizeOf(context).width;
//     final double screenHeight = MediaQuery.sizeOf(context).height;
//     double? hh = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
//     h = hh!;
//     if (h < 1.0) {
//       h = 1.0;
//     }
//     fontSize = 16 / h;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           localTitle,
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: VerticalSplitView(
//             left: Container(
//                 width: 300,
//                 decoration: BoxDecoration(
//                   color: color1,
//                   border: Border.all(color: Colors.black),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           height: 200,
//                           width: 300,
//                           padding: EdgeInsets.only(top: 5),
//                           child: Column(
//                             children: <Widget>[
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 2),
//                                 child: FutureBuilder(
//                                   future: Future.wait([
//                                     _getDropDownMenuItems(),
//                                   ]),
//                                   builder: (context,
//                                       AsyncSnapshot<List<dynamic>> snapshot) {
//                                     debugPrint(
//                                         'line 417 building FB ${snapshot.connectionState}');
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const CircularProgressIndicator();
//                                     } else if (snapshot.hasError) {
//                                       return Center(
//                                         child: Padding(
//                                           padding:
//                                               const EdgeInsets.only(bottom: 30),
//                                           child: Container(
//                                             height: 110,
//                                             child: Text(
//                                                 'Error: ${snapshot.error}',
//                                                 style: TextStyle(
//                                                     fontSize: fontSize,
//                                                     color: Colors.red,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                           ),
//                                         ),
//                                       );
//                                     } else if (snapshot.data == [[]] &&
//                                         snapshot.connectionState ==
//                                             ConnectionState.done) {
//                                       return Center(
//                                         child: Padding(
//                                           padding: EdgeInsets.only(bottom: 30),
//                                           child: Container(
//                                             height: 100,
//                                             width: screenWidth! - 10,
//                                             child: Text(
//                                                 overflow: TextOverflow.visible,
//                                                 'There are no ClientUsers for this client.',
//                                                 style: TextStyle(
//                                                     fontSize: fontSize,
//                                                     color: color2,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                           ),
//                                         ),
//                                       );
//                                     } else {
//                                       List<dynamic> listH = snapshot.data![0];
//                                       print('line 111 ${listH.length}');
//                                       if (listH.length == 0) {
//                                         return Center(
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 bottom: 30),
//                                             child: Container(
//                                               height: 100,
//                                               width: screenWidth! - 10,
//                                               child: Text(
//                                                   'There are no ClientUsers for this client.',
//                                                   overflow:
//                                                       TextOverflow.visible,
//                                                   style: TextStyle(
//                                                       fontSize: fontSize,
//                                                       color: color2,
//                                                       fontWeight:
//                                                           FontWeight.bold)),
//                                             ),
//                                           ),
//                                         );
//                                       } else {
//                                         List<dynamic> listD =
//                                             snapshot.data![0]!;
//                                         print('line 260 ${listD.length}');
//
//                                         return Container(
//                                           height: 80,
//                                           width: screenWidth! - 10,
//                                           child: Column(
//                                             children: [
//                                               DropdownMenu<dynamic>(
//                                                 initialSelection: null,
//                                                 controller: menuController,
//                                                 requestFocusOnTap: true,
//                                                 label: const Text(
//                                                     'Client User Menu'),
//                                                 onSelected: (dynamic value) {
//                                                   print(
//                                                       'line 278 on selected $value');
//                                                   selectedMenu = value;
//                                                   selectedMenuIndex =
//                                                       getSelectedMenuIndex(
//                                                           value);
//                                                   print(
//                                                       'line 283: $selectedMenuIndex');
//                                                   selectedMenuName =
//                                                       menuClientUsers![
//                                                               selectedMenuIndex!]
//                                                           ['clientUser'];
//                                                   setState(() {
//                                                     dropDownMenuOptionEntries =
//                                                         [];
//                                                     showRightSide = true;
//                                                     genericTitle =
//                                                         'Client Profile Menu';
//                                                   });
//                                                 },
//                                                 dropdownMenuEntries:
//                                                     dropDownMenuEntries,
//                                               )
//                                             ],
//                                           ),
//                                         );
//                                       }
//                                     }
//                                   },
//                                 ),
//                               ),
//                               if (selectedMenu != null)
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Text('Selected: ${selectedMenu}'),
//                                   ],
//                                 )
//                               else
//                                 const Text('Please select a Client User.'),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: () {
//                         print('line 662 insert add template');
//                         insertAddTemplateData();
//                       },
//                       child: Text('Insert Add Template'),
//                     ),
//                   ],
//                 )),
//             right: showRightSide == true
//                 ? Align(
//                     alignment: Alignment.topLeft,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Form(
//                               key: formKey,
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: 50,
//                                     width: screenWidth / 3,
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           height: 50,
//                                           width: screenWidth / 7,
//                                           child: TextFormField(
//                                             controller: clientUserIdController,
//                                             maxLength: 10,
//                                             decoration: InputDecoration(
//                                                 label: Text('Client User Id')),
//                                             validator: (value) {
//                                               return null;
//                                               //'some data' failed validation
//                                             },
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         Container(
//                                           height: 50,
//                                           width: screenWidth / 7,
//                                           child: TextFormField(
//                                               controller: activeController,
//                                               maxLength: 10,
//                                               decoration: InputDecoration(
//                                                   label: Text('Active')),
//                                               validator: (value) {
//                                                 if (value == null ||
//                                                     value.isEmpty) {
//                                                   return "You must enter a value for active";
//                                                 }
//                                                 return null;
//                                               }),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Container(
//                                     height: 50,
//                                     width: screenWidth / 3,
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           height: 50,
//                                           width: screenWidth / 7,
//                                           child: TextFormField(
//                                               controller: firstNameController,
//                                               maxLength: 50,
//                                               decoration: InputDecoration(
//                                                   label: Text('First Name')),
//                                               validator: (value) {
//                                                 if (value == null ||
//                                                     value.isEmpty) {
//                                                   return "You must enter a first name.";
//                                                 }
//                                                 return null;
//                                               }),
//                                         ),
//                                         SizedBox(width: 10),
//                                         Container(
//                                           height: 50,
//                                           width: screenWidth / 7,
//                                           child: TextFormField(
//                                               controller: lastNameController,
//                                               maxLength: 50,
//                                               decoration: InputDecoration(
//                                                   label: Text('Last Name')),
//                                               validator: (value) {
//                                                 if (value == null ||
//                                                     value.isEmpty) {
//                                                   return "You must enter a last name.";
//                                                 }
//                                                 return null;
//                                               }),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 50,
//                                     width: screenWidth / 3,
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           height: 50,
//                                           width: screenWidth / 7,
//                                           child: TextFormField(
//                                               controller: fullNameController,
//                                               maxLength: 100,
//                                               decoration: InputDecoration(
//                                                   label: Text('fullName')),
//                                               validator: (value) {
//                                                 if (value == null ||
//                                                     value.isEmpty) {
//                                                   return "You must enter a full name.";
//                                                 }
//                                                 return null;
//                                               }),
//                                         ),
//                                         SizedBox(width: 10),
//                                         Container(
//                                           height: 50,
//                                           width: screenWidth / 7,
//                                           child: TextFormField(
//                                               controller:
//                                                   dateOfLastLoginController,
//                                               maxLength: 30,
//                                               decoration: InputDecoration(
//                                                   label: Text(
//                                                       'Date Of Last Login')),
//                                               validator: (value) {
//                                                 return null;
//                                               }),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Container(
//                                       height: 50,
//                                       width: screenWidth / 3,
//                                       child: TextFormField(
//                                           keyboardType:
//                                               TextInputType.emailAddress,
//                                           controller: emailController,
//                                           maxLength: 100,
//                                           decoration: InputDecoration(
//                                               label: Text('Email')),
//                                           validator: (value) {
//                                             if (value == null ||
//                                                 value.isEmpty) {
//                                               return "You must enter an email.";
//                                             }
//                                             return null;
//                                           })),
//                                   SizedBox(height: 10),
//                                   Container(
//                                     height: 50,
//                                     width: screenWidth / 3,
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           height: 50,
//                                           width: screenWidth / 7,
//                                           child: TextFormField(
//                                               controller:
//                                                   loginCounterController,
//                                               maxLength: 10,
//                                               decoration: InputDecoration(
//                                                   label: Text('Login Counter')),
//                                               validator: (value) {
//                                                 return null;
//                                               }),
//                                         ),
//                                         SizedBox(width: 10),
//                                         Container(
//                                           height: 50,
//                                           width: screenWidth / 7,
//                                           child: TextFormField(
//                                               controller: userNameController,
//                                               maxLength: 30,
//                                               decoration: InputDecoration(
//                                                   label: Text('Username')),
//                                               validator: (value) {
//                                                 if (value == null ||
//                                                     value.isEmpty) {
//                                                   return "You must enter a username.";
//                                                 }
//                                                 return null;
//                                               }),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 50,
//                                     width: screenWidth / 3,
//                                     child: Row(children: [
//                                       Container(
//                                         height: 50,
//                                         width: screenWidth / 7,
//                                         child: TextFormField(
//                                             controller: passwordController,
//                                             maxLength: 20,
//                                             decoration: InputDecoration(
//                                                 label: Text('Password ')),
//                                             validator: (value) {
//                                               if (value == null ||
//                                                   value.isEmpty) {
//                                                 return "You must enter a password.";
//                                               }
//                                               return null;
//                                             }),
//                                       ),
//                                       SizedBox(width: 10),
//                                       Container(
//                                         height: 50,
//                                         width: screenWidth / 7,
//                                         child: TextFormField(
//                                             controller: displayNameController,
//                                             maxLength: 60,
//                                             decoration: InputDecoration(
//                                                 label: Text('Display Name')),
//                                             validator: (value) {
//                                               return null;
//                                             }),
//                                       ),
//                                     ]),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Container(
//                                     height: 50,
//                                     width: 300,
//                                     child: MultiDropdown<Role>(
//                                       items: items,
//                                       controller: rolesController,
//                                       enabled: true,
//                                       searchEnabled: true,
//                                       chipDecoration: ChipDecoration(
//                                         backgroundColor: color1,
//                                         wrap: true,
//                                         runSpacing: 2,
//                                         spacing: 10,
//                                       ),
//                                       fieldDecoration: FieldDecoration(
//                                         hintText: 'Roles',
//                                         hintStyle: const TextStyle(
//                                             color: Colors.black87),
//                                         prefixIcon: const Icon(
//                                             CupertinoIcons.app_badge),
//                                         showClearIcon: false,
//                                         border: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           borderSide: const BorderSide(
//                                               color: Colors.grey),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           borderSide: const BorderSide(
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                       ),
//                                       dropdownDecoration:
//                                           const DropdownDecoration(
//                                         marginTop: 2,
//                                         maxHeight: 500,
//                                         header: Padding(
//                                           padding: EdgeInsets.all(8),
//                                           child: Text(
//                                             'Select Roles from the list',
//                                             textAlign: TextAlign.start,
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       dropdownItemDecoration:
//                                           DropdownItemDecoration(
//                                         selectedIcon: const Icon(
//                                             Icons.check_box,
//                                             color: Colors.green),
//                                         disabledIcon: Icon(Icons.lock,
//                                             color: Colors.grey.shade300),
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please select a role';
//                                         }
//                                         return null;
//                                       },
//                                       onSelectionChange: (selectedItems) {
//                                         debugPrint(
//                                             "OnSelectionChange: $selectedItems");
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       rolesController.openDropdown();
//                                     },
//                                     child: const Text('Open/Close dropdown'),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 480),
//                                     child: Row(
//                                       children: [
//                                         ElevatedButton(
//                                           onPressed: () async {
//                                             bool? bl = formKey.currentState
//                                                 ?.validate();
//                                             if (bl != null && bl == false) {
//                                               print('line 789: $bl');
//                                             } else {
//                                               print('line 791 bl is null');
//                                               selectedItems =
//                                                   rolesController.selectedItems;
//                                               await _submit();
//                                             }
//                                           },
//                                           child: Text('Save'),
//                                         ),
//                                         SizedBox(width: 5),
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             print('line 662 reset');
//                                             resetData();
//                                           },
//                                           child: Text('Reset Form'),
//                                         ),
//                                         SizedBox(height: 10),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 : Container()),
//       ),
//     );
//   }
// }
//
// class VerticalSplitView extends StatefulWidget {
//   final Widget left;
//   final Widget right;
//   final double ratio;
//
//   const VerticalSplitView(
//       {Key? key, required this.left, required this.right, this.ratio = 0.25});
//
//   @override
//   _VerticalSplitViewState createState() => _VerticalSplitViewState();
// }
//
// class _VerticalSplitViewState extends State<VerticalSplitView> {
//   final _dividerWidth = 16.0;
//
//   double? _ratio;
//   double? _maxWidth;
//
//   get _width1 => _ratio! * _maxWidth!;
//
//   get _width2 => (1 - _ratio!) * _maxWidth!;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _ratio = widget.ratio;
//     // _ratio = .25;
//     print('line 99: $_ratio');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, BoxConstraints constraints) {
//       if (_maxWidth == null) _maxWidth = constraints.maxWidth - _dividerWidth;
//       if (_maxWidth != constraints.maxWidth) {
//         _maxWidth = constraints.maxWidth - _dividerWidth;
//       }
//       print('line 622: $_maxWidth');
//       return SizedBox(
//         width: constraints.maxWidth,
//         child: Row(
//           children: <Widget>[
//             SizedBox(
//               width: _width1,
//               child: widget.left,
//             ),
//             SizedBox(
//               width: _width2,
//               child: widget.right,
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
