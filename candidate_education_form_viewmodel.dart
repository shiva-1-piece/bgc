import 'dart:io';
import 'package:bgc_mobile/Candidate/Dashboard/Model/default_education_page_model.dart';
import 'package:bgc_mobile/Candidate/Dashboard/Model/education_details_model.dart';
import 'package:bgc_mobile/Candidate/Dashboard/education_details_repo.dart';
import 'package:bgc_mobile/Utils/loader_widget.dart';
import 'package:bgc_mobile/Utils/show_dailog_util.dart';
import 'package:bgc_mobile/Utils/static_text.dart';
import 'package:bgc_mobile/Utils/toast_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CandidateEducationFormViewModel extends ChangeNotifier {
  final List<String> categories = [
    "High School",
    "Higher Education",
    "Under Graduate",
    "Post Graduate",
  ];
  bool isNewUser = false;
  bool isManualFilePicked = false;
  File? file;
  File? higherEducationProofFile;
  File? diplomaFile;
  File? ugFile;
  File? pgFile;
  String? dobErrorEnrollment;
  String? dobErrorPassout;

  TextEditingController ugProofController = TextEditingController();
  TextEditingController pgProofController = TextEditingController();

  HighSchoolData? educationInfo;
  HigherSecondaryDetailsData? higherSecondaryEducationInfo;
  UnderGraduationEducationInfo? underGraduationEducationInfo;
  DiplomaDetailsResponse? diplomaEducationInfo;
  PostGraduationDetailsResponse? postGraduationEducationInfo;
  EducationDetailsResponsePage? educationDetailsResponsePage;

// ===================== DISPOSE FETCHED DATA FOR NEXT USER ==============================
  void clearState() {
    isNewUser = false;
    isManualFilePicked = false;
    file = null;
    dobErrorEnrollment = null;
    dobErrorPassout = null;
    //educationProofController.clear();
    educationInfo = null;
    underGraduationEducationInfo = null;
    notifyListeners();
  }

  bool _isVerified = false;
  bool get isVerified => _isVerified;

// ============================ IS VERIFY BUTTON ======================
  void onVerifyView(bool? value) {
    _isVerified = value ?? false;
    notifyListeners();
  }

  // ============== HIGH SCHOOL FILE PICKER ====================
  void pickFilesEducation({
    required Function(File file) onFilePicked,
    required TextEditingController controller,
    GlobalKey<FormFieldState>? fieldKey,
    BuildContext? context,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      if (result.files.single.size <= 1 * 1024 * 1024) {
        final pickedFile = File(result.files.single.path!);
        controller.text = result.files.single.name;
        onFilePicked(pickedFile);
        fieldKey?.currentState?.validate();
        notifyListeners();
      } else {
        ToastUtils.showToast(
          context: (fieldKey?.currentContext) ?? (context!),
          message: "File size cannot exceed 1 MB",
          type: ToastificationType.error,
        );
      }
    }
  }

  // ===================== SANITIZE THE TEXT WITH SPECIAL CHARACHTERS ==============================

  String sanitizeText(String text) {
    // Remove leading and trailing spaces
    text = text.trimLeft();

    // Replace multiple spaces with a single space
    text = text.replaceAll(RegExp(r'\s+'), ' ');

    // Capitalize the first letter of each word
    text = text
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');

    return text;
  }

// ===================== SANITIZE THE TEXT WITH NO SPECIAL CHARACHTERS ==============================

  String sanitizeSpecialCharacters(String text) {
    // Remove leading and trailing spaces
    text = text.trimLeft();

    // Replace multiple spaces with a single space
    text = text.replaceAll(RegExp(r'\s+'), ' ');

    // Remove special characters except for letters, numbers, and spaces
    text = text.replaceAll(RegExp(r'[^a-zA-Z ]'), '');

    // Capitalize the first letter of each word
    text = text
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');

    return text;
  }

