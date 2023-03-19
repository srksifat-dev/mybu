import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mybu/common/my_snackbar.dart';
import 'package:mybu/features/notification/controller/new_notification_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/schedule.dart';
import '../../../theme/theme/app_color.dart';
import '../repository/bus_schedule_repository.dart';

class RouteOne extends ConsumerWidget {
  const RouteOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final busScheduleController = ref.watch(providerOfBusScheduleController);

    var datas = ref.watch(providerOfBusSchedules);
    List<Schedule> schedules = [];
    if (datas != null) {
      for (Map<String, dynamic> data in datas) {
        schedules.add(Schedule.fromJson(data));
      }
    }
    List<Schedule> routeOne =
        schedules.where((schedule) => schedule.routeNo == 1).toList();
    // List<Schedule> fromCampusRouteOne = routeOne
    //     .where((schedule) => schedule.from!.toLowerCase() == "campus")
    //     .toList();
    // List<Schedule> toCampusRouteOne = routeOne
    //     .where((schedule) => schedule.to!.toLowerCase() == "campus")
    //     .toList();

    return Column(
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              10.heightBox,
              const Text(
                "Notification",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              10.heightBox,
              FlutterSwitch(
                width: 100,
                height: 40,
                valueFontSize: 20,
                toggleSize: 45.0,
                value: ref.watch(providerOfNotificationForRouteOne),
                borderRadius: 30.0,
                padding: 8.0,
                showOnOff: true,
                activeColor: AppColors.kSkyBlue,
                inactiveColor: AppColors.kLightRed,
                activeTextColor: Colors.black,
                inactiveTextColor: Colors.black,
                activeToggleColor: Colors.black,
                inactiveToggleColor: Colors.black,
                onToggle: (val) async {
                  if (await Permission.notification.isGranted) {
                    ref
                        .read(providerOfNotificationForRouteOne.notifier)
                        .update((state) => !state);
                    GetStorage().write("notificationForRouteOne", val);
                    if (val) {
                      NewNotificationController()
                          .scheduleNotification(routeOne);
                      mySnackbar(context, "Notification On for Route One");
                    } else {
                      NewNotificationController().cancelNotification(routeOne);
                    }
                  } else if (await Permission.notification.isDenied) {
                    openAppSettings();
                  }
                },
              ),
              20.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: context.percentWidth * 33,
                      child: "বরিশাল ক্লাব".text.bold.xl2.makeCentered()),
                  SizedBox(
                    width: context.percentWidth * 33,
                    height: 30,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: -4,
                          child: "→"
                              .text
                              .bold
                              .color(AppColors.kSkyBlue)
                              .xl2
                              .makeCentered(),
                        ),
                        Positioned(
                          bottom: -4,
                          child: "←"
                              .text
                              .bold
                              .color(AppColors.kLightRed)
                              .xl2
                              .makeCentered(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: context.percentWidth * 33,
                    child: "বিশ্ববিদ্যালয়".text.bold.xl2.makeCentered(),
                  ),
                ],
              ),
              5.heightBox,
              const Text(
                "বরিশাল ক্লাব ⇄ বাংলা বাজার মোড় ⇄ নুরিয়া স্কুল ⇄ আমতলার মোড় ⇄ রূপাতলী হাউজিং ⇄ কাঁঠাল তলা ⇄ টোল ঘর ⇄ বিশ্ববিদ্যালয়",
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              5.heightBox
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.kLightGray
                : AppColors.kDeepBlue,
            child: ListView.builder(
              itemCount: routeOne.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TimelineTile(
                    axis: TimelineAxis.vertical,
                    alignment: TimelineAlign.center,
                    indicatorStyle: IndicatorStyle(
                      height: 25,
                      width: 60,
                      indicator: ElasticIn(
                        delay: const Duration(milliseconds: 300),
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.kLightGray
                                  : AppColors.kDeepBlue,
                              borderRadius: BorderRadius.circular(5)),
                          child: routeOne[index].minute == 00
                              ? "${routeOne[index].hour! > 12 ? routeOne[index].hour! - 12 : routeOne[index].hour} : ${routeOne[index].minute}0 ${routeOne[index].hour! >= 12 ? 'pm' : 'am'}"
                                  .text
                                  .size(10)
                                  .bold
                                  .color(Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.kLightGray
                                      : AppColors.kDeepBlue)
                                  .makeCentered()
                              : "${routeOne[index].hour! > 12 ? routeOne[index].hour! - 12 : routeOne[index].hour} : ${routeOne[index].minute} ${routeOne[index].hour! >= 12 ? 'pm' : 'am'}"
                                  .text
                                  .size(10)
                                  .bold
                                  .color(Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.kLightGray
                                      : AppColors.kDeepBlue)
                                  .makeCentered(),
                        ),
                      ),
                    ),
                    startChild: routeOne[index].from!.toLowerCase() != "campus"
                        ? SlideInLeft(
                            from: 500,
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 30),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              // height: context.percentWidth * 10,
                              // width: context.percentWidth * 10,
                              decoration: BoxDecoration(
                                  color: AppColors.kSkyBlue,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Wrap(
                                spacing: 10,
                                alignment: WrapAlignment.center,
                                children: routeOne[index]
                                    .buses!
                                    .map(
                                      (e) => Text(
                                        e.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          )
                        : Container(),
                    endChild: routeOne[index].from!.toLowerCase() != "campus"
                        ? Container()
                        : SlideInRight(
                            from: 500,
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 30),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              // height: context.percentWidth * 10,
                              // width: context.percentWidth * 30,
                              decoration: BoxDecoration(
                                  color: AppColors.kLightRed,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Wrap(
                                spacing: 10,
                                alignment: WrapAlignment.center,
                                children: routeOne[index]
                                    .buses!
                                    .map(
                                      (e) => Text(
                                        e.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
