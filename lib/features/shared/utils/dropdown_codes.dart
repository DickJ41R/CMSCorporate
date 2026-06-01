class DropDownCodes {
  DropDownCodes();

  Future<List<Map<String, dynamic>>> getRegistrantCancelReasons() async {
    List<Map<String, dynamic>> lst = [
      {"codeId": 2512, "reason": "Family Emergency"},
      {"codeId": 2513, "reason": "Sick"},
      {"codeId": 2514, "reason": "Transportation Issues"},
      {"codeId": 2680, "reason": "Requested Time Off"},
      {"codeId": 2689, "reason": "Fatigue"},
      {"codeId": 2739, "reason": "No Call No Show"},
      {"codeId": 2740, "reason": "Called Out"}
    ];
    return lst;
  }

  Future<List<Map<String, dynamic>>> getClientCancelReasons() async {
    List<Map<String, dynamic>> lst = [
      {"codeId": 2088, "reason": "Census Low"},
      {"codeId": 2089, "reason": "Not Needed"},
      {"codeId": 2090, "reason": "Other Agency Filled"},
      {"codeId": 2091, "reason": "Staff Filled"},
      {"codeId": 2730, "reason": "Cancelled by Second Level Manager"},
      {"codeId": 2731, "reason": "Maintenance Repairs"},
      {"codeId": 2732, "reason": "Closed Beds - Unit"},
      {
        "codeId": 2733,
        "reason": "Other Agency - Preferred Provider filled Shift"
      },
      {"codeId": 2754, "reason": "StafferLinkFSM Cancellation"},
      {"codeId": 2834, "reason": "VMS Cancellation"},
      {"codeId": 2843, "reason": "Not Confirmed - CLIENT"},
      {"codeId": 2844, "reason": "Not Confirmed - REGISTRANT"},
      {"codeId": 2845, "reason": "Shift no longer available"}
    ];
    return lst;
  }

  Future<List<dynamic>> getOrderTypes() async {
    List<dynamic> lst = [
      {"orderTypeCodeID": 4011, "codeName": "Travel"},
      {"orderTypeCodeID": 4012, "codeName": "Contract"},
      {"orderTypeCodeID": 4013, "codeName": "PerDiem"}
    ];
    return lst;
  }

  Future<List<dynamic>> getRateTypeCodes() async {
    List<dynamic> lst = [
      {
        "rateTypeCodeId": 2491,
        "codeName": "Contract",
        "codeDesc": "Contract Rate"
      },
      {
        "rateTypeCodeId": 2492,
        "codeName": "MedSurg",
        "codeDesc": "Medical / Surgical Rate"
      },
      {
        "rateTypeCodeId": 2493,
        "codeName": "Orientation",
        "codeDesc": "Orientation Rate"
      },
      {
        "rateTypeCodeId": 2494,
        "codeName": "Specialty",
        "codeDesc": "Specialty Rate"
      },
      {
        "rateTypeCodeId": 2683,
        "codeName": "Per Diem",
        "codeDesc": "Scheduled Daily"
      },
      {
        "rateTypeCodeId": 2684,
        "codeName": "13 Week Contract",
        "codeDesc": "Long Term Assignment"
      },
      {
        "rateTypeCodeId": 2685,
        "codeName": "Subsidy - Tax Free",
        "codeDesc": "Long Term Assignment Weekly Subsidy Amount"
      },
      {
        "rateTypeCodeId": 2686,
        "codeName": "Bonus",
        "codeDesc": "Referral Bonus"
      },
      {
        "rateTypeCodeId": 2741,
        "codeName": "Evaluation",
        "codeDesc": "Evaluation"
      },
      {
        "rateTypeCodeId": 2742,
        "codeName": "Recertification",
        "codeDesc": "Recertification"
      },
      {
        "rateTypeCodeId": 2743,
        "codeName": "Evaluation Orientation",
        "codeDesc": "Evaluation Orientation"
      },
      {
        "rateTypeCodeId": 2744,
        "codeName": "Recertification Orientation",
        "codeDesc": "Recertification Orientation"
      },
      {
        "rateTypeCodeId": 2755,
        "codeName": "Travel",
        "codeDesc": "Travel Mileage"
      },
      {
        "rateTypeCodeId": 2837,
        "codeName": "Premium",
        "codeDesc": "Premium Rate"
      }
    ];
    return lst;
  }

  List<Map<String, dynamic>> getClientUserRoles() {
    List<Map<String, dynamic>> listOfRoles = [
      {
        'roleId': 1,
        'role': 'ClientDON',
        'roleDescription': 'Director Of Nursing',
        'isAdministrator': true,
        'canSchedule': true,
        'canVerify': true,
      },
      {
        'roleId': 2,
        'role': 'ClientADON',
        'roleDescription': 'Assistant Director Of Nursing',
        'isAdministrator': true,
        'canSchedule': true,
        'canVerify': true
      },
      {
        'roleId': 3,
        'role': 'ClientAdministrator',
        'roleDescription': 'Administrator',
        'isAdministrator': true,
        'canSchedule': false,
        'canVerify': false,
      },
      {
        'roleId': 4,
        'role': 'ClientDepartmentManager',
        'roleDescription': 'Department Manager',
        'isAdministrator': true,
        'canSchedule': true,
        'canVerify': true
      },
      {
        'roleId': 5,
        'role': 'ClientShiftSupervisor',
        'roleDescription': 'Shift Supervisor',
        'isAdministrator': true,
        'canSchedule': true,
        'canVerify': true,
      },
      {
        'roleId': 6,
        'role': 'ClientScheduler',
        'roleDescription': 'Shift Scheduler',
        'isAdministrator': true,
        'canSchedule': true,
        'canVerify': true,
      },
      {
        'roleId': 7,
        'role': 'ClientBilling',
        'roleDescription': 'Client Billing',
        'isAdministrator': false,
        'canSchedule': false,
        'canVerify': false,
      },
      {
        'roleId': 8,
        'role': 'ClientStaff',
        'roleDescription': 'Staff',
        'isAdministrator': false,
        'canSchedule': false,
        'canVerify': false
      },
      {
        'roleId': 9,
        'role': 'CMSAdmin',
        'roleDescription': 'CMS Administrator',
        'isAdministrator': true,
        'canSchedule': true,
        'canVerify': false
      },
    ];
    return listOfRoles;
  }

  Future<List<dynamic>> getWorkerCompCodes() async {
    List<dynamic> lst = [
      //note codeName is WorkersCompTypeCode
      {"workersCompCodeId": 2639, "codeName": "7111", "codeDesc": "Dietary"},
      {
        "workersCompCodeId": 2646,
        "codeName": "8049",
        "codeDesc": "Clinics / Health Practitioner / Physical Therapist"
      },
      {
        "workersCompCodeId": 2652,
        "codeName": "8742",
        "codeDesc": "Sales (outside)"
      },
      {
        "workersCompCodeId": 2654,
        "codeName": "8810",
        "codeDesc": "Clerical Office Employees"
      },
      {
        "workersCompCodeId": 2655,
        "codeName": "8811",
        "codeDesc": "Immunization Clinics"
      },
      {
        "workersCompCodeId": 2656,
        "codeName": "8829",
        "codeDesc": "Nursing Home-DO NOT USE"
      },
      {
        "workersCompCodeId": 2657,
        "codeName": "8830",
        "codeDesc": "Hospital Professional"
      },
      {
        "workersCompCodeId": 2658,
        "codeName": "8832",
        "codeDesc": "Physician and Clerical"
      },
      {
        "workersCompCodeId": 2659,
        "codeName": "8833",
        "codeDesc": "Hospital - Professional Employees"
      },
      {
        "workersCompCodeId": 2660,
        "codeName": "8835",
        "codeDesc": "Nursing - Home Health"
      },
      {
        "workersCompCodeId": 2664,
        "codeName": "9040",
        "codeDesc": "Hospital North Dakota"
      },
      {"workersCompCodeId": 2665, "codeName": "9050", "codeDesc": "Hospice"},
      {
        "workersCompCodeId": 2669,
        "codeName": "9999",
        "codeDesc": "Not Otherwise Classified"
      },
      {
        "workersCompCodeId": 2745,
        "codeName": "8849",
        "codeDesc": "NC State nursing Homes"
      },
      {
        "workersCompCodeId": 2752,
        "codeName": "8868",
        "codeDesc": "School Professional Employees"
      },
      {
        "workersCompCodeId": 2753,
        "codeName": "8864",
        "codeDesc": "Social Services Organization"
      },
      {
        "workersCompCodeId": 2759,
        "codeName": "8828",
        "codeDesc": "Texas Home Health"
      },
      {
        "workersCompCodeId": 2836,
        "codeName": "8824",
        "codeDesc": "Nursing Home"
      }
    ];
    return lst;
  }

  List<Map<String, String>> clientContactTypes = [
    {
      "CodeID": "2092",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Accounting"
    },
    {
      "CodeID": "2093",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Administration",
    },
    {
      "CodeID": "2094",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Business Development"
    },
    {"CodeID": "2095", "CodeKey": "ClientContactTypes", "CodeName": "Clinical"},
    {
      "CodeID": "2096",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Continuous Care"
    },
    {
      "CodeID": "2097",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Contracts"
    },
    {
      "CodeID": "2098",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Coordinator"
    },
    {
      "CodeID": "2099",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Data Management"
    },
    {"CodeID": "2100", "CodeKey": "ClientContactTypes", "CodeName": "Director"},
    {
      "CodeID": "2101",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Drug Information"
    },
    {
      "CodeID": "2102",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Education"
    },
    {
      "CodeID": "2103",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Executive: Non- Clinical Executive Member",
    },
    {
      "CodeID": "2104",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Facility Contact Info"
    },
    {
      "CodeID": "2105",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Family Member"
    },
    {
      "CodeID": "2106",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Finance",
    },
    {
      "CodeID": "2107",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Food Services"
    },
    {
      "CodeID": "2108",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Health Information Management"
    },
    {
      "CodeID": "2109",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Home Care / Private Duty"
    },
    {
      "CodeID": "2110",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Housekeeping"
    },
    {
      "CodeID": "2111",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Human Resources"
    },
    {
      "CodeID": "2112",
      "CodeKey": "ClientContactTypes",
      "CodeNae": "Information Technology"
    },
    {
      "CodeID": "2113",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Labor and Delivery"
    },
    {
      "CodeID": "2114",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Laboratory"
    },
    {"CodeID": "2115", "CodeKey": "ClientContactTypes", "CodeName": "Legal"},
    {
      "CodeID": "2116",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Long Term Care"
    },
    {
      "CodeID": "2117",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Marketing"
    },
    {
      "CodeID": "2118",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Medical Staff Services"
    },
    {
      "CodeID": "2119",
      "CodeKey": "ClientContactTypes",
      "CodeName":
          "Nursing - Director of Clinical Services - Acute Care Multiple Area Manager",
    },
    {
      "CodeID": "2120",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Office",
    },
    {"CodeID": "2121", "CodeKey": "ClientContactTypes", "CodeName": "Patient"},
    {"CodeID": "2122", "CodeKey": "ClientContactTypes", "CodeName": "Pharmacy"},
    {
      "CodeID": "2123",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Physician"
    },
    {
      "CodeID": "2124",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Procurement"
    },
    {
      "CodeID": "2125",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Program Manager"
    },
    {
      "CodeID": "2126",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Project Management"
    },
    {
      "CodeID": "2127",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Purchasing"
    },
    {
      "CodeID": "2128",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Quality Assurance"
    },
    {"CodeID": "2129", "CodeKey": "ClientContactTypes", "CodeName": "Sales"},
    {
      "CodeID": "2130",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Secretary"
    },
    {"CodeID": "2131", "CodeKey": "ClientContactTypes", "CodeName": "Staffing"},
    {
      "CodeID": "2132",
      "CodeKey": "ClientContactTypes",
      "CodeName": "Supervisor"
    }
  ];
  List<Map<String, dynamic>> getClientContactTypeData() {
    return clientContactTypes;
  }

  List<Map<String, dynamic>> getClientAddressTypes() {
    List<Map<String, dynamic>> clientAddressTypes = [
      {
        "CodeID": 9997,
        "CodeName": "Mailing",
        "CodeDesc": null,
        "SortOrder": 0,
        "CodeValue": null,
        "IsDefault": false,
        "UserTypeCodeID": null,
        "InterfaceValue": null,
        "HideOnlineApp": null,
        "CodeKey": "AddressTypes"
      },
      {
        "CodeID": 9998,
        "CodeName": "Billing",
        "CodeDesc": null,
        "SortOrder": 0,
        "CodeValue": null,
        "IsDefault": false,
        "UserTypeCodeID": null,
        "InterfaceValue": null,
        "HideOnlineApp": null,
        "CodeKey": "AddressTypes"
      },
      {
        "CodeID": 9999,
        "CodeName": "Physical",
        "CodeDesc": null,
        "SortOrder": 0,
        "CodeValue": null,
        "IsDefault": false,
        "UserTypeCodeID": null,
        "InterfaceValue": null,
        "HideOnlineApp": null,
        "CodeKey": "AddressTypes"
      },
    ];
    return clientAddressTypes;
  }

  List<Map<String, dynamic>> getHCPAddressTypes() {
    List<Map<String, dynamic>> addressTypes = [
      {
        "CodeID": 2060,
        "CodeName": "Emergency",
        "CodeDesc": null,
        "SortOrder": 0,
        "CodeValue": null,
        "IsDefault": false,
        "UserTypeCodeID": null,
        "InterfaceValue": null,
        "HideOnlineApp": null,
        "CodeKey": "AddressTypes"
      },
      {
        "CodeID": 2061,
        "CodeName": "Home",
        "CodeDesc": null,
        "SortOrder": 0,
        "CodeValue": null,
        "IsDefault": true,
        "UserTypeCodeID": null,
        "InterfaceValue": null,
        "HideOnlineApp": null,
        "CodeKey": "AddressTypes"
      },
      {
        "CodeID": 2062,
        "CodeName": "Work",
        "CodeDesc": null,
        "SortOrder": 0,
        "CodeValue": null,
        "IsDefault": false,
        "UserTypeCodeID": null,
        "InterfaceValue": null,
        "HideOnlineApp": null,
        "CodeKey": "AddressTypes"
      },
      {
        "CodeID": 9999,
        "CodeName": "Physical",
        "CodeDesc": null,
        "SortOrder": 0,
        "CodeValue": null,
        "IsDefault": false,
        "UserTypeCodeID": null,
        "InterfaceValue": null,
        "HideOnlineApp": null,
        "CodeKey": "AddressTypes"
      }
    ];
    return addressTypes;
  }

  List<Map<String, String>> disabilityTypes = [
    {"CodeID": '', "CodeName": "Environmental Illness"},
    {"CodeID": '', "CodeName": "Hearing Impairment"},
    {"CodeID": '', "CodeName": "Learning Disabilities"},
    {"CodeID": '', "CodeName": "Mental Impairment"},
    {"CodeID": '', "CodeName": "Mobility Impairment / Motor Physical"},
    {"CodeID": '', "CodeName": "Physical Health"},
    {"CodeID": '', "CodeName": "Speech / Language"},
    {"CodeID": '', "CodeName": "Vision Impairment"},
  ];
  List<Map<String, dynamic>> ethnicityTypes = [
    {
      "CodeID": 2398,
      "CodeName": "American Indian/Alaskan Native",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "I",
      "HideOnlineApp": null,
      "CodeKey": "Ethnicity"
    },
    {
      "CodeID": 2399,
      "CodeName": "Asian",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "A",
      "HideOnlineApp": null,
      "CodeKey": "Ethnicity"
    },
    {
      "CodeID": 2400,
      "CodeName": "Black (not Hispanic or Latino)",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "B",
      "HideOnlineApp": null,
      "CodeKey": "Ethnicity"
    },
    {
      "CodeID": 2401,
      "CodeName": "Hispanic or Latino",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "H",
      "HideOnlineApp": null,
      "CodeKey": "Ethnicity"
    },
    {
      "CodeID": 2402,
      "CodeName": "Native Hawaiian / Pacific Islander",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "N",
      "HideOnlineApp": null,
      "CodeKey": "Ethnicity"
    },
    {
      "CodeID": 2403,
      "CodeName": "Two or More Races (not Hispanic or Latino)",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "U",
      "HideOnlineApp": null,
      "CodeKey": "Ethnicity"
    },
    {
      "CodeID": 2404,
      "CodeName": "White (not Hispanic or Latino)",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "W",
      "HideOnlineApp": null,
      "CodeKey": "Ethnicity"
    }
  ];
  List<Map<String, dynamic>> userTypes = [
    {
      "CodeId": 2594,
      "CodeKey": "UserType",
      "CodeName": "Biller",
      "CodeDescription": "Biller",
      "CodeValue": "Biller"
    },
    {
      "CodeId": 2595,
      "CodeKey": "UserType",
      "CodeName": "Collector",
      "CodeDescription": "Collector",
      "CodeValue": "Collector"
    },
    {
      "CodeId": 2596,
      "CodeKey": "UserType",
      "CodeName": "Coordinator",
      "CodeDescription": "Coordinator",
      "CodeValue": "Coordinator"
    },
    {
      "CodeId": 2597,
      "CodeKey": "UserType",
      "CodeName": "Interviewer",
      "CodeDescription": "Interviewer",
      "CodeValue": "Interviewer"
    },
    {
      "CodeId": 2598,
      "CodeKey": "UserType",
      "CodeName": "Recruiter",
      "CodeDescription": "Recruiter",
      "CodeValue": "Recruiter"
    },
    {
      "CodeId": 2690,
      "CodeKey": "UserType",
      "CodeName": "Branch Manager",
      "CodeDescription": "Market Manager",
      "CodeValue": "Branch Manager"
    },
    {
      "CodeId": 2691,
      "CodeKey": "UserType",
      "CodeName": "Payroll Coordinator",
      "CodeDescription": "PC",
      "CodeValue": "Payroll Coordinator"
    },
    {
      "CodeId": 2692,
      "CodeKey": "UserType",
      "CodeName": "Account Receivable",
      "CodeDescription": "A/R Corp",
      "CodeValue": "Account Receivable"
    },
    {
      "CodeId": 2748,
      "CodeKey": "UserType",
      "CodeName": "Virtual Recruiter",
      "CodeDescription": "Recruiter",
      "CodeValue": "Virtual Recruiter"
    },
    {
      "CodeId": 2749,
      "CodeKey": "UserType",
      "CodeName": "Nursetesting",
      "CodeDescription": "NT User",
      "CodeValue": "Nursetesting"
    },
    {
      "CodeId": 2807,
      "CodeKey": "UserType",
      "CodeName": "Client Account Manager",
      "CodeDescription": "Client Account Manager",
      "CodeValue": "Client Account Manager"
    }
  ];

  Map<String, dynamic> getUserTypes(int vv) {
    bool haveValue = false;
    Map<String, dynamic> sv = {};
    for (Map<String, dynamic> item in userTypes) {
      item.forEach((key, value) {
        if (key == 'CodeId' && value == vv) {
          sv = item;
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  List<Map<String, dynamic>> getGenderTypes() {
    List<Map<String, dynamic>> genderTypes = [
      {
        "CodeID": 2406,
        "CodeName": "M",
        "CodeDesc": "Male",
        "SortOrder": 0,
        "CodeValue": null,
        "IsDefault": false,
        "UserTypeCodeID": null,
        "InterfaceValue": "M",
        "HideOnlineApp": null,
        "CodeKey": "Gender"
      },
      {
        "CodeID": 2405,
        "CodeName": "F",
        "CodeDesc": "Female",
        "SortOrder": 1,
        "CodeValue": null,
        "IsDefault": false,
        "UserTypeCodeID": null,
        "InterfaceValue": "F",
        "HideOnlineApp": null,
        "CodeKey": "Gender"
      },
      {
        "CodeID": 2842,
        "CodeName": "B",
        "CodeDesc": "Non-Binary",
        "SortOrder": 2,
        "CodeValue": null,
        "IsDefault": false,
        "UserTypeCodeID": null,
        "InterfaceValue": "B",
        "HideOnlineApp": null,
        "CodeKey": "Gender"
      },
      {
        "CodeID": 2841,
        "CodeName": "N",
        "CodeDesc": "Not Specified",
        "SortOrder": 3,
        "CodeValue": null,
        "IsDefault": false,
        "UserTypeCodeID": null,
        "InterfaceValue": "N",
        "HideOnlineApp": null,
        "CodeKey": "Gender"
      }
    ];
    return genderTypes;
  }

  List<Map<String, dynamic>> maritalStatuses = [
    {
      "CodeID": 2395,
      "CodeName": "D",
      "CodeDesc": "Divorced",
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "D",
      "HideOnlineApp": null,
      "CodeKey": "EEOMaritalStatus"
    },
    {
      "CodeID": 2396,
      "CodeName": "M",
      "CodeDesc": "Married",
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "M",
      "HideOnlineApp": null,
      "CodeKey": "EEOMaritalStatus"
    },
    {
      "CodeID": 2397,
      "CodeName": "S",
      "CodeDesc": "Single",
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "S",
      "HideOnlineApp": null,
      "CodeKey": "EEOMaritalStatus"
    }
  ];
  List<Map<String, dynamic>> disciplineTypes = [
    {
      "disciplineId": "558",
      "disciplineName": "CNA",
      "disciplineDescription": "Certified Nursing Assistant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": ['CNA-I', 'CNAII', 'RMA', 'CNA/M']
    },
    {
      "disciplineId": "559",
      "disciplineName": "LPN",
      "disciplineDescription": "Licensed Practical Nurse",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "560",
      "disciplineName": "RN",
      "disciplineDescription": "Registered Nurse",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "561",
      "disciplineName": "PT",
      "disciplineDescription": "Physical Therapist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "562",
      "disciplineName": "OT",
      "disciplineDescription": "Occupational Therapist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "563",
      "disciplineName": "PCT",
      "disciplineDescription": "Patient Care Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": ['HCT', 'DSP', 'HHA']
    },
    {
      "disciplineId": "564",
      "disciplineName": "RRT",
      "disciplineDescription": "Respiratory Therapist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "565",
      "disciplineName": "RT",
      "disciplineDescription": "Rad Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "566",
      "disciplineName": "HHLPN",
      "disciplineDescription": "Home Health Care LPN",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "567",
      "disciplineName": "HCT",
      "disciplineDescription": "Healthcare Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": ['PCT', 'DSP', 'HHA']
    },
    {
      "disciplineId": "568",
      "disciplineName": "PTA",
      "disciplineDescription": "Physical Therapist Assistant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "569",
      "disciplineName": "OTA",
      "disciplineDescription": "Occupational Therapist Assistant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "570",
      "disciplineName": "SLP",
      "disciplineDescription": "Speech Language Patholotist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "571",
      "disciplineName": "MA",
      "disciplineDescription": "Medical Assistant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "572",
      "disciplineName": "LDN",
      "disciplineDescription": "Licensed Dietician/Nutritionist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "574",
      "disciplineName": "RNLTC",
      "disciplineDescription": "Registered Nurse - Long Term Care",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "575",
      "disciplineName": "Diet",
      "disciplineDescription": "Dietician",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "576",
      "disciplineName": "COTA",
      "disciplineDescription": "Certified Occupational Therapist Assistant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "577",
      "disciplineName": "FNP",
      "disciplineDescription": "Family Nurse Practitioner",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "578",
      "disciplineName": "CMA",
      "disciplineDescription": "Certified Medical Assistant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "579",
      "disciplineName": "STACO",
      "disciplineDescription": "Staffing Coordinator",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "582",
      "disciplineName": "ICD-9",
      "disciplineDescription":
          "Medical - Coder primary/secondary dx and procedure",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "583",
      "disciplineName": "CCS",
      "disciplineDescription": "Coding Specialist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "584",
      "disciplineName": "Phleb",
      "disciplineDescription": "Phlebotomist - Certified",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "585",
      "disciplineName": "EKG",
      "disciplineDescription": "EKG Technicial",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "586",
      "disciplineName": "RASST",
      "disciplineDescription": "Clinical Research Assistant - Certified",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "588",
      "disciplineName": "SRN-T",
      "disciplineDescription": "Specialty RN - Telemetry",
      "hasSkills": false,
      "hasSpecialties": true,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "589",
      "disciplineName": "SRN-E",
      "disciplineDescription": "Specialty RN - Telemetry",
      "hasSkills": false,
      "hasSpecialties": true,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "590",
      "disciplineName": "SRN-I",
      "disciplineDescription": "Specialty RN - ICU",
      "hasSkills": false,
      "hasSpecialties": true,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "591",
      "disciplineName": "SRN-C",
      "disciplineDescription": "Specialty RN - CCU",
      "hasSkills": false,
      "hasSpecialties": true,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "592",
      "disciplineName": "Staff",
      "disciplineDescription": "Internal Staff",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "593",
      "disciplineName": "SRN-N",
      "disciplineDescription": "Specialty RN - Neonatal ICU",
      "hasSkills": false,
      "hasSpecialties": true,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "595",
      "disciplineName": "RN-PS",
      "disciplineDescription": "RN Psychiatric",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "597",
      "disciplineName": "CST",
      "disciplineDescription": "Certified Surgical Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "598",
      "disciplineName": "SRN-P",
      "disciplineDescription": "Pediatric RN",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "599",
      "disciplineName": "RNDIA",
      "disciplineDescription": "Dialysis RN",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "600",
      "disciplineName": "RNHHC",
      "disciplineDescription": "RN Home Health",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "601",
      "disciplineName": "CRTT",
      "disciplineDescription": "Certified Respiratory Therapy Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "602",
      "disciplineName": "CNA-I",
      "disciplineDescription": "Certified Nursing Assistant - I",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": ['CNA-II']
    },
    {
      "disciplineId": "603",
      "disciplineName": "CNAII",
      "disciplineDescription": "Certified Nursing Assistant - II",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "604",
      "disciplineName": "MOFF",
      "disciplineDescription": "Medical Office - Secretary",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "605",
      "disciplineName": "RNCM",
      "disciplineDescription": "Registered Nurse - Case Manager",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "606",
      "disciplineName": "RNENF",
      "disciplineDescription": "RN Enforcement Nurse - WC Fraud",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "607",
      "disciplineName": "SRNCL",
      "disciplineDescription": "Specialty RN Cardiac Cath Lab",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "608",
      "disciplineName": "RN-OR",
      "disciplineDescription": "Registered Nurse - OR",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "609",
      "disciplineName": "ECHOV",
      "disciplineDescription": "Vascular/Echo Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "610",
      "disciplineName": "CNA-A",
      "disciplineDescription": "CNA - Acute Care",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "611",
      "disciplineName": "RN-CR",
      "disciplineDescription": "RN Corrections Facilities",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "612",
      "disciplineName": "LPN-C",
      "disciplineDescription": "LPN - Corrections Facilities",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "613",
      "disciplineName": "RN-P",
      "disciplineDescription": "Post Anesthesia Care Unit PACU",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "614",
      "disciplineName": "RN-MS",
      "disciplineDescription": "RN Med/Surg",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "615",
      "disciplineName": "CNA-S",
      "disciplineDescription": "CNA - Sitter",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": ['CNA']
    },
    {
      "disciplineId": "616",
      "disciplineName": "PTech",
      "disciplineDescription": "Psych. Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "617",
      "disciplineName": "S Tec",
      "disciplineDescription": "Surgery Technician",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "619",
      "disciplineName": "DENT",
      "disciplineDescription": "Dentist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "620",
      "disciplineName": "DASS",
      "disciplineDescription": "Dental Assistant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "621",
      "disciplineName": "BICO",
      "disciplineDescription": "Biller/Coder",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "622",
      "disciplineName": "Chair",
      "disciplineDescription": "Program Chair",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "623",
      "disciplineName": "NP",
      "disciplineDescription": "Nurse Practitioner",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "624",
      "disciplineName": "PA",
      "disciplineDescription": "Physician Assistant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "625",
      "disciplineName": "LVN",
      "disciplineDescription": "Licensed Vocational Nurse",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "626",
      "disciplineName": "SOWO",
      "disciplineDescription": "Social Worker",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "627",
      "disciplineName": "MRS",
      "disciplineDescription": "Medical Retail Sales",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "628",
      "disciplineName": "CPD-T",
      "disciplineDescription": "Central Processing Department Tecnician",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "629",
      "disciplineName": "sonog",
      "disciplineDescription": "Sonographer",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "630",
      "disciplineName": "PHT",
      "disciplineDescription": "Pharmacy Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "631",
      "disciplineName": "Psych",
      "disciplineDescription": "Psychiatrist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "632",
      "disciplineName": "PHIN",
      "disciplineDescription": "Pharmacy Intern",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "633",
      "disciplineName": "ART",
      "disciplineDescription": "Art Therapist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "634",
      "disciplineName": "IT",
      "disciplineDescription": "Consultant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "635",
      "disciplineName": "Sitter",
      "disciplineDescription": "Non Certified Sitter",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "636",
      "disciplineName": "PHTec",
      "disciplineDescription": "Public Health Technician",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "637",
      "disciplineName": "DHYG",
      "disciplineDescription": "Dental Hygienist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "638",
      "disciplineName": "H-Tec",
      "disciplineDescription": "Histo-Tec",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "639",
      "disciplineName": "LPNCH",
      "disciplineDescription": "LPN Charge Nurse",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "640",
      "disciplineName": "RNCH",
      "disciplineDescription": "RN Charge Nurse",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "641",
      "disciplineName": "RN-S1",
      "disciplineDescription": "RN Specialty 1",
      "hasSkills": false,
      "hasSpecialties": true,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "642",
      "disciplineName": "RN-S2",
      "disciplineDescription": "RN Specialty 2",
      "hasSkills": false,
      "hasSpecialties": true,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "643",
      "disciplineName": "Scrib",
      "disciplineDescription": "RN Specialty 2",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "644",
      "disciplineName": "MDAC",
      "disciplineDescription": "Mobile Drug and Alcohol Collector",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "645",
      "disciplineName": "CNA/M",
      "disciplineDescription": "CNA and Medical Assistant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": ['RMA']
    },
    {
      "disciplineId": "646",
      "disciplineName": "HHA",
      "disciplineDescription": "Home Health Aide",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": ['PTC', 'HCT', 'DSP']
    },
    {
      "disciplineId": "647",
      "disciplineName": "DSP",
      "disciplineDescription": "Direct Support Professional",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": ['PCT', 'HCT', 'HHA']
    },
    {
      "disciplineId": "648",
      "disciplineName": "Trans",
      "disciplineDescription": "Medical Transcriptionist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": false,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "649",
      "disciplineName": "EEG",
      "disciplineDescription": "EEG Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "650",
      "disciplineName": "USONO",
      "disciplineDescription": "Ultrasound Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "651",
      "disciplineName": "RMA",
      "disciplineDescription": "Registered Medical Assistant",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": ['CNA/M']
    },
    {
      "disciplineId": "652",
      "disciplineName": "MA-LA",
      "disciplineDescription": "MA LAB",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "653",
      "disciplineName": "LPN-L",
      "disciplineDescription": "LPN-Lead",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "656",
      "disciplineName": "HOUSE",
      "disciplineDescription": "Housekeeping & Laundry",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "657",
      "disciplineName": "HEDRC",
      "disciplineDescription": "Medical Records Cleark",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": false,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "658",
      "disciplineName": "LPN-T",
      "disciplineDescription": "LPN Treatment Nurse",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "659",
      "disciplineName": "MedTech",
      "disciplineDescription": "Med Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "661",
      "disciplineName": "PSYCO",
      "disciplineDescription": "Psychologist",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "662",
      "disciplineName": "SRNA",
      "disciplineDescription": "State Registered Nurse Aide",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "663",
      "disciplineName": "KMA",
      "disciplineDescription": "Kentucky Medication Aide",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    },
    {
      "disciplineId": "664",
      "disciplineName": "GACM",
      "disciplineDescription": "Georgia Medication Aide/Med Tech",
      "hasSkills": false,
      "hasSpecialties": false,
      "lastTouched": '',
      "hideOnlineApp": true,
      "glAccount": "",
      "fsmLinked": '',
      "licenseRequired": true,
      "eeocCategoryCodeId": "",
      "socCodeId": "",
      "p8JobTitleCode": "",
      "matchingDisciplines": []
    }
  ];
  List<Map<String, dynamic>> shiftCodes = [
    {
      "codeId": 145,
      "codeKey": "ShiftCodes",
      "codeName": "1",
      "codeDesc": "Day",
      "codeValue": "",
      "sortOrder": "0",
      "color": "",
      "isDefault": "False"
    },
    {
      "codeId": 146,
      "codeKey": "ShiftCodes",
      "codeName": "2",
      "codeDesc": "Evening",
      "codeValue": "",
      "sortOrder": "1",
      "color": "",
      "isDefault": "False"
    },
    {
      "codeId": 147,
      "codeKey": "ShiftCodes",
      "codeName": "3",
      "codeDesc": "Night",
      "codeValue": "",
      "sortOrder": "2",
      "color": "",
      "isDefault": "False"
    },
    {
      "codeId": 148,
      "codeKey": "ShiftCodes",
      "codeName": "AP",
      "codeDesc": "12 Hours AM-PM",
      "codeValue": "",
      "sortOrder": "3",
      "color": "",
      "isDefault": "False"
    },
    {
      "codeId": 149,
      "codeKey": "ShiftCodes",
      "codeName": "PA",
      "codeDesc": "12 Hours PM-AM",
      "codeValue": "",
      "sortOrder": "4",
      "color": "",
      "isDefault": "False"
    },
    {
      "codeId": 150,
      "codeKey": "ShiftCodes",
      "codeName": "CB",
      "codeDesc": "Callback",
      "codeValue": "",
      "sortOrder": "5",
      "color": "",
      "isDefault": "False"
    },
    {
      "codeId": 151,
      "codeKey": "ShiftCodes",
      "codeName": "CH",
      "codeDesc": "Charge",
      "codeValue": "",
      "sortOrder": "6",
      "color": "",
      "isDefault": "False"
    },
    {
      "codeId": 153,
      "codeKey": "ShiftCodes",
      "codeName": "OC",
      "codeDesc": "On Call",
      "codeValue": "",
      "sortOrder": "8",
      "color": "",
      "isDefault": "False"
    },
    {
      "codeId": 155,
      "codeKey": "ShiftCodes",
      "codeName": "TR",
      "codeDesc": "Travel",
      "codeValue": "",
      "sortOrder": "10",
      "color": "",
      "isDefault": "False"
    }
  ];
  List<Map<String, dynamic>> contactTypes = [
    {
      "CodeID": 2367,
      "CodeName": "Email",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "flagIsEmail": true,
      "flagIsTelephone": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null,
      "CodeKey": "ContactTypes"
    },
    {
      "CodeID": 2368,
      "CodeName": "Emergency",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "flagIsEmail": false,
      "flagIsTelephone": true,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null,
      "CodeKey": "ContactTypes"
    },
    {
      "CodeID": 2369,
      "CodeName": "Home",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "flagIsEmail": false,
      "flagIsTelephone": true,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null,
      "CodeKey": "ContactTypes"
    },
    {
      "CodeID": 2370,
      "CodeName": "Mobile",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "flagIsEmail": false,
      "flagIsTelephone": true,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null,
      "CodeKey": "ContactTypes"
    },
    {
      "CodeID": 2371,
      "CodeName": "Other",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "flagIsEmail": false,
      "flagIsTelephone": true,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null,
      "CodeKey": "ContactTypes"
    },
    {
      "CodeID": 2372,
      "CodeName": "Work",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "flagIsEmail": false,
      "flagIsTelephone": true,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null,
      "CodeKey": "ContactTypes"
    }
  ];
  List<Map<String, dynamic>> referralSources = [
    {
      "CodeID": 2495,
      "CodeName": "Banner Ad / Sponsor",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2496,
      "CodeName": "Billboard / Outdoor",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2687,
      "CodeName": "Careerbuilder.com",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2769,
      "CodeName": "Craigslist",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2767,
      "CodeName": "Green Sheets Houston",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2497,
      "CodeName": "Internet",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2498,
      "CodeName": "Job Fair / Exhibit",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2750,
      "CodeName": "Job Service",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2499,
      "CodeName": "Journal / Magazine Ad",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2500,
      "CodeName": "Local Newspaper",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2768,
      "CodeName": "Local Papers Houston",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2501,
      "CodeName": "Mailing / Letter",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2502,
      "CodeName": "Purchased Prospect List",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2503,
      "CodeName": "Radio / Television",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2504,
      "CodeName": "Referral / Word of Mouth",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2505,
      "CodeName": "Transfer from another Branch",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    },
    {
      "CodeID": 2506,
      "CodeName": "Walk - Ins",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": false,
      "CodeKey": "ReferralSource"
    }
  ];
  List<Map<String, dynamic>> veteranCodes = [
    {
      "CodeID": 2498,
      "CodeName": "Newly Separated Veteran",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null
    },
    {
      "CodeID": 2499,
      "CodeName": "Other Protected Veterans",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null
    },
    {
      "CodeID": 2500,
      "CodeName": "Special Disabled Veteran",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null
    }
  ];
  List<Map<String, dynamic>> months = [
    {"monthNumber": 1, "monthName": "January"},
    {"monthNumber": 2, "monthName": "February"},
    {"monthNumber": 3, "monthName": "March"},
    {"monthNumber": 4, "monthName": "April"},
    {"monthNumber": 5, "monthName": "May"},
    {"monthNumber": 6, "monthName": "June"},
    {"monthNumber": 7, "monthName": "July"},
    {"monthNumber": 8, "monthName": "August"},
    {"monthNumber": 9, "monthName": "September"},
    {"monthNumber": 10, "monthName": "October"},
    {"monthNumber": 11, "monthName": "November"},
    {"monthNumber": 12, "monthName": "December"},
  ];
  List<Map<String, double>> slingPayrollHours = [
    {"minutes": 1.0, "decimal": 0.02},
    {"minutes": 2.0, "decimal": 0.03},
    {"minutes": 3.0, "decimal": 0.05},
    {"minutes": 4.0, "decimal": 0.07},
    {"minutes": 5.0, "decimal": 0.08},
    {"minutes": 6.0, "decimal": 0.10},
    {"minutes": 7.0, "decimal": 0.12},
    {"minutes": 8.0, "decimal": 0.13},
    {"minutes": 9.0, "decimal": 0.15},
    {"minutes": 10.0, "decimal": 0.17},
    {"minutes": 11.0, "decimal": 0.19},
    {"minutes": 12.0, "decimal": 0.20},
    {"minutes": 13.0, "decimal": 0.22},
    {"minutes": 14.0, "decimal": 0.23},
    {"minutes": 15.0, "decimal": 0.25},
    {"minutes": 16.0, "decimal": 0.22},
    {"minutes": 17.0, "decimal": 0.28},
    {"minutes": 18.0, "decimal": 0.30},
    {"minutes": 19.0, "decimal": 0.32},
    {"minutes": 20.0, "decimal": 0.33},
    {"minutes": 21.0, "decimal": 0.35},
    {"minutes": 22.0, "decimal": 0.37},
    {"minutes": 23.0, "decimal": 0.38},
    {"minutes": 24.0, "decimal": 0.40},
    {"minutes": 25.0, "decimal": 0.42},
    {"minutes": 26.0, "decimal": 0.43},
    {"minutes": 27.0, "decimal": 0.45},
    {"minutes": 28.0, "decimal": 0.47},
    {"minutes": 29.0, "decimal": 0.48},
    {"minutes": 30.0, "decimal": 0.50},
    {"minutes": 31.0, "decimal": 0.52},
    {"minutes": 32.0, "decimal": 0.53},
    {"minutes": 33.0, "decimal": 0.55},
    {"minutes": 34.0, "decimal": 0.57},
    {"minutes": 35.0, "decimal": 0.58},
    {"minutes": 36.0, "decimal": 0.60},
    {"minutes": 37.0, "decimal": 0.62},
    {"minutes": 38.0, "decimal": 0.63},
    {"minutes": 39.0, "decimal": 0.65},
    {"minutes": 40.0, "decimal": 0.67},
    {"minutes": 41.0, "decimal": 0.68},
    {"minutes": 42.0, "decimal": 0.70},
    {"minutes": 43.0, "decimal": 0.72},
    {"minutes": 44.0, "decimal": 0.73},
    {"minutes": 45.0, "decimal": 0.75},
    {"minutes": 46.0, "decimal": 0.77},
    {"minutes": 47.0, "decimal": 0.78},
    {"minutes": 48.0, "decimal": 0.80},
    {"minutes": 49.0, "decimal": 0.82},
    {"minutes": 50.0, "decimal": 0.83},
    {"minutes": 51.0, "decimal": 0.85},
    {"minutes": 52.0, "decimal": 0.87},
    {"minutes": 53.0, "decimal": 0.88},
    {"minutes": 54.0, "decimal": 0.90},
    {"minutes": 55.0, "decimal": 0.92},
    {"minutes": 56.0, "decimal": 0.93},
    {"minutes": 57.0, "decimal": 0.95},
    {"minutes": 58.0, "decimal": 0.97},
    {"minutes": 59.0, "decimal": 0.98},
    {"minutes": 60.0, "decimal": 1.00},
  ];
  List<Map<String, dynamic>> clientTypes = [
    {
      "CodeID": 2150,
      "CodeCategory": "ClientType",
      "CodeName": "Clinic",
      "CodeDescription": ""
    },
    {
      "CodeID": 2151,
      "CodeCategory": "ClientType",
      "CodeName": "Correctional Hospital",
      "CodeDescription": "Prison Hospital"
    },
    {
      "CodeID": 2152,
      "CodeCategory": "ClientType",
      "CodeName": "Flu Clinics",
      "CodeDescription": ""
    },
    {
      "CodeID": 2153,
      "CodeCategory": "ClientType",
      "CodeName": "Home Care",
      "CodeDescription": ""
    },
    {
      "CodeID": 2154,
      "CodeCategory": "ClientType",
      "CodeName": "Hospice",
      "CodeDescription": ""
    },
    {
      "CodeID": 2155,
      "CodeCategory": "ClientType",
      "CodeName": "Hospital",
      "CodeDescription": "Acute Care Facility"
    },
    {
      "CodeID": 2156,
      "CodeCategory": "ClientType",
      "CodeName": "Long Term Care",
      "CodeDescription": "Nursing Homes, LTC Facilities"
    },
    {
      "CodeID": 2157,
      "CodeCategory": "ClientType",
      "CodeName": "Long Term Care",
      "CodeDescription": "Nursing Homes, LTC Facilities"
    }
  ];
  List<Map<String, dynamic>> clientStatus = [
    {
      "CodeID": "A",
      "CodeCategory": "ClientStatus",
      "CodeName": "Active",
      "CodeDescription": ""
    },
    {
      "CodeID": "I",
      "CodeCategory": "ClientStatus",
      "CodeName": "Inactive",
      "CodeDescription": ""
    },
  ];
  List<Map<String, dynamic>> SICCodes = [
    {
      "CodeID": 111,
      "CodeCategory": "SICCodes",
      "CodeName": "8011",
      "CodeDescription": "Doctors of Medicine"
    },
    {
      "CodeID": 112,
      "CodeCategory": "SICCodes",
      "CodeName": "8021",
      "CodeDescription": "Dentists - Clinics and Offices"
    },
    {
      "CodeID": 113,
      "CodeCategory": "SICCodes",
      "CodeName": "8031",
      "CodeDescription": "Doctors of Osteopathy"
    },
    {
      "CodeID": 114,
      "CodeCategory": "SICCodes",
      "CodeName": "8041",
      "CodeDescription": "Chiroptractors - Clinics and Offices"
    },
    {
      "CodeID": 115,
      "CodeCategory": "SICCodes",
      "CodeName": "8042",
      "CodeDescription": "Optometrists - Clinics and Offices"
    },
    {
      "CodeID": 116,
      "CodeCategory": "SICCodes",
      "CodeName": "8043",
      "CodeDescription": "Podiatrists and Chiropodists - Clinics and Offices"
    },
    {
      "CodeID": 117,
      "CodeCategory": "SICCodes",
      "CodeName": "8049",
      "CodeDescription": "Health Practitioners - Clinics and Offices"
    },
    {
      "CodeID": 118,
      "CodeCategory": "SICCodes",
      "CodeName": "8049",
      "CodeDescription": "Skill Nursing Care Facilities"
    },
    {
      "CodeID": 119,
      "CodeCategory": "SICCodes",
      "CodeName": "8052",
      "CodeDescription": "Intermediate Care Facilities"
    },
    {
      "CodeID": 120,
      "CodeCategory": "SICCodes",
      "CodeName": "8059",
      "CodeDescription": "Nursing & Personal Care Facilities"
    },
    {
      "CodeID": 121,
      "CodeCategory": "SICCodes",
      "CodeName": "8062",
      "CodeDescription": "Hospitals - General Medical & Surgical"
    },
    {
      "CodeID": 122,
      "CodeCategory": "SICCodes",
      "CodeName": "8063",
      "CodeDescription": "Psychiatric Hospitals"
    },
    {
      "CodeID": 123,
      "CodeCategory": "SICCodes",
      "CodeName": "8069",
      "CodeDescription": "Specialty Hospitals Except Psychiatric"
    },
    {
      "CodeID": 124,
      "CodeCategory": "SICCodes",
      "CodeName": "8071",
      "CodeDescription": "Medical and X-Ray Laboratories"
    },
    {
      "CodeID": 125,
      "CodeCategory": "SICCodes",
      "CodeName": "8072",
      "CodeDescription": "Dental Laboratories"
    },
    {
      "CodeID": 126,
      "CodeCategory": "SICCodes",
      "CodeName": "8082",
      "CodeDescription": "Home Health Care Services"
    },
    {
      "CodeID": 127,
      "CodeCategory": "SICCodes",
      "CodeName": "8092",
      "CodeDescription": "Kidney Dialysis Centers"
    },
    {
      "CodeID": 128,
      "CodeCategory": "SICCodes",
      "CodeName": "8093",
      "CodeDescription": "Specialty Outpatient Facilities"
    },
    {
      "CodeID": 129,
      "CodeCategory": "SICCodes",
      "CodeName": "8099",
      "CodeDescription": "Health and Allied Services"
    }
  ];

  List<Map<String, dynamic>> groupCodes = [
    {
      "CodeID": 2407,
      "CodeCategory": "GroupCodes",
      "CodeName": "AAS",
      "CodeDescription": "All About"
    },
    {
      "CodeID": 2712,
      "CodeCategory": "GroupCodes",
      "CodeName": "NCDHHS",
      "CodeDescription": "ANC Dept of Health and Human Services Facility"
    },
    {
      "CodeID": 2713,
      "CodeCategory": "GroupCodes",
      "CodeName": "Broadlane SE",
      "CodeDescription": "SouthEast Region"
    },
    {
      "CodeID": 2714,
      "CodeCategory": "GroupCodes",
      "CodeName": "SCHR",
      "CodeDescription": "South Carolina Healthcare Resources VMS"
    },
    {
      "CodeID": 2715,
      "CodeCategory": "GroupCodes",
      "CodeName": "Medefis",
      "CodeDescription": "Medefis VMS"
    },
  ];
  List<Map<String, dynamic>> branchNames = [
    {
      "CodeID": 615,
      "CodeCategory": "BranchName",
      "CodeName": "RALEIGH CMS 101",
      "CodeDescription": "Raleigh, NC 27615 [919-977-3729]",
      "Active": true
    },
    {
      "CodeID": 620,
      "CodeCategory": "BranchName",
      "CodeName": "Raleigh Internal Staff CMS 901",
      "CodeDescription": "Raleigh, NC 27609",
      "Active": false
    },
    {
      "CodeID": 621,
      "CodeCategory": "BranchName",
      "CodeName": "Houston CMS 102",
      "CodeDescription": "Sugar Land, TX 77498-3680 [832-615-7691]",
      "Active": false
    },
    {
      "CodeID": 622,
      "CodeCategory": "BranchName",
      "CodeName": "Houston Internal Staff CMS 902",
      "CodeDescription": "Sugar Land, TX 77498-3680 [832-615-7691]",
      "Active": false
    },
    {
      "CodeID": 623,
      "CodeCategory": "BranchName",
      "CodeName": "Roanoke CMS 104",
      "CodeDescription": "Roanoke, VA 24018 [540-904-5206]",
      "Active": false
    },
    {
      "CodeID": 624,
      "CodeCategory": "BranchName",
      "CodeName": "COLUMBIA CMS 105",
      "CodeDescription": "Columbia, SC 29201 [803-661-9274]",
      "Active": true
    },
    {
      "CodeID": 625,
      "CodeCategory": "BranchName",
      "CodeName": "Consolidated Staffing IT",
      "CodeDescription": "Memphis, TN 38104 [843-743-4540]",
      "Active": false
    },
    {
      "CodeID": 626,
      "CodeCategory": "BranchName",
      "CodeName": "Florence Internal Staff CMS 905",
      "CodeDescription": "Florence, SC",
      "Active": false
    },
    {
      "CodeID": 627,
      "CodeCategory": "BranchName",
      "CodeName": "Roanoke Internal Staff CMS 904",
      "CodeDescription": "Roanoke, VA 24018 [540-904-5206]",
      "Active": false
    },
    {
      "CodeID": 629,
      "CodeCategory": "BranchName",
      "CodeName": "Advance Professional Resources",
      "CodeDescription": "Memphis, TN 38120 [865-765-7855]",
      "Active": false
    },
    {
      "CodeID": 630,
      "CodeCategory": "BranchName",
      "CodeName": "Oakland 801",
      "CodeDescription": "Memphis, TN 38104 [901-507-9722]",
      "Active": false
    },
    {
      "CodeID": 631,
      "CodeCategory": "BranchName",
      "CodeName": "NASHVILLE CMS 106",
      "CodeDescription": "Nashville, TN 37214-5102",
      "Active": true
    },
    {
      "CodeID": 632,
      "CodeCategory": "BranchName",
      "CodeName": "MEMPHIS CMS 107",
      "CodeDescription": "Memphis, TN 38120 [901-507-9722]",
      "Active": true
    },
    {
      "CodeID": 633,
      "CodeCategory": "BranchName",
      "CodeName": "Advanced Professional Resources IT",
      "CodeDescription": "Memphis, TN 38104 [901-507-9722]",
      "Active": false
    },
    {
      "CodeID": 634,
      "CodeCategory": "BranchName",
      "CodeName": "AUGUSTA CMS 110",
      "CodeDescription": "Augusta, GA 30907",
      "Active": true
    },
    {
      "CodeID": 635,
      "CodeCategory": "BranchName",
      "CodeName": "FLORENCE CMS 111",
      "CodeDescription": "Florence, SC 29501",
      "Active": true
    },
    {
      "CodeID": 636,
      "CodeCategory": "BranchName",
      "CodeName": "Medical Travel",
      "CodeDescription": "Memphis TN 38120",
      "Active": true
    },
    {
      "CodeID": 637,
      "CodeCategory": "BranchName",
      "CodeName": "GREENVILLE CMS 113",
      "CodeDescription": "Greenville, SC 29601",
      "Active": true
    },
    {
      "CodeID": 638,
      "CodeCategory": "BranchName",
      "CodeName": "KNOXVILLE CMS 114",
      "CodeDescription": "Maryville, TN 37804",
      "Active": true
    },
    {
      "CodeID": 639,
      "CodeCategory": "BranchName",
      "CodeName": "TRI CITIES CMS 115",
      "CodeDescription": "Johnson City, TN 7604 [423-640-8451]",
      "Active": true
    },
    {
      "CodeID": 640,
      "CodeCategory": "BranchName",
      "CodeName": "CHATTANOOGA CMS 116",
      "CodeDescription": "Chattanooga, TN",
      "Active": true
    },
    {
      "CodeID": 641,
      "CodeCategory": "BranchName",
      "CodeName": "LEXINGTON CMS 117",
      "CodeDescription": "Lexington, KY 40515",
      "Active": true
    },
    {
      "CodeID": 642,
      "CodeCategory": "BranchName",
      "CodeName": "ATLANTA CMS 118",
      "CodeDescription": "Marietta, GA 30067",
      "Active": true
    },
    {
      "CodeID": 643,
      "CodeCategory": "BranchName",
      "CodeName": "MACON CMS 119",
      "CodeDescription": "Macon, GA 31210",
      "Active": true
    },
    {
      "CodeID": 644,
      "CodeCategory": "BranchName",
      "CodeName": "VENDOR MANAGEMENT CMS 120",
      "CodeDescription": "Raleigh, NC 7615",
      "Active": true
    },
    {
      "CodeID": 645,
      "CodeCategory": "BranchName",
      "CodeName": "CLEVELAND CMS 121",
      "CodeDescription": "Cleveland, OH 44109",
      "Active": true
    },
  ];
  List<Map<String, String>> timeTypes = [
    {
      "CodeID": "Q",
      "CodeCategory": "BranchName",
      "CodeName": "Quarter",
      "CodeDescription": ""
    },
    {
      "CodeID": "T",
      "CodeCategory": "BranchName",
      "CodeName": "Tenths",
      "CodeDescription": ""
    },
    {
      "CodeID": "M",
      "CodeCategory": "BranchName",
      "CodeName": "Minutes",
      "CodeDescription": ""
    },
  ];
  List<Map<String, dynamic>> workerCompCodes = [
    {"WorkersCompCodeID": 2639, "CodeName": "7111", "CodeDesc": "Dietary"},
    {
      "WorkersCompCodeID": 2646,
      "CodeName": "8049",
      "CodeDesc": "Clinics / Health Practitioner / Physical Therapist"
    },
    {
      "WorkersCompCodeID": 2652,
      "CodeName": "8742",
      "CodeDesc": "Sales (outside)"
    },
    {
      "WorkersCompCodeID": 2654,
      "CodeName": "8810",
      "CodeDesc": "Clerical Office Employees"
    },
    {
      "WorkersCompCodeID": 2655,
      "CodeName": "8811",
      "CodeDesc": "Immunization Clinics"
    },
    {
      "WorkersCompCodeID": 2656,
      "CodeName": "8829",
      "CodeDesc": "Nursing Home-DO NOT USE"
    },
    {
      "WorkersCompCodeID": 2657,
      "CodeName": "8830",
      "CodeDesc": "Hospital Professional"
    },
    {
      "WorkersCompCodeID": 2658,
      "CodeName": "8832",
      "CodeDesc": "Physician and Clerical"
    },
    {
      "WorkersCompCodeID": 2659,
      "CodeName": "8833",
      "CodeDesc": "Hospital - Professional Employees"
    },
    {
      "WorkersCompCodeID": 2660,
      "CodeName": "8835",
      "CodeDesc": "Nursing - Home Health"
    },
    {
      "WorkersCompCodeID": 2664,
      "CodeName": "9040",
      "CodeDesc": "Hospital North Dakota"
    },
    {"WorkersCompCodeID": 2665, "CodeName": "9050", "CodeDesc": "Hospice"},
    {
      "WorkersCompCodeID": 2669,
      "CodeName": "9999",
      "CodeDesc": "Not Otherwise Classified"
    },
    {
      "WorkersCompCodeID": 2745,
      "CodeName": "8849",
      "CodeDesc": "NC State nursing Homes"
    },
    {
      "WorkersCompCodeID": 2752,
      "CodeName": "8868",
      "CodeDesc": "School Professional Employees"
    },
    {
      "WorkersCompCodeID": 2753,
      "CodeName": "8864",
      "CodeDesc": "Social Services Organization"
    },
    {
      "WorkersCompCodeID": 2759,
      "CodeName": "8828",
      "CodeDesc": "Texas Home Health"
    },
    {"WorkersCompCodeID": 2836, "CodeName": "8824", "CodeDesc": "Nursing Home"}
  ];

  List<Map<String, dynamic>> contactJobTitles = [
    {
      "CodeID": "2157",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Accounts Payable"
    },
    {
      "CodeID": "2158",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Administrator"
    },
    {
      "CodeID": "2159",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Anesthesia Assistant"
    },
    {
      "CodeID": "2160",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Anesthesiologist"
    },
    {
      "CodeID": "2161",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Angiographer"
    },
    {"CodeID": "2162", "CodeKey": "ContactJobTitle", "CodeName": "Architect"},
    {"CodeID": "2163", "CodeKey": "ContactJobTitle", "CodeName": "Assistant"},
    {
      "CodeID": "2164",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Attending Physician"
    },
    {"CodeID": "2165", "CodeKey": "ContactJobTitle", "CodeName": "Attorney"},
    {"CodeID": "2166", "CodeKey": "ContactJobTitle", "CodeName": "Audiologist"},
    {"CodeID": "2167", "CodeKey": "ContactJobTitle", "CodeName": "Auditor"},
    {
      "CodeID": "2168",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Bed Controller"
    },
    {
      "CodeID": "2169",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Biostatistician"
    },
    {
      "CodeID": "2170",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Board of Director"
    },
    {"CodeID": "2171", "CodeKey": "ContactJobTitle", "CodeName": "Bookkeeper"},
    {
      "CodeID": "2172",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Branch Chief"
    },
    {
      "CodeID": "2173",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Branch Director"
    },
    {
      "CodeID": "2174",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Branch Manager"
    },
    {
      "CodeID": "2175",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Branch Nurse Manager"
    },
    {
      "CodeID": "2176",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Budget Analyst"
    },
    {
      "CodeID": "2177",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Business Administrator"
    },
    {
      "CodeID": "2178",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Business Coordinator"
    },
    {
      "CodeID": "2179",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Business Development Manager"
    },
    {
      "CodeID": "2180",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Business Development Specialist"
    },
    {
      "CodeID": "2181",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Business Manager"
    },
    {
      "CodeID": "2182",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Business Office Assistant"
    },
    {
      "CodeID": "2183",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Business Office Manager"
    },
    {
      "CodeID": "2184",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Business Operations Manager"
    },
    {
      "CodeID": "2185",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Business System Coordinator"
    },
    {"CodeID": "2186", "CodeKey": "ContactJobTitle", "CodeName": "Captain"},
    {
      "CodeID": "2187",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Cardio-Pulmonary Technician"
    },
    {
      "CodeID": "2188",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Care Management Specialist"
    },
    {
      "CodeID": "2189",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Care Plan Coordinator"
    },
    {"CodeID": "2190", "CodeKey": "ContactJobTitle", "CodeName": "Caregiver"},
    {"CodeID": "2191", "CodeKey": "ContactJobTitle", "CodeName": "Caretaker"},
    {
      "CodeID": "2192",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Case Coordination Manager"
    },
    {
      "CodeID": "2193",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Case Manager"
    },
    {
      "CodeID": "2194",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Case Manager Supervisor"
    },
    {"CodeID": "2195", "CodeKey": "ContactJobTitle", "CodeName": "Case Worker"},
    {"CodeID": "2196", "CodeKey": "ContactJobTitle", "CodeName": "CEO"},
    {
      "CodeID": "2197",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Certified Nursing Assistant"
    },
    {
      "CodeID": "2198",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Certified Public Accountant"
    },
    {
      "CodeID": "2199",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Certified Registered Nurse Anesthetist"
    },
    {
      "CodeID": "2200",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Certified Respiratory Therapy Technologist"
    },
    {"CodeID": "2201", "CodeKey": "ContactJobTitle", "CodeName": "CFO"},
    {"CodeID": "2202", "CodeKey": "ContactJobTitle", "CodeName": "Charge"},
    {
      "CodeID": "2203",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Charge Nurse"
    },
    {
      "CodeID": "2204",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Charge Radiology"
    },
    {
      "CodeID": "2205",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Charge Respiratory Therapist"
    },
    {
      "CodeID": "2206",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Charge Technologist"
    },
    {
      "CodeID": "2207",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Charge Therapist"
    },
    {"CodeID": "2208", "CodeKey": "ContactJobTitle", "CodeName": "Child"},
    {
      "CodeID": "2209",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Chiropractor"
    },
    {
      "CodeID": "2210",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Claims Associate"
    },
    {
      "CodeID": "2211",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Clerical Specialist"
    },
    {
      "CodeID": "2212",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Clerical Supervisor"
    },
    {"CodeID": "2213", "CodeKey": "ContactJobTitle", "CodeName": "Clerk"},
    {"CodeID": "2214", "CodeKey": "ContactJobTitle", "CodeName": "CNO"},
    {"CodeID": "2215", "CodeKey": "ContactJobTitle", "CodeName": "Coder"},
    {"CodeID": "2216", "CodeKey": "ContactJobTitle", "CodeName": "Collector"},
    {"CodeID": "2217", "CodeKey": "ContactJobTitle", "CodeName": "Colonel"},
    {"CodeID": "2218", "CodeKey": "ContactJobTitle", "CodeName": "Commander"},
    {"CodeID": "2219", "CodeKey": "ContactJobTitle", "CodeName": "Companion"},
    {
      "CodeID": "2220",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Compliance Administrator"
    },
    {
      "CodeID": "2221",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Compliance Officer"
    },
    {"CodeID": "2222", "CodeKey": "ContactJobTitle", "CodeName": "Comptroller"},
    {"CodeID": "2223", "CodeKey": "ContactJobTitle", "CodeName": "Consultant"},
    {
      "CodeID": "2224",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Contract Administrator"
    },
    {
      "CodeID": "2225",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Contract Officer"
    },
    {
      "CodeID": "2226",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Contract Specialist"
    },
    {"CodeID": "2227", "CodeKey": "ContactJobTitle", "CodeName": "Controller"},
    {"CodeID": "2228", "CodeKey": "ContactJobTitle", "CodeName": "COO"},
    {"CodeID": "2229", "CodeKey": "ContactJobTitle", "CodeName": "Coordinator"},
    {"CodeID": "2230", "CodeKey": "ContactJobTitle", "CodeName": "Counselor"},
    {
      "CodeID": "2231",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Customer Service Representative"
    },
    {"CodeID": "2232", "CodeKey": "ContactJobTitle", "CodeName": "Cytologist"},
    {
      "CodeID": "2233",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Data Analyst"
    },
    {
      "CodeID": "2234",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Data Coordinator"
    },
    {
      "CodeID": "2235",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Data Manager"
    },
    {
      "CodeID": "2236",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Dean of Pharmacology"
    },
    {
      "CodeID": "2237",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Dental Assistant"
    },
    {
      "CodeID": "2238",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Department Head"
    },
    {"CodeID": "2239", "CodeKey": "ContactJobTitle", "CodeName": "Deputy"},
    {
      "CodeID": "2240",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Deputy Director"
    },
    {
      "CodeID": "2241",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Deputy Executive Director Human Resources"
    },
    {
      "CodeID": "2242",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Deputy Warden"
    },
    {
      "CodeID": "2243",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Dictionary Coder"
    },
    {"CodeID": "2244", "CodeKey": "ContactJobTitle", "CodeName": "Director"},
    {
      "CodeID": "2245",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Discharge Planner"
    },
    {"CodeID": "2246", "CodeKey": "ContactJobTitle", "CodeName": "Doctor"},
    {
      "CodeID": "2247",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Documentation Specialist"
    },
    {"CodeID": "2248", "CodeKey": "ContactJobTitle", "CodeName": "DON"},
    {
      "CodeID": "2249",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Drug Information Associate"
    },
    {
      "CodeID": "2250",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Drug Safety Associate"
    },
    {"CodeID": "2251", "CodeKey": "ContactJobTitle", "CodeName": "Educator"},
    {
      "CodeID": "2252",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Employment Specialist"
    },
    {"CodeID": "2253", "CodeKey": "ContactJobTitle", "CodeName": "Esquire"},
    {
      "CodeID": "2254",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Event Coordinator"
    },
    {"CodeID": "2255", "CodeKey": "ContactJobTitle", "CodeName": "EVP"},
    {
      "CodeID": "2256",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Executive Administrator"
    },
    {
      "CodeID": "2257",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Executive Director"
    },
    {
      "CodeID": "2258",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Executive Nursing Director"
    },
    {
      "CodeID": "2259",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Executive Vice President"
    },
    {"CodeID": "2260", "CodeKey": "ContactJobTitle", "CodeName": "Facilitator"},
    {
      "CodeID": "2261",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Family Member"
    },
    {
      "CodeID": "2262",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Finance Officer"
    },
    {
      "CodeID": "2263",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Financial Planner"
    },
    {"CodeID": "2264", "CodeKey": "ContactJobTitle", "CodeName": "Friend"},
    {"CodeID": "2265", "CodeKey": "ContactJobTitle", "CodeName": "Gatekeeper"},
    {"CodeID": "2266", "CodeKey": "ContactJobTitle", "CodeName": "Grandchild"},
    {"CodeID": "2267", "CodeKey": "ContactJobTitle", "CodeName": "Grandparent"},
    {"CodeID": "2268", "CodeKey": "ContactJobTitle", "CodeName": "Guardian"},
    {"CodeID": "2269", "CodeKey": "ContactJobTitle", "CodeName": "Head Nurse"},
    {
      "CodeID": "2270",
      "CodeKey": "ContactJobTitle",
      "CodeName": "House Supervisor"
    },
    {
      "CodeID": "2271",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Human Resource Coordinator"
    },
    {
      "CodeID": "2272",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Human Resource Manager"
    },
    {
      "CodeID": "2273",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Human Resources"
    },
    {
      "CodeID": "2274",
      "CodeKey": "ContactJobTitle",
      "CodeName": "In - House Monitor"
    },
    {"CodeID": "2275", "CodeKey": "ContactJobTitle", "CodeName": "Instructor"},
    {
      "CodeID": "2276",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Investigator"
    },
    {
      "CodeID": "2277",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Lead Technologist"
    },
    {
      "CodeID": "2278",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Legal Guardian"
    },
    {"CodeID": "2279", "CodeKey": "ContactJobTitle", "CodeName": "Liaison"},
    {
      "CodeID": "2280",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Licensed Practical Nurse"
    },
    {
      "CodeID": "2281",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Maintenance Supervisor"
    },
    {"CodeID": "2282", "CodeKey": "ContactJobTitle", "CodeName": "Major"},
    {"CodeID": "2283", "CodeKey": "ContactJobTitle", "CodeName": "Manager"},
    {
      "CodeID": "2284",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Medical Director"
    },
    {
      "CodeID": "2285",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Medical Officer"
    },
    {
      "CodeID": "2286",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Medical Technologist"
    },
    {
      "CodeID": "2287",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Medical Writer"
    },
    {"CodeID": "2288", "CodeKey": "ContactJobTitle", "CodeName": "Migration"},
    {
      "CodeID": "2289",
      "CodeKey": "ContactJobTitle",
      "CodeName": "National Director"
    },
    {
      "CodeID": "2290",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Nuclear Medical Technologist"
    },
    {
      "CodeID": "2291",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Nurse Executive"
    },
    {
      "CodeID": "2292",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Nurse Manager"
    },
    {
      "CodeID": "2293",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Nurse Manager - Day"
    },
    {
      "CodeID": "2294",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Nurse Practitioner"
    },
    {
      "CodeID": "2295",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Nursing Director"
    },
    {
      "CodeID": "2296",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Nursing Manager"
    },
    {
      "CodeID": "2297",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Nursing Supervisor"
    },
    {
      "CodeID": "2298",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Occupational Therapist"
    },
    {
      "CodeID": "2299",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Office Administrator"
    },
    {
      "CodeID": "2300",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Office Manager"
    },
    {"CodeID": "2301", "CodeKey": "ContactJobTitle", "CodeName": "On Call"},
    {"CodeID": "2302", "CodeKey": "ContactJobTitle", "CodeName": "Owner"},
    {"CodeID": "2303", "CodeKey": "ContactJobTitle", "CodeName": "Pager"},
    {
      "CodeID": "2304",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Pager - Supervisor"
    },
    {
      "CodeID": "2305",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Pager - Weekend"
    },
    {"CodeID": "2306", "CodeKey": "ContactJobTitle", "CodeName": "Paralegal"},
    {"CodeID": "2307", "CodeKey": "ContactJobTitle", "CodeName": "Parent"},
    {"CodeID": "2308", "CodeKey": "ContactJobTitle", "CodeName": "Partner"},
    {
      "CodeID": "2309",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Patient Care Coordinator"
    },
    {
      "CodeID": "2310",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Payroll Clerk"
    },
    {"CodeID": "2311", "CodeKey": "ContactJobTitle", "CodeName": "Pharmacist"},
    {
      "CodeID": "2312",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Phlebotomist"
    },
    {
      "CodeID": "2313",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Physical Therapist"
    },
    {"CodeID": "2314", "CodeKey": "ContactJobTitle", "CodeName": "Physician"},
    {
      "CodeID": "2315",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Police Officer"
    },
    {
      "CodeID": "2316",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Power of Attorney"
    },
    {"CodeID": "2317", "CodeKey": "ContactJobTitle", "CodeName": "Preceptor"},
    {"CodeID": "2318", "CodeKey": "ContactJobTitle", "CodeName": "President"},
    {"CodeID": "2319", "CodeKey": "ContactJobTitle", "CodeName": "Principal"},
    {
      "CodeID": "2320",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Privacy Officer"
    },
    {
      "CodeID": "2321",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Program Manager"
    },
    {
      "CodeID": "2322",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Project Manager"
    },
    {
      "CodeID": "2323",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Project Specialist"
    },
    {
      "CodeID": "2324",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Purchasing Agent"
    },
    {
      "CodeID": "2325",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Quality Assurance Associate"
    },
    {
      "CodeID": "2326",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Quality Assurance Auditor"
    },
    {
      "CodeID": "2327",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Radiology Technician"
    },
    {
      "CodeID": "2328",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Radiology Technologist"
    },
    {
      "CodeID": "2329",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Receptionist"
    },
    {"CodeID": "2330", "CodeKey": "ContactJobTitle", "CodeName": "Recruiter"},
    {"CodeID": "2331", "CodeKey": "ContactJobTitle", "CodeName": "Regional"},
    {
      "CodeID": "2332",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Regulatory Affairs Associate"
    },
    {
      "CodeID": "2333",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Rehabilitation Director"
    },
    {
      "CodeID": "2334",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Research Nurse"
    },
    {
      "CodeID": "2335",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Research Scientist"
    },
    {
      "CodeID": "2336",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Respiratory Therapist"
    },
    {
      "CodeID": "2337",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Risk Manager"
    },
    {
      "CodeID": "2338",
      "CodeKey": "ContactJobTitle",
      "CodeName": "School Nurse"
    },
    {"CodeID": "2339", "CodeKey": "ContactJobTitle", "CodeName": "Secretary"},
    {
      "CodeID": "2340",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Senior Clinical Research Associate"
    },
    {
      "CodeID": "2341",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Senior Data Manager"
    },
    {
      "CodeID": "2342",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Senior Regulatory Affairs Associate"
    },
    {"CodeID": "2343", "CodeKey": "ContactJobTitle", "CodeName": "Sergeant"},
    {"CodeID": "2344", "CodeKey": "ContactJobTitle", "CodeName": "Sibling"},
    {
      "CodeID": "2345",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Site Manager"
    },
    {
      "CodeID": "2346",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Social Worker"
    },
    {"CodeID": "2347", "CodeKey": "ContactJobTitle", "CodeName": "Specialist"},
    {
      "CodeID": "2348",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Speech Language Pathologist"
    },
    {"CodeID": "2349", "CodeKey": "ContactJobTitle", "CodeName": "Spouse"},
    {
      "CodeID": "2350",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Nursing Coordinator"
    },
    {
      "CodeID": "2351",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Statistical Analysis System Programmer"
    },
    {
      "CodeID": "2352",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Study Coordinator"
    },
    {
      "CodeID": "2353",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Superintendent"
    },
    {"CodeID": "2354", "CodeKey": "ContactJobTitle", "CodeName": "Supervisor"},
    {"CodeID": "2355", "CodeKey": "ContactJobTitle", "CodeName": "Surgeon"},
    {
      "CodeID": "2356",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Switchboard Operator"
    },
    {"CodeID": "2357", "CodeKey": "ContactJobTitle", "CodeName": "Team Leader"},
    {"CodeID": "2358", "CodeKey": "ContactJobTitle", "CodeName": "Technician"},
    {
      "CodeID": "2359",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Technologist"
    },
    {"CodeID": "2360", "CodeKey": "ContactJobTitle", "CodeName": "Therapist"},
    {
      "CodeID": "2361",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Trust Officer"
    },
    {"CodeID": "2362", "CodeKey": "ContactJobTitle", "CodeName": "Underwriter"},
    {
      "CodeID": "2363",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Unit Manager"
    },
    {
      "CodeID": "2364",
      "CodeKey": "ContactJobTitle",
      "CodeName": "Vice President"
    },
    {"CodeID": "2365", "CodeKey": "ContactJobTitle", "CodeName": "VP"},
    {"CodeID": "2366", "CodeKey": "ContactJobTitle", "CodeName": "Warden"}
  ];

  List<Map<String, dynamic>> rateTypes = [
    {"CodeID": "2491", "CodeKey": "RateType", "CodeName": "Contract Rate"},
    {
      "CodeID": "2492",
      "CodeKey": "RateType",
      "CodeName": "Medical / Surgical Rate"
    },
    {"CodeID": "2493", "CodeKey": "RateType", "CodeName": "Orientation Rate"},
    {"CodeID": "2494", "CodeKey": "RateType", "CodeName": "Specialty Rate"},
    {
      "CodeID": "2683",
      "CodeKey": "RateType",
      "CodeName": "Per Diem - Scheduled Daily"
    },
    {
      "CodeID": "2684",
      "CodeKey": "RateType",
      "CodeName": "13 Week Contract - Long Term Assignment"
    },
    {
      "CodeID": "2685",
      "CodeKey": "RateType",
      "CodeName":
          "Subsidy - Tax Free - Long Term Assignment Weekly Subsidy Amount"
    },
    {"CodeID": "2686", "CodeKey": "RateType", "CodeName": "Referral Bonus"},
    {"CodeID": "2741", "CodeKey": "RateType", "CodeName": "Evaluation"},
    {"CodeID": "2742", "CodeKey": "RateType", "CodeName": "Recertification"},
    {
      "CodeID": "2743",
      "CodeKey": "RateType",
      "CodeName": "Evaluation Orientation"
    },
    {
      "CodeID": "2744",
      "CodeKey": "RateType",
      "CodeName": "Recertification Orientation"
    },
    {
      "CodeID": "2755",
      "CodeKey": "RateType",
      "CodeName": "Travel - Travel Mileage"
    },
    {"CodeID": "2837", "CodeKey": "RateType", "CodeName": "Premium Rate"}
  ];

  List<Map<String, dynamic>> rateGroupTypes = [
    {
      "CodeID": 1402,
      "CodeKey": "RateGroupType",
      "CodeName": "Daily Rate",
      "CodeDescription": "Daily Rate",
      "CodeValue": "D"
    },
    {
      "CodeID": 1403,
      "CodeKey": "RateGroupType",
      "CodeName": "Contract Rate",
      "CodeDescription": "Contract Rate",
      "CodeValue": "C"
    },
    {
      "CodeID": 1404,
      "CodeKey": "RateGroupType",
      "CodeName": "Client Template",
      "CodeDescription": "Client Template",
      "CodeValue": "T"
    }
  ];
  List<Map<String, dynamic>> credentials = [
    {
      "CodeID": 116,
      "CodeDescription": 'ACLS Expiration Date',
      "CodeValue": 'ACLS',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 117,
      "CodeDescription": 'Age Specific Competency',
      "CodeValue": 'AGE',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 118,
      "CodeDescription": 'Professional Certification - Number',
      "CodeValue": 'CERT',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 119,
      "CodeDescription": 'Continuing Education Units',
      "CodeValue": 'CEU - Governing Board Required',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 120,
      "CodeDescription": 'CPR Certification Exp Date',
      "CodeValue": 'CPR',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 121,
      "CodeDescription": 'Criminal Background Check',
      "CodeValue": 'CRIM',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 122,
      "CodeDescription": 'Consent/Disclaimer Form Signed',
      "CodeValue": 'DISCL',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 123,
      "CodeDescription": 'Drug Screen',
      "CodeValue": 'Drug',
      "CodeKey": 'Credential',
      "CredentialType": '+-RES'
    },
    {
      "CodeID": 124,
      "CodeDescription": 'Performance Evaluation',
      "CodeValue": 'EVAL',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 125,
      "CodeDescription": 'Hep B Information',
      "CodeValue": 'HEPB',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 126,
      "CodeDescription": 'Health Assessment',
      "CodeValue": 'HLTH',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 127,
      "CodeDescription": 'IV Certification',
      "CodeValue": 'IV',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 128,
      "CodeDescription": 'JCAHO Core Mandatory Tests (via NT)',
      "CodeValue": '2009 Core Mandatory Part I - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 129,
      "CodeDescription": 'Medication Administration Test',
      "CodeValue": 'MED',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 130,
      "CodeDescription": 'Neonatal Resusitation Provider',
      "CodeValue": 'NRP',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 131,
      "CodeDescription": 'OSHA Mandatory Module V4',
      "CodeValue": 'OSHA Mandatory Module V4 - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 132,
      "CodeDescription": 'Pediatric Advanced Life Support',
      "CodeValue": 'PALS',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 133,
      "CodeDescription": 'TB Test Expiration Date',
      "CodeValue": 'PPD',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 134,
      "CodeDescription": 'Rubella',
      "CodeValue": 'RUBEL',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 135,
      "CodeDescription": 'Rubeola',
      "CodeValue": 'RUBEO',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 136,
      "CodeDescription": 'OIG/GSA Exclusion (Contractor)',
      "CodeValue": 'Sanct',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 137,
      "CodeDescription": 'TB Symptoms Review Form',
      "CodeValue": 'TBSR',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 138,
      "CodeDescription": 'Varicella',
      "CodeValue": 'VARI',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 139,
      "CodeDescription": 'Chest X-Ray (Positive PPD)',
      "CodeValue": 'XRAY',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 140,
      "CodeDescription": 'Excluded Parties Listing Service',
      "CodeValue": 'EPLS - Annually',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 141,
      "CodeDescription": 'Professional License - Number',
      "CodeValue": 'LIC',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 143,
      "CodeDescription": 'Annual Skills Checklist',
      "CodeValue": 'Skills Checklist',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 144,
      "CodeDescription": 'References',
      "CodeValue": 'Clinical Reference',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 145,
      "CodeDescription": 'Signed Job Description',
      "CodeValue": 'Job Description',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 146,
      "CodeDescription": 'Board Status - Clear',
      "CodeValue": 'License Status Verified - Annually',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 147,
      "CodeDescription": 'Signed Application',
      "CodeValue": 'Application',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 148,
      "CodeDescription": 'Signed CMS Gerenal Orientation Doc',
      "CodeValue": 'CMS General Orientation',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 149,
      "CodeDescription": 'Abuse Registry Check',
      "CodeValue": 'Abuse',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 150,
      "CodeDescription": 'Non-Clinical Reference',
      "CodeValue": 'Professional Reference',
      "CodeKey": 'Credential',
      "CredentialType": '+-RES'
    },
    {
      "CodeID": 151,
      "CodeDescription": 'NT Core Mandatory Part II (Nursing)',
      "CodeValue": '2009 Core Mandatory Part II (Nursing) - MandatoryT',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 152,
      "CodeDescription": 'LPN - Long Term Care A v1 - Clinical',
      "CodeValue": 'LPN - Long Term Care A v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 153,
      "CodeDescription": 'NT Core Mandatory Part II (Allied)',
      "CodeValue": '2009 Core Mandatory Part II (Allied) - MandatoryTe',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 154,
      "CodeDescription": 'NT RN Pharmacology - Test',
      "CodeValue": '2010 Medical Surgical Exam A - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 155,
      "CodeDescription": 'CNA - Long Term Care B V1',
      "CodeValue": 'Long Term Care CNA B - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 156,
      "CodeDescription": 'CNA - Long Term Care A V1',
      "CodeValue": 'Long Term Care CNA A - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 157,
      "CodeDescription": 'NT Core Mand Part II (Non-Licensed)',
      "CodeValue": '2009 Core Mandatory Part II (Non-Licensed) - Manda',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 158,
      "CodeDescription": 'NT CNA Acute',
      "CodeValue": 'CNA Acute Care A  - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 159,
      "CodeDescription": 'NT Medical Assist',
      "CodeValue": 'Medical Assistant - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 160,
      "CodeDescription": 'NT Medical Biller/Coder',
      "CodeValue": 'Medical Biller/Coder - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 161,
      "CodeDescription": 'NT OT',
      "CodeValue": 'Occupational Therapist - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 162,
      "CodeDescription": 'NT Phleb',
      "CodeValue": 'Phlebotomy - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 163,
      "CodeDescription": 'NT Physical Therapy',
      "CodeValue": 'Physical Therapist 100108 - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 164,
      "CodeDescription": 'NT EKG/Tele Tech',
      "CodeValue": 'Tele Tech/EKG Rhythms Ver 2 - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 165,
      "CodeDescription": 'NT Dietician Checklist',
      "CodeValue": 'Dietician - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 166,
      "CodeDescription": 'NT PTA Checkist',
      "CodeValue": 'Physical Therapy Assistant - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 167,
      "CodeDescription": 'NT - ER RN',
      "CodeValue": 'Emergency Room0408 - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 168,
      "CodeDescription": 'NT - ER RN Med Test',
      "CodeValue": 'ER Medications1008 - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 169,
      "CodeDescription": 'NT - RN Telemetry Test',
      "CodeValue": 'Telemetry0508 - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 170,
      "CodeDescription": 'NT - RN Critical Care Test',
      "CodeValue": 'Critical Care - California - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 171,
      "CodeDescription": 'NT SRN NICU Pharm Test',
      "CodeValue": 'NICU Pharmacology - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 172,
      "CodeDescription": 'NT SRN NICU Test',
      "CodeValue": 'NICU0508 - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 173,
      "CodeDescription": 'NT RN NICU Checklist',
      "CodeValue": 'NICU - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 174,
      "CodeDescription": 'NT RN - Dialysis',
      "CodeValue": 'Dialysis - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 175,
      "CodeDescription": 'NT RN Dialysis',
      "CodeValue": 'Dialysis - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 176,
      "CodeDescription": 'NT RN Psych Test',
      "CodeValue": 'Psychiatric - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 177,
      "CodeDescription": 'NT Tele RN Checklist',
      "CodeValue": 'Telemetry - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 178,
      "CodeDescription": 'NT RN Home Health Test',
      "CodeValue": 'HHC-Medication - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 179,
      "CodeDescription": 'NT - CST Checklist',
      "CodeValue": 'OR/Surgical Technologist - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 180,
      "CodeDescription": 'NT RN TELE Dysrhythmia Exam',
      "CodeValue": 'Dysrhythmia (Basic)_Interpretation Only_A - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 181,
      "CodeDescription": 'NT RN Pediatric Assessment test',
      "CodeValue": 'Pediatrics - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 182,
      "CodeDescription": 'NT RN Peds Pharmacology Tests',
      "CodeValue": 'PEDS Pharmacology - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 183,
      "CodeDescription": 'NT RN Medical Surgical Test',
      "CodeValue": 'Medical Surgical B - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 184,
      "CodeDescription": 'Long Term Care RN A - Clinical',
      "CodeValue": 'Long Term Care RN A - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 185,
      "CodeDescription": 'NT LTC Pharmacology Test',
      "CodeValue": 'Geriatric LTC-Pharmacology - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 186,
      "CodeDescription": 'NT Respiratory Therapist Checklist',
      "CodeValue": 'Respiratory Therapist0408 - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 187,
      "CodeDescription": 'CNA - II Certificate',
      "CodeValue": 'CNA - II Certification',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 188,
      "CodeDescription": 'NT - CMA Checklist',
      "CodeValue": 'Certified Medication Aide - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 189,
      "CodeDescription": 'NT Psych Tech Checklist',
      "CodeValue": 'Psychiatric Technician/Behavioral Health Tech - Al',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 190,
      "CodeDescription": '',
      "CodeValue": 'HIPAA Mandatory Exam0208 - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 191,
      "CodeDescription": 'NT - Geriatric test',
      "CodeValue": 'Geriatric-LTC - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 192,
      "CodeDescription": 'NT - RN OR Test',
      "CodeValue": 'Operating Room - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 193,
      "CodeDescription": 'NT Psych Tech Cheklist',
      "CodeValue": 'Psych Technician/Behavioral Health Tech - CheckLis',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 194,
      "CodeDescription": 'NT CNA Checklist',
      "CodeValue": 'CNA-Sitter - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 195,
      "CodeDescription": 'NT RN Case Manager Test',
      "CodeValue": 'RN/LPN Case Manager v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 196,
      "CodeDescription": 'NT Case Manager Checklist',
      "CodeValue": 'RN/LPN Case Manager - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 197,
      "CodeDescription": 'Alleging Fraud',
      "CodeValue": ' Breach of Trust',
      "CodeKey": 'Credential',
      "CredentialType": ''
    },
    {
      "CodeID": 198,
      "CodeDescription": 'Theft',
      "CodeValue": ' Fraud',
      "CodeKey": 'Credential',
      "CredentialType": 'False'
    },
    {
      "CodeID": 199,
      "CodeDescription": 'NT Cardiac Cath Lab Checklist',
      "CodeValue": 'Cardiac Cath Lab - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 200,
      "CodeDescription": '12 Panel Drug Test',
      "CodeValue": 'Negative Drug Screen - 12 Panel',
      "CodeKey": 'Credential',
      "CredentialType": '+-RES'
    },
    {
      "CodeID": 201,
      "CodeDescription": '',
      "CodeValue": 'Operating Room- Scrub 0309 - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 202,
      "CodeDescription": 'NT - RN (OR Circulating) Checklist',
      "CodeValue": 'Operating Room - Circulating 0309 - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 203,
      "CodeDescription": 'References',
      "CodeValue": 'References',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 204,
      "CodeDescription": 'Release',
      "CodeValue": 'SRVS Release',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 205,
      "CodeDescription": 'DMRS',
      "CodeValue": 'DMRS',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 206,
      "CodeDescription": 'Identification',
      "CodeValue": 'ID',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 207,
      "CodeDescription": 'TN Fire Safety',
      "CodeValue": 'TN Fire Safety',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 208,
      "CodeDescription": 'NT Rad Tech Checklist',
      "CodeValue": 'Rad Tech/X-Ray Tech0908 - AlliedList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 209,
      "CodeDescription": 'NT MRI',
      "CodeValue": 'MRI TECHNOLOGIST - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 210,
      "CodeDescription": '',
      "CodeValue": 'Geriatric/LTC - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 211,
      "CodeDescription": '2009 JCAHO Core Mandataory III',
      "CodeValue": '2009 Core Mandatory Part III - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 212,
      "CodeDescription": '2 yrs Acute Care Exp',
      "CodeValue": 'Two Years Hospital Experience',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 213,
      "CodeDescription": 'NT Checklist Echo-Vasc Tech',
      "CodeValue": 'ECHO-VASCULAR TECHNICIAN - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 214,
      "CodeDescription": '',
      "CodeValue": 'Critical Care - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 215,
      "CodeDescription": '',
      "CodeValue": 'Med-Surg/Tele Combo - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 219,
      "CodeDescription": 'RN/LPN Corrections',
      "CodeValue": 'Corrections-RN/LPN - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 220,
      "CodeDescription": 'RN-P PACU NT Test',
      "CodeValue": 'PACU0408 - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 221,
      "CodeDescription": 'RN-P NT PACU Checklist',
      "CodeValue": 'PACU - CheckList',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 222,
      "CodeDescription": '',
      "CodeValue": 'Critical Care Medications - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 223,
      "CodeDescription": 'LPN - Long Term Care B v1 - Clinical',
      "CodeValue": 'LPN - Long Term Care B v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 224,
      "CodeDescription": 'Statement',
      "CodeValue": 'CMS Code of Conduct',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 225,
      "CodeDescription": 'RN Med/Surg Checklist',
      "CodeValue": 'Medical Surgical A - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 226,
      "CodeDescription": 'Proof of Immunity',
      "CodeValue": 'H1N1 Flu Vaccination',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 227,
      "CodeDescription": 'Long Term Care RN B - Clinical',
      "CodeValue": 'Long Term Care RN B - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 228,
      "CodeDescription": 'JCAHO Core Mandatory Tests (via NT)',
      "CodeValue": '2010 Core Mandatory Part I - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 229,
      "CodeDescription": 'NT Core Mandatory Part II (Allied)',
      "CodeValue": '2010 Core Mandatory Part II (Allied) - MandatoryTe',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 230,
      "CodeDescription": 'NT Core Mand Part II (Non Licensed)',
      "CodeValue": '2010 Core Mandatory Part II (Non-Licensed) - Manda',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 231,
      "CodeDescription": 'NT Core Mandatory Part II (Nursing)',
      "CodeValue": '2010 Core Mandatory Part II (Nursing) - MandatoryT',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 232,
      "CodeDescription": '2009 JCAHO Core Mandatory III',
      "CodeValue": '2010 Core Mandatory Part III - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 233,
      "CodeDescription": 'Confidentiality Agreement',
      "CodeValue": 'Confidentiality Agreement',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 236,
      "CodeDescription": 'Work Comp Procedure Policy',
      "CodeValue": 'Work Comp Procedure Policy',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 238,
      "CodeDescription": 'RN Pharmacology',
      "CodeValue": '2010 RN Pharmacology Exam A - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 239,
      "CodeDescription": 'Abuse Mandatory 0408.2',
      "CodeValue": 'Abuse Mandatory0408 - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 240,
      "CodeDescription": 'HIPPA Statement',
      "CodeValue": 'HIPAA Statement',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 241,
      "CodeDescription": '2011 Core Mandatory Part I',
      "CodeValue": '2011 Core Mandatory Part I - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'LICNS'
    },
    {
      "CodeID": 242,
      "CodeDescription": '2011 Core Mandatory Part II (Allied',
      "CodeValue": '2011 Core Mandatory Part II (Allied) - MandatoryTe',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 243,
      "CodeDescription": '2011 Core Mandatory Part II (Non-Li',
      "CodeValue": '2011 Core Mandatory Part II (Non-Licensed) - Manda',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 244,
      "CodeDescription": '2011 Core Mandatory Part II (Nursin',
      "CodeValue": '2011 Core Mandatory Part II (Nursing) - MandatoryT',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 245,
      "CodeDescription": '2011 Core Mandatory Part III',
      "CodeValue": '2011 Core Mandatory Part III - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 246,
      "CodeDescription": '2011 NPSG Mandatory (Allied)',
      "CodeValue": '2011 NPSG Mandatory (Allied) - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 247,
      "CodeDescription": '2011 NPSG Mandatory (Non-Licensed)',
      "CodeValue": '2011 NPSG Mandatory (Non-Licensed Personnel) - Man',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 248,
      "CodeDescription": 'Fingerprints',
      "CodeValue": 'Fingerprints',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 249,
      "CodeDescription": 'Sexual Abuse',
      "CodeValue": 'Sexual Harassment Mandatory - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 250,
      "CodeDescription": 'Violence in the Workplace',
      "CodeValue": 'Workplace Violence Mandatory - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 251,
      "CodeDescription": 'Backkground Verification',
      "CodeValue": 'Background Verification',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 252,
      "CodeDescription": 'Measels Mumps Rubella',
      "CodeValue": 'MMR',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 253,
      "CodeDescription": 'TN Title VI',
      "CodeValue": 'TN Title VI',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 254,
      "CodeDescription": 'TN Universal Precautions',
      "CodeValue": 'TN Universal Precautions',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 255,
      "CodeDescription": 'TN Direct Support',
      "CodeValue": 'TN Direct Support',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 256,
      "CodeDescription": 'TN HIPPA',
      "CodeValue": 'TN HIPPA',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 257,
      "CodeDescription": 'TN Incident Reporting',
      "CodeValue": 'TN Incident Reporting',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 258,
      "CodeDescription": 'TN Maltreatment',
      "CodeValue": 'TN Maltreatment',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 259,
      "CodeDescription": 'TN Safety in the Home and Community',
      "CodeValue": 'TN Safety Home',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 260,
      "CodeDescription": 'Staff Development',
      "CodeValue": 'Staff Development',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 261,
      "CodeDescription": '2012 Core Mandatory Part 2',
      "CodeValue": '2012 Core Mandatory Part I - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 262,
      "CodeDescription": '2012 Core Mandatory Part II (Non-Li',
      "CodeValue": '2012 Core Mandatory Part II (Non-Licensed) - Manda',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 263,
      "CodeDescription": '2012 Core Mandatory Part II (Nursin',
      "CodeValue": '2012 Core Mandatory Part II (Nursing) - MandatoryT',
      "CodeKey": 'Credential',
      "CredentialType": 'SCORE'
    },
    {
      "CodeID": 264,
      "CodeDescription": '2012 Core Mandatory Part III',
      "CodeValue": '2012 Core Mandatory Part III - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 265,
      "CodeDescription": 'E Verify',
      "CodeValue": 'E Verify',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 266,
      "CodeDescription": '2016 Core Mandatory Part I V8',
      "CodeValue": '2016 Core Mandatory Part I V8 - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 267,
      "CodeDescription": '2016 Core Mandatory Part II (Non-Licensed) V6',
      "CodeValue":
          '2016 Core Mandatory Part II (Non-Licensed) V6 - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 268,
      "CodeDescription": '2016 Core Mandatory Part II (Nursing) V8',
      "CodeValue": '2016 Core Mandatory Part II (Nursing) V8 - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 269,
      "CodeDescription": '2016 Core Mandatory Part III V6',
      "CodeValue": '2016 Core Mandatory Part III V6 - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 270,
      "CodeDescription": 'OIG',
      "CodeValue": 'OIG',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 271,
      "CodeDescription": 'Mississippi Letter',
      "CodeValue": 'Mississippi Letter',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 272,
      "CodeDescription": 'SCS Requirement',
      "CodeValue": 'SCS Requirement',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 273,
      "CodeDescription": 'Relias Training',
      "CodeValue": 'Relias Training',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 274,
      "CodeDescription": 'CPI Training',
      "CodeValue": 'CPI Training',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 275,
      "CodeDescription": 'Meritan Release Form',
      "CodeValue": 'Meritan Release Form',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 276,
      "CodeDescription": 'Core Mandatory Part I - MandatoryTest',
      "CodeValue": '2018 Core Mandatory Part I - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 277,
      "CodeDescription": '2018 Core Mandatory Part II (Non-Licensed)',
      "CodeValue": '2018 Core Mandatory Part II (Non-Licensed) - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 278,
      "CodeDescription": '2018 Core Mandatory Part II (Allied)',
      "CodeValue": '2018 Core Mandatory Part II (Allied) - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 279,
      "CodeDescription": '2018 Core Mandatory Part II (Nursing)',
      "CodeValue": '2018 Core Mandatory Part II (Nursing) - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 280,
      "CodeDescription": 'Tennessee Abuse Registry',
      "CodeValue": 'TN Abuse Registry',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 281,
      "CodeDescription": 'D & S  Consent and Authorization Form',
      "CodeValue": 'D & S  Consent',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 282,
      "CodeDescription": 'D & S Annual Relias Course Work',
      "CodeValue": 'D & S Annual Relias',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 283,
      "CodeDescription": 'CMA Checklist',
      "CodeValue": 'Medical Assistant - Checklist',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 284,
      "CodeDescription": 'RN Psych Test',
      "CodeValue": 'RN Psychiatric / Behavioral Health V1 - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 285,
      "CodeDescription": 'RN Psych - Checklist',
      "CodeValue": 'RN-Psychiatric/Behavioral Health - Checklist',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 286,
      "CodeDescription": '',
      "CodeValue": 'Medical Surgical - Checklist',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 287,
      "CodeDescription": 'Psychiatric/Behavioral Health - Checklist',
      "CodeValue": 'Psychiatric/Behavioral Health - Checklist',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 288,
      "CodeDescription": 'Medical Assistant A V1',
      "CodeValue": 'Medical Assistant A V1',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 289,
      "CodeDescription": 'CNA Certification',
      "CodeValue": 'CNA CERT',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 290,
      "CodeDescription": 'RN Psych Test',
      "CodeValue": 'Psychiatric RN (Acute) A - Test',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 291,
      "CodeDescription": '2019 Core Mandatory Part I',
      "CodeValue": '2019 Core Mandatory Part I - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 292,
      "CodeDescription": '2019 Core Mandatory Part II',
      "CodeValue": '2019 Core Mandatory Part II (Allied) - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 293,
      "CodeDescription": '2019 Core Mandatory Part II',
      "CodeValue": '2019 Core Mandatory Part II (Non-Licensed) - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 294,
      "CodeDescription": '2019 Core Mandatory Part II',
      "CodeValue": '2019 Core Mandatory Part II (Nursing) - MandatoryTest',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 295,
      "CodeDescription": 'School Nurse - Checklist',
      "CodeValue": 'School Nurse - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 296,
      "CodeDescription": 'SC License Only',
      "CodeValue": 'SC Only',
      "CodeKey": 'Credential',
      "CredentialType": 'LICNS'
    },
    {
      "CodeID": 297,
      "CodeDescription": 'GA Only License',
      "CodeValue": 'GA Only',
      "CodeKey": 'Credential',
      "CredentialType": 'LICNS'
    },
    {
      "CodeID": 298,
      "CodeDescription": '',
      "CodeValue": 'D & S Checklist',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 299,
      "CodeDescription": 'Abuse Test',
      "CodeValue": 'Abuse: Child',
      "CodeKey": 'Credential',
      "CredentialType": 'False'
    },
    {
      "CodeID": 300,
      "CodeDescription": 'Med Tech Cert',
      "CodeValue": 'Med Tech Cert',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 301,
      "CodeDescription": 'Special Training for Private Homes',
      "CodeValue": 'DIDDS',
      "CodeKey": 'Credential',
      "CredentialType": 'CEU'
    },
    {
      "CodeID": 302,
      "CodeDescription": '',
      "CodeValue": 'Sex Offender Report',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 303,
      "CodeDescription": 'AK License',
      "CodeValue": 'AK License',
      "CodeKey": 'Credential',
      "CredentialType": 'LICNS'
    },
    {
      "CodeID": 304,
      "CodeDescription": 'COVID Vaccine Card',
      "CodeValue": 'COVID Vaccine Card',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    },
    {
      "CodeID": 305,
      "CodeDescription": 'COVID Vaccine w/ Exp Date',
      "CodeValue": 'COVID Vaccine w/ Exp Date',
      "CodeKey": 'Credential',
      "CredentialType": 'EXPDT'
    },
    {
      "CodeID": 306,
      "CodeDescription": 'General ICU - Self',
      "CodeValue": 'General ICU - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 307,
      "CodeDescription": 'General ICU RN A v3 - Clinical',
      "CodeValue": 'General ICU RN A v3 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 308,
      "CodeDescription": 'General ICU RN B v3 - Clinical',
      "CodeValue": 'General ICU RN B v3 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 309,
      "CodeDescription": 'ED RN A - Clinical',
      "CodeValue": 'ED RN A - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 310,
      "CodeDescription": 'ED RN B - Clinical',
      "CodeValue": 'ED RN B - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 311,
      "CodeDescription": '',
      "CodeValue": 'HIPAA - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 312,
      "CodeDescription": 'CNA - Self',
      "CodeValue": 'CNA - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 313,
      "CodeDescription": 'Charge RN - Self',
      "CodeValue": 'Charge RN - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 314,
      "CodeDescription": 'Home Health - Self',
      "CodeValue": 'Home Health - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 315,
      "CodeDescription": 'Hospice And Palliative CNA - Self',
      "CodeValue": 'Hospice And Palliative CNA - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 316,
      "CodeDescription": 'Hospice And Palliative LPN - Self',
      "CodeValue": 'Hospice And Palliative LPN - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 317,
      "CodeDescription": 'Hospice And Palliative RN - Self',
      "CodeValue": 'Hospice And Palliative RN - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 318,
      "CodeDescription": 'LPN/LVN Competency - Self',
      "CodeValue": 'LPN/LVN Competency - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 319,
      "CodeDescription": 'Medical Assistant - Self',
      "CodeValue": 'Medical Assistant - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 320,
      "CodeDescription": 'Medication Aide - Self',
      "CodeValue": 'Medication Aide - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 321,
      "CodeDescription": 'Radiology Technologist - Self',
      "CodeValue": 'Radiology Technologist - Self',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 322,
      "CodeDescription": 'Case Manager RN A v1 - Clinical',
      "CodeValue": 'Case Manager RN A v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 323,
      "CodeDescription": 'Case Manager RN B - Clinical',
      "CodeValue": 'Case Manager RN B - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 324,
      "CodeDescription": 'CNA Acute Care A  v1 - Clinical',
      "CodeValue": 'CNA Acute Care A  v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 325,
      "CodeDescription": 'CNA Acute Care B  v1 - Clinical',
      "CodeValue": 'CNA Acute Care B  v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 326,
      "CodeDescription": 'CNA Sitter A - Clinical',
      "CodeValue": 'CNA Sitter A - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 327,
      "CodeDescription": 'CNA Sitter B - Clinical',
      "CodeValue": 'CNA Sitter B - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 328,
      "CodeDescription": 'Home Health Aide A - Clinical',
      "CodeValue": 'Home Health Aide A - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 329,
      "CodeDescription": 'Home Health Aide B - Clinical',
      "CodeValue": 'Home Health Aide B - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 330,
      "CodeDescription": 'Home Health RN A v2 - Clinical',
      "CodeValue": 'Home Health RN A v2 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 331,
      "CodeDescription": 'Home Health RN B v2 - Clinical',
      "CodeValue": 'Home Health RN B v2 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 332,
      "CodeDescription": 'Hospice RN AV2 - Clinical',
      "CodeValue": 'Hospice RN AV2 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 333,
      "CodeDescription": 'Hospice RN BV2 - Clinical',
      "CodeValue": 'Hospice RN BV2 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 334,
      "CodeDescription": 'LPN Pharmacology_Acute A v1 - Clinical',
      "CodeValue": 'LPN Pharmacology_Acute A v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 335,
      "CodeDescription": 'LPN Pharmacology_Acute B v1 - Clinical',
      "CodeValue": 'LPN Pharmacology_Acute B v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 336,
      "CodeDescription": 'LPN Pharmacology_Long Term Care A  v1 - Clinical',
      "CodeValue": 'LPN Pharmacology_Long Term Care A  v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 337,
      "CodeDescription": 'LPN Pharmacology_Long Term Care B v1 - Clinical',
      "CodeValue": 'LPN Pharmacology_Long Term Care B v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 338,
      "CodeDescription": 'LPN/LVN A - Clinical',
      "CodeValue": 'LPN/LVN A - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 339,
      "CodeDescription": 'Medical Assistant B - Clinical',
      "CodeValue": 'Medical Assistant B - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 340,
      "CodeDescription": 'School RN A v1 - Clinical',
      "CodeValue": 'School RN A v1 - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 341,
      "CodeDescription": 'School RN B - Clinical',
      "CodeValue": 'School RN B - Clinical',
      "CodeKey": 'Credential',
      "CredentialType": 'NTSCORE'
    },
    {
      "CodeID": 342,
      "CodeDescription": 'TN only License',
      "CodeValue": 'TN only',
      "CodeKey": 'Credential',
      "CredentialType": 'LICNS'
    },
    {
      "CodeID": 343,
      "CodeDescription": 'NC only License',
      "CodeValue": 'NC Only',
      "CodeKey": 'Credential',
      "CredentialType": 'LICNS'
    },
    {
      "CodeID": 344,
      "CodeDescription": 'VA only License',
      "CodeValue": 'VA Only',
      "CodeKey": 'Credential',
      "CredentialType": 'LICNS'
    },
    {
      "CodeID": 345,
      "CodeDescription": 'Professional License',
      "CodeValue": 'Professional License',
      "CodeKey": 'Credential',
      "CredentialType": 'MLICN'
    },
    {
      "CodeID": 346,
      "CodeDescription": '',
      "CodeValue": 'SAMS',
      "CodeKey": 'Credential',
      "CredentialType": 'YESNO'
    }
  ];
  Map<String, dynamic> getCredentials(int v) {
    Map<String, dynamic> st = {};
    bool haveValue = false;
    for (Map<String, dynamic> item in rateGroupTypes) {
      item.forEach((key, value) {
        //print('line 2620: $key $value $v');
        if (key == "CodeID" && value == v) {
          st = item;
          haveValue = true;
        }
      });
      if (haveValue == true) {
        break;
      }
    }
    return st;
  }

  Map<String, dynamic> getRateGroupTypes(int v) {
    Map<String, dynamic> st = {};
    bool haveValue = false;
    for (Map<String, dynamic> item in rateGroupTypes) {
      item.forEach((key, value) {
        //print('line 2620: $key $value $v');
        if (key == "CodeID" && value == v) {
          st = item;
          haveValue = true;
        }
      });
      if (haveValue == true) {
        break;
      }
    }
    return st;
  }

  String getRateTypes(String v) {
    bool haveValue = false;
    String sv = '';
    for (Map<String, dynamic> item in rateTypes) {
      item.forEach((key, value) {
        if (key == 'CodeID' && value == v) {
          sv = item['CodeName'];
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  String getContactJobTitles(String v) {
    bool haveValue = false;
    String sv = '';
    for (Map<String, dynamic> item in contactJobTitles) {
      item.forEach((key, value) {
        if (key == 'CodeID' && value == v) {
          sv = item['CodeName'];
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  String getClientContactTypes(String vv) {
    bool haveValue = false;
    String sv = '';
    for (Map<String, dynamic> item in clientContactTypes) {
      item.forEach((key, value) {
        if (key == 'CodeID' && value == vv) {
          sv = item['CodeName'];
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  String getTimeTypes(String vv) {
    bool haveValue = false;
    String sv = '';
    for (Map<String, dynamic> item in timeTypes) {
      item.forEach((key, value) {
        if (key == 'CodeID' && value == vv) {
          sv = item['CodeName'];
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  Map<String, dynamic> getDisciplinesTypes(String vv) {
    bool haveValue = false;
    Map<String, dynamic> sv = {};
    for (Map<String, dynamic> item in timeTypes) {
      item.forEach((key, value) {
        if (key == 'CodeID' && value == vv) {
          sv = item;
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  List<Map<String, dynamic>> getDisciplines() {
    return disciplineTypes;
  }

  String getBranchNames(int vv) {
    bool haveValue = false;
    String sv = '';
    for (Map<String, dynamic> item in branchNames) {
      item.forEach((key, value) {
        if (key == 'CodeID' && value == vv) {
          sv = item['CodeName'];
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  int getBranchIds(String vv) {
    bool haveValue = false;
    int sv = 0;
    for (Map<String, dynamic> item in branchNames) {
      item.forEach((key, value) {
        if (key == 'CodeName' && value == vv) {
          sv = item['CodeID'];
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  String getGroupCodes(int vv) {
    bool haveValue = false;
    String sv = '';
    for (Map<String, dynamic> item in groupCodes) {
      item.forEach((key, value) {
        if (key == 'CodeID' && value == vv) {
          sv = item['CodeDescription'];
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  String getSICCodes(int vv) {
    bool haveValue = false;
    String sv = '';
    for (Map<String, dynamic> item in SICCodes) {
      item.forEach((key, value) {
        if (key == 'CodeID' && value == vv) {
          sv = item['CodeDescription'];
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  String getClientStatus(String vv) {
    bool haveValue = false;
    String sv = '';
    for (Map<String, dynamic> item in clientStatus) {
      item.forEach((key, value) {
        if (key == 'CodeID' && value == vv) {
          sv = item['CodeName'];
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  String getClientTypes(int vv) {
    bool haveValue = false;
    String sv = '';
    for (Map<String, dynamic> item in clientTypes) {
      item.forEach((key, value) {
        if (key == 'CodeID' && value == vv) {
          sv = item['CodeName'];
          haveValue = true;
        }
      });
      if (haveValue) {
        break;
      }
    }
    return sv;
  }

  double getSlingPayrollHours(int vv) {
    double v = vv.toDouble();
    double rv = 0;
    bool haveDecimal = false;
    for (Map<String, dynamic> item in slingPayrollHours) {
      item.forEach((key, value) {
        if (key == "minutes" && value == v) {
          rv = item['decimal'];
          haveDecimal = true;
        }
      });
      if (haveDecimal) {
        break;
      }
    }
    return rv;
  }

  String getMonthNames(dynamic v) {
    String st = '';
    for (Map<String, dynamic> item in months) {
      item.forEach((key, value) {
        if (key == "monthNumber" && value == v) {
          st = item['monthName'].toString();
        }
      });
      if (st != '') {
        break;
      }
    }
    return st;
  }

  String getVeteranCodes(dynamic v) {
    String st = '';
    for (Map<String, dynamic> item in veteranCodes) {
      item.forEach((key, value) {
        if (key == "CodeID" && value == v) {
          st = item['CodeName'].toString();
        }
      });
      if (st != '') {
        break;
      }
    }
    return st;
  }

  String getGender(dynamic v) {
    String st = '';
    List<Map<String, dynamic>> genderTypes = getGenderTypes();
    for (Map<String, dynamic> item in genderTypes) {
      item.forEach((key, value) {
        if (key == "CodeID" && value == v) {
          st = item['CodeDesc'].toString();
        }
      });
      if (st != '') {
        break;
      }
    }
    return st;
  }

  Map<String, dynamic> getContactType(dynamic v) {
    Map<String, dynamic> st = {};
    bool haveValue = false;
    for (Map<String, dynamic> item in contactTypes) {
      item.forEach((key, value) {
        //print('line 2620: $key $value $v');
        if (key == "CodeID" && value == v) {
          st = item;
          haveValue = true;
        }
      });
      if (haveValue == true) {
        break;
      }
    }
    return st;
  }

  String getAddressType(dynamic v) {
    String st = '';
    List<Map<String, dynamic>> addressTypes = getClientAddressTypes();
    for (Map<String, dynamic> item in addressTypes) {
      item.forEach((key, value) {
        if (key == "CodeID" && value == v) {
          st = item['CodeName'].toString();
        }
      });
      if (st != '') {
        break;
      }
    }
    return st;
  }

  String getDisability(dynamic v) {
    String st = '';
    for (Map<String, dynamic> item in disabilityTypes) {
      item.forEach((key, value) {
        if (key == "CodeID" && value == v) {
          st = item['CodeDesc'].toString();
        }
      });
      if (st != '') {
        break;
      }
    }
    return st;
  }

  String getMaritalStatus(dynamic v) {
    String st = '';
    for (Map<String, dynamic> item in maritalStatuses) {
      item.forEach((key, value) {
        if (key == "CodeID" && value == v) {
          st = item['CodeDesc'].toString();
        }
      });
      if (st != '') {
        break;
      }
    }
    return st;
  }

  String getEthnicity(dynamic v) {
    String st = '';
    for (Map<String, dynamic> item in ethnicityTypes) {
      item.forEach((key, value) {
        if (key == "CodeID" && value == v) {
          st = item['CodeName'].toString();
        }
      });
      if (st != '') {
        break;
      }
    }
    return st;
  }

  String getReferralSources(dynamic v) {
    String st = '';
    for (Map<String, dynamic> item in referralSources) {
      item.forEach((key, value) {
        if (key == "CodeID" && value == v) {
          st = item['CodeName'].toString();
        }
      });
      if (st != '') {
        break;
      }
    }
    return st;
  }

  List<dynamic> convertUtcToInt(String sutc) {
    print('line 10 converutc: $sutc');
    List<dynamic> iutc = [];
    List<String> lutc = sutc.split('-');
    print('line 13 convert utc $lutc');
    iutc.add(int.tryParse(lutc[0].toString()));
    iutc.add(int.tryParse(lutc[1].toString()));
    String sday = lutc[2].toString().substring(0, 2);
    iutc.add(int.tryParse(sday));
    iutc.add(0);
    iutc.add(0);
    iutc.add(0);
    iutc.add(0);
    iutc.add(0);
    return iutc;
  }

  List<dynamic> reformatDate(dynamic dateString,
      {bool convertUtc = false, bool isTime = false}) {
    if (dateString == null || dateString == '') {
      return [];
    }
    if (dateString.length < 6) {
      return [];
    }
    if (dateString.length < 9) {
      int si = dateString.indexOf(':', 0);
      if (si == -1) {
        print('line 3049 did not find a :');
        return [];
      }
      //  print('line 10 $si');
      String hrs = dateString.substring(0, si);
      int hr = int.parse(hrs);
      //  print('line 13');
      String mns = dateString.substring(si + 1, 4);
      int mn = int.parse(mns);
      //  print('line 16');
      if (dateString.indexOf('PM', 0) != -1) {
        hr += 12;
      }
      //   print('line 18');
      List<dynamic> xtc = [1900, 1, 1, hr, mn, 0, 0, 0];
      return xtc;
      //print('line 18 $xtc');
    }
    print('line 2716 $dateString $isTime');
    //possible results
    //mm/dd/yyyy  mm/d/yyyy  m/d/yyyy
    dateString = dateString.replaceAll(RegExp('/'), '-');
    int fdx = dateString.indexOf('-', 0);
    int fdy = -1;
    int fdz = -1;
    String mon = '';
    String yr = '';
    String day = '';
    List<dynamic> utc;
    if (fdx == -1) {
      return [];
    }
    if (fdx > 2) {
      if (convertUtc == true) {
        utc = convertUtcToInt(dateString);
        return utc;
      }
      return [dateString];
    }

    if (dateString.length <= 8) {
      //mo/day/yr
      print('line 2735: $dateString ? mo-day-yr');
      mon = dateString.substring(0, fdx);
      fdy = dateString.indexOf('-', fdx + 1);
      day = dateString.substring(fdx + 1, fdy);
      fdz = fdy + 1;
      print('line 2739: $fdx $fdy $fdz');
      yr = dateString.substring(fdz);
      if (yr.length == 2) {
        yr = '20$yr';
      }
      print('line 2744: $mon $day $yr');
    } else {
      List<String> sp = dateString.split('-');
      if (sp[0].length == 4) {
        //year-mo-day
        print('line 2749: $dateString ? year-mo-day');
        print('line 2750: $fdx $fdy $fdz');
        day = dateString.substring(fdx + 1, fdy);
        if (day.trim().length == 1) {
          day = '0${day.trim()}';
        }
        if (mon.trim().length == 1) {
          mon = '0${mon.trim()}';
        }
        fdz = fdy + 1;
        yr = dateString.substring(fdz, fdz + 4);
        fdz += 4;
        print('line 2761: $yr $mon $day');
      } else {
        //mo-yr-year
        mon = dateString.substring(0, fdx);
        fdy = dateString.indexOf('-', fdx + 1);
        day = dateString.substring(fdx + 1, fdy);
        fdz = fdy + 1;
        print('line 2770: $fdx $fdy $fdz');
        yr = dateString.substring(fdz);
        fdz += 4;
        print('line 2773 $yr $mon $day');
      }
    }
    print('line 2765: $fdx $fdy $fdz ${dateString.length}');
    String ending = dateString.substring(fdz, dateString.length);
    ending = ending.trim();
    ending = ending.replaceAll(' ', ':');
    List<String> eds = ending.split(':');
    //  print('line 34:  $yr $mon $day $ending');
    dateString = '$yr-$mon-$day';
    if (isTime == false) {
      if (convertUtc == true) {
        utc = convertUtcToInt(dateString);
        return utc;
      }
      return [dateString + ' 00:00:00.000'];
    } else {
      if (eds.contains('PM')) {
        int ip = int.parse(eds[0]);
        ip += 12;
        eds[0] = ip.toString();
      } else {
        if (eds[0].length == 1) {
          eds[0] = '0${eds[0]}';
        }
      }
      dateString = '$yr-$mon-$day ${eds[0]}:${eds[1]}:00.${eds[2]}0';
      // print(dateString);
      // print(DateTime.now());
      // return DateFormat.yMEd().add_jms().format(DateTime.parse(dateString));

      if (convertUtc == true) {
        utc = convertUtcToInt(dateString);
        return utc;
      }
      return [dateString];
    }
  }

  bool isNullEmptyOrFalse(dynamic o) {
    if (o is Map<String, dynamic> || o is List<dynamic>) {
      return o == null || o.length == 0;
    }
    return o == null || false == o || "" == o || o == "System.Byte[]";
  }

  List<Map<String, dynamic>> addressTypes = [
    {
      "CodeID": 2060,
      "CodeName": "Emergency",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null,
      "CodeKey": "AddressTypes"
    },
    {
      "CodeID": 2061,
      "CodeName": "Home",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": true,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null,
      "CodeKey": "AddressTypes"
    },
    {
      "CodeID": 2062,
      "CodeName": "Work",
      "CodeDesc": null,
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": null,
      "HideOnlineApp": null,
      "CodeKey": "AddressTypes"
    }
  ];
  List<Map<String, dynamic>> genderTypes = [
    {
      "CodeID": 2406,
      "CodeName": "M",
      "CodeDesc": "Male",
      "SortOrder": 0,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "M",
      "HideOnlineApp": null,
      "CodeKey": "Gender"
    },
    {
      "CodeID": 2405,
      "CodeName": "F",
      "CodeDesc": "Female",
      "SortOrder": 1,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "F",
      "HideOnlineApp": null,
      "CodeKey": "Gender"
    },
    {
      "CodeID": 2842,
      "CodeName": "B",
      "CodeDesc": "Non-Binary",
      "SortOrder": 2,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "B",
      "HideOnlineApp": null,
      "CodeKey": "Gender"
    },
    {
      "CodeID": 2841,
      "CodeName": "N",
      "CodeDesc": "Not Specified",
      "SortOrder": 3,
      "CodeValue": null,
      "IsDefault": false,
      "UserTypeCodeID": null,
      "InterfaceValue": "N",
      "HideOnlineApp": null,
      "CodeKey": "Gender"
    }
  ];

  Future<List<Map<String, dynamic>>> getRegistrantCancelreasons() async {
    List<Map<String, dynamic>> lst = [
      {"codeId": 2512, "reason": "Family Emergency"},
      {"codeId": 2513, "reason": "Sick"},
      {"codeId": 2514, "reason": "Transportation Issues"},
      {"codeId": 2680, "reason": "Requested Time Off"},
      {"codeId": 2689, "reason": "Fatigue"},
      {"codeId": 2739, "reason": "No Call No Show"},
      {"codeId": 2740, "reason": "Called Out"}
    ];
    return lst;
  }

  List<Map<String, dynamic>> userBranches = [
    {"branchId": 0, "branchName": "CORPORATE", "index": 0},
    {"branchId": 615, "branchName": "RALEIGH CMS 101", "index": 1},
    {"branchId": 624, "branchName": "COLUMBIA CMS 105", "index": 2},
    {"branchId": 631, "branchName": "NASHVILLE CMS 106", "index": 3},
    {"branchId": 632, "branchName": "MEMPHIS CMS 107", "index": 4},
    {"branchId": 634, "branchName": "AUGUSTA-GREENVILLE CMS 110", "index": 5},
    {"branchId": 635, "branchName": "FLORENCE CMS 111", "index": 6},
    {"branchId": 638, "branchName": "KNOXVILLE-TRI CITIES CMS 114", "index": 7},
    {"branchId": 640, "branchName": "CHATTANOOGA CMS 116", "index": 8},
    {"branchId": 641, "branchName": "LEXINGTON CMS 117", "index": 9},
  ];
  List<Map<String, dynamic>> getUserBranches() {
    return userBranches;
  }
   Future<List<dynamic>> getClientCancelReasons() async {
        List<dynamic> lst = [
          {"codeId": 2088, "reason": "Census Low"},
          {"codeId": 2089, "reason": "Not Needed"},
          {"codeId": 2090, "reason": "Other Agency Filled"},
          {"codeId": 2091, "reason": "Staff Filled"},
          {"codeId": 2730, "reason": "Cancelled by Second Level Manager"},
          {"codeId": 2731, "reason": "Maintenance Repairs"},
          {"codeId": 2732, "reason": "Closed Beds - Unit"},
          {
            "codeId": 2733,
            "reason": "Other Agency - Preferred Provider filled Shift"
          },
          {"codeId": 2754, "reason": "StafferLinkFSM Cancellation"},
          {"codeId": 2834, "reason": "VMS Cancellation"},
          {"codeId": 2843, "reason": "Not Confirmed - CLIENT"},
          {"codeId": 2844, "reason": "Not Confirmed - REGISTRANT"},
          {"codeId": 2845, "reason": "Shift no longer available"}
        ];
        return lst;
      }

      Future<List<dynamic>> getRegistrantCancelreasons() async {
        List<dynamic> lst = [
          {"codeId": 2512, "reason": "Family Emergency"},
          {"codeId": 2513, "reason": "Sick"},
          {"codeId": 2514, "reason": "Transportation Issues"},
          {"codeId": 2680, "reason": "Requested Time Off"},
          {"codeId": 2689, "reason": "Fatigue"},
          {"codeId": 2739, "reason": "No Call No Show"},
          {"codeId": 2740, "reason": "Called Out"}
        ];
        return lst;
      }

      Future<List<dynamic>> getOrderTypes() async {
        List<dynamic> lst = [
          {"orderTypeCodeID": 4011, "codeName": "Travel"},
          {"orderTypeCodeID": 4012, "codeName": "Contract"},
          {"orderTypeCodeID": 4013, "codeName": "PerDiem"}
        ];
        return lst;
      }

      Future<List<dynamic>> getRateTypeCodes() async {
        List<dynamic> lst = [
          {
            "rateTypeCodeId": 2491,
            "codeName": "Contract",
            "codeDesc": "Contract Rate"
          },
          {
            "rateTypeCodeId": 2492,
            "codeName": "MedSurg",
            "codeDesc": "Medical / Surgical Rate"
          },
          {
            "rateTypeCodeId": 2493,
            "codeName": "Orientation",
            "codeDesc": "Orientation Rate"
          },
          {
            "rateTypeCodeId": 2494,
            "codeName": "Specialty",
            "codeDesc": "Specialty Rate"
          },
          {
            "rateTypeCodeId": 2683,
            "codeName": "Per Diem",
            "codeDesc": "Scheduled Daily"
          },
          {
            "rateTypeCodeId": 2684,
            "codeName": "13 Week Contract",
            "codeDesc": "Long Term Assignment"
          },
          {
            "rateTypeCodeId": 2685,
            "codeName": "Subsidy - Tax Free",
            "codeDesc": "Long Term Assignment Weekly Subsidy Amount"
          },
          {
            "rateTypeCodeId": 2686,
            "codeName": "Bonus",
            "codeDesc": "Referral Bonus"
          },
          {
            "rateTypeCodeId": 2741,
            "codeName": "Evaluation",
            "codeDesc": "Evaluation"
          },
          {
            "rateTypeCodeId": 2742,
            "codeName": "Recertification",
            "codeDesc": "Recertification"
          },
          {
            "rateTypeCodeId": 2743,
            "codeName": "Evaluation Orientation",
            "codeDesc": "Evaluation Orientation"
          },
          {
            "rateTypeCodeId": 2744,
            "codeName": "Recertification Orientation",
            "codeDesc": "Recertification Orientation"
          },
          {
            "rateTypeCodeId": 2755,
            "codeName": "Travel",
            "codeDesc": "Travel Mileage"
          },
          {
            "rateTypeCodeId": 2837,
            "codeName": "Premium",
            "codeDesc": "Premium Rate"
          }
        ];
        return lst;
      }

      Future<List<dynamic>> getWorkerCompCodes() async {
        List<dynamic> lst = [
          //note codeName is WorkersCompTypeCode
          {"workersCompCodeId": 2639, "codeName": "7111", "codeDesc": "Dietary"},
          {
            "workersCompCodeId": 2646,
            "codeName": "8049",
            "codeDesc": "Clinics / Health Practitioner / Physical Therapist"
          },
          {
            "workersCompCodeId": 2652,
            "codeName": "8742",
            "codeDesc": "Sales (outside)"
          },
          {
            "workersCompCodeId": 2654,
            "codeName": "8810",
            "codeDesc": "Clerical Office Employees"
          },
          {
            "workersCompCodeId": 2655,
            "codeName": "8811",
            "codeDesc": "Immunization Clinics"
          },
          {
            "workersCompCodeId": 2656,
            "codeName": "8829",
            "codeDesc": "Nursing Home-DO NOT USE"
          },
          {
            "workersCompCodeId": 2657,
            "codeName": "8830",
            "codeDesc": "Hospital Professional"
          },
          {
            "workersCompCodeId": 2658,
            "codeName": "8832",
            "codeDesc": "Physician and Clerical"
          },
          {
            "workersCompCodeId": 2659,
            "codeName": "8833",
            "codeDesc": "Hospital - Professional Employees"
          },
          {
            "workersCompCodeId": 2660,
            "codeName": "8835",
            "codeDesc": "Nursing - Home Health"
          },
          {
            "workersCompCodeId": 2664,
            "codeName": "9040",
            "codeDesc": "Hospital North Dakota"
          },
          {"workersCompCodeId": 2665, "codeName": "9050", "codeDesc": "Hospice"},
          {
            "workersCompCodeId": 2669,
            "codeName": "9999",
            "codeDesc": "Not Otherwise Classified"
          },
          {
            "workersCompCodeId": 2745,
            "codeName": "8849",
            "codeDesc": "NC State nursing Homes"
          },
          {
            "workersCompCodeId": 2752,
            "codeName": "8868",
            "codeDesc": "School Professional Employees"
          },
          {
            "workersCompCodeId": 2753,
            "codeName": "8864",
            "codeDesc": "Social Services Organization"
          },
          {
            "workersCompCodeId": 2759,
            "codeName": "8828",
            "codeDesc": "Texas Home Health"
          },
          {
            "workersCompCodeId": 2836,
            "codeName": "8824",
            "codeDesc": "Nursing Home"
          }
        ];
        return lst;
      }
// AuthService authServices = AuthService();
  Future<List<dynamic>> getClientCancelReasons() async {
    List<dynamic> lst = [
      {"codeId": 2088, "reason": "Census Low"},
      {"codeId": 2089, "reason": "Not Needed"},
      {"codeId": 2090, "reason": "Other Agency Filled"},
      {"codeId": 2091, "reason": "Staff Filled"},
      {"codeId": 2730, "reason": "Cancelled by Second Level Manager"},
      {"codeId": 2731, "reason": "Maintenance Repairs"},
      {"codeId": 2732, "reason": "Closed Beds - Unit"},
      {
        "codeId": 2733,
        "reason": "Other Agency - Preferred Provider filled Shift"
      },
      {"codeId": 2754, "reason": "StafferLinkFSM Cancellation"},
      {"codeId": 2834, "reason": "VMS Cancellation"},
      {"codeId": 2843, "reason": "Not Confirmed - CLIENT"},
      {"codeId": 2844, "reason": "Not Confirmed - REGISTRANT"},
      {"codeId": 2845, "reason": "Shift no longer available"}
    ];
    return lst;
  }

  Future<List<dynamic>> getRegistrantCancelreasons() async {
    List<dynamic> lst = [
      {"codeId": 2512, "reason": "Family Emergency"},
      {"codeId": 2513, "reason": "Sick"},
      {"codeId": 2514, "reason": "Transportation Issues"},
      {"codeId": 2680, "reason": "Requested Time Off"},
      {"codeId": 2689, "reason": "Fatigue"},
      {"codeId": 2739, "reason": "No Call No Show"},
      {"codeId": 2740, "reason": "Called Out"}
    ];
    return lst;
  }

  Future<List<dynamic>> getOrderTypes() async {
    List<dynamic> lst = [
      {"orderTypeCodeID": 4011, "codeName": "Travel"},
      {"orderTypeCodeID": 4012, "codeName": "Contract"},
      {"orderTypeCodeID": 4013, "codeName": "PerDiem"}
    ];
    return lst;
  }

  Future<List<dynamic>> getRateTypeCodes() async {
    List<dynamic> lst = [
      {
        "rateTypeCodeId": 2491,
        "codeName": "Contract",
        "codeDesc": "Contract Rate"
      },
      {
        "rateTypeCodeId": 2492,
        "codeName": "MedSurg",
        "codeDesc": "Medical / Surgical Rate"
      },
      {
        "rateTypeCodeId": 2493,
        "codeName": "Orientation",
        "codeDesc": "Orientation Rate"
      },
      {
        "rateTypeCodeId": 2494,
        "codeName": "Specialty",
        "codeDesc": "Specialty Rate"
      },
      {
        "rateTypeCodeId": 2683,
        "codeName": "Per Diem",
        "codeDesc": "Scheduled Daily"
      },
      {
        "rateTypeCodeId": 2684,
        "codeName": "13 Week Contract",
        "codeDesc": "Long Term Assignment"
      },
      {
        "rateTypeCodeId": 2685,
        "codeName": "Subsidy - Tax Free",
        "codeDesc": "Long Term Assignment Weekly Subsidy Amount"
      },
      {
        "rateTypeCodeId": 2686,
        "codeName": "Bonus",
        "codeDesc": "Referral Bonus"
      },
      {
        "rateTypeCodeId": 2741,
        "codeName": "Evaluation",
        "codeDesc": "Evaluation"
      },
      {
        "rateTypeCodeId": 2742,
        "codeName": "Recertification",
        "codeDesc": "Recertification"
      },
      {
        "rateTypeCodeId": 2743,
        "codeName": "Evaluation Orientation",
        "codeDesc": "Evaluation Orientation"
      },
      {
        "rateTypeCodeId": 2744,
        "codeName": "Recertification Orientation",
        "codeDesc": "Recertification Orientation"
      },
      {
        "rateTypeCodeId": 2755,
        "codeName": "Travel",
        "codeDesc": "Travel Mileage"
      },
      {
        "rateTypeCodeId": 2837,
        "codeName": "Premium",
        "codeDesc": "Premium Rate"
      }
    ];
    return lst;
  }

  Future<List<dynamic>> getWorkerCompCodes() async {
    List<dynamic> lst = [
      //note codeName is WorkersCompTypeCode
      {"workersCompCodeId": 2639, "codeName": "7111", "codeDesc": "Dietary"},
      {
        "workersCompCodeId": 2646,
        "codeName": "8049",
        "codeDesc": "Clinics / Health Practitioner / Physical Therapist"
      },
      {
        "workersCompCodeId": 2652,
        "codeName": "8742",
        "codeDesc": "Sales (outside)"
      },
      {
        "workersCompCodeId": 2654,
        "codeName": "8810",
        "codeDesc": "Clerical Office Employees"
      },
      {
        "workersCompCodeId": 2655,
        "codeName": "8811",
        "codeDesc": "Immunization Clinics"
      },
      {
        "workersCompCodeId": 2656,
        "codeName": "8829",
        "codeDesc": "Nursing Home-DO NOT USE"
      },
      {
        "workersCompCodeId": 2657,
        "codeName": "8830",
        "codeDesc": "Hospital Professional"
      },
      {
        "workersCompCodeId": 2658,
        "codeName": "8832",
        "codeDesc": "Physician and Clerical"
      },
      {
        "workersCompCodeId": 2659,
        "codeName": "8833",
        "codeDesc": "Hospital - Professional Employees"
      },
      {
        "workersCompCodeId": 2660,
        "codeName": "8835",
        "codeDesc": "Nursing - Home Health"
      },
      {
        "workersCompCodeId": 2664,
        "codeName": "9040",
        "codeDesc": "Hospital North Dakota"
      },
      {"workersCompCodeId": 2665, "codeName": "9050", "codeDesc": "Hospice"},
      {
        "workersCompCodeId": 2669,
        "codeName": "9999",
        "codeDesc": "Not Otherwise Classified"
      },
      {
        "workersCompCodeId": 2745,
        "codeName": "8849",
        "codeDesc": "NC State nursing Homes"
      },
      {
        "workersCompCodeId": 2752,
        "codeName": "8868",
        "codeDesc": "School Professional Employees"
      },
      {
        "workersCompCodeId": 2753,
        "codeName": "8864",
        "codeDesc": "Social Services Organization"
      },
      {
        "workersCompCodeId": 2759,
        "codeName": "8828",
        "codeDesc": "Texas Home Health"
      },
      {
        "workersCompCodeId": 2836,
        "codeName": "8824",
        "codeDesc": "Nursing Home"
      }
    ];
    return lst;
  }
// AuthService authServices = AuthService();
  Future<List<dynamic>> getClientCancelReasons() async {
    List<dynamic> lst = [
      {"codeId": 2088, "reason": "Census Low"},
      {"codeId": 2089, "reason": "Not Needed"},
      {"codeId": 2090, "reason": "Other Agency Filled"},
      {"codeId": 2091, "reason": "Staff Filled"},
      {"codeId": 2730, "reason": "Cancelled by Second Level Manager"},
      {"codeId": 2731, "reason": "Maintenance Repairs"},
      {"codeId": 2732, "reason": "Closed Beds - Unit"},
      {
        "codeId": 2733,
        "reason": "Other Agency - Preferred Provider filled Shift"
      },
      {"codeId": 2754, "reason": "StafferLinkFSM Cancellation"},
      {"codeId": 2834, "reason": "VMS Cancellation"},
      {"codeId": 2843, "reason": "Not Confirmed - CLIENT"},
      {"codeId": 2844, "reason": "Not Confirmed - REGISTRANT"},
      {"codeId": 2845, "reason": "Shift no longer available"}
    ];
    return lst;
  }

  Future<List<dynamic>> getRegistrantCancelreasons() async {
    List<dynamic> lst = [
      {"codeId": 2512, "reason": "Family Emergency"},
      {"codeId": 2513, "reason": "Sick"},
      {"codeId": 2514, "reason": "Transportation Issues"},
      {"codeId": 2680, "reason": "Requested Time Off"},
      {"codeId": 2689, "reason": "Fatigue"},
      {"codeId": 2739, "reason": "No Call No Show"},
      {"codeId": 2740, "reason": "Called Out"}
    ];
    return lst;
  }

  Future<List<dynamic>> getOrderTypes() async {
    List<dynamic> lst = [
      {"orderTypeCodeID": 4011, "codeName": "Travel"},
      {"orderTypeCodeID": 4012, "codeName": "Contract"},
      {"orderTypeCodeID": 4013, "codeName": "PerDiem"}
    ];
    return lst;
  }

  Future<List<dynamic>> getRateTypeCodes() async {
    List<dynamic> lst = [
      {
        "rateTypeCodeId": 2491,
        "codeName": "Contract",
        "codeDesc": "Contract Rate"
      },
      {
        "rateTypeCodeId": 2492,
        "codeName": "MedSurg",
        "codeDesc": "Medical / Surgical Rate"
      },
      {
        "rateTypeCodeId": 2493,
        "codeName": "Orientation",
        "codeDesc": "Orientation Rate"
      },
      {
        "rateTypeCodeId": 2494,
        "codeName": "Specialty",
        "codeDesc": "Specialty Rate"
      },
      {
        "rateTypeCodeId": 2683,
        "codeName": "Per Diem",
        "codeDesc": "Scheduled Daily"
      },
      {
        "rateTypeCodeId": 2684,
        "codeName": "13 Week Contract",
        "codeDesc": "Long Term Assignment"
      },
      {
        "rateTypeCodeId": 2685,
        "codeName": "Subsidy - Tax Free",
        "codeDesc": "Long Term Assignment Weekly Subsidy Amount"
      },
      {
        "rateTypeCodeId": 2686,
        "codeName": "Bonus",
        "codeDesc": "Referral Bonus"
      },
      {
        "rateTypeCodeId": 2741,
        "codeName": "Evaluation",
        "codeDesc": "Evaluation"
      },
      {
        "rateTypeCodeId": 2742,
        "codeName": "Recertification",
        "codeDesc": "Recertification"
      },
      {
        "rateTypeCodeId": 2743,
        "codeName": "Evaluation Orientation",
        "codeDesc": "Evaluation Orientation"
      },
      {
        "rateTypeCodeId": 2744,
        "codeName": "Recertification Orientation",
        "codeDesc": "Recertification Orientation"
      },
      {
        "rateTypeCodeId": 2755,
        "codeName": "Travel",
        "codeDesc": "Travel Mileage"
      },
      {
        "rateTypeCodeId": 2837,
        "codeName": "Premium",
        "codeDesc": "Premium Rate"
      }
    ];
    return lst;
  }

  Future<List<dynamic>> getWorkerCompCodes() async {
    List<dynamic> lst = [
      //note codeName is WorkersCompTypeCode
      {"workersCompCodeId": 2639, "codeName": "7111", "codeDesc": "Dietary"},
      {
        "workersCompCodeId": 2646,
        "codeName": "8049",
        "codeDesc": "Clinics / Health Practitioner / Physical Therapist"
      },
      {
        "workersCompCodeId": 2652,
        "codeName": "8742",
        "codeDesc": "Sales (outside)"
      },
      {
        "workersCompCodeId": 2654,
        "codeName": "8810",
        "codeDesc": "Clerical Office Employees"
      },
      {
        "workersCompCodeId": 2655,
        "codeName": "8811",
        "codeDesc": "Immunization Clinics"
      },
      {
        "workersCompCodeId": 2656,
        "codeName": "8829",
        "codeDesc": "Nursing Home-DO NOT USE"
      },
      {
        "workersCompCodeId": 2657,
        "codeName": "8830",
        "codeDesc": "Hospital Professional"
      },
      {
        "workersCompCodeId": 2658,
        "codeName": "8832",
        "codeDesc": "Physician and Clerical"
      },
      {
        "workersCompCodeId": 2659,
        "codeName": "8833",
        "codeDesc": "Hospital - Professional Employees"
      },
      {
        "workersCompCodeId": 2660,
        "codeName": "8835",
        "codeDesc": "Nursing - Home Health"
      },
      {
        "workersCompCodeId": 2664,
        "codeName": "9040",
        "codeDesc": "Hospital North Dakota"
      },
      {"workersCompCodeId": 2665, "codeName": "9050", "codeDesc": "Hospice"},
      {
        "workersCompCodeId": 2669,
        "codeName": "9999",
        "codeDesc": "Not Otherwise Classified"
      },
      {
        "workersCompCodeId": 2745,
        "codeName": "8849",
        "codeDesc": "NC State nursing Homes"
      },
      {
        "workersCompCodeId": 2752,
        "codeName": "8868",
        "codeDesc": "School Professional Employees"
      },
      {
        "workersCompCodeId": 2753,
        "codeName": "8864",
        "codeDesc": "Social Services Organization"
      },
      {
        "workersCompCodeId": 2759,
        "codeName": "8828",
        "codeDesc": "Texas Home Health"
      },
      {
        "workersCompCodeId": 2836,
        "codeName": "8824",
        "codeDesc": "Nursing Home"
      }
    ];
    return lst;
  }

}
