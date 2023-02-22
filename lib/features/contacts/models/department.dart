

import 'package:mybu/features/contacts/models/teacher.dart';

class Department {
  final String name;
  final String shortName;
  final List<Teacher> teachers;
  Department({
    required this.name,
    required this.shortName,
    required this.teachers,
  });
}
