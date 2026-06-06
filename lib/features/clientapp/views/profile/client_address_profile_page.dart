
import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/services/clientapp/client_services.dart';

class ClientAddressProfilePage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ClientAddressProfilePage({super.key, required this.args});

  @override
  State<ClientAddressProfilePage> createState() =>
      _ClientAddressProfilePageState();
}

class _ClientAddressProfilePageState extends State<ClientAddressProfilePage> {
  final formKey = GlobalKey<FormState>();

  ClientServices clientServices = ClientServices();

  Map<String, dynamic>? arguments;
  List<Map<String, dynamic>> listOfAddresses = [];
  List<Map<String, dynamic>>? menuAddresses;
  List<DropdownMenuEntry<dynamic>> dropDownMenuEntries = [];
  List<DropdownMenuEntry<dynamic>> dropDownMenuOptionEntries = [];

  Future<List<dynamic>> _getDropDownMenuItems() async {
    debugPrint(
        'line 30 get client address Dropdownitems: ${listOfAddresses.length}');
    dropDownMenuEntries = [];
    menuAddresses = [];
    try {
      if (listOfAddresses.length == 0) {
        listOfAddresses =
            await clientServices.getClientAddressData(arguments!['clientId']);
      }
      debugPrint('line 35: ${listOfAddresses!.length}');
      if (listOfAddresses.length > 0) {
        for (int i = 0; i < listOfAddresses!.length; i++) {
          Map<String, dynamic> adr = listOfAddresses![i];

          Map<String, dynamic> madr = {
            'addressType': adr['addressType'],
            'addressName': adr['addressType']
          };
          DropdownMenuEntry me = DropdownMenuEntry(
              value: madr['addressType'], label: madr['addressType']);
          dropDownMenuEntries.add(me);
          menuAddresses!.add(madr);
        }
        debugPrint('line 48: ${dropDownMenuEntries}');
        return dropDownMenuEntries;
      } else {
        return [];
      }
      debugPrint('line 49: dropdownentries ${dropDownMenuEntries.length}');
    } catch (e) {
      debugPrint('line 49: error: ${e.toString()}');
      throw Exception('line 21 error getting dropdown menu items');
    }
  }

  Future<void> _update() async {
    debugPrint(
        'line 60 in address update:$isPrimary ${addressLine1Controller.text} ${addressLine2Controller.text} ${cityController.text} ${stateController.text} ${zipCodeController.text} ${countyController.text} ${latitudeController.text} ${longitudeController.text}');
    try {
      Map<String, dynamic> data = {
        "clientId": arguments!['clientId'],
        "addressLine1": addressLine1Controller.text,
        "addressLine2": addressLine2Controller.text,
        "city": cityController.text,
        "state": stateController.text,
        "county": countyController.text,
        "zipCode": zipCodeController.text,
        "latitude":
            isPrimary == true ? double.parse(latitudeController.text) : null,
        "longitude":
            isPrimary == true ? double.parse(longitudeController.text) : null,
      };
      debugPrint('line 76 just call ${currentAddressId!} ${data}');
      bool? bl =
          await clientServices.updateClientAddressForm(currentAddressId!, data);
      debugPrint('line 85');
      formKey.currentState?.reset();
      _initializeControllers();
      listOfAddresses = [];
      _getDropDownMenuItems();
      return;
    } catch (e) {
      debugPrint('line 76 error: ${e.toString()}');
    }
  }

  bool isPrimary = false;
  String localTitle = 'Client Addresses';
  String? clientName;
  //controllers
  TextEditingController clientNameController = TextEditingController();
  TextEditingController addressTypeController = TextEditingController();
  TextEditingController addressNameController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController countyController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  void _initializeControllers() {
    addressTypeController.text = "";
    addressNameController.text = "";
    addressLine1Controller.text = "";
    addressLine2Controller.text = "";
    cityController.text = "";
    stateController.text = "";
    zipCodeController.text = "";
    countyController.text = "";
    latitudeController.text = "";
    longitudeController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    clientNameController.dispose();
    addressTypeController.dispose();
    addressNameController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    countyController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    menuController.dispose();
  }

