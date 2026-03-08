//import 'package:realm/realm.dart';
class CMSSpecialRequirement {
  const CMSSpecialRequirement(
      this.id,
      this.codeId,
      this.name,
      this.required,
      this.days,
      this.startTime,
      this.endTime,
      this.nextDate,
      this.notes
      );

  final Object id;
  final String codeId;
  final String name;
  final bool required;
  final int? days;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? nextDate;
  final String? notes;
}
