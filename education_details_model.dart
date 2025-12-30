class HighSchoolDetailsResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final String? timestamp;
  final HighSchoolData? data;

  HighSchoolDetailsResponse({
    this.status,
    this.statusCode,
    this.message,
    this.timestamp,
    this.data,
  });

  factory HighSchoolDetailsResponse.fromJson(Map<String, dynamic> json) {
    return HighSchoolDetailsResponse(
      status: json['status'],
      statusCode: json['statusCode'],
      message: json['message'],
      timestamp: json['timestamp'],
      data: json['data'] != null ? HighSchoolData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'timestamp': timestamp,
      'data': data?.toJson(),
    };
  }
}

class HighSchoolData {
  final int? id;
  final String? candidateId;
  final String? educationLevel;
  final String? enrollmentNumber;
  final String? instituteName;
  final String? qualification;
  final String? specialization;
  final String? enrolledYear;
  final String? passingYear;
  final String? address;
  final String? city;
  final String? stateRegionProvince;
  final String? country;
  final String? zipCode;
  final String? certificateFileUrl;
  final String? bgcStatus;

  HighSchoolData({
    this.id,
    this.candidateId,
    this.educationLevel,
    this.enrollmentNumber,
    this.instituteName,
    this.qualification,
    this.specialization,
    this.enrolledYear,
    this.passingYear,
    this.address,
    this.city,
    this.stateRegionProvince,
    this.country,
    this.zipCode,
    this.certificateFileUrl,
    this.bgcStatus,
  });

  factory HighSchoolData.fromJson(Map<String, dynamic> json) {
    return HighSchoolData(
      id: json['id'],
      candidateId: json['candidateId'],
      educationLevel: json['educationLevel'],
      enrollmentNumber: json['enrollmentNumber'],
      instituteName: json['instituteName'],
      qualification: json['qualification'],
      specialization: json['specialization'],
      enrolledYear: json['enrolledYear'],
      passingYear: json['passingYear'],
      address: json['address'],
      city: json['city'],
      stateRegionProvince: json['stateRegionProvince'],
      country: json['country']?.toString().trim(),
      zipCode: json['zipCode'],
      certificateFileUrl: json['certificateFileUrl'],
      bgcStatus: json['bgcStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidateId': candidateId,
      'educationLevel': educationLevel,
      'enrollmentNumber': enrollmentNumber,
      'instituteName': instituteName,
      'qualification': qualification,
      'specialization': specialization,
      'enrolledYear': enrolledYear,
      'passingYear': passingYear,
      'address': address,
      'city': city,
      'stateRegionProvince': stateRegionProvince,
      'country': country,
      'zipCode': zipCode,
      'certificateFileUrl': certificateFileUrl,
      'bgcStatus': bgcStatus,
    };
  }
}

// higher_secondary_details_response.dart

class HigherSecondaryDetailsResponse {
  final bool status;
  final int statusCode;
  final String message;
  final String timestamp;
  final HigherSecondaryDetailsData? data;

  HigherSecondaryDetailsResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.timestamp,
    this.data,
  });

  factory HigherSecondaryDetailsResponse.fromJson(Map<String, dynamic> json) {
    return HigherSecondaryDetailsResponse(
      status: json['status'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      data: json['data'] != null
          ? HigherSecondaryDetailsData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'timestamp': timestamp,
      'data': data?.toJson(),
    };
  }
}

class HigherSecondaryDetailsData {
  final int id;
  final String candidateId;
  final String educationLevel;
  final String enrollmentNumber;
  final String instituteName;
  final String qualification;
  final String specialization;
  final String enrolledYear;
  final String passingYear;
  final String address;
  final String city;
  final String stateRegionProvince;
  final String country;
  final String zipCode;
  final String certificateFileUrl;
  final String? bgcStatus;

  HigherSecondaryDetailsData({
    required this.id,
    required this.candidateId,
    required this.educationLevel,
    required this.enrollmentNumber,
    required this.instituteName,
    required this.qualification,
    required this.specialization,
    required this.enrolledYear,
    required this.passingYear,
    required this.address,
    required this.city,
    required this.stateRegionProvince,
    required this.country,
    required this.zipCode,
    required this.certificateFileUrl,
    this.bgcStatus,
  });

