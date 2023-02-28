import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mybu/features/bus_schedule/screen/route_1.dart';
import 'package:mybu/features/bus_schedule/screen/route_2.dart';
import 'package:mybu/features/bus_schedule/screen/route_3.dart';
import 'package:mybu/features/home/screen/home_screen.dart';
import 'package:mybu/features/notification/controller/notification_controller.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/title_scroll_navigation.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../theme/theme/app_color.dart';
import '../controller/bus_schedule_controller.dart';
import '../repository/bus_schedule_repository.dart';

class BusScheduleScreen extends ConsumerStatefulWidget {
  final String? payload;
  BusScheduleScreen({
    Key? key,
    required this.payload,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BusScheduleScreenState();
}

class _BusScheduleScreenState extends ConsumerState<BusScheduleScreen> {
  // late final NotificationController notificationController;

  @override
  Widget build(BuildContext context) {
    var datas = ref.watch(providerOfBusSchedules) as List;

    print(datas);

    final busScheduleController = ref.watch(providerOfBusScheduleController);
    return Scaffold(
        appBar: AppBar(
          title: "Bus Schedule".text.make(),
          actions: [
            IconButton(
                onPressed: () {
                  // nextMaxProgress(allDateTimeForRouteOne);
                  busScheduleController.getAllSchedules(
                      context: context, ref: ref);
                  FlutterBackgroundService().invoke("download");
                },
                icon: const Icon(Icons.download))
          ],
        ),
        body: datas == []
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  "There is no bus schedules! Please"
                      .text
                      .xl
                      .bold
                      .color(AppColors.kSkyBlue)
                      .make(),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.kSkyBlue),
                    ),
                    onPressed: () {
                      busScheduleController.getAllSchedules(
                          context: context, ref: ref);
                    },
                    child: Text(
                      "Download it",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  Spacer(),
                ],
              )
            : TitleScrollNavigation(
                identiferStyle: NavigationIdentiferStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.kDeepBlue
                        : AppColors.kLightGray,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
                barStyle: TitleNavigationBarStyle(
                  background: Colors.transparent,
                  elevation: -50,
                  style: const TextStyle(fontSize: 20),
                  activeColor: Theme.of(context).brightness == Brightness.light
                      ? AppColors.kDeepBlue
                      : AppColors.kLightGray,
                  deactiveColor:
                      Theme.of(context).brightness == Brightness.light
                          ? AppColors.kLightGray
                          : AppColors.kDeepGray,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  spaceBetween: 40,
                ),
                titles: const ["Route-1", "Route-2", "Route-3"],
                pages: const [RouteOne(), RouteTwo(), RouteThree()],
              ));
  }
}
