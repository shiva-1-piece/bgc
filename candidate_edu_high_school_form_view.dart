import 'dart:io';
import 'package:bgc_mobile/Candidate/Dashboard/Model/education_details_model.dart';
import 'package:bgc_mobile/Candidate/Dashboard/view/candidate_education_details_view.dart';
import 'package:bgc_mobile/Candidate/Dashboard/viewmodel/candidate_education_form_viewmodel.dart';
import 'package:bgc_mobile/Login/View/change_password_view.dart';
import 'package:bgc_mobile/Utils/appbar_util.dart';
import 'package:bgc_mobile/Utils/color_constraints.dart';
import 'package:bgc_mobile/Utils/elevated_button_util.dart';
import 'package:bgc_mobile/Utils/show_dailog_util.dart';
import 'package:bgc_mobile/Utils/static_text.dart';
import 'package:bgc_mobile/Utils/tap_gesture_textfield.dart';
import 'package:bgc_mobile/Utils/textfeild_util.dart';
import 'package:bgc_mobile/Utils/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class CandidateEducationFormView extends StatefulWidget {
  final String category;
  const CandidateEducationFormView({super.key, required this.category});

  @override
  State<CandidateEducationFormView> createState() =>
      _CandidateEducationFormViewState();
}

class _CandidateEducationFormViewState
    extends State<CandidateEducationFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isManualFilePicked = false;
  File? file;
  HighSchoolData? educationInfo;
  TextEditingController city = TextEditingController();
  TextEditingController enrollmentNumber = TextEditingController();
  TextEditingController instituteName = TextEditingController();
  TextEditingController specialization = TextEditingController();
  TextEditingController degree = TextEditingController();
  TextEditingController yearofenrollment = TextEditingController();
  TextEditingController yearofpassout = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController crtfile = TextEditingController();
  TextEditingController highSchoolProof = TextEditingController();
  final enrollyearFieldKey = GlobalKey<FormFieldState>();
  final passoutyearFieldKey = GlobalKey<FormFieldState>();
  final educationProofFieldKey = GlobalKey<FormFieldState>();
  final pincodeFieldKey = GlobalKey<FormFieldState>();
  final enrollNoFiledKey = GlobalKey<FormFieldState>();
  final instituteNameFieldKey = GlobalKey<FormFieldState>();
  bool pinCodeTouched = false;
  final pinCodeFocusNode = FocusNode();
  bool _keyboardWasActive = false;

  void _handleBack(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      FocusScope.of(context).unfocus();
      _keyboardWasActive = true;
    } else if (_keyboardWasActive) {
      _keyboardWasActive = false;
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    pinCodeFocusNode.addListener(() {
      if (!pinCodeFocusNode.hasFocus && !pinCodeTouched) {
        setState(() {
          pinCodeTouched = true;
        });
        pincodeFieldKey.currentState?.validate();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final candidateId = prefs.getInt('candidateId');
      final accessToken = prefs.getString('accessToken');

      if (candidateId != null || accessToken != null) {
        if (!mounted) return;
        final viewModel = Provider.of<CandidateEducationFormViewModel>(context,
            listen: false);
        viewModel.clearState();
        await viewModel.fetchHighSchoolDetails(candidateId.toString(), context);
        final info = viewModel.educationInfo;

        if (info != null) {
          setState(() {
            enrollmentNumber.text = info.enrollmentNumber ?? '';
            instituteName.text = info.instituteName ?? '';
            //degree.text = degreeValue;
            specialization.text = info.specialization ?? '';
            yearofenrollment.text = info.enrolledYear ?? '';
            yearofpassout.text = info.passingYear ?? '';
            country.text = info.country ?? '';
            state.text = info.stateRegionProvince ?? '';
            city.text = info.city ?? '';
            pincode.text = info.zipCode ?? '';
            address.text = info.address ?? '';
            highSchoolProof.text = info.certificateFileUrl ?? '';
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppbar(
        title: StaticText().highSchoolDetails,
        height: 70,
        onPressed: () => _handleBack(context),
        actions: [
          PopupMenuButton<String>(
            icon: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Center(
                child: const Icon(
                  Icons.settings,
                  size: 23,
                  color: Colors.white,
                ),
              ),
            ),
            offset: const Offset(0, 70), // adjust vertically as needed
            onSelected: (value) {
              if (value == 'change_password') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordView(),
                  ),
                );
              } else if (value == 'logout') {
                CustomShowDailogs.showdailogLogout(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'change_password',
                child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.lock_outline,
                      size: 20, color: ColorsConst().green),
                  title: const Text('Change Password',
                      style: TextStyle(fontSize: 16)),
                  contentPadding: const EdgeInsets.only(left: 13, right: 0),
                  minLeadingWidth: 0,
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.logout, size: 20, color: Colors.red[400]),
                  title: const Text('Logout', style: TextStyle(fontSize: 16)),
                  contentPadding: const EdgeInsets.only(left: 15, right: 0),
                  minLeadingWidth: 00,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider(
            create: (_) {
              final vm = CandidateEducationFormViewModel();
              vm.candidateEducationForm(widget.category);
              // Fetch data and update ViewModel
              SharedPreferences.getInstance().then((prefs) async {
                final candidateId = prefs.getInt('candidateId');
                final accessToken = prefs.getString('accessToken');
                if (candidateId != null || accessToken != null) {
                  vm.clearState();
                  await vm.fetchHighSchoolDetails(candidateId.toString(), _);
                  final info = vm.educationInfo;
                  if (info != null) {
                    final degreeValue = info.qualification ?? '';
                    if (vm.qualificationsByCategory[vm.selectedCategory]!
                        .contains(degreeValue)) {
                      vm.updateQualification(degreeValue);
                    }
                  }
                }
              });
              return vm;
            },
            child: Consumer<CandidateEducationFormViewModel>(
                builder: (context, viewModel, child) {
              return Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextFormField(
                              controller: enrollmentNumber,
                              labelText: StaticText().enrollmentNoOptional,
                              prefixIcon: Icons.touch_app_outlined,
                              //validator: viewModel.validateEnrollNo,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeAlphanumericNoSpaces(val);
                                enrollmentNumber.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                              },
                              maxLength: 20,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: instituteName,
                              labelText: StaticText().instituteNameOptional,
                              prefixIcon: Icons.business_rounded,
                              //validator: viewModel.validateInstituteName,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                instituteName.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                              },
                              maxLength: 40,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: degree,
                              labelText: StaticText().qualification,
                              prefixIcon: Icons.school_outlined,
                              dropdownItems: viewModel.qualificationsByCategory[
                                  viewModel.selectedCategory]!,
                              dropdownValue: viewModel.selectedQualification,
                              onDropdownChanged: (newValue) {
                                viewModel.updateQualification(newValue!);
                                degree.text = newValue;
                              },
                              validator: viewModel.validateQualification,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormFieldWithTap(
                              fieldKey: enrollyearFieldKey,
                              onTap: () async {
                                await viewModel.selectEnrollDate(context,
                                    yearofenrollment, enrollyearFieldKey);
                              },
                              //readOnly: true,
                              controller: yearofenrollment,
                              labelText: StaticText().yearOfEmrollment,
                              prefixIcon: Icons.cake_outlined,
                              suffixIcon: Icon(
                                Icons.calendar_month_outlined,
                                color: ColorsConst().purple,
                              ),

                              validator: (value) =>
                                  viewModel.validateEnroll(value),
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormFieldWithTap(
                              fieldKey: passoutyearFieldKey,
                              onTap: () async {
                                await viewModel.selectPassoutDate(
                                    context,
                                    yearofpassout,
                                    yearofenrollment.text,
                                    passoutyearFieldKey);
                              },
                              controller: yearofpassout,
                              labelText: StaticText().yearOfPassout,
                              prefixIcon: Icons.cake_outlined,
                              suffixIcon: Icon(
                                Icons.calendar_month_outlined,
                                color: ColorsConst().purple,
                              ),
                              validator: (value) => viewModel.validatePassout(
                                value,
                                yearofenrollment.text,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: address,
                              labelText: StaticText().addressOptional,
                              prefixIcon: Icons.home_outlined,
                              maxLength: 40,
                              //validator: viewModel.validateAddressLine,
                              onChanged: (val) {
                                final cleaned = viewModel.sanitizeText(val);
                                address.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: city,
                              labelText: StaticText().cityOptional,
                              prefixIcon: Icons.location_city_rounded,
                              maxLength: 20,
                              // validator: viewModel.validateCity,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                city.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: state,
                              labelText: StaticText().stateOptional,
                              prefixIcon: Icons.map_outlined,
                              isCSCPicker: true,
                              cscFieldType: 'state',
                              onStateChanged: (value) {
                                setState(() {
                                  state.text =
                                      value; // Update the controller when the state changes
                                });
                              },
                              //validator: viewModel.validateState,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: country..text = "India",
                              labelText: StaticText().country,
                              prefixIcon: Icons.public,
                              readOnly: true,
                              // validator: viewModel.validateCountry,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              fieldKey: pincodeFieldKey,
                              focusNode: pinCodeFocusNode,
                              controller: pincode,
                              labelText: StaticText().pincodeOptional,
                              prefixIcon: Icons.pin_drop_outlined,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              validator: (value) {
                                if (!pinCodeTouched) return null;
                                return viewModel.validatePinCode(value);
                              },
                              onChanged: (val) {
                                if (pinCodeTouched) {
                                  pincodeFieldKey.currentState?.validate();
                                }
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormFieldWithTap(
                              fieldKey: educationProofFieldKey,
                              onTap: () {
                                viewModel.pickFilesEducation(
                                  controller: highSchoolProof,
                                  fieldKey: educationProofFieldKey,
                                  onFilePicked: (file) {
                                    viewModel.file = file;
                                  },
                                );
                              },
                              controller: highSchoolProof,
                              labelText: StaticText().educationProof,
                              prefixIcon: Icons.library_books_outlined,
                              suffixIcon: Icon(
                                Icons.file_upload_outlined,
                                color: ColorsConst().purple,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return StaticText().emptyEducationImage;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomElevatedButton(
                                  text: StaticText().cancel,
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CandidateEducationDetailsView(),
                                      ),
                                    );
                                  },
                                ),
                                CustomElevatedButton(
                                    text: StaticText().submit,
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        if (Provider.of<CandidateEducationFormViewModel>(
                                                    context,
                                                    listen: false)
                                                .file ==
                                            null) {
                                          ToastUtils.showToast(
                                            context: context,
                                            message:
                                                'Please upload High School certificate.',
                                            type: ToastificationType.warning,
                                          );
                                          return;
                                        }

                                        // Retrieve candidateId from SharedPreferences
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        final candidateId =
                                            prefs.getInt('candidateId');

                                        if (candidateId == null) {
                                          if (!context.mounted) return;
                                          ToastUtils.showToast(
                                            context: context,
                                            message:
                                                'Candidate ID not found. Please try again.',
                                            type: ToastificationType.error,
                                          );
                                          return;
                                        }

                                        // Prepare the request object
                                        var reqObj = <String, dynamic>{};
                                        reqObj["enrollmentNumber"] =
                                            enrollmentNumber.text.trim();
                                        reqObj["inistitute"] =
                                            instituteName.text.trim();
                                        reqObj["degree"] = viewModel
                                            .selectedQualification
                                            .trim();
                                        reqObj["specialization"] =
                                            specialization.text.trim();
                                        reqObj["yearofenrollment"] =
                                            yearofenrollment.text.trim();
                                        reqObj["yearofpassout"] =
                                            yearofpassout.text.trim();
                                        reqObj["address"] = address.text.trim();
                                        reqObj["city"] = city.text.trim();
                                        reqObj["state"] = state.text.trim();
                                        reqObj["country"] = country.text.trim();
                                        reqObj["pincode"] = pincode.text.trim();
                                        reqObj["crtfile"] =
                                            await MultipartFile.fromFile(
                                          viewModel.file!.path,
                                          filename: viewModel.file!.path
                                              .split('/')
                                              .last,
                                          contentType:
                                              MediaType('application', 'pdf'),
                                        );
                                        if (!context.mounted) return;
                                        viewModel.submitHighSchoolDetails(
                                            context,
                                            reqObj,
                                            candidateId.toString());
                                      }
                                    }),
                              ],
                            ),
                          ],
                        )),
                  ));
            }),
          ),
        ),
      ),
    );
  }
}