// ===================== SANITIZE THE TEXT WITH NO SPACES ==============================
  String sanitizeAlphanumericNoSpaces(String text) {
    // Remove all non-alphanumeric characters (including spaces)
    text = text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    // Convert all letters to uppercase
    return text.toUpperCase();
  }

  // ===================== VALIDATE ENROLLMENT NUMBER ==============================

  String? validateEnrollNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StaticText().emptyEnrollmentNo;
    }
    if (value.contains(' ')) {
      return "Spaces are not allowed in enrollment number";
    }
    if (value.length < 5) {
      return "Enrollment number must be at least 5 characters";
    }
    return null;
  }
  // ===================== VALIDATE ENROLLMENT DATE ==============================

  String? validateEnroll(String? value) {
    if (value == null || value.isEmpty) {
      return StaticText().enrollError;
    }

    try {
      final parts = value.split('-');
      DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (e) {
      return "Invalid date format (Expected: YYYY-MM-DD)";
    }

    return null;
  }

  Future<void> selectEnrollDate(
    BuildContext context,
    TextEditingController controller,
    GlobalKey<FormFieldState>? fieldkey,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      // 🔄 Trigger form field update & validation
      if (fieldkey?.currentState != null) {
        fieldkey!.currentState!.didChange(controller.text);
        fieldkey.currentState!.validate();
      }
      notifyListeners();
    }
  }

  String? validatePassout(String? passoutValue, String? enrollValue) {
    if (passoutValue == null || passoutValue.isEmpty) {
      return StaticText().emptyPassout;
    }

    try {
      final passoutParts = passoutValue.split('-');
      final passoutDate = DateTime(
        int.parse(passoutParts[0]),
        int.parse(passoutParts[1]),
        int.parse(passoutParts[2]),
      );

      if (enrollValue != null && enrollValue.isNotEmpty) {
        final enrollParts = enrollValue.split('-');
        final enrollDate = DateTime(
          int.parse(enrollParts[0]),
          int.parse(enrollParts[1]),
          int.parse(enrollParts[2]),
        );

        if (!passoutDate.isAfter(enrollDate)) {
          return StaticText().passoutError;
        }
      }
    } catch (e) {
      return "Invalid date format";
    }

    return null;
  }

  Future<void> selectPassoutDate(
    BuildContext context,
    TextEditingController controller,
    String? enrollDate,
    GlobalKey<FormFieldState>? fieldkey,
  ) async {
    DateTime? pickedDate;

    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);

    if (enrollDate != null && enrollDate.isNotEmpty) {
      try {
        final parts = enrollDate.split('-');
        final enrollDateParsed = DateTime(
          int.parse(parts[0]), // year
          int.parse(parts[1]), // month
          int.parse(parts[2]), // day
        );
        firstDate = enrollDateParsed.add(const Duration(days: 1)); // next day
      } catch (e) {
        firstDate = DateTime(1900); // fallback
      }
    }

    pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      // 🔄 Trigger form field update & validation
      if (fieldkey?.currentState != null) {
        fieldkey!.currentState!.didChange(controller.text);
        fieldkey.currentState!.validate();
      }
      notifyListeners();
    }
  }

  // ===================== VALIDATE QUALIFICATION ==============================
  // Qualifications mapped by category
  final Map<String, List<String>> qualificationsByCategory = {
    "High School": ["SSC", "CBSE"],
    //"Higher Education": ["Intermediate", "Diploma"],
    "Under Graduate": ["BE", "BSC", "BBA", "BCom", "B-Tech", "B-Pharmacy"],
    "Post Graduate": [
      "MSC",
      "MCom",
      "MBA",
      "MCA",
      "M-Tech",
      "M.Ed",
      "M-Pharmacy"
    ],
  };

  late String selectedCategory;
  late String selectedQualification;

  candidateEducationForm(String initialCategory) {
    selectedCategory = initialCategory;
    selectedQualification = qualificationsByCategory[initialCategory]!.first;
  }

  void updateCategory(String newCategory) {
    selectedCategory = newCategory;
    selectedQualification = qualificationsByCategory[newCategory]!.first;
    notifyListeners();
  }

  void updateQualification(String newQualification) {
    selectedQualification = newQualification;
    notifyListeners();
  }

  // ===================== VALIDATE QUALIFICATION ==============================

  String? validateQualification(String? value) {
    if (value == null || value.isEmpty) {
      return "Please select a qualification";
    }
    return null;
  }

  // ===================== VALIDATE SPECIALIZATION ==============================

  String? validateSpecialization(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StaticText().emptySpecialisation; // Error for other categories
    }
    return null;
  }

  // ===================== VALIDATE INSTITUTE NAME ==============================

  String? validateInstituteName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StaticText().emptyInstituteName;
    }
    return null;
  }

  // ===================== VALIDATE EDUCATION IMAGE ==============================

  String? validateEducationImage(String? value) {
    if (value == null || value.isEmpty) {
      return StaticText().emptyEducationImage;
    }
    return null;
  }

