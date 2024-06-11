class ServiceModel {
  final int id;
  String name;
  String? categoryName;
  bool isActive;
  double price;
  int categoryId;

  ServiceModel({
    required this.id,
    required this.name,
    this.categoryName,
    required this.isActive,
    required this.price,
    required this.categoryId,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      categoryName: json['categoryName'],
      isActive: json['isActive'],
      price: json['price'].toDouble(),
      categoryId: json['categoryId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      'price': price,
      'categoryId': categoryId,
    };
  }
}
