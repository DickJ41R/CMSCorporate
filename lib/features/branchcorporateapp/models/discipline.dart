

class CMSDiscipline {
  const CMSDiscipline(
  //    this.id,
      this.disciplineId,
      this.disciplineName,
      this.disciplineDescription,
      this.hasSkills,
      this.hasSpecialties,
      this.lastTouched,
      this.hideOnlineApp,
      this.glAccount,
      this.fsmLinked,
      this.eeocCategoryCodeId,
      this.socCodeCodeId,
      this.p8JobTitleCode,
      this.matchingDisciplines,
      this.licenseRequired,
      this.weekDayRate,
      this.weekEndRate,
      this.weekDayShifts,
      this.weekEndShifts,
      this.index,
      this.isSelected
      );

  //final ObjectId id;
  final int disciplineId;
  final String disciplineName;
  final String disciplineDescription;
  final bool? hasSkills;
  final bool? hasSpecialties;
  final String? lastTouched;
  final bool? hideOnlineApp;
  final String? glAccount;
  final String? fsmLinked;
  final String? eeocCategoryCodeId;
  final String? socCodeCodeId;
  final String? p8JobTitleCode;
  final List<dynamic>? matchingDisciplines;
  final bool? licenseRequired;
  final double weekDayRate;
  final double weekEndRate;
  final int weekDayShifts;
  final int weekEndShifts;
  final int index;
  final bool? isSelected;
}