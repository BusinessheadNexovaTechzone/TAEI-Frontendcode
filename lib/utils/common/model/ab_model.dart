class Ab {
  int? id;
  String? name;

  Ab({
    this.id,
    this.name,
  });

  factory Ab.fromJson(Map<String, dynamic> json) => Ab(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
