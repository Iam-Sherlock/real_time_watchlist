class InstrumentModel {
  final int id;
  final String name;
  final double price;
  final double dayHigh;
  final double dayLow;
// final double minPrice;

  InstrumentModel({
    required this.id,
    required this.name,
    required this.price,
    required this.dayHigh,
    required this.dayLow,
    // required this.minPrice,
  });
  factory InstrumentModel.fromMap(Map<String, dynamic> map) {
    return InstrumentModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      dayHigh: map['day_high'],
      dayLow: map['day_low'],
      // minPrice: map['minPrice'],
    );
  }
}
