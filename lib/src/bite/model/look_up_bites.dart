import 'dart:convert';

/// ✅ Top-level function to parse JSON string to model
LookUpBiteStingMasterModel biteStingLookupModelFromJson(String str) =>
    LookUpBiteStingMasterModel.fromJson(json.decode(str));

/// ✅ Convert model to JSON string
String biteStingLookupModelToJson(LookUpBiteStingMasterModel data) =>
    json.encode(data.toJson());

// Dart Data Model for Bite/Sting Information

class LookUpBiteStingMasterModel {
  List<TypeOfBiteSting>? typeOfBiteSting;
  List<VenomousType>? venomousType;
  List<SiteOfBiteSting>? siteOfBiteSting;
  List<SymptomsPresentation>? symptomsPresentation;
  List<TimeInterval>? timeInterval;
  List<SupportiveCareProvided>? supportiveCareProvided;
  List<TypeOfOrganism>? typeOfOrganism;
  List<Outcome>? outcome;
  List<HospitalType>? hospitalType;
  List<DestinationHospital>? destinationHospital;
  List<ReasonForReferral>? reasonForReferral;
  List<ConditionOfPatient>? conditionOfPatient;

  LookUpBiteStingMasterModel({
    this.typeOfBiteSting,
    this.venomousType,
    this.siteOfBiteSting,
    this.symptomsPresentation,
    this.timeInterval,
    this.supportiveCareProvided,
    this.typeOfOrganism,
    this.outcome,
    this.hospitalType,
    this.destinationHospital,
    this.reasonForReferral,
    this.conditionOfPatient,
  });

