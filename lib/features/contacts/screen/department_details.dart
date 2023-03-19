import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controller/contact_controller.dart';
import '../models/department.dart';
import '../models/teacher.dart';


class DepartmentDetails extends StatefulWidget {
  final Department department;
  const DepartmentDetails({
    Key? key,
    required this.department,
  }) : super(key: key);

  @override
  State<DepartmentDetails> createState() => _DepartmentDetailsState();
}

class _DepartmentDetailsState extends State<DepartmentDetails> {
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String _phone = '';

  @override
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.department.shortName.text.make(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Teacher teacher = widget.department.teachers[index];
              return Container(
                padding: const EdgeInsets.only(left: 16),
                height: 80,
                decoration: BoxDecoration(
                  color: Vx.randomColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          teacher.name
                              .text
                              .xl
                              .align(TextAlign.center)
                              .bold
                              .make(),
                          teacher.designation
                              .text
                              .align(TextAlign.center)
                              .make(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: context.percentWidth * 24,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: _hasCallSupport
                                  ? (() => setState(() {
                                        _launched = ContactController.call(
                                            "0${teacher.contactNumber.toString()}");
                                      }))
                                  : null,
                              icon: Icon(Icons.call)),
                          IconButton(
                              onPressed: () =>
                                  ContactController.mail(teacher.email),
                              icon: Icon(Icons.mail)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => 16.heightBox,
            itemCount: widget.department.teachers.length),
      ),
    );
  }
}
