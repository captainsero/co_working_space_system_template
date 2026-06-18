class RoomsModel {
  final String name;
  final double price;
  final int reservationNum;

  final int minHours;
  final int maxHours;
  final int averageHours;

  RoomsModel({
    required this.name,
    required this.price,
    required this.reservationNum,
    required this.minHours,
    required this.maxHours,
    required this.averageHours,
  });

  factory RoomsModel.fromJson(Map<String, dynamic> json) {
    return RoomsModel(
      name: json['name'] as String,

      price: (json['price'] as num).toDouble(),

      reservationNum: (json['reservation_num'] ?? 0) as int,

      minHours: (json['min_hours'] ?? 0) as int,

      maxHours: (json['max_hours'] ?? 0) as int,

      averageHours: (json['average_hours'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "reservation_num": reservationNum,
      "min_hours": minHours,
      "max_hours": maxHours,
      "average_hours": averageHours,
    };
  }
}
