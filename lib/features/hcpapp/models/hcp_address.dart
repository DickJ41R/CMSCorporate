

class HCPAddress {
  const HCPAddress({
        // required this.id,  //_id
        // required this.mongodbId,  //from hcpprofessional
        required this.addressId,
        required this.addressTypeCodeId,
        required this.addressType,
        required this.addressLine1,
        required this.addressLine2,
        required this.city,
        required this.state,
        required this.zipCode,
        required this.isPrimary,
        required this.isPaycheck,
        required this.fullAddress,
        required this.county,
        required this.latitude,
        required this.longitude,
        required this.country});

  // final ObjectId id;
  // final ObjectId mongodbId; //0
  final int addressId; //2
  final int addressTypeCodeId; //3
  final String addressType; //4
  final String? addressLine1; //5
  final String? addressLine2; //6
  final String city; //7
  final String state; //8
  final String zipCode; //9
  final bool isPrimary; //10
  final bool isPaycheck; //11
  final String fullAddress; //12
  final String county; //13
  final double latitude; //14
  final double longitude; //15
  final String? country; //16

  Map<String, dynamic> setCollection() {
    Map<String, dynamic> col = {};
    // col['id'] = id;
    // col['mongodbId'] = mongodbId;
    col['addressId'] = addressId;
    col['addressTypeCodeId'] = addressTypeCodeId;
    col['addressType'] = addressType;
    if (addressLine1 != '') {
      col['addressLine1'] = addressLine1;
    }
    if (addressLine2 != '') {
      col['addressLine2'] = addressLine2;
    }
    col['city'] = city;
    col['state'] = state;
    col['zipCode'] = zipCode;
    col['isPrimary'] = isPrimary;
    col['isPaycheck'] = isPaycheck;
    col['fullAddress'] = fullAddress;
    col['county'] = county;
    col['latitude'] = latitude;
    col['longitude'] = longitude;
    if (country != '') {
      col['country'] = country;
    }

    return col;
  }
}