  int getSelectedMenuIndex(value) {
    debugPrint('line 57 getselected address index : $value');
    int index = -1;
    isPrimary = false;
    for (int i = 0; i < dropDownMenuEntries.length; i++) {
      DropdownMenuEntry de = dropDownMenuEntries[i];
      debugPrint('line 142: $value ${de.value}');
      if (value == de.value) {
        if (value == 'Primary') {
          isPrimary = true;
        }
        index = i;
        break;
      }
    }
    debugPrint('line 62: $isPrimary $index $arguments');
    if (index != -1) {
      clientNameController.text = arguments!['clientName'];

      Map<String, dynamic> adr = listOfAddresses![index];
      debugPrint('line 104: $adr');
      currentAddressId = adr['id'];
      addressTypeController.text = adr['addressType'];
      addressNameController.text =
          adr['addressName'] == null ? "" : adr['addressName'];
      addressLine1Controller.text = adr['addressLine1'];
      addressLine2Controller.text =
          adr['addressLine2'] == null ? "" : adr['addressLine2'];
      cityController.text = adr['city'];
      stateController.text = adr['state'];
      zipCodeController.text = adr['zipCode'].toString();
      countyController.text = adr['county'] == null ? "" : adr['county'];
      debugPrint('line 113 $isPrimary');

      if (adr['addressType'] == 'Primary') {
        isPrimary = true;
        latitudeController.text = adr['latitude'].toString();
        longitudeController.text = adr['longitude'].toString();
      }
      debugPrint('line 118 ${latitudeController.text}');
    } else {
      throw Exception('line 177 index = -1');
    }
    return index;
  }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    debugPrint('line 72 arguments $arguments');
  }

  double? screenHeight;
  double? fontSize;
  String? selectedMenu;
  String? selectedMenuName;
  int? selectedMenuNumber;
  int? selectedMenuIndex;
  bool flagHaveData = false;
  String? currentAddressId;
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
                decoration: BoxDecoration(
                  color: color1,
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    //  SizedBox(width: screenWidth - 10, height: 5),
                    Row(
                      children: [
                        Container(
                          height: 200,
                          width: 270,
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
                                            width: 270,
                                            child: Text(
                                                overflow: TextOverflow.visible,
                                                'There are no addresses for this client.',
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
                                      debugPrint('line 111 ${listH.length}');
                                      if (listH.length == 0) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 30),
                                            child: Container(
                                              height: 100,
                                              width: 270,
                                              child: Text(
                                                  'There are no addresses for this client.',
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
                                        debugPrint('line 260 ${listD.length}');

                                        return Container(
                                          height: 80,
                                          width: 270,
                                          child: Column(
                                            children: [
                                              DropdownMenu<dynamic>(
                                                initialSelection: null,
                                                controller: menuController,
                                                requestFocusOnTap: true,
                                                label: const Text(
                                                    'Client Address Menu'),
                                                onSelected: (dynamic value) {
                                                  debugPrint(
                                                      'line 278 on selected $value');
                                                  selectedMenu = value;
                                                  selectedMenuIndex =
                                                      getSelectedMenuIndex(
                                                          value);
                                                  debugPrint(
                                                      'line 283: $isPrimary $selectedMenuIndex');
                                                  selectedMenuName =
                                                      menuAddresses![
                                                              selectedMenuIndex!]
                                                          ['addressType'];
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
                                const Text('Please select a Client Address.'),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )),
            right: showRightSide == true
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                            key: formKey,
                            child: Column(children: [
                              Container(
                                height: 50,
                                width: 320,
                                child: TextFormField(
                                  controller: clientNameController,
                                  maxLength: 200,
                                  decoration: InputDecoration(
                                      label: Text('Client Name')),
                                  validator: (value) {
                                    return null;
                                    //'some data' failed validation
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: TextFormField(
                                    controller: addressTypeController,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                        label: Text('Address Type')),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "You must enter an address type";
                                      }
                                      return null;
                                    }),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 50,
                                width: 320,
                                child: TextFormField(
                                    controller: addressLine1Controller,
                                    maxLength: 200,
                                    decoration: InputDecoration(
                                        label: Text('Address Line 1')),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "You must enter an address type";
                                      }
                                      return null;
                                    }),
                              ),
                              Container(
                                height: 50,
                                width: 320,
                                child: TextFormField(
                                    controller: addressLine2Controller,
                                    maxLength: 200,
                                    decoration: InputDecoration(
                                        label: Text('Address Line 2')),
                                    validator: (value) {
                                      return null;
                                    }),
                              ),
                              Container(
                                height: 50,
                                width: 320,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                          controller: cityController,
                                          maxLength: 80,
                                          decoration: InputDecoration(
                                              label: Text('City')),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "You must enter a city.";
                                            }
                                            return null;
                                          }),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                        height: 50,
                                        width: 155,
                                        child: TextFormField(
                                            controller: zipCodeController,
                                            maxLength: 10,
                                            decoration: InputDecoration(
                                                label: Text('Zip Code')),
                                            validator: (value) {
                                              return null;
                                            })),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 320,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                          controller: stateController,
                                          decoration: InputDecoration(
                                              label: Text('State (eg TN)')),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "You must enter state code.";
                                            }
                                            if (value.length > 2) {
                                              return "State length > 2";
                                            }
                                            return null;
                                          }),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      height: 50,
                                      width: 155,
                                      child: TextFormField(
                                          controller: countyController,
                                          decoration: InputDecoration(
                                              label: Text('County')),
                                          validator: (value) {
                                            return null;
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              isPrimary == false
                                  ? Container()
                                  : Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 320,
                                          child: TextFormField(
                                              controller: latitudeController,
                                              maxLength: 30,
                                              decoration: InputDecoration(
                                                  label: Text('Latitude')),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "You must enter a Latitude.";
                                                }
                                                if (double.tryParse(value) ==
                                                    null) {
                                                  return "Enter numeric values for latitude.";
                                                }
                                                return null;
                                              }),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 320,
                                          child: TextFormField(
                                              controller: longitudeController,
                                              maxLength: 30,
                                              decoration: InputDecoration(
                                                  label: Text('Longitude')),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "You must enter a Longitude.";
                                                }
                                                if (double.tryParse(value) ==
                                                    null) {
                                                  return "Enter numeric values for longitude.";
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                            ])),
                        SizedBox(height: 10),
                        Center(
                          child: Container(
                            height: 50,
                            width: 320,
                            child: ElevatedButton(
                              onPressed: () {
                                bool? bl = formKey.currentState?.validate();
                                if (bl != null && bl == false) {
                                  debugPrint('line 529: $bl');
                                  return;
                                }
                                debugPrint('line 570: ${bl!}');
                                _update();
                              },
                              child: Text('Update'),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Container(
                            height: 50,
                            width: 320,
                            child: ElevatedButton(
                              onPressed: () {
                                formKey.currentState?.reset();
                              },
                              child: Text('Reset From'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()),
      ),
    );
  }
}
//   List<Widget> _buildForm(BuildContext context) {
//     bool isPrimary = true;
//     double screenWidth = MediaQuery.of(context).size.width;
//     debugPrint('line 240: $screenWidth $clientName');
//     return [
//         children: [
//           Container(
//             height: 40,
//             width: screenWidth / 3,
//             child: const FastTextField(
//               name: 'clientName',
//               labelText: 'Client Name',
//               placeholder: 'Client Name',
//             ),
//           ),
//           Container(
//             height: 40,
//             width: screenWidth / 3,
//             child: const FastTextField(
//               name: 'addressType',
//               labelText: 'Address Type',
//               placeholder: 'Type',
//             ),
//           ),
//           Container(
//             height: 40,
//             width: screenWidth / 3,
//             child: FastTextField(
//               name: 'addressName',
//               labelText: 'Address Name',
//               placeholder: 'Name',
//             ),
//           ),
//           Container(
//             height: 40,
//             width: screenWidth / 3,
//             child: const FastTextField(
//               name: 'addressLine1',
//               labelText: 'Address 1',
//               placeholder: 'Address',
//             ),
//           ),
//           Container(
//             height: 40,
//             width: screenWidth / 3,
//             child: const FastTextField(
//               name: 'addressLine2',
//               labelText: 'Address',
//               placeholder: 'Address',
//             ),
//           ),
//           Container(
//             height: 40,
//             width: screenWidth / 3,
//             child: Row(
//               children: [
//                 Container(
//                   height: 40,
//                   width: screenWidth / 7,
//                   child: const FastTextField(
//                     name: 'city',
//                     labelText: 'City',
//                     placeholder: 'city',
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Container(
//                   height: 40,
//                   width: screenWidth / 7,
//                   child: const FastTextField(
//                     name: 'state',
//                     labelText: 'State',
//                     placeholder: 'ST',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 40,
//             width: screenWidth / 3,
//             child: Row(
//               children: [
//                 Container(
//                   height: 40,
//                   width: screenWidth / 7,
//                   child: const FastTextField(
//                     name: 'zipCode',
//                     labelText: 'Zip Code',
//                     placeholder: 'zip',
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Container(
//                   height: 40,
//                   width: screenWidth / 7,
//                   child: const FastTextField(
//                     name: 'county',
//                     labelText: 'County',
//                     placeholder: 'county',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           isPrimary == false
//               ? Container()
//               : Column(
//                   children: [
//                     Container(
//                       height: 40,
//                       width: screenWidth / 3,
//                       child: const FastTextField(
//                         name: 'latitude',
//                         labelText: 'Latitude',
//                         placeholder: 'latitude',
//                       ),
//                     ),
//                     Container(
//                       height: 40,
//                       width: screenWidth / 3,
//                       child: const FastTextField(
//                         name: 'longitude',
//                         labelText: 'Longitude',
//                         placeholder: 'longitude',
//                       ),
//                     ),
//                   ],
//                 ),
//         ],
//       )
//     ];
//   }
// }

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
    debugPrint('line 99: $_ratio');
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
