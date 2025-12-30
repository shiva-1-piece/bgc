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

class CandidateDiplomaFormView extends StatefulWidget {
  final String category;
  const CandidateDiplomaFormView({super.key, required this.category});

  @override
  State<CandidateDiplomaFormView> createState() =>
      _CandidateDiplomaFormViewState();
}

class _CandidateDiplomaFormViewState extends State<CandidateDiplomaFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController diplomaCity = TextEditingController();
  TextEditingController diplomaEnrollmentNo = TextEditingController();
  TextEditingController diplomaInstituteName = TextEditingController();
  TextEditingController diplomaSpecialization = TextEditingController();
  TextEditingController diplomaDegree = TextEditingController();
  TextEditingController diplomaYearofenrollment = TextEditingController();
  TextEditingController diplomaYearofpassout = TextEditingController();
  TextEditingController diplomaCountry = TextEditingController();
  TextEditingController diplomaState = TextEditingController();
  TextEditingController diplomaPincode = TextEditingController();
  TextEditingController diplomaAddress = TextEditingController();
  TextEditingController diplomaCrtfile = TextEditingController();
  final enrollNoFieldKey = GlobalKey<FormFieldState>();
  final specializationFieldKey = GlobalKey<FormFieldState>();
  final diplomaenrollFieldKey = GlobalKey<FormFieldState>();
  final diplomapassoutFieldKey = GlobalKey<FormFieldState>();
  final diplomaProofFieldKey = GlobalKey<FormFieldState>();
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
        enrollNoFieldKey.currentState?.validate();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {


        if (!mounted) return;
        final viewModel = Provider.of<CandidateEducationFormViewModel>(context,
            listen: false);
        viewModel.clearState();
        await viewModel.fetchDiplomaDetails(context);
        final info = viewModel.diplomaEducationInfo;

        if (info != null) {
          setState(() {
            diplomaEnrollmentNo.text = info.data?.enrollmentNumber ?? '';
            diplomaInstituteName.text = info.data?.instituteName ?? '';
            diplomaDegree.text = info.data?.qualification ?? '';
            diplomaSpecialization.text = info.data?.specialization ?? '';
            diplomaYearofenrollment.text = info.data?.enrolledYear ?? '';
            diplomaYearofpassout.text = info.data?.passingYear ?? '';
            diplomaCountry.text = info.data?.country ?? '';
            diplomaState.text =
                info.data?.stateRegionProvince ?? ''; // <- this will now update in the UI
            diplomaCity.text = info.data?.city ?? '';
            diplomaPincode.text = info.data?.zipCode ?? '';
            diplomaAddress.text = info.data?.address ?? '';
            diplomaCrtfile.text = info.data?.certificateFileUrl ?? '';
          });
        }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppbar(
        title: StaticText().diplomaDetails,
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
            create: (_) => CandidateEducationFormViewModel(),
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
                              fieldKey: enrollNoFieldKey,
                              focusNode: enrollNoFocusNode,
                              controller: diplomaEnrollmentNo,
                              labelText: StaticText().enrollmentNo,
                              prefixIcon: Icons.touch_app_outlined,
                              validator: (value) {
                                if (!enrollNoTouched) return null;
                                return viewModel.validateEnrollNo(value);
                              },
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeAlphanumericNoSpaces(val);
                                diplomaEnrollmentNo.value = TextEditingValue(
                                  text: cleaned,
                                  selection: TextSelection.collapsed(
                                      offset: cleaned.length),
                                );
                                if (enrollNoTouched) {
                                  enrollNoFieldKey.currentState?.validate();
                                }
                              },
                              maxLength: 20,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: diplomaInstituteName,
                              labelText: StaticText().instituteNameOptional,
                              prefixIcon: Icons.business_rounded,
                              //validator: viewModel.validateInstituteName,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                diplomaInstituteName.value = TextEditingValue(
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
                              controller: diplomaDegree..text = "Diploma",
                              labelText: StaticText().qualification,
                              prefixIcon: Icons.school_outlined,
                              // dropdownItems: viewModel.qualificationsByCategory[
                              //     viewModel.selectedCategory]!,
                              // dropdownValue: viewModel.selectedQualification,
                              // onDropdownChanged: (newValue) {
                              //   viewModel.updateQualification(newValue!);
                              //   diplomaDegree.text = newValue;
                              // },
                              validator: viewModel.validateQualification,
                              readOnly: true,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              fieldKey: specializationFieldKey,
                              controller: diplomaSpecialization,
                              labelText: StaticText().specialization,
                              prefixIcon: Icons.school_outlined,
                              validator: viewModel.validateSpecialization,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                diplomaSpecialization.value = TextEditingValue(
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
                              fieldKey: diplomaenrollFieldKey,
                              onTap: () async {
                                await viewModel.selectEnrollDate(
                                    context,
                                    diplomaYearofenrollment,
                                    diplomaenrollFieldKey);
                              },
                              controller: diplomaYearofenrollment,
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
                              fieldKey: diplomapassoutFieldKey,
                              onTap: () async {
                                await viewModel.selectPassoutDate(
                                  context,
                                  diplomaYearofpassout,
                                  diplomaYearofenrollment.text,
                                  diplomapassoutFieldKey,
                                );
                              },
                              controller: diplomaYearofpassout,
                              labelText: StaticText().yearOfPassout,
                              prefixIcon: Icons.cake_outlined,
                              suffixIcon: Icon(
                                Icons.calendar_month_outlined,
                                color: ColorsConst().purple,
                              ),
                              validator: (value) => viewModel.validatePassout(
                                value,
                                diplomaYearofenrollment.text,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormField(
                              controller: diplomaAddress,
                              labelText: StaticText().addressOptional,
                              prefixIcon: Icons.home_outlined,
                              maxLength: 40,
                              //validator: viewModel.validateAddressLine,
                              onChanged: (val) {
                                final cleaned = viewModel.sanitizeText(val);
                                diplomaAddress.value = TextEditingValue(
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
                              controller: diplomaCity,
                              labelText: StaticText().cityOptional,
                              prefixIcon: Icons.location_city_rounded,
                              maxLength: 20,
                              //validator: viewModel.validateCity,
                              onChanged: (val) {
                                final cleaned =
                                    viewModel.sanitizeSpecialCharacters(val);
                                diplomaCity.value = TextEditingValue(
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
                              controller: diplomaState,
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
                              controller: diplomaCountry..text = "India",
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
                              controller: diplomaPincode,
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
                              fieldKey: diplomaProofFieldKey,
                              onTap: () {
                                viewModel.pickFilesEducation(
                                  controller: diplomaCrtfile,
                                  fieldKey: diplomaProofFieldKey,
                                  onFilePicked: (file) {
                                    viewModel.diplomaFile = file;
                                  },
                                );
                              },
                              controller: diplomaCrtfile,
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
                                                .diplomaFile ==
                                            null) {
                                          ToastUtils.showToast(
                                            context: context,
                                            message:
                                                'Please upload Diploma certificate.',
                                            type: ToastificationType.warning,
                                          );

                                          return;
                                        }

                                        // Retrieve candidateId from SharedPreferences
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();

                                        // Prepare the request object
                                        var reqObj = <String, dynamic>{};
                                        reqObj["enrollmentNumber"] =
                                            diplomaEnrollmentNo.text.trim();
                                        reqObj["instituteName"] =
                                            diplomaInstituteName.text.trim();
                                        reqObj["qualification"] =
                                            diplomaDegree.text.trim();
                                        reqObj["specialization"] =
                                            diplomaSpecialization.text.trim();
                                        reqObj["enrolledYear"] =
                                            diplomaYearofenrollment.text.trim();
                                        reqObj["passingYear"] =
                                            diplomaYearofpassout.text.trim();
                                        reqObj["address"] =
                                            diplomaAddress.text.trim();
                                        reqObj["city"] =
                                            diplomaCity.text.trim();
                                        reqObj["stateRegionProvince"] =
                                            diplomaState.text.trim();
                                        reqObj["country"] =
                                            diplomaCountry.text.trim();
                                        reqObj["zipCode"] =
                                            diplomaPincode.text.trim();
                                        reqObj["certificateFileUrl"] =
                                            await MultipartFile.fromFile(
                                          viewModel.diplomaFile!.path,
                                          filename: viewModel.diplomaFile!.path
                                              .split('/')
                                              .last,
                                          contentType:
                                              MediaType('application', 'pdf'),
                                        );
                                        if (!context.mounted) return;
                                        viewModel.submitDiplomaDetails(context,
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
