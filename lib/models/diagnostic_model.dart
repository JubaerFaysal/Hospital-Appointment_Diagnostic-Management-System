class DiagnosticModel {
  final int? id;
  final String testName;
  final String category;
  final String department;
  final double price;
  final String? description;
  final String? preparation;
  final String? image;

  DiagnosticModel({
    this.id,
    required this.testName,
    required this.category,
    required this.department,
    required this.price,
    this.description,
    this.preparation,
    this.image,
  });

  factory DiagnosticModel.fromJson(Map<String, dynamic> json) {
    return DiagnosticModel(
      id: json['id'],
      testName: json['test_name'],
      category: json['category'],
      department: json['department'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      preparation: json['preparation'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //if (id != null) 'id': id,
      'test_name': testName,
      'category': category,
      'department': department,
      'price': price,
      'description': description,
      'preparation': preparation,
      'image': image,
    };
  }
}