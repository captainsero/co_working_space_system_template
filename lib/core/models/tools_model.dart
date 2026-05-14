class ToolsModel {
  final int? id;
  final String name;

  ToolsModel({this.id, required this.name});

  factory ToolsModel.fromJson(Map<String, dynamic> json) {
    return ToolsModel(id: json['id'], name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name};
  }
}
