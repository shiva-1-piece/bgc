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

class CandidateUnderGraduationFormView extends StatefulWidget {
  final String category;
  const CandidateUnderGraduationFormView({super.key, required this.category});

  @override
  State<CandidateUnderGraduationFormView> createState() =>
      _CandidateUnderGraduationFormViewState();
}

class _CandidateUnderGraduationFormViewState
    extends State<CandidateUnderGraduationFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController ugCity = TextEditingController();
  TextEditingController ugEnrollmentNo = TextEditingController();
  TextEditingController ugInstituteName = TextEditingController();
  TextEditingController ugSpecialization = TextEditingController();
  TextEditingController ugDegree = TextEditingController();
  TextEditingController ugYearofenrollment = TextEditingController();
  TextEditingController ugYearofpassout = TextEditingController();
  TextEditingController ugCountry = TextEditingController();
  TextEditingController ugState = TextEditingController();
  TextEditingController ugPincode = TextEditingController();
  TextEditingController ugAddress = TextEditingController();
  TextEditingController ugCrtfile = TextEditingController();
  final ugenrollYearFieldKey = GlobalKey<FormFieldState>();
  final ugenrollNoFieldKey = GlobalKey<FormFieldState>();
  final instituteFieldKey = GlobalKey<FormFieldState>();
  final ugSpecializationFieldKey = GlobalKey<FormFieldState>();
  final ugpassoutFieldKey = GlobalKey<FormFieldState>();
  final ugProofFieldKey = GlobalKey<FormFieldState>();
  final pincodeFieldKey = GlobalKey<FormFieldState>();
  bool pinCodeTouched = false;
  final pinCodeFocusNode = FocusNode();
  bool enrollNoTouched = false;
  final enrollNoFocusNode = FocusNode();
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
        ugenrollNoFieldKey.currentState?.validate();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

        if (!mounted) return;
        final viewModel = Provider.of<CandidateEducationFormViewModel>(context,
            listen: false);
        viewModel.clearState();
        await viewModel.getUnderGraduationDetails(
          context);
        final info = viewModel.underGraduationEducationInfo;

        if (info != null) {
          setState(() {
            ugEnrollmentNo.text = info.data.enrollmentNumber ?? '';
            ugInstituteName.text = info.data.instituteName ?? '';
            //ugDegree.text = info.ugDegree ?? '';
            ugSpecialization.text = info.data.specialization ?? '';
            ugYearofenrollment.text = info.data.enrolledYear ?? '';
            ugYearofpassout.text = info.data.passingYear ?? '';
            ugCountry.text = info.data.country ?? '';
            ugState.text =
                info.data.stateRegionProvince ?? ''; // <- this will now update in the UI
            ugCity.text = info.data.city ?? '';
            ugPincode.text = info.data.zipCode ?? '';
            ugAddress.text = info.data.address ?? '';
            ugCrtfile.text = info.data.certificateFileUrl ?? '';
          });
        }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppbar(
        title: StaticText().underGraduationDetails,
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
            create: (context) {
              final vm = CandidateEducationFormViewModel();
              vm.candidateEducationForm(widget.category);
              // Fetch data and update ViewModel
            
               
                  vm.clearState();
                  if (!context.mounted) ;
                   vm.getUnderGraduationDetails(
                    context);
                  final info = vm.underGraduationEducationInfo;
                  if (info != null) {
                    final degreeValue = info.data.qualification ?? '';
                    if (vm.qualificationsByCategory[vm.selectedCategory]!
                        .contains(degreeValue)) {
                      vm.updateQualification(degreeValue);
                    }
                  
                }
              
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
                              fieldKey: ugenrollNoFieldKey,
                              focusNode: enrollNoFocusNode,
                              controller: ugEnrollmentNo,
                              labelText: StaticText().enrollmentNo,
                              prefixIcon: Icons.touch_app_outlined,
                              validator: (value) {
                                if (!enrollNoTouched) return null;
                                return viewModel.validateEnrollNo(value);
                              },
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeAlphanumericNoSpaces(val);
                                ugEnrollmentNo.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                                if (enrollNoTouched) {
                                  ugenrollNoFieldKey.currentState?.validate();
                                }
                              },
                              maxLength: 20,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              fieldKey: instituteFieldKey,
                              controller: ugInstituteName,
                              labelText: StaticText().instituteName,
                              prefixIcon: Icons.business_rounded,
                              validator: viewModel.validateInstituteName,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                ugInstituteName.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                                instituteFieldKey.currentState?.validate();
                              },
                              maxLength: 40,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: ugDegree,
                              labelText: StaticText().qualification,
                              prefixIcon: Icons.school_outlined,
                              dropdownItems: viewModel.qualificationsByCategory[
                                  viewModel.selectedCategory]!,
                              dropdownValue: viewModel.selectedQualification,
                              onDropdownChanged: (newValue) {
                                viewModel.updateQualification(newValue!);
                                ugDegree.text = newValue;
                              },
                              validator: viewModel.validateQualification,
                              readOnly: true,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              fieldKey: ugSpecializationFieldKey,
                              controller: ugSpecialization,
                              labelText: StaticText().specialization,
                              prefixIcon: Icons.school_outlined,
                              validator: viewModel.validateSpecialization,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                ugSpecialization.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                                ugSpecializationFieldKey.currentState
                                    ?.validate();
                              },
                              maxLength: 40,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormFieldWithTap(
                              fieldKey: ugenrollYearFieldKey,
                              onTap: () async {
                                await viewModel.selectEnrollDate(context,
                                    ugYearofenrollment, ugenrollYearFieldKey);
                              },
                              controller: ugYearofenrollment,
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
                              fieldKey: ugpassoutFieldKey,
                              onTap: () async {
                                await viewModel.selectPassoutDate(
                                    context,
                                    ugYearofpassout,
                                    ugYearofenrollment.text,
                                    ugpassoutFieldKey);
                              },
                              controller: ugYearofpassout,
                              labelText: StaticText().yearOfPassout,
                              prefixIcon: Icons.cake_outlined,
                              suffixIcon: Icon(
                                Icons.calendar_month_outlined,
                                color: ColorsConst().purple,
                              ),
                              validator: (value) => viewModel.validatePassout(
                                value,
                                ugYearofenrollment.text,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: ugAddress,
                              labelText: StaticText().addressOptional,
                              prefixIcon: Icons.home_outlined,
                              maxLength: 40,
                              //validator: viewModel.validateAddressLine,
                              onChanged: (val) {
                                final cleaned = viewModel.sanitizeText(val);
                                ugAddress.value = TextEditingValue(
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
                              controller: ugCity,
                              labelText: StaticText().cityOptional,
                              prefixIcon: Icons.location_city_rounded,
                              maxLength: 20,
                              //validator: viewModel.validateCity,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                ugCity.value = TextEditingValue(
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
                              controller: ugState,
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
                              controller: ugCountry..text = "India",
                              labelText: StaticText().country,
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
                              controller: ugPincode,
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
                              fieldKey: ugProofFieldKey,
                              onTap: () {
                                viewModel.pickFilesEducation(
                                  controller: ugCrtfile,
                                  fieldKey: ugProofFieldKey,
                                  onFilePicked: (file) {
                                    viewModel.ugFile = file;
                                  },
                                );
                              },
                              controller: ugCrtfile,
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
                                        if (!mounted) return;

                                        if (Provider.of<CandidateEducationFormViewModel>(
                                                    context,
                                                    listen: false)
                                                .ugFile ==
                                            null) {
                                          ToastUtils.showToast(
                                            context: context,
                                            message:
                                                'Please upload Under Graduation certificate.',
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
                                            ugEnrollmentNo.text.trim();
                                        reqObj["instituteName"] =
                                            ugInstituteName.text.trim();
                                        reqObj["qualification"] = viewModel
                                            .selectedQualification
                                            .trim();
                                        reqObj["specialization"] =
                                            ugSpecialization.text.trim();
                                        reqObj["enrolledYear"] =
                                            ugYearofenrollment.text.trim();
                                        reqObj["passingYear"] =
                                            ugYearofpassout.text.trim();
                                        reqObj["address"] =
                                            ugAddress.text.trim();
                                        reqObj["city"] = ugCity.text.trim();
                                        reqObj["stateRegionProvince"] = ugState.text.trim();
                                        reqObj["country"] =
                                            ugCountry.text.trim();
                                        reqObj["zipCode"] =
                                            ugPincode.text.trim();
                                        reqObj["certificateFileUrl"] =
                                            await MultipartFile.fromFile(
                                          viewModel.ugFile!.path,
                                          filename: viewModel.ugFile!.path
                                              .split('/')
                                              .last,
                                          contentType:
                                              MediaType('application', 'pdf'),
                                        );
                                        if (!context.mounted) return;
                                        viewModel.submitUnderGraduationDetails(
                                            context,
                                            reqObj);
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
