class JustificationModel {
  final String id;
  final String studentId;
  final String? absenceId;
  final String reason;
  final String status;
  final String? adminNote;
  final String? attachments;
  final DateTime createdAt;
  final StudentInfo? student;

  JustificationModel({
    required this.id,
    required this.studentId,
    this.absenceId,
    required this.reason,
    required this.status,
    this.adminNote,
    this.attachments,
    required this.createdAt,
    this.student,
  });

  factory JustificationModel.fromJson(Map<String, dynamic> json) {
    return JustificationModel(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      absenceId: json['absenceId'],
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
      adminNote: json['adminNote'],
      attachments: json['attachments'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      student: json['student'] != null ? StudentInfo.fromJson(json['student']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'absenceId': absenceId,
      'reason': reason,
      'status': status,
      'adminNote': adminNote,
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
      'student': student?.toJson(),
    };
  }

  String get statusDisplayName {
    switch (status) {
      case 'PENDING':
        return 'En attente';
      case 'APPROVED':
        return 'Approuvée';
      case 'REJECTED':
        return 'Rejetée';
      default:
        return status;
    }
  }

  bool get isPending => status == 'PENDING';
  bool get isApproved => status == 'APPROVED';
  bool get isRejected => status == 'REJECTED';
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
