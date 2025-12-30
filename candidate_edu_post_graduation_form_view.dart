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

class CandidatePostGraduationFormView extends StatefulWidget {
  final String category;
  const CandidatePostGraduationFormView({super.key, required this.category});

  @override
  State<CandidatePostGraduationFormView> createState() =>
      _CandidatePostGraduationFormViewState();
}

class _CandidatePostGraduationFormViewState
    extends State<CandidatePostGraduationFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController pgCity = TextEditingController();
  TextEditingController pgEnrollmentNo = TextEditingController();
  TextEditingController pgInstituteName = TextEditingController();
  TextEditingController pgSpecialization = TextEditingController();
  TextEditingController pgDegree = TextEditingController();
  TextEditingController pgYearofenrollment = TextEditingController();
  TextEditingController pgYearofpassout = TextEditingController();
  TextEditingController pgCountry = TextEditingController();
  TextEditingController pgState = TextEditingController();
  TextEditingController pgPincode = TextEditingController();
  TextEditingController pgAddress = TextEditingController();
  TextEditingController pgCrtfile = TextEditingController();
  final pgenrollNoFieldKey = GlobalKey<FormFieldState>();
  final pgInstituteFieldKey = GlobalKey<FormFieldState>();
  final specializationFieldKey = GlobalKey<FormFieldState>();
  final pgenrollYearFieldKey = GlobalKey<FormFieldState>();
  final pgpassoutFieldKey = GlobalKey<FormFieldState>();
  final pgProofFieldKey = GlobalKey<FormFieldState>();
  final pincodeFieldKey = GlobalKey<FormFieldState>();
  bool pinCodeTouched = false;
  final pinCodeFocusNode = FocusNode();
  bool enrollNoTouched = false;
  final enrollNoFocusNode = FocusNode();
  // bool instituteNameTouched = false;
  // final instituteNameFocusNode = FocusNode();
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
    enrollNoFocusNode.addListener(() {
      if (!enrollNoFocusNode.hasFocus && !enrollNoTouched) {
        setState(() {
          enrollNoTouched = true;
        });
        pgenrollNoFieldKey.currentState?.validate();
      }
    });
    // instituteNameFocusNode.addListener(() {
    //   if (!instituteNameFocusNode.hasFocus && !instituteNameTouched) {
    //     setState(() {
    //       instituteNameTouched = true;
    //     });
    //     pgInstituteFieldKey.currentState?.validate();
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final candidateId = prefs.getInt('candidateId');
      if (candidateId != null) {
        if (!mounted) return;
        final viewModel = Provider.of<CandidateEducationFormViewModel>(context,
            listen: false);
        viewModel.clearState();
        await viewModel.fetchPostGraduationDetails(context);
        final info = viewModel.postGraduationEducationInfo;

        if (info != null) {
          setState(() {
            pgEnrollmentNo.text = info.data.enrollmentNumber ?? '';
            pgInstituteName.text = info.data.instituteName ?? '';
            pgDegree.text = info.data.qualification ?? '';
            pgSpecialization.text = info.data.specialization ?? '';
            pgYearofenrollment.text = info.data.enrolledYear ?? '';
            pgYearofpassout.text = info.data.passingYear ?? '';
            pgCountry.text = info.data.country ?? '';
            pgState.text = info.data.stateRegionProvince ?? '';
            pgCity.text = info.data.city ?? '';
            pgPincode.text = info.data.zipCode ?? '';
            pgAddress.text = info.data.address ?? '';
            pgCrtfile.text = info.data.certificateFileUrl ?? '';
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
        title: StaticText().postGraduationDetails,
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
                  await vm.fetchPostGraduationDetails(_);
                  final info = vm.postGraduationEducationInfo;
                  if (info != null) {
                    final degreeValue = info.data.qualification ?? '';
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
                              fieldKey: pgenrollNoFieldKey,
                              focusNode: enrollNoFocusNode,
                              controller: pgEnrollmentNo,
                              labelText: StaticText().enrollmentNo,
                              prefixIcon: Icons.touch_app_outlined,
                              validator: (value) {
                                if (!enrollNoTouched) return null;
                                return viewModel.validateEnrollNo(value);
                              },
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeAlphanumericNoSpaces(val);
                                pgEnrollmentNo.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                                if (enrollNoTouched) {
                                  pgenrollNoFieldKey.currentState?.validate();
                                }
                              },
                              maxLength: 20,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              fieldKey: pgInstituteFieldKey,
                              controller: pgInstituteName,
                              labelText: StaticText().instituteName,
                              prefixIcon: Icons.business_rounded,
                              validator: viewModel.validateInstituteName,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                pgInstituteName.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                                pgInstituteFieldKey.currentState?.validate();
                              },
                              maxLength: 40,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: pgDegree,
                              labelText: StaticText().qualification,
                              prefixIcon: Icons.school_outlined,
                              dropdownItems: viewModel.qualificationsByCategory[
                                  viewModel.selectedCategory]!,
                              dropdownValue: viewModel.selectedQualification,
                              onDropdownChanged: (newValue) {
                                viewModel.updateQualification(newValue!);
                                pgDegree.text = newValue;
                              },
                              validator: viewModel.validateQualification,
                              readOnly: true,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              fieldKey: specializationFieldKey,
                              controller: pgSpecialization,
                              labelText: StaticText().specialization,
                              prefixIcon: Icons.school_outlined,
                              validator: viewModel.validateSpecialization,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                pgSpecialization.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                                specializationFieldKey.currentState?.validate();
                              },
                              maxLength: 40,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormFieldWithTap(
                              fieldKey: pgenrollYearFieldKey,
                              onTap: () async {
                                await viewModel.selectEnrollDate(context,
                                    pgYearofenrollment, pgenrollYearFieldKey);
                              },
                              controller: pgYearofenrollment,
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
                              fieldKey: pgpassoutFieldKey,
                              onTap: () async {
                                await viewModel.selectPassoutDate(
                                    context,
                                    pgYearofpassout,
                                    pgYearofenrollment.text,
                                    pgpassoutFieldKey);
                              },
                              controller: pgYearofpassout,
                              labelText: StaticText().yearOfPassout,
                              prefixIcon: Icons.cake_outlined,
                              suffixIcon: Icon(
                                Icons.calendar_month_outlined,
                                color: ColorsConst().purple,
                              ),
                              validator: (value) => viewModel.validatePassout(
                                value,
                                pgYearofenrollment.text,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: pgAddress,
                              labelText: StaticText().addressOptional,
                              prefixIcon: Icons.home_outlined,
                              maxLength: 40,
                              //validator: viewModel.validateAddressLine,
                              onChanged: (val) {
                                final cleaned = viewModel.sanitizeText(val);
                                pgAddress.value = TextEditingValue(
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
                              controller: pgCity,
                              labelText: StaticText().cityOptional,
                              prefixIcon: Icons.location_city_rounded,
                              maxLength: 20,
                              //validator: viewModel.validateCity,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                pgCity.value = TextEditingValue(
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
                              controller: pgState,
                              labelText: StaticText().stateOptional,
                              prefixIcon: Icons.map_outlined,
                              isCSCPicker: true,
                              cscFieldType: 'state',
                              onStateChanged: (value) {
                                // Handle state change
                                debugPrint("Selected State: $value");
                              },
                              //validator: viewModel.validateState,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: pgCountry..text = "India",
                              labelText: StaticText().currentAddressCountry,
                              prefixIcon: Icons.public,
                              readOnly: true,
                              validator: viewModel.validateCountry,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              fieldKey: pincodeFieldKey,
                              focusNode: pinCodeFocusNode,
                              controller: pgPincode,
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
                              fieldKey: pgProofFieldKey,
                              onTap: () {
                                viewModel.pickFilesEducation(
                                  controller: pgCrtfile,
                                  fieldKey: pgProofFieldKey,
                                  onFilePicked: (file) {
                                    viewModel.pgFile = file;
                                  },
                                );
                              },
                              controller: pgCrtfile,
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
                                                .pgFile ==
                                            null) {
                                          ToastUtils.showToast(
                                            context: context,
                                            message:
                                                "Please upload Under Graduation certificate.",
                                            type: ToastificationType.warning,
                                          );
                                          return;
                                        }

                                        // Retrieve candidateId from SharedPreferences
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        if (!context.mounted) return;
                                        // Prepare the request object
                                        var reqObj = <String, dynamic>{};
                                        reqObj["enrollmentNumber"] =
                                            pgEnrollmentNo.text.trim();
                                        reqObj["instituteName"] =
                                            pgInstituteName.text.trim();
                                        reqObj["qualification"] = viewModel
                                            .selectedQualification
                                            .trim();
                                        reqObj["specialization"] =
                                            pgSpecialization.text.trim();
                                        reqObj["enrolledYear"] =
                                            pgYearofenrollment.text.trim();
                                        reqObj["passingYear"] =
                                            pgYearofpassout.text.trim();
                                        reqObj["address"] =
                                            pgAddress.text.trim();
                                        reqObj["city"] = pgCity.text.trim();
                                        reqObj["stateRegionProvince"] = pgState.text.trim();
                                        reqObj["country"] =
                                            pgCountry.text.trim();
                                        reqObj["zipCode"] =
                                            pgPincode.text.trim();
                                        reqObj["certificateFileUrl"] =
                                            await MultipartFile.fromFile(
                                          viewModel.pgFile!.path,
                                          filename: viewModel.pgFile!.path
                                              .split('/')
                                              .last,
                                          contentType:
                                              MediaType('application', 'pdf'),
                                        );
                                        if (!context.mounted) return;
                                        viewModel.submitPostGraduationDetails(
                                            context,
                                            reqObj,);
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
