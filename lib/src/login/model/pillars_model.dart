class EmergencyData {
  final int totalPatients;
  final List<CategoryData> categories;

  EmergencyData({required this.totalPatients, required this.categories});

  factory EmergencyData.fromJson(Map<String, dynamic> json) {
    var list = (json['categories'] as List)
        .map((item) => CategoryData.fromJson(item))
        .toList();
    return EmergencyData(
      totalPatients: json['totalPatients'],
      categories: list,
    );
  }
}

class CategoryData {
  final String type;
  final int patients;

  CategoryData({required this.type, required this.patients});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      type: json['type'],
      patients: json['patients'],
    );
  }
}