// ===================== VALIDATE COUNTRY ==============================

  String? validateCountry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StaticText().emptyCountry;
    }

    return null; // No error
  }

  // ===================== VALIDATE STATE ==============================

  String? validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StaticText().emptyState;
    }

    return null; // No error
  }

  // ===================== VALIDATE CITY ==============================

  String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StaticText().emptyCity;
    }

    return null; // No error
  }

  // ===================== VALIDATE CURRRENT PIN CODE ==============================
  String? validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return StaticText().validPincode; // "Pincode must be exactly 6 digits"
    }
    return null; // Valid pincode
  }

// ===================== VALIDATE ADDRESS ==============================

  String? validateAddressLine(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StaticText().emptyCurrentAdddressFirstLine;
    }

    return null; // No error
  }

// ===================== GET DEFAULT EDUCATION INFO PAGE ==============================

  Future<void> fetchDefaultEducationInfo(
      BuildContext context) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    try {
      EducationDetailsResponsePage response = await CandidateEducationRepo()
          .getDefaultEducationInfo(context: context);
      if (!context.mounted) return;
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (response.status == true) {
        educationDetailsResponsePage = response;
        isNewUser = false;
      } else {
        isNewUser = true; // No data or error
      }

      notifyListeners();
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
          context,
          "Please check your internet connection and try again.",
          () {
            Navigator.pop(context);
          },
        );
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }

  // COLOR FOR EDUCATION FILL STATUS
  List<bool> get isEducationFilleds {
    if (educationDetailsResponsePage == null) {
      return [false, false, false, false, false];
    }

    return [
      educationDetailsResponsePage!.data.highSchoolFilled ?? false,
      educationDetailsResponsePage!.data.higherSecondaryFilled ?? false,
      educationDetailsResponsePage!.data.diplomaFilled ?? false,
      educationDetailsResponsePage!.data.undergraduateFilled ?? false,
      educationDetailsResponsePage!.data.postgraduateFilled ?? false,
    ];
  }

  // SUBMIT BUTTON FILLED STATUS

  bool areAllDetailsFilled() {
    bool isHigherOrDiplomaFilled =
        isEducationFilleds[1] || isEducationFilleds[2];
    bool isUnderOrPostGraduationFilled =
        isEducationFilleds[3] || isEducationFilleds[4];

    return isEducationFilleds[0] &&
        isHigherOrDiplomaFilled &&
        isUnderOrPostGraduationFilled;
  }

