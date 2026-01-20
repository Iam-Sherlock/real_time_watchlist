class InstrumentModel {
  final String name;
  final double maxPrice;
final double minPrice;

  InstrumentModel({
    required this.name,
    required this.maxPrice,
    required this.minPrice,
  });
  factory InstrumentModel.fromMap(Map<String, dynamic> map) {
    return InstrumentModel(
      name: map['name'],
      maxPrice: map['maxPrice'],
      minPrice: map['minPrice'],
    );
  }
}
