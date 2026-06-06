import 'package:cms_web/features/clientapp/models/client_shift_data.dart';
import 'package:flutter/foundation.dart';

class HCPAvailability {
  HCPAvailability(
      //  this.id,
      this.hcpId,
      this.availabilityId,
      this.monthNumber,
      this.monthName,
      this.currentYear,
      this.discipline,
      this.shiftInfo,
      this.lastname,
      this.firstname,
      this.branchName,
      this.facilityName);

//   factory CMSEmployeeAvailability.fromJson(Map<String, Object?> json) =>
//       _$CMSEmployeeAvailabilityFromJson(json);
// By adding this annotation, this property will not be considered as part
  // of the Firestore document, but instead represent the document ID.
//  @Id()
  // final ObjectId id; //0
  final int hcpId; //1
  final int availabilityId; //2
  final int monthNumber;
  final String monthName;
  final int currentYear;
  final String discipline;
  final List<Map<String, ShiftInformation>> shiftInfo;
  final String lastname;
  final String firstname;
  final String branchName;
  final String? facilityName;

  //:::caution If your model class is defined in a separate file than the Firestore reference, you will
  // need to explicitly specify fromJson/toJson functions as followed:
  //Map<String, Object?> toJson() => _$CMSEmployeeAvailabilityToJson(this);

  Map<String, dynamic> setCollection() {
    Map<String, dynamic> col = {};
    debugPrint('line 41 cmsempavail: $availabilityId $shiftInfo');
    //  col['uid'] = id;
    col['hcpId'] = hcpId;
    col['availabilityId'] = availabilityId;
    col['monthNumber'] = monthNumber;
    col['monthName'] = monthName;
    col['currentYear'] = currentYear;
    col['discipline'] = discipline;
    col['shiftInfo'] = shiftInfo;
    col['lastname'] = lastname;
    col['firstname'] = firstname;
    col['branchName'] = branchName;
    if (facilityName != null) {
      col['facilityName'] = facilityName;
    }
    return col;
  }
}