// ===================== GET HIGH SCHOOL ==============================

  Future<void> fetchHighSchoolDetails(
      String cadId, BuildContext context) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    try {
      var response = await CandidateEducationRepo()
          .getHighSchoolDetails(candId: cadId, context: context);
      if (!context.mounted) return;
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (response.data != null) {
        educationInfo = response.data!;
        isNewUser = false;
      } else {
        isNewUser = true; // No data returned
      }

      notifyListeners();
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
          context,
          "Please check your internet connection and try again.",
          () {
            Navigator.pop(context);
          },
        );
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }

  // ===================== POST HIGH SCHOOL ==============================

  void submitHighSchoolDetails(context, reqObj, candId) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    notifyListeners();
    try {
      var response = await CandidateEducationRepo().postHighSchoolDetails(
        reqObj: reqObj,
        candidateId: candId,
      );
      LoaderWidget.removeProgressIndicatorAlertDialog(context);
      notifyListeners();
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['didError'] == true &&
            response.data['errorMessage'] != null) {
          ToastUtils.showToast(
            context: context,
            message: response.data['errorMessage'],
            type: ToastificationType.error,
          );
        } else {
          ToastUtils.showToast(
            context: context,
            message: "High School Details Saved successfully.",
            type: ToastificationType.success,
          );
          Navigator.pop(context, true);
        }
      } else {
        ToastUtils.showToast(
          context: context,
          message: "Something went wrong",
          type: ToastificationType.info,
        );
      }
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);
      ToastUtils.showToast(
        context: context,
        message: error.toString().replaceFirst('Exception:', '').trim(),
        type: ToastificationType.error,
      );
      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
            context, "Please check your internet connection and try again.",
            () {
          Navigator.pop(context);
          Navigator.pop(context);
          notifyListeners();
        });
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }

  // ===================== GET HIGHER SECONDARY ==============================

  Future<void> fetchHigherSecondaryDetails(
    BuildContext context) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    try {
      var response = await CandidateEducationRepo()
          .getHigherSecondaryDetails(context: context);
      if (!context.mounted) return;
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (response.data!= null) {
        higherSecondaryEducationInfo = response.data!;
        isNewUser = false;
      } else {
        isNewUser = true; // No data returned
      }

      notifyListeners();
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
          context,
          "Please check your internet connection and try again.",
          () {
            Navigator.pop(context);
          },
        );
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }

  // ===================== POST HIGHER SECONDARY ==============================

  void submitHigherSecondaryDetails(context, reqObj) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    notifyListeners();
    try {
      var response = await CandidateEducationRepo().postHigherSecondaryDetails(
        reqObj: reqObj,
      );
      LoaderWidget.removeProgressIndicatorAlertDialog(context);
      notifyListeners();
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['didError'] == true &&
            response.data['errorMessage'] != null) {
          ToastUtils.showToast(
              context: context,
              message: response.data['errorMessage'],
              type: ToastificationType.error);
        } else {
          ToastUtils.showToast(
              context: context,
              message: "Higher Secondary Details Saved successfully.",
              type: ToastificationType.success);
          Navigator.pop(context, true);
        }
      } else {
        ToastUtils.showToast(
            context: context,
            message: "Something went wrong",
            type: ToastificationType.info);
      }
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);
      ToastUtils.showToast(
        context: context,
        message: error.toString().replaceFirst('Exception:', '').trim(),
        type: ToastificationType.error,
      );
      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
            context, "Please check your internet connection and try again.",
            () {
          Navigator.pop(context);
          Navigator.pop(context);
          notifyListeners();
        });
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }

  // ===================== GET DIPLOMA ==============================

  Future<void> fetchDiplomaDetails(BuildContext context) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    try {
      var response = await CandidateEducationRepo()
          .getDiplomaDetails(context: context);
      if (!context.mounted) return;
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (response.data != null) {
      diplomaEducationInfo = response;
        isNewUser = false;
      } else {
        isNewUser = true; // No data returned
      }

      notifyListeners();
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
          context,
          "Please check your internet connection and try again.",
          () {
            Navigator.pop(context);
          },
        );
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }

  // ===================== POST DIPLOMA ==============================

  void submitDiplomaDetails(context, reqObj,) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    notifyListeners();
    try {
      var response = await CandidateEducationRepo().postDiplomaDetails(
        reqObj: reqObj,
      );
      LoaderWidget.removeProgressIndicatorAlertDialog(context);
      notifyListeners();
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['didError'] == true &&
            response.data['errorMessage'] != null) {
          ToastUtils.showToast(
            context: context,
            message: response.data['errorMessage'],
            type: ToastificationType.error,
          );
        } else {
          ToastUtils.showToast(
            context: context,
            message: "Diploma Details Saved successfully.",
            type: ToastificationType.success,
          );
          Navigator.pop(context, true);
        }
      } else {
        ToastUtils.showToast(
          context: context,
          message: "Something went wrong",
          type: ToastificationType.info,
        );
      }
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);
      ToastUtils.showToast(
        context: context,
        message: error.toString().replaceFirst('Exception:', '').trim(),
        type: ToastificationType.error,
      );

      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
            context, "Please check your internet connection and try again.",
            () {
          Navigator.pop(context);
          Navigator.pop(context);
          notifyListeners();
        });
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }

  // ===================== GET UNDER GRADUATION ==============================

  Future<void> getUnderGraduationDetails(
     BuildContext context) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    try {
      var response = await CandidateEducationRepo()
          .getUnderGraduationDetails(context: context);
      if (!context.mounted) return;
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (response.data != null) {
       // underGraduationEducationInfo = response?.data;
        isNewUser = false;
      } else {
        isNewUser = true; // No data returned
      }

      notifyListeners();
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
          context,
          "Please check your internet connection and try again.",
          () {
            Navigator.pop(context);
          },
        );
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }

  // ===================== POST UNDER GRADUATION ==============================

  void submitUnderGraduationDetails(context, reqObj,) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    notifyListeners();
    try {
      var response = await CandidateEducationRepo().postUnderGraduationDetails(
        reqObj: reqObj,
      );
      LoaderWidget.removeProgressIndicatorAlertDialog(context);
      notifyListeners();
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['didError'] == true &&
            response.data['errorMessage'] != null) {
          ToastUtils.showToast(
            context: context,
            message: response.data['errorMessage'],
            type: ToastificationType.error,
          );
        } else {
          ToastUtils.showToast(
            context: context,
            message: "Under Graduation Details Saved successfully.",
            type: ToastificationType.success,
          );
          Navigator.pop(context, true);
        }
      } else {
        ToastUtils.showToast(
          context: context,
          message: "Something went wrong",
          type: ToastificationType.info,
        );
      }
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);
      ToastUtils.showToast(
        context: context,
        message: error.toString().replaceFirst('Exception:', '').trim(),
        type: ToastificationType.error,
      );

      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
            context, "Please check your internet connection and try again.",
            () {
          Navigator.pop(context);
          Navigator.pop(context);
          notifyListeners();
        });
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }

