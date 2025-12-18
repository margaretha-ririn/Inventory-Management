class InventoryModel {
  final int itemId;
  final String itemName;
  final String? description;
  final int quantity;
  final int minStock;
  final double? unitPrice;
  final String? conditionStatus;
  final String? imageUrl;
  final String? categoryName;
  final String? locationName;

  InventoryModel({
    required this.itemId,
    required this.itemName,
    this.description,
    required this.quantity,
    this.minStock = 0,
    this.unitPrice,
    this.conditionStatus,
    this.imageUrl,
    this.categoryName,
    this.locationName,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      itemId: json['item_id'] is int ? json['item_id'] : int.parse(json['item_id'].toString()),
      itemName: json['item_name'],
      description: json['description'],
      quantity: json['quantity'] is int ? json['quantity'] : int.parse(json['quantity'].toString()),
      minStock: json['min_stock'] != null 
          ? (json['min_stock'] is int ? json['min_stock'] : int.parse(json['min_stock'].toString())) 
          : 0,
      unitPrice: json['unit_price'] != null 
          ? (json['unit_price'] is double ? json['unit_price'] : double.parse(json['unit_price'].toString())) 
          : null,
      conditionStatus: json['condition_status'],
      imageUrl: json['image_url'],
      categoryName: json['category_name'],
      locationName: json['location_name'],
    );
  }
}
