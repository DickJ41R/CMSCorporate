//import 'package:hcp_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:async';
import 'package:syncfusion_flutter_core/theme.dart';
//import 'package:hcp_app/screens/show_hcp_file_menu.dart';
import 'package:cms_web/features/hcpapp/services/hcp_services.dart';
import 'package:cms_web/features/hcpapp/models/hcprofessional_data_model.dart';
//import 'package:hcp_app/pages/login/login.dart';

class ProcessSearchHCPsScreen extends StatefulWidget {
  final Map<String, String> args;
  ProcessSearchHCPsScreen({super.key, required this.args});

  @override
  _ProcessSearchHCPsScreenState createState() =>
      _ProcessSearchHCPsScreenState();
}

class _ProcessSearchHCPsScreenState extends State<ProcessSearchHCPsScreen> {
  bool hasSelectionData = false;
  List<HCProfessionalDataModel>? hcpDataSource;
  final searchController = TextEditingController();
// To perform a search in the DataGrid.
  final DataGridController _dataGridController = DataGridController();
  var _selectedRow;
  var _selectedIndex;
  HCPServices hcpServices = HCPServices();
  late DataGridSource hcpDataClassSource;
  Map<String, String>? arguments;
  Future<List<HCProfessionalDataModel>> getAllHCPs() async {
    print('line 40: $arguments!');

    try {
      List<HCProfessionalDataModel>? hcpData =
          await hcpServices.getHCPDataFromSearch(arguments!);
      print('line 46: $arguments! $hcpData');
      //_clients = clients;
      if (hcpData.isEmpty || hcpData == []) {
        print('line 48:');
        return [];
      }
      print('line 51 ${hcpData.length}');

      dynamic ds = HCPDataSource(hcps: hcpData);
      hcpDataClassSource = ds;
      List<DataGridRow> rows = ds.getDataGridRows();
      List<DataGridCell> cells = rows[0].getCells();
      print('line 56: ${cells[0].columnName}');

      return hcpData;
    } catch (e) {
      print('line 60 _processhcp error: $e');
      return [];
//rethrow
//throw Exception('Error getting client invoices: $e');
    }
  }

  String? selectedName;
  String? selectedClientId;
////  Future<List<dynamic>>? getClientsX(context) async {
  //   clientDataSource = await getClients(context);
  //   return clientDataSource;
  // }

  @override
  void initState() {
    super.initState();
    arguments = widget.args;
    print('line 75 in initstate ${arguments!}');
    // getClientsX(context);

    //dataRetrievalAndFiltering = getHCPList();
    // dataRetrievalAndFiltering.then(  (value) {
    //   print('line 91: $value');
    //    return value;
    // });
  }

