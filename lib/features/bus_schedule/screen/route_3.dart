import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mybu/common/my_snackbar.dart';
import 'package:mybu/features/bus_schedule/controller/bus_schedule_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/schedule.dart';
import '../../../theme/theme/app_color.dart';
import '../../notification/controller/new_notification_controller.dart';
import '../repository/bus_schedule_repository.dart';

class RouteThree extends ConsumerWidget {
  RouteThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    bool enlarged = ref.watch(providerOfEnlarged);
    var datas = ref.watch(providerOfBusSchedules);
    var timeForRouteThree = ref.watch(providerOfTimeForRouteThree);
    List<Schedule> schedules = [];
    if (datas != null) {
      for (Map<String, dynamic> data in datas) {
        schedules.add(Schedule.fromJson(data));
      }
    }
    List<Schedule> routeThree =
        schedules.where((schedule) => schedule.routeNo == 3).toList();
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          color: AppColors.kDeepBlue,
          height:
              enlarged ? context.percentHeight * 25 : context.percentHeight * 7,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              8.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Notification",
                          style: TextStyle(
                              fontSize: context.percentHeight * 3,
                              fontWeight: FontWeight.bold),
                        ),
                        10.widthBox,
                        FlutterSwitch(
                          width: 100,
                          height: context.percentHeight * 5,
                          valueFontSize: 20,
                          toggleSize: 45.0,
                          value: ref.watch(providerOfNotificationForRouteThree),
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
                                  .read(providerOfNotificationForRouteThree
                                      .notifier)
                                  .update((state) => !state);
                              GetStorage()
                                  .write("notificationForRouteThree", val);
                              if (val) {
                                NewNotificationController()
                                    .scheduleNotification(
                                        routeThree, timeForRouteThree);
                                mySnackbar(
                                    context, "Notification On for Route Three");
                              } else {
                                NewNotificationController()
                                    .cancelNotification(routeThree);
                              }
                            } else if (await Permission.notification.isDenied) {
                              openAppSettings();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        ref.read(providerOfEnlarged.notifier).update(
                              (state) => !state,
                            );
                        GetStorage().write("enlarged", enlarged);
                      },
                      icon: enlarged
                          ? Icon(Icons.arrow_drop_up)
                          : Icon(Icons.arrow_drop_down))
                ],
              ),
              Visibility(
                maintainAnimation: true,
                maintainState: true,
                visible: enlarged,
                child: ref.watch(providerOfNotificationForRouteThree)
                    ? FadeIn(
                        delay: Duration(milliseconds: 400),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            "Send me notification".text.xl.make(),
                            SizedBox(
                              width: 60,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: timeForRouteThree,
                                  items: [
                                    DropdownMenuItem(
                                      child: "5".text.xl.make(),
                                      value: 5,
                                    ),
                                    DropdownMenuItem(
                                      child: "10".text.xl.make(),
                                      value: 10,
                                    ),
                                    DropdownMenuItem(
                                      child: "15".text.xl.make(),
                                      value: 15,
                                    ),
                                    DropdownMenuItem(
                                      child: "20".text.xl.make(),
                                      value: 20,
                                    ),
                                  ],
                                  onChanged: (val) {
                                    ref
                                        .read(providerOfTimeForRouteThree
                                            .notifier)
                                        .update(
                                          (state) => val!,
                                        );
                                    GetStorage()
                                        .write("timeForRouteThree", val);
                                    NewNotificationController()
                                        .scheduleNotification(routeThree, val!);
                                  },
                                  isExpanded: true,
                                ),
                              ),
                            ).px(8),
                            "minutes before".text.xl.make(),
                          ],
                        ),
                      )
                    : Container(),
              ),
              Visibility(
                maintainAnimation: true,
                maintainState: true,
                visible: enlarged,
                child: FadeIn(
                  delay: Duration(milliseconds: 400),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: context.percentWidth * 33,
                          child: "নথুল্লাবাদ".text.bold.xl2.makeCentered()),
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
                ),
              ),
              Visibility(
                maintainAnimation: true,
                maintainState: true,
                visible: enlarged,
                child: FadeIn(
                  delay: Duration(milliseconds: 400),
                  child: const Text(
                    "নথুল্লাবাদ ব্রীজের ঢাল ⇄ কলেজ এভিনিউ ⇄ টিটিসি মুল গেট ⇄ চৌমাথার মোড় ⇄ থানা কাউন্সিলের মুল গেট ⇄ আমতলার মোড় ⇄ রূপাতলী হাউজিং ⇄ কাঁঠাল তলা ⇄ টোল ঘর ⇄ বিশ্ববিদ্যালয়",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Visibility(
                  maintainAnimation: true,
                  maintainState: true,
                  visible: enlarged,
                  child: FadeIn(
                      delay: Duration(milliseconds: 400), child: 5.heightBox)),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : AppColors.kBackground,
            child: ListView.builder(
              itemCount: routeThree.length,
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
                          child: routeThree[index].minute == 00
                              ? "${routeThree[index].hour! > 12 ? routeThree[index].hour! - 12 : routeThree[index].hour} : ${routeThree[index].minute}0 ${routeThree[index].hour! >= 12 ? 'pm' : 'am'}"
                                  .text
                                  .size(10)
                                  .color(Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.kLightGray
                                      : AppColors.kDeepBlue)
                                  .bold
                                  .makeCentered()
                              : "${routeThree[index].hour! > 12 ? routeThree[index].hour! - 12 : routeThree[index].hour} : ${routeThree[index].minute} ${routeThree[index].hour! >= 12 ? 'pm' : 'am'}"
                                  .text
                                  .size(10)
                                  .color(Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.kLightGray
                                      : AppColors.kDeepBlue)
                                  .bold
                                  .makeCentered(),
                        ),
                      ),
                    ),
                    startChild:
                        routeThree[index].from!.toLowerCase() != "campus"
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
                                    children: routeThree[index]
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
                    endChild: routeThree[index].from!.toLowerCase() != "campus"
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
                                children: routeThree[index]
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
