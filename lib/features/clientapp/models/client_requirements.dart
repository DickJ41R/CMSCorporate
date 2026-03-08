
class ClientRequirements {

  const ClientRequirements(
     this.requirementCategoryCode,  //et credentials, special,
     this.requirementId,    //CPR
     this.requirementCode,
     this.requirementDescription, //Tuberculosis
     this.requirementInstructions,
     this.requirementMonthsLimitation
  );

  final String requirementCategoryCode;
  final int requirementId;
  final String requirementCode;
  final String requirementDescription;
  final String requirementInstructions;
  final int requirementMonthsLimitation;
}