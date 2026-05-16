class ClientType {
  final int? id;
  final String type;

  ClientType({this.id, required this.type});

  factory ClientType.fromJson(Map<String, dynamic> json) {
    return ClientType(id: json['id'], type: json['type'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type};
  }
}
