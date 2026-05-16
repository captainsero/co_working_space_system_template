class OfferClass {
  final String name;
  final String code;
  final String type;
  final double value; // could be percentage, fixed amount, etc.
  final String description;
  final bool active;
  final int usage;

  OfferClass({
    required this.name,
    required this.code,
    required this.type,
    required this.value,
    required this.description,
    required this.active,
    required this.usage,
  });
}

enum OfferType { percentage, fixed, freeItem, freeHour }
