import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/my_snackbar.dart';
import '../../../models/schedule.dart';
import '../../home/screen/home_screen.dart';
import '../repository/bus_schedule_repository.dart';

final providerOfBusScheduleController = Provider((ref) {
  final busScheduleRepo = ref.watch(providerOfBusScheduleRepository);
  return BusScheduleController(busScheduleRepo: busScheduleRepo, ref: ref);
});

final StateProvider<bool> providerOfEnlarged =
    StateProvider((ref) => GetStorage().read("enlarged") ?? false);
final StateProvider<int> providerOfTabIndex =
    StateProvider((ref) => GetStorage().read("tabIndex")?? 0) ;

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
        List<Map<String, dynamic>> schedulesData = [];
        List<Schedule> schedules = [];
        var datas = await busScheduleRepo.firestore
            .collection("schedules")
            .orderBy("id")
            .get()
            .then((value) =>
                value.docs.map((e) => Schedule.fromJson(e.data())).toList());
        for (Schedule schedule in datas) {
          schedulesData.add(schedule.toJson());
        }
        await GetStorage().write("schedules", schedulesData);
        ref
            .read(providerOfBusSchedules.notifier)
            .update((state) => schedulesData);
        GetStorage().write("version", versionDatabase);

        for (Map<String, dynamic> data in schedulesData) {
          schedules.add(Schedule.fromJson(data));
        }
        for (Schedule schedule in schedules) {
          switch (schedule.routeNo) {
            case 1:
              routeOne.add(schedule);
              break;
            case 2:
              routeTwo.add(schedule);
              break;
            case 3:
              routeThree.add(schedule);
              break;
            default:
          }
        }
        for (Schedule schedule in routeOne) {
          if (schedule.from!.toLowerCase() == "campus") {
            fromCampusRouteOne.add(schedule);
          } else {
            toCampusRouteOne.add(schedule);
          }
        }
        for (Schedule schedule in routeTwo) {
          if (schedule.from!.toLowerCase() == "campus") {
            fromCampusRouteTwo.add(schedule);
          } else {
            toCampusRouteTwo.add(schedule);
          }
        }
        for (Schedule schedule in routeThree) {
          if (schedule.from!.toLowerCase() == "campus") {
            fromCampusRouteThree.add(schedule);
          } else {
            toCampusRouteThree.add(schedule);
          }
        }
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
