import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../repository/faculty_repository.dart';
import 'department_details.dart';

class FacultyOfBusinessStudies extends StatelessWidget {
  const FacultyOfBusinessStudies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var departments = FacultyRepository.faculties[2].departments;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
      child: ListView.separated(
          itemBuilder: ((context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            DepartmentDetails(department: departments[index])));
              },
              child: Container(
                height: 80,
                child: "${departments[index].name}"
                    .text
                    .xl2
                    .align(TextAlign.center)
                    .makeCentered(),
                decoration: BoxDecoration(
                  color: Vx.randomColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }),
          separatorBuilder: (_, __) => 16.heightBox,
          itemCount: departments.length),
    );
  }
}