// ===================== GET POST GRADUATION ==============================

  Future<void> fetchPostGraduationDetails(
     BuildContext context) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    try {
      var response = await CandidateEducationRepo()
          .getPostGraduationDetails(context: context);
      if (!context.mounted) return;
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (response.data != null) {
        // postGraduationEducationInfo = response.data;
        isNewUser = false;
      } else {
        isNewUser = true; // No data returned
      }

      notifyListeners();
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);

      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
          context,
          "Please check your internet connection and try again.",
          () {
            Navigator.pop(context);
          },
        );
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }

  // ===================== POST POST GRADUATION ==============================

  void submitPostGraduationDetails(context, reqObj,) async {
    LoaderWidget.showProgressIndicatorAlertDialog(context);
    notifyListeners();
    try {
      var response = await CandidateEducationRepo().postPostGraduationDetails(
        reqObj: reqObj,
      );
      LoaderWidget.removeProgressIndicatorAlertDialog(context);
      notifyListeners();
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['didError'] == true &&
            response.data['errorMessage'] != null) {
          ToastUtils.showToast(
            context: context,
            message: response.data['errorMessage'],
            type: ToastificationType.error,
          );
        } else {
          ToastUtils.showToast(
            context: context,
            message: "Post Graduation Details Saved successfully.",
            type: ToastificationType.success,
          );
          Navigator.pop(context, true);
        }
      } else {
        ToastUtils.showToast(
          context: context,
          message: "Something went wrong",
          type: ToastificationType.info,
        );
      }
    } catch (error) {
      LoaderWidget.removeProgressIndicatorAlertDialog(context);
      ToastUtils.showToast(
        context: context,
        message: error.toString().replaceFirst('Exception:', '').trim(),
        type: ToastificationType.error,
      );
      if (error.toString().contains("No internet connection")) {
        CustomShowDailogs.showdailogCustom(
            context, "Please check your internet connection and try again.",
            () {
          Navigator.pop(context);
          Navigator.pop(context);
          notifyListeners();
        });
      } else if (error.toString().contains("Session expired")) {
        CustomShowDailogs.showdailogCustomSessionExpired(context);
      }
    }
  }
}
