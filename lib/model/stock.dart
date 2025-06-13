class Stock {
  final String id;
  final String name;
  double price;

  Stock({required this.id, required this.name, required this.price});

  Stock copyWith({double? price}) {
    return Stock(
      id: id,
      name: name,
      price: price ?? this.price,
    );
  }
}
