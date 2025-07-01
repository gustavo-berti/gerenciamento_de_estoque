class Product {
  final int? id;
  final String name;
  final int amount;
  final double purchasePrice;
  final double sellPrice;
  final int categoryId;
  final int supplierId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    required this.name,
    required this.amount,
    required this.purchasePrice,
    required this.sellPrice,
    required this.categoryId,
    required this.supplierId,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      amount: map['amount'] as int,
      purchasePrice: (map['purchase_price'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (map['sell_price'] as num?)?.toDouble() ?? 0.0,
      categoryId: map['category_id'] as int,
      supplierId: map['supplier_id'] as int,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'purchase_price': purchasePrice,
      'sell_price': sellPrice,
      'category_id': categoryId,
      'supplier_id': supplierId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    int? amount,
    double? purchasePrice,
    double? sellPrice,
    int? categoryId,
    int? supplierId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellPrice: sellPrice ?? this.sellPrice,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, amount: $amount, purchasePrice: $purchasePrice, sellPrice: $sellPrice, categoryId: $categoryId, supplierId: $supplierId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          amount == other.amount &&
          purchasePrice == other.purchasePrice &&
          sellPrice == other.sellPrice &&
          categoryId == other.categoryId &&
          supplierId == other.supplierId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      amount.hashCode ^
      purchasePrice.hashCode ^
      sellPrice.hashCode ^
      categoryId.hashCode ^
      supplierId.hashCode;
}