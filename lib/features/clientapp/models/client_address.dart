import 'package:cloud_firestore/cloud_firestore.dart';

class ClientAddress {
  const ClientAddress({
    required this.id,
    required this.departmentId,
    required this.clientAddressId,
    required this.addressTypeCodeId,
    required this.addressType,
    required this.addressName,
    required this.attention,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.county,
    required this.country,
    required this.isDepartment
  });

  final String id;
  final int departmentId;
  final int clientAddressId; //1
  final dynamic addressTypeCodeId; //2
  final String addressType; //3
  final dynamic addressName; //4
  final dynamic attention; //5
  final dynamic addressLine1; //6
  final dynamic addressLine2; //7
  final String city; //8
  final String state; //9
  final String zipCode; //10
  final dynamic county; //11
  final dynamic country; //12
  final bool isDepartment;

  factory ClientAddress.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();
    return ClientAddress(
        id: data?['id'],
        departmentId: data?['departmentId'],
        clientAddressId: data?['departmentId'],
        //1
        addressTypeCodeId: data?['addressTypeCodeId'],
        addressType: data?['addressType'],
        //3
        addressName: data?['addressName'],
        //4
        attention: data?['attention'],
        //5
        addressLine1: data?['addressLine1'],
        //6
        addressLine2: data?['addressLine2'],
        //7
        city: data?['city'],
        //8
        state: data?['state'],
        //9
        zipCode: data?['zipCode'],
        //10
        county: data?['county'],
        //11
        country: data?['country'],
        //12
        isDepartment: data?['isDepartment']
    );
  }

  Map<String, dynamic> setCollection() {
    Map<String, dynamic> col = {};
    col['id'] = id;
    col['departmentId'] = departmentId;
    col['clientAddressId'] = clientAddressId;
    col['addressTypeCodeId'] = addressTypeCodeId;
    col['addressType'] = addressType;
    if (addressName != null && addressName != '') {
      col['addressName'] = addressName;
    }
    if (attention != null && attention != '') {
      col['attention'] = attention;
    }
    if (addressLine1 != null && addressLine1 != '') {
      col['addressLine1'] = addressLine1;
    }
    if (addressLine2 != null && addressLine2 != '') {
      col['addressLine2'] = addressLine2;
    }
    col['city'] = city;
    col['state'] = state;
    col['zipCode'] = zipCode;
    if (county != null && county != '') {
      col['county'] = county;
    }
    if (country != null &&  country != '') {
      col['country'] = country;
    }
    col['isDepartment'] = isDepartment;
    return col;
  }
}