  factory LookUpBiteStingMasterModel.fromJson(Map<String, dynamic> json) {
    return LookUpBiteStingMasterModel(
      typeOfBiteSting: (json['TypeOfBiteSting'] as List<dynamic>?)
          ?.map((e) => TypeOfBiteSting.fromJson(e as Map<String, dynamic>))
          .toList(),
      venomousType: (json['VenomousType'] as List<dynamic>?)
          ?.map((e) => VenomousType.fromJson(e as Map<String, dynamic>))
          .toList(),
      siteOfBiteSting: (json['SiteOfBiteSting'] as List<dynamic>?)
          ?.map((e) => SiteOfBiteSting.fromJson(e as Map<String, dynamic>))
          .toList(),
      symptomsPresentation: (json['SymptomsPresentation'] as List<dynamic>?)
          ?.map((e) => SymptomsPresentation.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeInterval: (json['TimeInterval'] as List<dynamic>?)
          ?.map((e) => TimeInterval.fromJson(e as Map<String, dynamic>))
          .toList(),
      supportiveCareProvided: (json['SupportiveCareProvided'] as List<dynamic>?)
          ?.map((e) => SupportiveCareProvided.fromJson(e as Map<String, dynamic>))
          .toList(),
      typeOfOrganism: (json['TypeOfOrganism'] as List<dynamic>?)
          ?.map((e) => TypeOfOrganism.fromJson(e as Map<String, dynamic>))
          .toList(),
      outcome: (json['Outcome'] as List<dynamic>?)
          ?.map((e) => Outcome.fromJson(e as Map<String, dynamic>))
          .toList(),
      hospitalType: (json['HospitalType'] as List<dynamic>?)
          ?.map((e) => HospitalType.fromJson(e as Map<String, dynamic>))
          .toList(),
      destinationHospital: (json['DestinationHospital'] as List<dynamic>?)
          ?.map((e) => DestinationHospital.fromJson(e as Map<String, dynamic>))
          .toList(),
      reasonForReferral: (json['ReasonForReferral'] as List<dynamic>?)
          ?.map((e) => ReasonForReferral.fromJson(e as Map<String, dynamic>))
          .toList(),
      conditionOfPatient: (json['ConditionOfPatient'] as List<dynamic>?)
          ?.map((e) => ConditionOfPatient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TypeOfBiteSting': typeOfBiteSting?.map((e) => e.toJson()).toList(),
      'VenomousType': venomousType?.map((e) => e.toJson()).toList(),
      'SiteOfBiteSting': siteOfBiteSting?.map((e) => e.toJson()).toList(),
      'SymptomsPresentation': symptomsPresentation?.map((e) => e.toJson()).toList(),
      'TimeInterval': timeInterval?.map((e) => e.toJson()).toList(),
      'SupportiveCareProvided': supportiveCareProvided?.map((e) => e.toJson()).toList(),
      'TypeOfOrganism': typeOfOrganism?.map((e) => e.toJson()).toList(),
      'Outcome': outcome?.map((e) => e.toJson()).toList(),
      'HospitalType': hospitalType?.map((e) => e.toJson()).toList(),
      'DestinationHospital': destinationHospital?.map((e) => e.toJson()).toList(),
      'ReasonForReferral': reasonForReferral?.map((e) => e.toJson()).toList(),
      'ConditionOfPatient': conditionOfPatient?.map((e) => e.toJson()).toList(),
    };
  }
}

// Sub-models for the list items

class TypeOfBiteSting {
  int? id;
  String? name;

  TypeOfBiteSting({this.id, this.name});

  factory TypeOfBiteSting.fromJson(Map<String, dynamic> json) {
    return TypeOfBiteSting(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class VenomousType {
  int? id;
  String? name;

  VenomousType({this.id, this.name});

  factory VenomousType.fromJson(Map<String, dynamic> json) {
    return VenomousType(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SiteOfBiteSting {
  int? id;
  String? name;

  SiteOfBiteSting({this.id, this.name});

  factory SiteOfBiteSting.fromJson(Map<String, dynamic> json) {
    return SiteOfBiteSting(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SymptomsPresentation {
  int? id;
  String? name;

  SymptomsPresentation({this.id, this.name});

  factory SymptomsPresentation.fromJson(Map<String, dynamic> json) {
    return SymptomsPresentation(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class TimeInterval {
  int? id;
  String? name;

  TimeInterval({this.id, this.name});

  factory TimeInterval.fromJson(Map<String, dynamic> json) {
    return TimeInterval(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SupportiveCareProvided {
  int? id;
  String? name;

  SupportiveCareProvided({this.id, this.name});

  factory SupportiveCareProvided.fromJson(Map<String, dynamic> json) {
    return SupportiveCareProvided(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class TypeOfOrganism {
  int? id;
  String? name;
  int? typeOfBiteStingId;

  TypeOfOrganism({this.id, this.name, this.typeOfBiteStingId});

  factory TypeOfOrganism.fromJson(Map<String, dynamic> json) {
    return TypeOfOrganism(
      id: json['id'] as int?,
      name: json['name'] as String?,
      typeOfBiteStingId: json['type_of_bite_sting_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type_of_bite_sting_id': typeOfBiteStingId,
    };
  }
}

class Outcome {
  int? id;
  String? name;

  Outcome({this.id, this.name});

  factory Outcome.fromJson(Map<String, dynamic> json) {
    return Outcome(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class HospitalType {
  int? id;
  String? name;

  HospitalType({this.id, this.name});

  factory HospitalType.fromJson(Map<String, dynamic> json) {
    return HospitalType(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DestinationHospital {
  int? id;
  String? name;

  DestinationHospital({this.id, this.name});

  factory DestinationHospital.fromJson(Map<String, dynamic> json) {
    return DestinationHospital(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ReasonForReferral {
  int? id;
  String? name;

  ReasonForReferral({this.id, this.name});

  factory ReasonForReferral.fromJson(Map<String, dynamic> json) {
    return ReasonForReferral(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ConditionOfPatient {
  int? id;
  String? name;

  ConditionOfPatient({this.id, this.name});

  factory ConditionOfPatient.fromJson(Map<String, dynamic> json) {
    return ConditionOfPatient(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
