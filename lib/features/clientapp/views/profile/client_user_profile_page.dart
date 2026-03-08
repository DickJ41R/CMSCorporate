//Client User Profile Page
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cms_web/features/clientapp/services/client_services.dart';
import 'package:cms_web/features/shared/services/utility_services.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  final String role;
  final int id;

  const Role({required this.role, required this.id});
}

class ClientUserProfilePage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientUserProfilePage({super.key, required this.args});

  @override
  State<ClientUserProfilePage> createState() => _ClientUserProfilePageState();
}

class _ClientUserProfilePageState extends State<ClientUserProfilePage> {
  final formKey = GlobalKey<FormState>();
  String? documentId;
  ClientServices clientServices = ClientServices();
  UtilitiesServices utilityServices = UtilitiesServices();
  Map<String, dynamic>? arguments;
  List<Map<String, dynamic>> listOfClientUsers = [];
  List<Map<String, dynamic>>? menuClientUsers;
  List<DropdownMenuEntry<dynamic>> dropDownMenuEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownMenuOptionEntries = [];
  List<DropdownItem<Role>>? selectedItems;
  Future<List<dynamic>> _getDropDownMenuItems() async {
    print('line 30 get client address Dropdownitems');
    dropDownMenuEntries = [];
    menuClientUsers = [];
    try {
      if (listOfClientUsers.length == 0) {
        listOfClientUsers =
            await clientServices.getClientUsers(arguments!['clientId']);
      }
      int largestId = -1;
      print('line 35: ${listOfClientUsers!.length}');
      if (listOfClientUsers.length > 0) {
        for (int i = 0; i < listOfClientUsers!.length; i++) {
          Map<String, dynamic> clu = listOfClientUsers![i];
          if (clu['clientUserId'] > largestId) {
            largestId = clu['clientUserId'];
          }
          Map<String, dynamic> mclu = {
            'clientUserId': clu['clientUserId'].toString(),
            'fullName': clu['fullName']
          };
          DropdownMenuEntry me = DropdownMenuEntry(
              value: mclu['clientUserId'], label: mclu['fullName']);
          dropDownMenuEntries.add(me);
          menuClientUsers!.add(mclu);
        }
        nextId = largestId + 1;
        print('line 48: $nextId $largestId ${dropDownMenuEntries}');
        return dropDownMenuEntries;
      } else {
        nextId = 1;
        insertAddTemplateData();
        return [];
      }
      print('line 49: dropdownentries ${dropDownMenuEntries.length}');
    } catch (e) {
      print('line 49: error: ${e.toString()}');
      throw Exception('line 21 error getting dropdown menu items');
    }
  }

