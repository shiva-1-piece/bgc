import 'package:bgc_mobile/Candidate/Dashboard/view/candidate_address_details_view.dart';
import 'package:bgc_mobile/Candidate/Dashboard/view/candidate_dashboard.dart';
import 'package:bgc_mobile/Candidate/Dashboard/view/candidate_edu_diploma_form_view.dart';
import 'package:bgc_mobile/Candidate/Dashboard/view/candidate_edu_high_school_form_view.dart';
import 'package:bgc_mobile/Candidate/Dashboard/view/candidate_edu_higher_secondary_form_view.dart';
import 'package:bgc_mobile/Candidate/Dashboard/view/candidate_edu_post_graduation_form_view.dart';
import 'package:bgc_mobile/Candidate/Dashboard/view/candidate_edu_under_graduation_form_view.dart';
import 'package:bgc_mobile/Candidate/Dashboard/view/candidate_employment_add_details_view.dart';
import 'package:bgc_mobile/Candidate/Dashboard/viewmodel/candidate_education_form_viewmodel.dart';
import 'package:bgc_mobile/Login/View/change_password_view.dart';
import 'package:bgc_mobile/Utils/appbar_util.dart';
import 'package:bgc_mobile/Utils/color_constraints.dart';
import 'package:bgc_mobile/Utils/elevated_button_util.dart';
import 'package:bgc_mobile/Utils/show_dailog_util.dart';
import 'package:bgc_mobile/Utils/static_text.dart';
import 'package:bgc_mobile/Utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CandidateEducationDetailsView extends StatefulWidget {
  const CandidateEducationDetailsView({super.key});

  @override
  State<CandidateEducationDetailsView> createState() =>
      _CandidateEducationDetailsViewState();
}

class _CandidateEducationDetailsViewState
    extends State<CandidateEducationDetailsView> {
  List<String> education = [
    StaticText().highSchoolEducationDetails,
    StaticText().higherSecondaryEducationDetails,
    StaticText().diplomaEducationDetails,
    StaticText().underGraduationEducationDetails,
    StaticText().postGraduationEducationDetails
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CandidateEducationFormViewModel>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CandidateDashboard(),
          ),
        );
      },
      child: Scaffold(
        appBar: CustomAppbar(
          title: StaticText().educationDetails,
          height: 70,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CandidateDashboard(),
              ),
            );
          },
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
                    leading:
                        Icon(Icons.logout, size: 20, color: Colors.red[400]),
                    title: const Text('Logout', style: TextStyle(fontSize: 16)),
                    contentPadding: const EdgeInsets.only(left: 15, right: 0),
                    minLeadingWidth: 00,
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              // child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: education.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        if (index == 0) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CandidateEducationFormView(
                                category: getCategoryByIndex(index),
                              ),
                            ),
                          );
                          if (result == true) {
                            final prefs = await SharedPreferences.getInstance();
                          }
                        }
                        if (index == 1) {
                          if (!context.mounted) return;
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CandidateHigherSecondaryFormView(
                                category: getCategoryByIndex(index),
                              ),
                            ),
                          );
                          if (result == true) {
                            final prefs = await SharedPreferences.getInstance();
                          }
                        }
                        if (index == 2) {
                          if (!context.mounted) return;
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CandidateDiplomaFormView(
                                category: getCategoryByIndex(index),
                              ),
                            ),
                          );
                          if (result == true) {
                            final prefs = await SharedPreferences.getInstance();
                          }
                        }
                        if (index == 3) {
                          if (!context.mounted) return;
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CandidateUnderGraduationFormView(
                                category: getCategoryByIndex(index),
                              ),
                            ),
                          );
                          if (result == true) {
                            final prefs = await SharedPreferences.getInstance();
                          }
                        }
                        if (index == 4) {
                          if (!context.mounted) return;
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CandidatePostGraduationFormView(
                                category: getCategoryByIndex(index),
                              ),
                            ),
                          );
                          if (result == true) {
                            final prefs = await SharedPreferences.getInstance();
                        
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 15),
                        decoration: BoxDecoration(
                            color: viewModel.isEducationFilleds[index]
                                ? Colors.green
                                : ColorsConst().purple,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(color: Colors.grey, blurRadius: 2)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: education[index],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                ],
                              ),
                            ),
                            ClipOval(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: ColorsConst().white,
                                child: const Icon(Icons.edit),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              //),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomElevatedButton(
                    text: StaticText().previous,
                    padding: const EdgeInsets.only(left: 36, right: 36),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CandidateAddressDetailsView(),
                        ),
                      );
                    },
                  ),
                  CustomElevatedButton(
                    text: StaticText().submit,
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    onPressed: () {
                      if (viewModel.areAllDetailsFilled()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CandidateEmploymentAddDetailsView(),
                          ),
                        );
                      } else {
                        CustomShowDailogs.showDialogEducationDetailsIncomplete(
                            context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getCategoryByIndex(int index) {
    switch (index) {
      case 0:
        return "High School";
      case 1:
        return "Higher Education";
      case 2:
        return "Higher Education";
      case 3:
        return "Under Graduate";
      case 4:
        return "Post Graduate";
      default:
        return "High School";
    }
  }
}
