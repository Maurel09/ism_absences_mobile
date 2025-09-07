class CourseModel {
  final String id;
  final String name;
  final String code;
  final String? description;
  final bool isActive;
  final DateTime createdAt;

  CourseModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.isActive,
    required this.createdAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get displayName => '$name ($code)';
}
