class GroceryItem {
  final String id;
  final String name;
  final String? brand;
  final String? source; // 'REWE', 'DM', or null for free text
  final bool isChecked;
  final DateTime createdAt;

  GroceryItem({
    required this.id,
    required this.name,
    this.brand,
    this.source,
    this.isChecked = false,
    required this.createdAt,
  });

  GroceryItem copyWith({bool? isChecked}) {
    return GroceryItem(
      id: id,
      name: name,
      brand: brand,
      source: source,
      isChecked: isChecked ?? this.isChecked,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'source': source,
      'isChecked': isChecked,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GroceryItem.fromMap(String id, Map<String, dynamic> map) {
    return GroceryItem(
      id: id,
      name: map['name'] as String,
      brand: map['brand'] as String?,
      source: map['source'] as String?,
      isChecked: map['isChecked'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
