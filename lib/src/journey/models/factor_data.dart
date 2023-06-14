class FactorDataModel {
  FactorDataModel({
    required this.id,
    required this.name,
    required this.isSelected,
  });

  int id;
  String name;
  bool isSelected;

  factory FactorDataModel.fromJson(Map<String, dynamic> json) => FactorDataModel(
        id: json["id"],
        name: json["name"],
        isSelected: json["is_selected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_selected": isSelected,
      };
}
