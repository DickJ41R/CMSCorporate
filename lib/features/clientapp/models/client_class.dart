import 'package:cloud_firestore/cloud_firestore.dart';

class ClientClass {
  /// Creates the order class with required details.
  ClientClass(
      this.clientId,
      this.statusId,
      this.clientName,
      this.branchName,
      this.clientType,
      this.disciplinesServiced,
      this.city,
      this.state,
      this.balance,
      this.openCredit);

  /// Id of an order.
  final String clientId;

  /// status an order.
  final String statusId;

  /// client Name of an order.
  final String clientName;
  final String branchName;
  final String clientType;

  /// City of an order.
  final String disciplinesServiced;
  final String city;
  final String state;

  /// Freight of an order.

  /// Price of an order.
  final String balance;
  final String openCredit;

  // String getCity(int clientId) {
  //   String city = '';
  //   FirebaseFirestore.instance
  //       .collection('ClientAddress')
  //       .where('clientId', isEqualTo: clientId)
  //       .where('addressType', isEqualTo: 'Physical')
  //       .get()
  //       .then((QuerySnapshot) {
  //     for (var docSnapshot in QuerySnapshot.docs) {
  //       var obj = docSnapshot.data();
  //       city = obj['city'];
  //       break;
  //     }
  //   });
  //   print('line 53')
  //   return city;
  // }
  //
  // String getState(int clientId) {
  //   String state = '';
  //   FirebaseFirestore.instance
  //       .collection('ClientAddress')
  //       .where('clientId', isEqualTo: clientId)
  //       .where('addressType', isEqualTo: 'Physical')
  //       .get()
  //       .then((QuerySnapshot) {
  //     for (var docSnapshot in QuerySnapshot.docs) {
  //       var obj = docSnapshot.data();
  //       state = obj['state'];
  //       break;
  //     }
  //   });
  //   return state;
  // }

  factory ClientClass.fromJson(Map<String, dynamic> json) {
    return ClientClass(
        json['clientId'] as String,
        json['statusId'] as String,
        json['clientName'] as String,
        json['branchName'] as String,
        json['clientType'] == null ? "" : json['clientType'] as String,
        json['disciplineServiced'] == null
            ? ""
            : json['disciplineServiced'] as String,
        json['city'] == null ? "" : json['city'] as String,
        json['state'] == null ? "" : json['state'] as String,
        json['balance'] == null ? "\$0.00" : json['balance'] as String,
        json['openCredit'] as String);
  }

  Map<String, dynamic> toJson() => {
        'clientId': clientId,
        'statusId': statusId,
        'clientName': clientName,
        'branchName': branchName,
        'clientType': clientType,
        'disciplinesServiced': disciplinesServiced,
        'city': city,
        'state': state,
        'balance': balance,
        'openCredit': openCredit
//      'payRate': payRate,
      };

  ClientClass copyWith(
      {String? clientId,
      String? statusId,
      String? clientName,
      String? branchName,
      String? clientType,
      String? disciplinesServiced,
      String? city,
      String? state,
      String? balance,
      String? openCredit}) {
    print('line 115');
    return ClientClass(
        clientId ?? this.clientId,
        statusId ?? this.statusId,
        clientName ?? this.clientName,
        branchName ?? this.branchName,
        clientType ?? this.clientType,
        disciplinesServiced ?? this.disciplinesServiced,
        city ?? this.city,
        state ?? this.state,
        balance ?? this.balance,
        openCredit ?? this.openCredit);
  }

  List<ClientClass> ClientClasses = <ClientClass>[];

  void convertToClientClasses(List<dynamic> listD) {
    for (int i = 0; i < listD.length; i++) {
      dynamic ld = listD[i];
      ClientClass wkc = ClientClass(
          ld['clientId'],
          ld['statusId'],
          ld['clientName'],
          ld['branchName'],
          ld['clientType'],
          ld['disciplinesServiced'],
          ld['city'],
          ld['state'],
          ld['balance'],
          ld['openCredit']);
      ClientClasses.add(wkc);
    }
  }
}
