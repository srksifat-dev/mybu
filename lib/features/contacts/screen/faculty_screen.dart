import 'package:flutter/material.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/title_scroll_navigation.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../theme/theme/app_color.dart';
import 'faculty_of_arts_and_humanities.dart';
import 'faculty_of_bio_science.dart';
import 'faculty_of_business_studies.dart';
import 'faculty_of_law.dart';
import 'faculty_of_science_and_engineering.dart';
import 'faculty_of_social_sciences.dart';


class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Familiar with Faculties".text.make(),
        centerTitle: true,
      ),
      body: TitleScrollNavigation(
        identiferStyle: NavigationIdentiferStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.kDeepBlue
                : AppColors.kLightGray,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            position: IdentifierPosition.topAndRight),
        barStyle: TitleNavigationBarStyle(
          background: Colors.transparent,
          elevation: -50,
          style: const TextStyle(fontSize: 20),
          activeColor: Theme.of(context).brightness == Brightness.light
              ? AppColors.kDeepBlue
              : AppColors.kLightGray,
          deactiveColor: Theme.of(context).brightness == Brightness.light
              ? AppColors.kLightGray
              : AppColors.kDeepGray,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          spaceBetween: 40,
        ),
        titles: const [
          "Faculty of Science & Engineering",
          "Faculty of Bio-Sciences",
          "Faculty of Business Studies",
          "Faculty of Social Sciences",
          "Faculty of Arts & Humanities",
          "Faculty of Law",
        ],
        pages: const[
          FacultyOfScienceAndEngineering(),
          FacultyOfBioScience(),
          FacultyOfBusinessStudies(),
          FacultyOfSocialScience(),
          FacultyOfArtsAndHumanities(),
          FacultyOfLaw(),
        ],
      ),
    );
  }
}
