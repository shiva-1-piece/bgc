class EducationDetailsResponsePage {
  final bool status;
  final int statusCode;
  final String message;
  final DateTime timestamp;
  final EducationDetailsStatus data;

  EducationDetailsResponsePage({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.timestamp,
    required this.data,
  });

  factory EducationDetailsResponsePage.fromJson(Map<String, dynamic> json) {
    return EducationDetailsResponsePage(
      status: json['status'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp']),
      data: EducationDetailsStatus.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'data': data.toJson(),
    };
  }
}

class EducationDetailsStatus {
  final bool highSchoolFilled;
  final bool higherSecondaryFilled;
  final bool diplomaFilled;
  final bool undergraduateFilled;
  final bool postgraduateFilled;

  EducationDetailsStatus({
    required this.highSchoolFilled,
    required this.higherSecondaryFilled,
    required this.diplomaFilled,
    required this.undergraduateFilled,
    required this.postgraduateFilled,
  });

  factory EducationDetailsStatus.fromJson(Map<String, dynamic> json) {
    return EducationDetailsStatus(
      highSchoolFilled: json['highSchoolFilled'] as bool,
      higherSecondaryFilled: json['higherSecondaryFilled'] as bool,
      diplomaFilled: json['diplomaFilled'] as bool,
      undergraduateFilled: json['undergraduateFilled'] as bool,
      postgraduateFilled: json['postgraduateFilled'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'highSchoolFilled': highSchoolFilled,
      'higherSecondaryFilled': higherSecondaryFilled,
      'diplomaFilled': diplomaFilled,
      'undergraduateFilled': undergraduateFilled,
      'postgraduateFilled': postgraduateFilled,
    };
  }
}