  factory HigherSecondaryDetailsData.fromJson(Map<String, dynamic> json) {
    return HigherSecondaryDetailsData(
      id: json['id'] ?? 0,
      candidateId: json['candidateId'] ?? '',
      educationLevel: json['educationLevel'] ?? '',
      enrollmentNumber: json['enrollmentNumber'] ?? '',
      instituteName: json['instituteName'] ?? '',
      qualification: json['qualification'] ?? '',
      specialization: json['specialization'] ?? '',
      enrolledYear: json['enrolledYear'] ?? '',
      passingYear: json['passingYear'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      stateRegionProvince: json['stateRegionProvince'] ?? '',
      country: json['country']?.trim() ?? '',
      zipCode: json['zipCode'] ?? '',
      certificateFileUrl: json['certificateFileUrl'] ?? '',
      bgcStatus: json['bgcStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidateId': candidateId,
      'educationLevel': educationLevel,
      'enrollmentNumber': enrollmentNumber,
      'instituteName': instituteName,
      'qualification': qualification,
      'specialization': specialization,
      'enrolledYear': enrolledYear,
      'passingYear': passingYear,
      'address': address,
      'city': city,
      'stateRegionProvince': stateRegionProvince,
      'country': country,
      'zipCode': zipCode,
      'certificateFileUrl': certificateFileUrl,
      'bgcStatus': bgcStatus,
    };
  }
}

class DiplomaDetailsResponse {
  final bool status;
  final int statusCode;
  final String message;
  final DateTime timestamp;
  final DiplomaDetails? data;

  DiplomaDetailsResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.timestamp,
    this.data,
  });

  factory DiplomaDetailsResponse.fromJson(Map<String, dynamic> json) {
    return DiplomaDetailsResponse(
      status: json['status'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      timestamp: json['timestamp'] ?? '',
      // timestamp: DateTime.parse(json['timestamp']),
       data: json['data'] != null
          ? DiplomaDetails.fromJson(json['data'])
          : null,
      // data: DiplomaDetails.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'data': data?.toJson(),
    };
  }
}

class DiplomaDetails {
  final int id;
  final String candidateId;
  final String educationLevel;
  final String enrollmentNumber;
  final String instituteName;
  final String qualification;
  final String specialization;
  final String enrolledYear;
  final String passingYear;
  final String address;
  final String city;
  final String stateRegionProvince;
  final String country;
  final String zipCode;
  final String certificateFileUrl;
  final String? bgcStatus;

  DiplomaDetails({
    required this.id,
    required this.candidateId,
    required this.educationLevel,
    required this.enrollmentNumber,
    required this.instituteName,
    required this.qualification,
    required this.specialization,
    required this.enrolledYear,
    required this.passingYear,
    required this.address,
    required this.city,
    required this.stateRegionProvince,
    required this.country,
    required this.zipCode,
    required this.certificateFileUrl,
    this.bgcStatus,
  });

  factory DiplomaDetails.fromJson(Map<String, dynamic> json) {
    return DiplomaDetails(
      id: json['id'],
      candidateId: json['candidateId'],
      educationLevel: json['educationLevel'],
      enrollmentNumber: json['enrollmentNumber'],
      instituteName: json['instituteName'],
      qualification: json['qualification'],
      specialization: json['specialization'],
      enrolledYear: json['enrolledYear'],
      passingYear: json['passingYear'],
      address: json['address'],
      city: json['city'],
      stateRegionProvince: json['stateRegionProvince'],
      country: (json['country'] as String).trim(),
      zipCode: json['zipCode'],
      certificateFileUrl: json['certificateFileUrl'],
      bgcStatus: json['bgcStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidateId': candidateId,
      'educationLevel': educationLevel,
      'enrollmentNumber': enrollmentNumber,
      'instituteName': instituteName,
      'qualification': qualification,
      'specialization': specialization,
      'enrolledYear': enrolledYear,
      'passingYear': passingYear,
      'address': address,
      'city': city,
      'stateRegionProvince': stateRegionProvince,
      'country': country,
      'zipCode': zipCode,
      'certificateFileUrl': certificateFileUrl,
      'bgcStatus': bgcStatus,
    };
  }
}



class UnderGraduationEducationInfo {
  final bool status;
  final int statusCode;
  final String message;
  final DateTime timestamp;
  final UnderGraduationEducationData data;

  UnderGraduationEducationInfo({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.timestamp,
    required this.data,
  });

