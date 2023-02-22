import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

final providerOfBusScheduleRepository = Provider(
    (ref) => BusScheduleRepository(firestore: FirebaseFirestore.instance));

final providerOfBusSchedules = StateProvider(
  (ref) {
    return GetStorage().read("schedules");
  },
);

class BusScheduleRepository {
  final FirebaseFirestore firestore;
  BusScheduleRepository({
    required this.firestore,
  });
}
