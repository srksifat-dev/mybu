import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/my_snackbar.dart';
import '../../../models/schedule.dart';
import '../repository/bus_schedule_repository.dart';

final providerOfBusScheduleController = Provider((ref) {
  final busScheduleRepo = ref.watch(providerOfBusScheduleRepository);
  return BusScheduleController(busScheduleRepo: busScheduleRepo, ref: ref);
});

class BusScheduleController {
  final BusScheduleRepository busScheduleRepo;
  final ProviderRef ref;
  BusScheduleController({
    required this.busScheduleRepo,
    required this.ref,
  });

  Future<void> getAllSchedules(
      {required BuildContext context, required WidgetRef ref}) async {
   final String? versionLocal = GetStorage().read("version") as String?;
    final String versionDatabase = await getVersion(context);
    if (versionLocal == null || versionLocal != versionDatabase) {
      try {
        List<Map<String, dynamic>> schedules = [];
        var data = await busScheduleRepo.firestore
            .collection("schedules").orderBy("id")
            .get()
            .then((value) =>
                value.docs.map((e) => Schedule.fromJson(e.data())).toList());
        for (Schedule schedule in data) {
          schedules.add(schedule.toJson());
        }
        await GetStorage().write("schedules", schedules);
        ref.read(providerOfBusSchedules.notifier).update((state) => schedules);
        mySnackbar(
            context, "Your Bus Schedules have been downloaded successfully!");
        GetStorage().write("version", versionDatabase);
      } catch (error) {
        // showing error message
        mySnackbar(context, "Something wrong. Please try again!");
      }
    } else {
      mySnackbar(context, "Your bus schedule is updated!");
    }
  }

  Future<String> getVersion(BuildContext context) async {
    String version = "";
    try {
      var v = await busScheduleRepo.firestore
          .collection("version")
          .doc("1")
          .get()
          .then((value) => value.data());
      version = v!["no"];
    } catch (e) {
      mySnackbar(context, "Can't get the version!");
    }
    return version;
  }
}
