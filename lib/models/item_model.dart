// lib/models/item_model.dart
class Item {
  final int itemId;
  final String? barcode;
  final String itemName;
  final String? description;
  final int categoryId;
  final String? categoryName;
  final int locationId;
  final String? locationName;
  final int quantity;
  final int minStock;
  final double? unitPrice;
  final double? totalValue;
  final String conditionStatus;
  final String? imageUrl;
  final String? sku;
  final DateTime createdAt;

  Item({
    required this.itemId,
    this.barcode,
    required this.itemName,
    this.description,
    required this.categoryId,
    this.categoryName,
    required this.locationId,
    this.locationName,
    required this.quantity,
    required this.minStock,
    this.unitPrice,
    this.totalValue,
    required this.conditionStatus,
    this.imageUrl,
    this.sku,
    required this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['item_id'],
      barcode: json['barcode'],
      itemName: json['item_name'],
      description: json['description'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      locationId: json['location_id'],
      locationName: json['location_name'],
      quantity: json['quantity'],
      minStock: json['min_stock'],
      unitPrice: json['unit_price'] != null
          ? double.parse(json['unit_price'].toString())
          : null,
      totalValue: json['total_value'] != null
          ? double.parse(json['total_value'].toString())
          : null,
      conditionStatus: json['condition_status'],
      imageUrl: json['image_url'],
      sku: json['sku'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Convert Item to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'barcode': barcode,
      'item_name': itemName,
      'description': description,
      'category_id': categoryId,
      'category_name': categoryName,
      'location_id': locationId,
      'location_name': locationName,
      'quantity': quantity,
      'min_stock': minStock,
      'unit_price': unitPrice,
      'total_value': totalValue,
      'condition_status': conditionStatus,
      'image_url': imageUrl,
      'sku': sku,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create copy with updated fields
  Item copyWith({
    int? itemId,
    String? barcode,
    String? itemName,
    String? description,
    int? categoryId,
    String? categoryName,
    int? locationId,
    String? locationName,
    int? quantity,
    int? minStock,
    double? unitPrice,
    double? totalValue,
    String? conditionStatus,
    String? imageUrl,
    String? sku,
    DateTime? createdAt,
  }) {
    return Item(
      itemId: itemId ?? this.itemId,
      barcode: barcode ?? this.barcode,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      quantity: quantity ?? this.quantity,
      minStock: minStock ?? this.minStock,
      unitPrice: unitPrice ?? this.unitPrice,
      totalValue: totalValue ?? this.totalValue,
      conditionStatus: conditionStatus ?? this.conditionStatus,
      imageUrl: imageUrl ?? this.imageUrl,
      sku: sku ?? this.sku,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Check if item is low on stock
  bool get isLowStock => quantity <= minStock;

  // Check if item is out of stock
  bool get isOutOfStock => quantity == 0;

  // Get stock status
  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  // Calculate total value if not provided
  double get calculatedTotalValue {
    if (totalValue != null) return totalValue!;
    if (unitPrice != null) return unitPrice! * quantity;
    return 0.0;
  }

  @override
  String toString() {
    return 'Item(itemId: $itemId, itemName: $itemName, quantity: $quantity, conditionStatus: $conditionStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.itemId == itemId &&
        other.barcode == barcode &&
        other.itemName == itemName &&
        other.description == description &&
        other.categoryId == categoryId &&
        other.categoryName == categoryName &&
        other.locationId == locationId &&
        other.locationName == locationName &&
        other.quantity == quantity &&
        other.minStock == minStock &&
        other.unitPrice == unitPrice &&
        other.totalValue == totalValue &&
        other.conditionStatus == conditionStatus &&
        other.imageUrl == imageUrl &&
        other.sku == sku &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return itemId.hashCode ^
        barcode.hashCode ^
        itemName.hashCode ^
        description.hashCode ^
        categoryId.hashCode ^
        categoryName.hashCode ^
        locationId.hashCode ^
        locationName.hashCode ^
        quantity.hashCode ^
        minStock.hashCode ^
        unitPrice.hashCode ^
        totalValue.hashCode ^
        conditionStatus.hashCode ^
        imageUrl.hashCode ^
        sku.hashCode ^
        createdAt.hashCode;
  }
}