  factory UnderGraduationEducationInfo.fromJson(Map<String, dynamic> json) {
    return UnderGraduationEducationInfo(
      status: json['status'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp']),
      data: UnderGraduationEducationData.fromJson(json['data']),
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

class UnderGraduationEducationData {
  final int id;
  final String candidateId;
  final String educationLevel;
  final String enrollmentNumber;
  final String instituteName;
  final String qualification;
  final String specialization;
  final String enrolledYear;
  final String passingYear;
  final String address;
  final String city;
  final String stateRegionProvince;
  final String country;
  final String zipCode;
  final String certificateFileUrl;
  final String? bgcStatus;

  UnderGraduationEducationData({
    required this.id,
    required this.candidateId,
    required this.educationLevel,
    required this.enrollmentNumber,
    required this.instituteName,
    required this.qualification,
    required this.specialization,
    required this.enrolledYear,
    required this.passingYear,
    required this.address,
    required this.city,
    required this.stateRegionProvince,
    required this.country,
    required this.zipCode,
    required this.certificateFileUrl,
    this.bgcStatus,
  });

  factory UnderGraduationEducationData.fromJson(Map<String, dynamic> json) {
    return UnderGraduationEducationData(
      id: json['id'],
      candidateId: json['candidateId'],
      educationLevel: json['educationLevel'],
      enrollmentNumber: json['enrollmentNumber'],
      instituteName: json['instituteName'],
      qualification: json['qualification'],
      specialization: json['specialization'],
      enrolledYear: json['enrolledYear'],
      passingYear: json['passingYear'],
      address: json['address'],
      city: json['city'],
      stateRegionProvince: json['stateRegionProvince'],
      country: (json['country'] as String).trim(),
      zipCode: json['zipCode'],
      certificateFileUrl: json['certificateFileUrl'],
      bgcStatus: json['bgcStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidateId': candidateId,
      'educationLevel': educationLevel,
      'enrollmentNumber': enrollmentNumber,
      'instituteName': instituteName,
      'qualification': qualification,
      'specialization': specialization,
      'enrolledYear': enrolledYear,
      'passingYear': passingYear,
      'address': address,
      'city': city,
      'stateRegionProvince': stateRegionProvince,
      'country': country,
      'zipCode': zipCode,
      'certificateFileUrl': certificateFileUrl,
      'bgcStatus': bgcStatus,
    };
  }
}


class PostGraduationDetailsResponse {
  final bool status;
  final int statusCode;
  final String message;
  final DateTime timestamp;
  final PostGraduationDetails data;

  PostGraduationDetailsResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.timestamp,
    required this.data,
  });

  factory PostGraduationDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PostGraduationDetailsResponse(
      status: json['status'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp']),
      data: PostGraduationDetails.fromJson(json['data']),
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

class PostGraduationDetails {
  final int id;
  final String candidateId;
  final String educationLevel;
  final String enrollmentNumber;
  final String instituteName;
  final String qualification;
  final String specialization;
  final String enrolledYear;
  final String passingYear;
  final String address;
  final String city;
  final String stateRegionProvince;
  final String country;
  final String zipCode;
  final String certificateFileUrl;
  final String? bgcStatus;

  PostGraduationDetails({
    required this.id,
    required this.candidateId,
    required this.educationLevel,
    required this.enrollmentNumber,
    required this.instituteName,
    required this.qualification,
    required this.specialization,
    required this.enrolledYear,
    required this.passingYear,
    required this.address,
    required this.city,
    required this.stateRegionProvince,
    required this.country,
    required this.zipCode,
    required this.certificateFileUrl,
    this.bgcStatus,
  });

  factory PostGraduationDetails.fromJson(Map<String, dynamic> json) {
    return PostGraduationDetails(
      id: json['id'],
      candidateId: json['candidateId'],
      educationLevel: json['educationLevel'],
      enrollmentNumber: json['enrollmentNumber'],
      instituteName: json['instituteName'],
      qualification: json['qualification'],
      specialization: json['specialization'],
      enrolledYear: json['enrolledYear'],
      passingYear: json['passingYear'],
      address: json['address'],
      city: json['city'],
      stateRegionProvince: json['stateRegionProvince'],
      country: (json['country'] as String).trim(),
      zipCode: json['zipCode'],
      certificateFileUrl: json['certificateFileUrl'],
      bgcStatus: json['bgcStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidateId': candidateId,
      'educationLevel': educationLevel,
      'enrollmentNumber': enrollmentNumber,
      'instituteName': instituteName,
      'qualification': qualification,
      'specialization': specialization,
      'enrolledYear': enrolledYear,
      'passingYear': passingYear,
      'address': address,
      'city': city,
      'stateRegionProvince': stateRegionProvince,
      'country': country,
      'zipCode': zipCode,
      'certificateFileUrl': certificateFileUrl,
      'bgcStatus': bgcStatus,
    };
  }
}
