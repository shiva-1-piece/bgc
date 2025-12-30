import 'package:bgc_mobile/Candidate/Dashboard/Model/default_education_page_model.dart';
import 'package:bgc_mobile/Candidate/Dashboard/Model/education_details_model.dart';
import 'package:bgc_mobile/Utils/Api/api_constants.dart';
import 'package:bgc_mobile/Utils/Api/api_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CandidateEducationRepo {
// =================== GET DEFAULT EDUCATION INFO API ===================
  Future<EducationDetailsResponsePage> getDefaultEducationInfo({
  
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      Response response = await ApiService().getResponseBodyQuery(
          url: ApiConst.getDefaultEducationInfo, // <-- Make sure this is correct

          accessToken: accessToken.toString());

      if (response.statusCode == 503) {
        throw Exception("No internet connection. Please check your network.");
      } else if (response.statusCode == 401) {
        throw Exception("Session expired. Please log in again.");
      } else if (response.statusCode != 200) {
        throw Exception("Failed to fetch data: ${response.statusMessage}");
      }

      return EducationDetailsResponsePage.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // =================== GET HIGH SCHOOL DETAILS API ===================
  Future<HighSchoolDetailsResponse> getHighSchoolDetails({
    required String candId,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      Response response = await ApiService().getResponseBodyQuery(
          url: ApiConst.getHighSchoolDetails, // <-- Make sure this is correct
          paramKey: "candidateid",
          params: candId,
          accessToken: accessToken.toString());

      if (response.statusCode == 503) {
        throw Exception("No internet connection. Please check your network.");
      } else if (response.statusCode == 401) {
        throw Exception("Session expired. Please log in again.");
      } else if (response.statusCode != 200) {
        throw Exception("Failed to fetch data: ${response.statusMessage}");
      }

      return HighSchoolDetailsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // =================== POST HIGH SCHOOL DETAILS API ===================

  Future<dynamic> postHighSchoolDetails({
    required String candidateId,
    required Map<String, dynamic> reqObj,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Response response = await ApiService().postResponseBodyAccessTokenFormData(
        url: ApiConst.postHighSchoolDetails,
        accessToken: accessToken.toString(),
        reqObj: reqObj);
    if (response.statusCode == 503) {
      throw Exception("No internet connection. Please check your network.");
    } else if (response.statusCode == 401) {
      throw Exception("Session expired. Please log in again.");
    } else if (response.statusCode != 200) {
      throw Exception("Failed to login. Error: ${response.statusMessage}");
    }
    return response;
  }

// =================== GET HIGHER SECONDARY DETAILS API ===================
  Future<HigherSecondaryDetailsResponse> getHigherSecondaryDetails({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      Response response = await ApiService().getResponseBody(
          url: ApiConst
              .getHigherSecondaryDetails, // <-- Make sure this is correct

          accessToken: accessToken.toString());

      if (response.statusCode == 503) {
        throw Exception("No internet connection. Please check your network.");
      } else if (response.statusCode == 401) {
        throw Exception("Session expired. Please log in again.");
      } else if (response.statusCode != 200) {
        throw Exception("Failed to fetch data: ${response.statusMessage}");
      }

      return HigherSecondaryDetailsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // =================== POST HIGHER SECONDARY DETAILS API ===================

  Future<dynamic> postHigherSecondaryDetails({
    required Map<String, dynamic> reqObj,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Response response = await ApiService().postResponseBodyAccessTokenFormData(
        url: ApiConst.postHigherSecondaryDetails,
        accessToken: accessToken.toString(),
        reqObj: reqObj);
    if (response.statusCode == 503) {
      throw Exception("No internet connection. Please check your network.");
    } else if (response.statusCode == 401) {
      throw Exception("Session expired. Please log in again.");
    } else if (response.statusCode != 200) {
      throw Exception("Failed to login. Error: ${response.statusMessage}");
    }
    return response;
  }

  // =================== GET UNDER GRADUATION DETAILS API ===================
  Future<UnderGraduationEducationInfo> getUnderGraduationDetails({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      Response response = await ApiService().getResponseBody(
          url: ApiConst
              .getUnderGraduationDetails, // <-- Make sure this is correct

          accessToken: accessToken.toString());

      if (response.statusCode == 503) {
        throw Exception("No internet connection. Please check your network.");
      } else if (response.statusCode == 401) {
        throw Exception("Session expired. Please log in again.");
      } else if (response.statusCode != 200) {
        throw Exception("Failed to fetch data: ${response.statusMessage}");
      }

      return UnderGraduationEducationInfo.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // =================== POST UNDER GRADUATION DETAILS API ===================

  Future<dynamic> postUnderGraduationDetails({
    required Map<String, dynamic> reqObj,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Response response = await ApiService().postResponseBodyAccessTokenFormData(
        url: ApiConst.postUnderGraduationDetails,
        accessToken: accessToken.toString(),
        reqObj: reqObj);
    if (response.statusCode == 503) {
      throw Exception("No internet connection. Please check your network.");
    } else if (response.statusCode == 401) {
      throw Exception("Session expired. Please log in again.");
    } else if (response.statusCode != 200) {
      throw Exception("Failed to login. Error: ${response.statusMessage}");
    }
    return response;
  }

  // =================== GET DIPLOMA DETAILS API ===================
  Future<DiplomaDetailsResponse> getDiplomaDetails({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      Response response = await ApiService().getResponseBody(
          url: ApiConst.getDiplomaDetails, // <-- Make sure this is correct
          accessToken: accessToken.toString());

      if (response.statusCode == 503) {
        throw Exception("No internet connection. Please check your network.");
      } else if (response.statusCode == 401) {
        throw Exception("Session expired. Please log in again.");
      } else if (response.statusCode != 200) {
        throw Exception("Failed to fetch data: ${response.statusMessage}");
      }

      return DiplomaDetailsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // =================== POST DIPLOMA DETAILS API ===================

  Future<dynamic> postDiplomaDetails({
    required Map<String, dynamic> reqObj,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Response response = await ApiService().postResponseBodyAccessTokenFormData(
        url: ApiConst.postDiplomaDetails,
        accessToken: accessToken.toString(),
        reqObj: reqObj);
    if (response.statusCode == 503) {
      throw Exception("No internet connection. Please check your network.");
    } else if (response.statusCode == 401) {
      throw Exception("Session expired. Please log in again.");
    } else if (response.statusCode != 200) {
      throw Exception("Failed to login. Error: ${response.statusMessage}");
    }
    return response;
  }

  // =================== GET PG DETAILS API ===================
  Future<PostGraduationDetailsResponse> getPostGraduationDetails({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      Response response = await ApiService().getResponseBody(
          url: ApiConst
              .getPostGraduationDetails, // <-- Make sure this is correct

          accessToken: accessToken.toString());

      if (response.statusCode == 503) {
        throw Exception("No internet connection. Please check your network.");
      } else if (response.statusCode == 401) {
        throw Exception("Session expired. Please log in again.");
      } else if (response.statusCode != 200) {
        throw Exception("Failed to fetch data: ${response.statusMessage}");
      }

      return PostGraduationDetailsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // =================== POST PG DETAILS API ===================

  Future<dynamic> postPostGraduationDetails({
    required Map<String, dynamic> reqObj,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Response response = await ApiService().postResponseBodyAccessTokenFormData(
        url: ApiConst.postPostGraduationDetails,
        accessToken: accessToken.toString(),
        reqObj: reqObj);
    if (response.statusCode == 503) {
      throw Exception("No internet connection. Please check your network.");
    } else if (response.statusCode == 401) {
      throw Exception("Session expired. Please log in again.");
    } else if (response.statusCode != 200) {
      throw Exception("Failed to login. Error: ${response.statusMessage}");
    }
    return response;
  }
}
