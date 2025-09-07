class AbsenceModel {
  final String id;
  final String studentId;
  final String courseId;
  final String status;
  final DateTime date;
  final StudentInfo? student;
  final CourseInfo? course;

  AbsenceModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.status,
    required this.date,
    this.student,
    this.course,
  });

  factory AbsenceModel.fromJson(Map<String, dynamic> json) {
    return AbsenceModel(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      courseId: json['courseId'] ?? '',
      status: json['status'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      student: json['student'] != null ? StudentInfo.fromJson(json['student']) : null,
      course: json['course'] != null ? CourseInfo.fromJson(json['course']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'status': status,
      'date': date.toIso8601String(),
      'student': student?.toJson(),
      'course': course?.toJson(),
    };
  }

  String get statusDisplayName {
    switch (status) {
      case 'PRESENT':
        return 'Présent';
      case 'ABSENT':
        return 'Absent';
      case 'LATE':
        return 'En retard';
      default:
        return status;
    }
  }

  bool get isPresent => status == 'PRESENT';
  bool get isAbsent => status == 'ABSENT';
  bool get isLate => status == 'LATE';
}

class StudentInfo {
  final String firstName;
  final String lastName;

  StudentInfo({
    required this.firstName,
    required this.lastName,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  String get fullName => '$firstName $lastName';
}

class CourseInfo {
  final String id;
  final String name;
  final String code;
  final String? description;
  final bool isActive;

  CourseInfo({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.isActive,
  });

  factory CourseInfo.fromJson(Map<String, dynamic> json) {
    return CourseInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'isActive': isActive,
    };
  }

  String get displayName => '$name ($code)';
}