  List<GridColumn> get getColumns {
    return <GridColumn>[
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Name',
          width: columnWidths['Name']!,
          label: Container(
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Name',
                // style: TextStyle(
                //   fontSize:16,
                //   fontWeight: FontWeight.bold
                // ),
              ))),
      GridColumn(
          allowSorting: true,
          allowFiltering: true,
          columnName: 'Disc',
          width: columnWidths['Disc']!,
          label: Container(
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Disc',
                // style: TextStyle(
                //     fontSize:16,
                //     fontWeight: FontWeight.bold
                // ),
              ))),
      GridColumn(
          columnName: 'Date',
          width: columnWidths['Date']!,
          label: Container(
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Date',
                // style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold
                // ),
                overflow: TextOverflow.ellipsis,
              ))),
      // GridColumn(
      //     columnName: 'Branch',
      //     width: columnWidths['Branch']!,
      //     label: Container(
      //         padding: const EdgeInsets.all(4.0),
      //         alignment: Alignment.centerLeft,
      //         child: const Text(
      //           'Branch',
      //           overflow: TextOverflow.ellipsis,
      //         ))),
      GridColumn(
          columnName: 'Status',
          allowFiltering: true,
          allowSorting: true,
          width: columnWidths['Status']!,
          label: Container(
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Sta',
                // style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold
                // ),
                overflow: TextOverflow.ellipsis,
              ))),
    ];
  }

  DataGridSource? dgs;
  late Map<String, double> columnWidths = {
    'Name': 165.0,
    'Disc': 70.0,
    'Date': 85.0,
    'Status': 60.0,
  };
  Color color1 = Color.fromARGB(255, 134, 219, 197); //green from website
  Color color2 = Color.fromARGB(255, 19, 125, 103); //green from logo
  Color color3 = Colors.grey.shade200;
  double? screenWidth;
  double? screenHeight;
  double fontSize = 18;
  double largeFontSize = 18;
  double? h;
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    h = MediaQuery.maybeOf(context)?.textScaler.scale(1.0);
    if (h! < 1.0) {
      h = 1.0;
    }
    print('line 182 screenheight: $screenHeight');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color.fromARGB(255, 13, 125, 103),
        actions: <Widget>[
          // IconButton(
          //     icon: const Icon(Icons.close),
          //     onPressed: () {
          //       //getMessageStream();
          //       Navigator.pop(context);
          //     }),
        ],
        title: const Center(
          child: Text(
            "HCP Listing",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: Future.wait([
                getAllHCPs(),
              ]),
              builder: (context, snapshot) {
                print(
                    'line 129: ${snapshot.data}  ${snapshot.connectionState} ${snapshot.hasData}');
                if (snapshot.connectionState == ConnectionState.done &&
                    (snapshot.hasData == false || snapshot.data == [[]])) {
                  // Run a task after the first frame is displayed
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop(null);
                  });
                } else if (snapshot.connectionState ==
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
                      height: 110,
                      width: screenWidth! - 10,
                      child: SizedBox(
                          height: 10,
                          child: Text('Error: ${snapshot.error}',
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .fontSize! /
                                      h!,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold))),
                    ),
                  );
                } else if (snapshot.data == [[]] &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        height: 110,
                        width: screenWidth! - 10,
                        child: Text(
                            'There are no health care professionals for the entered data.',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .fontSize! /
                                    h!,
                                color: color2,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                } else {
                  hcpDataSource = snapshot.data![0]; // cast to List<Marker>
                  print('line 111 ${hcpDataSource!.length}');
                  if (hcpDataSource!.length == 0) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Container(
                          height: 110,
                          width: screenWidth! - 10,
                          child: Text(
                              'There are no health care professionals for the entered data.',
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .fontSize! /
                                      h!,
                                  color: color2,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                      height: 600,
                      width: screenWidth! - 10,
                      child: SfDataGridTheme(
                        data: SfDataGridThemeData(gridLineStrokeWidth: 2.0),
                        child: SfDataGrid(
                          source: hcpDataClassSource,
                          columns: getColumns,
                          allowSorting: false,
                          controller: _dataGridController,
                          columnWidthMode: ColumnWidthMode.fill,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.row,
                          gridLinesVisibility: GridLinesVisibility.horizontal,
                          headerGridLinesVisibility:
                              GridLinesVisibility.horizontal,
                          allowFiltering: false,
                        ),
                      ),
                    );
                  }
                  return Container();
                }
                return Container();
              },
            ),
            SizedBox(height: 10),
            Container(
              height: 60,
              width: screenWidth! - 10,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black87, width: 4),
                  borderRadius: BorderRadius.circular(12)),
              child: TextButton(
                  child: const Text(
                    'Save HCP',
                    style: TextStyle(
                      color: Color.fromARGB(255, 19, 125, 103),
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    //SelectedIndex
                    _selectedIndex = _dataGridController.selectedIndex;

                    //SelectedRow
                    _selectedRow = _dataGridController.selectedRow;
                    print('line 306: $_selectedRow');
                    print('line 307: $_selectedIndex');
                    if (_selectedRow == null) {
                      Widget exitButton = TextButton(
                          child: const Text(
                            "Exit",
                            style: TextStyle(
                                color: Color.fromARGB(255, 19, 125, 103)),
                          ),
                          onPressed: () {
                            print('line 265 exit button');
                            Navigator.of(context).pop(null);
                          });
                      Widget cancelButton = TextButton(
                        child: const Text("Cancel",
                            style: TextStyle(
                                color: Color.fromARGB(255, 19, 125, 103))),
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                      );
                      AlertDialog alert = AlertDialog(
                          title: const Text('Exit Issue',
                              style: TextStyle(
                                color: Colors.black87,
                              )),
                          content: const Text(
                              'You have not selected an Employee.  Do you still wish to Exit?',
                              style: TextStyle(
                                color: Colors.black87,
                              )),
                          actions: [
                            exitButton,
                            cancelButton,
                          ]);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    } else {
                      List<DataGridCell> cells = _selectedRow.getCells();
                      print(
                          'line 353: ${cells[0].columnName}, ${cells[0].value}');
                      String hName = cells[0].value;
                      HCProfessionalDataModel? fnr;
                      for (int i = 0; i < hcpDataSource!.length; i++) {
                        HCProfessionalDataModel hcpm = hcpDataSource![i];
                        if (hName == hcpm.hcpName) {
                          fnr = hcpm;
                          break;
                        }
                      }
                      // selectedName = "(" +
                      //     cells[0].value.toString() +
                      //     ") " +
                      //     cells[1].value.toString();
                      // print('line 361 $selectedName');
                      if (fnr != null) {
                        print('line 403 $fnr ${fnr.hcpName}');
                      }
                      Navigator.of(context).pop(fnr);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class HCPDataSource extends DataGridSource {
  final List<HCProfessionalDataModel> hcps;
  HCPDataSource({required this.hcps}) {
    print('line 183: ${hcps[0].hcpId}');
    _hcpdata = hcps
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Name', value: e.hcpName),
              DataGridCell<String>(columnName: 'Disc', value: e.disciplineName),
              DataGridCell<String>(
                  columnName: 'Date', value: e.shiftDateString),
              DataGridCell<String>(columnName: 'Status', value: e.shiftStatus),
            ]))
        .toList();
  }
  List<DataGridRow> getDataGridRows() {
    return _hcpdata;
  }

  List<DataGridRow> _hcpdata = [];

  @override
  List<DataGridRow> get rows => _hcpdata;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getBackgroundColor() {
      int index = effectiveRows.indexOf(row);
      if (index % 2 == 0) {
        return Colors.grey.shade200;
      } else {
        return Colors.white;
      }
    }

    return DataGridRowAdapter(
        color: getBackgroundColor(),
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}