  String localTitle = 'Client ClientUsers';
  final rolesController = MultiSelectController<Role>();
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
  TextEditingController dateOfLastLoginController = TextEditingController();

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
    dateOfLastLoginController.dispose();
    rolesController.dispose();
    menuController.dispose();
  }

  Future<bool> _submit() async {
    print('line 110 in submit');
    bool bl = false;
    //regex email
    // final bool emailValid = RegExp(
    //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(email);
    DateTime dte = DateTime.parse(dateOfLastLoginController.text);
    List<dynamic> roles = [];

    for (int j = 0; j < selectedItems!.length; j++) {
      DropdownItem<Role> di = selectedItems![j];
      if (di.selected == false) {
        continue;
      }
      Role role = di.value;
      roles.add(role.role);
    }
    try {
      Map<String, dynamic> clt = {
        "clientId": clientId,
        "clientUserId": int.parse(clientUserIdController.text),
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "fullName": fullNameController.text,
        "active": bool.parse(activeController.text),
        "displayName": displayNameController.text,
        "email": emailController.text,
        "loginCounter": int.parse(loginCounterController.text),
        "password": passwordController.text,
        "userName": userNameController.text,
        "dateOfLastLogin": dte,
        "roles": roles
      };
      print('line 142 $clt');
      await clientServices.insertClientUser(clt);
      listOfClientUsers.clear();
      await _getDropDownMenuItems();
      resetData();
      return bl;
    } catch (e) {
      print('line 148 error: ${e.toString()}');
      return bl;
    }
  }

  int? nextId;
  int getSelectedMenuIndex(value) {
    print('line 155 getselected address index : $value');
    int index = -1;
    setState(() {
      resetData();
      showRightSide = false;
    });
    try {
      for (int i = 0; i < dropDownMenuEntries.length; i++) {
        DropdownMenuEntry de = dropDownMenuEntries[i];
        print('line 154: $value ${de.value}');
        if (value == de.value) {
          index = i;
          break;
        }
      }

      print('line 167: $index $arguments');

      if (index != -1) {
        Map<String, dynamic> clu = listOfClientUsers[index];
        documentId = clu['id'];
        print('line 172: $documentId ${clu['lastName']}');
        clientUserIdController.text = clu['clientUserId'].toString();
        firstNameController.text = clu['firstName'];
        lastNameController.text = clu['lastName'];
        fullNameController.text = clu['fullName'];
        activeController.text = clu['active'] == false ? 'false' : 'true';
        displayNameController.text =
            clu['displayName'] == null ? "" : clu['displayName'];
        emailController.text = clu['email'];
        loginCounterController.text =
            clu['loginCounter'] == null ? '0' : clu['loginCounter'].toString();
        passwordController.text = clu['password'];
        userNameController.text =
            clu['username'] == null ? '0' : clu['username'];
        dateOfLastLoginController.text =
            utilityServices.convertFromTimestamp(clu['dateOfLastLogin']);
        print('line 188 ${dateOfLastLoginController.text}');
        for (int i = 0; i < clu['roles'].length; i++) {
          String srole = clu['roles'][i];
          //   print('line 133: ${clu['roles'].length} $srole');
          for (int j = 0; j < items.length; j++) {
            DropdownItem di = items[j];
            Role role = di.value;
            //   print('line 137: $srole ${role.role}');
            // if (srole == role.role) {
            //   //     print('line 139 got hit: $srole $role');
            //   di.selected = true;
            // }
          }
        }
        return index;
      } else {
        throw Exception('line 196 did not find a client user');
      }
    } catch (e) {
      print('line 206 error: ${e.toString()}');
      throw Exception('line 207 ${e.toString()}');
    }
  }

  var items = [
    DropdownItem(label: 'Admin', value: Role(role: 'ClientAdmin', id: 1)),
    DropdownItem(label: 'DON', value: Role(role: 'ClientDON', id: 2)),
    DropdownItem(label: 'ADON', value: Role(role: 'ClientADON', id: 3)),
    DropdownItem(
        label: 'Scheduler', value: Role(role: 'ClientScheduler', id: 4)),
    DropdownItem(
        label: 'Shift Supervisor',
        value: Role(role: 'ClientSupervisor', id: 5)),
    DropdownItem(label: 'Staff', value: Role(role: 'ClientStaff', id: 6)),
    DropdownItem(
        label: 'Accounting', value: Role(role: 'ClientAccount', id: 7)),
    DropdownItem(label: 'Manager', value: Role(role: 'ClientManager', id: 8)),
  ];
  int? clientId;
  // Future<bool> _submit() async {}
  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    clientId = arguments!['clientId'];
    print('line 72 arguments $arguments');
  }

  void resetData() {
    formKey.currentState?.reset();
    clientUserIdController.text = "";
    firstNameController.text = "";
    lastNameController.text = "";
    fullNameController.text = "";
    activeController.text = "";
    displayNameController.text = "";
    emailController.text = "";
    loginCounterController.text = "";
    passwordController.text = "";
    userNameController.text = "";
    dateOfLastLoginController.text = "";
    rolesController.clearAll();
  }

  void insertAddTemplateData() {
    print('line 246: $nextId');
    clientUserIdController.text = nextId.toString();
    firstNameController.text = "";
    lastNameController.text = "";
    fullNameController.text = "";
    activeController.text = "";
    displayNameController.text = "";
    emailController.text = "";
    loginCounterController.text = "0";
    passwordController.text = "";
    userNameController.text = "";
    dateOfLastLoginController.text = "";
    setState(() {
      showRightSide = true;
    });
  }

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
  String genericTitle = '';
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double totalCurrentBalance = 0.0;
  double h = 1.0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const title = 'Client Address Form';
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    double? hh = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    h = hh!;
    if (h < 1.0) {
      h = 1.0;
    }
    fontSize = 16 / h;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localTitle,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: VerticalSplitView(
            left: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: color1,
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 200,
                          width: 300,
                          padding: EdgeInsets.only(top: 5),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: FutureBuilder(
                                  future: Future.wait([
                                    _getDropDownMenuItems(),
                                  ]),
                                  builder: (context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    debugPrint(
                                        'line 417 building FB ${snapshot.connectionState}');
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 30),
                                          child: Container(
                                            height: 110,
                                            child: Text(
                                                'Error: ${snapshot.error}',
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.data == [[]] &&
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 30),
                                          child: Container(
                                            height: 100,
                                            width: screenWidth! - 10,
                                            child: Text(
                                                overflow: TextOverflow.visible,
                                                'There are no ClientUsers for this client.',
                                                style: TextStyle(
                                                    fontSize: fontSize,
                                                    color: color2,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      );
                                    } else {
                                      List<dynamic> listH = snapshot.data![0];
                                      print('line 111 ${listH.length}');
                                      if (listH.length == 0) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 30),
                                            child: Container(
                                              height: 100,
                                              width: screenWidth! - 10,
                                              child: Text(
                                                  'There are no ClientUsers for this client.',
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: TextStyle(
                                                      fontSize: fontSize,
                                                      color: color2,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        );
                                      } else {
                                        List<dynamic> listD =
                                            snapshot.data![0]!;
                                        print('line 260 ${listD.length}');

                                        return Container(
                                          height: 80,
                                          width: screenWidth! - 10,
                                          child: Column(
                                            children: [
                                              DropdownMenu<dynamic>(
                                                initialSelection: null,
                                                controller: menuController,
                                                requestFocusOnTap: true,
                                                label: const Text(
                                                    'Client User Menu'),
                                                onSelected: (dynamic value) {
                                                  print(
                                                      'line 278 on selected $value');
                                                  selectedMenu = value;
                                                  selectedMenuIndex =
                                                      getSelectedMenuIndex(
                                                          value);
                                                  print(
                                                      'line 283: $selectedMenuIndex');
                                                  selectedMenuName =
                                                      menuClientUsers![
                                                              selectedMenuIndex!]
                                                          ['clientUser'];
                                                  setState(() {
                                                    dropDownMenuOptionEntries =
                                                        [];
                                                    showRightSide = true;
                                                    genericTitle =
                                                        'Client Profile Menu';
                                                  });
                                                },
                                                dropdownMenuEntries:
                                                    dropDownMenuEntries,
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              if (selectedMenu != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Selected: ${selectedMenu}'),
                                  ],
                                )
                              else
                                const Text('Please select a Client User.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        print('line 662 insert add template');
                        insertAddTemplateData();
                      },
                      child: Text('Insert Add Template'),
                    ),
                  ],
                )),
            right: showRightSide == true
                ? Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: screenWidth / 3,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: screenWidth / 7,
                                          child: TextFormField(
                                            controller: clientUserIdController,
                                            maxLength: 10,
                                            decoration: InputDecoration(
                                                label: Text('Client User Id')),
                                            validator: (value) {
                                              return null;
                                              //'some data' failed validation
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          height: 50,
                                          width: screenWidth / 7,
                                          child: TextFormField(
                                              controller: activeController,
                                              maxLength: 10,
                                              decoration: InputDecoration(
                                                  label: Text('Active')),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "You must enter a value for active";
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    height: 50,
                                    width: screenWidth / 3,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: screenWidth / 7,
                                          child: TextFormField(
                                              controller: firstNameController,
                                              maxLength: 50,
                                              decoration: InputDecoration(
                                                  label: Text('First Name')),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "You must enter a first name.";
                                                }
                                                return null;
                                              }),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          height: 50,
                                          width: screenWidth / 7,
                                          child: TextFormField(
                                              controller: lastNameController,
                                              maxLength: 50,
                                              decoration: InputDecoration(
                                                  label: Text('Last Name')),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "You must enter a last name.";
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: screenWidth / 3,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: screenWidth / 7,
                                          child: TextFormField(
                                              controller: fullNameController,
                                              maxLength: 100,
                                              decoration: InputDecoration(
                                                  label: Text('fullName')),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "You must enter a full name.";
                                                }
                                                return null;
                                              }),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          height: 50,
                                          width: screenWidth / 7,
                                          child: TextFormField(
                                              controller:
                                                  dateOfLastLoginController,
                                              maxLength: 30,
                                              decoration: InputDecoration(
                                                  label: Text(
                                                      'Date Of Last Login')),
                                              validator: (value) {
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                      height: 50,
                                      width: screenWidth / 3,
                                      child: TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: emailController,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              label: Text('Email')),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "You must enter an email.";
                                            }
                                            return null;
                                          })),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 50,
                                    width: screenWidth / 3,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: screenWidth / 7,
                                          child: TextFormField(
                                              controller:
                                                  loginCounterController,
                                              maxLength: 10,
                                              decoration: InputDecoration(
                                                  label: Text('Login Counter')),
                                              validator: (value) {
                                                return null;
                                              }),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          height: 50,
                                          width: screenWidth / 7,
                                          child: TextFormField(
                                              controller: userNameController,
                                              maxLength: 30,
                                              decoration: InputDecoration(
                                                  label: Text('Username')),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "You must enter a username.";
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: screenWidth / 3,
                                    child: Row(children: [
                                      Container(
                                        height: 50,
                                        width: screenWidth / 7,
                                        child: TextFormField(
                                            controller: passwordController,
                                            maxLength: 20,
                                            decoration: InputDecoration(
                                                label: Text('Password ')),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "You must enter a password.";
                                              }
                                              return null;
                                            }),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        height: 50,
                                        width: screenWidth / 7,
                                        child: TextFormField(
                                            controller: displayNameController,
                                            maxLength: 60,
                                            decoration: InputDecoration(
                                                label: Text('Display Name')),
                                            validator: (value) {
                                              return null;
                                            }),
                                      ),
                                    ]),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 50,
                                    width: 300,
                                    child: MultiDropdown<Role>(
                                      items: items,
                                      controller: rolesController,
                                      enabled: true,
                                      searchEnabled: true,
                                      chipDecoration: ChipDecoration(
                                        backgroundColor: color1,
                                        wrap: true,
                                        runSpacing: 2,
                                        spacing: 10,
                                      ),
                                      fieldDecoration: FieldDecoration(
                                        hintText: 'Roles',
                                        hintStyle: const TextStyle(
                                            color: Colors.black87),
                                        prefixIcon: const Icon(
                                            CupertinoIcons.app_badge),
                                        showClearIcon: false,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      dropdownDecoration:
                                          const DropdownDecoration(
                                        marginTop: 2,
                                        maxHeight: 500,
                                        header: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'Select Roles from the list',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      dropdownItemDecoration:
                                          DropdownItemDecoration(
                                        selectedIcon: const Icon(
                                            Icons.check_box,
                                            color: Colors.green),
                                        disabledIcon: Icon(Icons.lock,
                                            color: Colors.grey.shade300),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a role';
                                        }
                                        return null;
                                      },
                                      onSelectionChange: (selectedItems) {
                                        debugPrint(
                                            "OnSelectionChange: $selectedItems");
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      rolesController.openDropdown();
                                    },
                                    child: const Text('Open/Close dropdown'),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.only(left: 480),
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            bool? bl = formKey.currentState
                                                ?.validate();
                                            if (bl != null && bl == false) {
                                              print('line 789: $bl');
                                            } else {
                                              print('line 791 bl is null');
                                              selectedItems =
                                                  rolesController.selectedItems;
                                              await _submit();
                                            }
                                          },
                                          child: Text('Save'),
                                        ),
                                        SizedBox(width: 5),
                                        ElevatedButton(
                                          onPressed: () {
                                            print('line 662 reset');
                                            resetData();
                                          },
                                          child: Text('Reset Form'),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container()),
      ),
    );
  }
}

class VerticalSplitView extends StatefulWidget {
  final Widget left;
  final Widget right;
  final double ratio;

  const VerticalSplitView(
      {Key? key, required this.left, required this.right, this.ratio = 0.25});

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
    // _ratio = .25;
    print('line 99: $_ratio');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      if (_maxWidth == null) _maxWidth = constraints.maxWidth - _dividerWidth;
      if (_maxWidth != constraints.maxWidth) {
        _maxWidth = constraints.maxWidth - _dividerWidth;
      }
      print('line 622: $_maxWidth');
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
