import 'package:cms_web/features/shared/utils/dropdown_codes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DropDownCodes dropDownCodes = DropDownCodes();

class ClientDNU {
  ClientDNU(
      {required this.dnuId,
      required this.hcpId,
      required this.clientId,
      required this.departmentId,
      required this.comments,
      required this.lastTouched,
      required this.flagDNU,
      required this.flagClientDNU,
      required this.flagHCPDNU,
      required this.dnuDate,
      required this.clientDNUDate,
      required this.hcpDNUDate,
      required this.ownerId});
  final int dnuId;
  final int hcpId;
  final int clientId;
  final int departmentId;
  final String comments;
  final String? lastTouched;
  final bool flagDNU;
  final bool flagClientDNU;
  final bool flagHCPDNU;
  final String? dnuDate;
  final String? clientDNUDate;
  final String? hcpDNUDate;
  final String ownerId;

  factory ClientDNU.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ClientDNU(
      dnuId: data?["dnuId"],
      hcpId: data?['hcpId'],
      clientId: data?["clientId"],
      departmentId: data?['departmentId'],
      comments: data?['comments'],
      lastTouched: data?['lastTouched:'],
      flagDNU: data?['flagDNU'],
      flagClientDNU: data?['flagClientDNU'],
      flagHCPDNU: data?['flagHCPDNU'],
      dnuDate: data?['dnuDate'],
      clientDNUDate: data?['clientDNUDate'],
      hcpDNUDate: data?['hcpDNUDate'],
      ownerId: data?['ownerId'],
    );
  }

  Map<String, dynamic> getClientDNUModelData(Map<String, dynamic> imp) {
    Map<String, dynamic> dataElements = {};
    String dms;
    List<dynamic> lutc = [];
    imp.forEach((k, v) {
      print('line 13 getdnumodel: $k $v');
      switch (k) {
        case 'DnuID':
          {
            dataElements['dnuId'] = int.parse(v);
          }
          break;
        case 'RegID':
          {
            dataElements['hcpId'] = int.parse(v);
          }
          break;
        case 'ClientID':
          {
            dataElements['clientId'] = int.parse(v);
          }
          break;
        case 'DeptID':
          {
            dataElements['departmentId'] = int.parse(v);
          }
          break;
        case 'Comments':
          {
            if (v == null) {
              v = '';
            }
            dataElements['comments'] = v;
          }
          break;
        case 'LastTouched':
          {
            dms = DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0).toIso8601String();
            dataElements['lastTouched'] = dms;
          }
          break;
        case 'DNU':
          {
            dataElements['flagDNU'] = (v == 'True');
          }
          break;
        case 'ClientDNS':
          {
            dataElements['flagClientDNU'] = (v == 'True');
          }
          break;
        case 'RegistrantDNS':
          {
            dataElements['flagHCPDNU'] = (v == 'True');
          }
        case 'DNUDate':
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              if (v != null) {
                lutc = dropDownCodes.reformatDate(v,
                    convertUtc: true, isTime: false);
                if (lutc.isNotEmpty) {
                  dms = DateTime.utc(
                          lutc[0], lutc[1], lutc[2], lutc[3], lutc[4], lutc[5])
                      .toIso8601String();
                  dataElements['dnuDate'] = dms;
                } else {
                  dms =
                      DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0).toIso8601String();
                  dataElements['dnuDate'] = dms;
                }
              } else {
                dms = DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0).toIso8601String();
                dataElements['dnuDate'] = dms;
              }
            }
          }
          break;
        case 'ClientDNSDate':
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              if (v != null) {
                lutc = dropDownCodes.reformatDate(v,
                    convertUtc: true, isTime: false);
                if (lutc.isNotEmpty) {
                  dataElements['clientDNUDate'] = DateTime.utc(
                      lutc[0], lutc[1], lutc[2], lutc[3], lutc[4], lutc[5]);
                } else {
                  dms =
                      DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0).toIso8601String();
                  dataElements['clientDNUDate'] = dms;
                }
              } else {
                dms = DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0).toIso8601String();
                dataElements['clientDNUDate'] = dms;
              }
            } else {
              dms = DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0).toIso8601String();
              dataElements['clientDNUDate'] = dms;
            }
          }
          break;
        case 'RegistrantDNSDate':
          {
            bool b = dropDownCodes.isNullEmptyOrFalse(v);
            if (b == false) {
              if (v != null) {
                lutc = dropDownCodes.reformatDate(v,
                    convertUtc: true, isTime: false);
                if (lutc.isNotEmpty) {
                  dms = DateTime.utc(
                          lutc[0], lutc[1], lutc[2], lutc[3], lutc[4], lutc[5])
                      .toIso8601String();
                  dataElements['hcpDNUDate'] = dms;
                } else {
                  dms =
                      DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0).toIso8601String();
                  dataElements['hcpDNUDate'] = dms;
                }
              } else {
                dms = DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0).toIso8601String();
                dataElements['hcpDNUDate'] = dms;
              }
            } else {
              dms = DateTime.utc(1900, 1, 1, 0, 0, 0, 0, 0).toIso8601String();
              dataElements['hcpDNUDate'] = dms;
            }
          }
          break;
        default:
          {}
          break;
      }
    });
    print('line 802 get clident data model exiting...');
    dataElements['ownerId'] = imp['ownerId'];
    return dataElements;
  }
}
