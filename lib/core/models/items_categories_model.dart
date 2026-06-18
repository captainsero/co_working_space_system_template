class ItemsCategoryModel {
  final int? id;
  final String name;

  ItemsCategoryModel({this.id, required this.name});

  factory ItemsCategoryModel.fromJson(Map<String, dynamic> json) {
    return ItemsCategoryModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
