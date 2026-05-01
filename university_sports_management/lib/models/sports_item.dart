class SportsItem {
  final int id;
  final String name;
  final String category;
  final int totalQuantity;
  final int availableQuantity;

  SportsItem({
    required this.id,
    required this.name,
    required this.category,
    required this.totalQuantity,
    required this.availableQuantity,
  });

  // This converts JSON data from your Azure API into a Flutter Object
  factory SportsItem.fromJson(Map<String, dynamic> json) {
    return SportsItem(
      id: json['ItemID'],
      name: json['ItemName'],
      category: json['Category'],
      totalQuantity: json['TotalQuantity'],
      availableQuantity: json['AvailableQuantity'],
    );
  }
}