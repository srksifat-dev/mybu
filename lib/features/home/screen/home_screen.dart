import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/schedule.dart';
import '../../../theme/theme/app_color.dart';
import '../../bus_schedule/repository/bus_schedule_repository.dart';
import '../../bus_schedule/screen/bus_schedule_screen.dart';
import '../../contacts/controller/contact_controller.dart';
import '../../contacts/screen/faculty_screen.dart';
import '../../notification/controller/new_notification_controller.dart';
import '../widget/next_schedule.dart';
import 'image_slider.dart';

List<Schedule> schedules = [];

List<Schedule> routeOne = [];
List<Schedule> fromCampusRouteOne = [];
List<Schedule> toCampusRouteOne = [];

List<Schedule> routeTwo = [];
List<Schedule> fromCampusRouteTwo = [];
List<Schedule> toCampusRouteTwo = [];

List<Schedule> routeThree = [];
List<Schedule> fromCampusRouteThree = [];
List<Schedule> toCampusRouteThree = [];

class HomeScreen extends ConsumerStatefulWidget {
  final String route = "/";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    var datas = GetStorage().read("schedules");

    var notificationForRouteOne = GetStorage().read("notificationForRouteOne");
    var notificationForRouteTwo = GetStorage().read("notificationForRouteTwo");
    var notificationForRouteThree =
        GetStorage().read("notificationForRouteThree");

    if (datas != null) {
      for (Map<String, dynamic> data in datas) {
        schedules.add(Schedule.fromJson(data));
      }
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

    if (notificationForRouteOne != null) {
      if (notificationForRouteOne) {
        NewNotificationController().scheduleNotification(routeOne);
      }
    }

    if (notificationForRouteTwo != null) {
      if (notificationForRouteTwo) {
        NewNotificationController().scheduleNotification(routeTwo);
      }
    }

    if (notificationForRouteThree != null) {
      if (notificationForRouteThree) {
        NewNotificationController().scheduleNotification(routeThree);
      }
    }
    super.initState();
  }
  // @override
  // void didChangeDependencies() {

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    var datas = ref.watch(providerOfBusSchedules) as List;

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  const CustomImageSlider(),
                  datas.length < 2
                      ? Container()
                      : Row(
                          children: ["Next Schedules".text.bold.xl2.make()],
                        ).pOnly(left: 16, bottom: 8),
                  datas.length < 2
                      ? Container()
                      : DateTime.now().isAfter(DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day, 21, 30))
                          ? Container(
                              height: context.percentHeight * 13,
                              width: context.percentWidth * 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.kSkyBlue.withOpacity(0.3),
                              ),
                              child: "There is no bus schedule today!"
                                  .toString()
                                  .text
                                  .xl
                                  .bold
                                  .makeCentered(),
                            ).px(16)
                          : SizedBox(
                              height: context.percentHeight * 13,
                              width: context.percentWidth * 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  switch (index) {
                                    case 0:
                                      return DateTime.now().isAfter(DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day,
                                              21,
                                              30))
                                          ? Container()
                                          : NextSchedule(
                                              toCampusRouteOne, index);
                                    case 1:
                                      return DateTime.now().isAfter(DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day,
                                              16,
                                              15))
                                          ? Container()
                                          : NextSchedule(
                                              fromCampusRouteOne, index);
                                    case 2:
                                      return DateTime.now().isAfter(DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day,
                                              15,
                                              40))
                                          ? Container()
                                          : NextSchedule(
                                              toCampusRouteTwo, index);
                                    case 3:
                                      return DateTime.now().isAfter(DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day,
                                              16,
                                              15))
                                          ? Container()
                                          : NextSchedule(
                                              fromCampusRouteTwo, index);
                                    case 4:
                                      return DateTime.now().isAfter(DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day,
                                              21,
                                              30))
                                          ? Container()
                                          : NextSchedule(
                                              toCampusRouteThree, index);
                                    case 5:
                                      return DateTime.now().isAfter(DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day,
                                              16,
                                              15))
                                          ? Container()
                                          : NextSchedule(
                                              fromCampusRouteThree, index);
                                    default:
                                      return null;
                                  }
                                },
                                itemCount: 6,
                              ),
                            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: context.percentWidth * 35,
                        width: context.percentWidth * 35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const ContactScreen()),
                                );
                              },
                              child: Container(
                                height: context.percentWidth * 20,
                                width: context.percentWidth * 20,
                                decoration: BoxDecoration(
                                  color: AppColors.kSkyBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.school,
                                  size: context.percentWidth * 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            10.heightBox,
                            "Faculties"
                                .text
                                .xl2
                                .color(Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.kLightGray
                                    : AppColors.kDeepBlue)
                                .bold
                                .make()
                          ],
                        ),
                      ),
                      SizedBox(
                        height: context.percentWidth * 35,
                        width: context.percentWidth * 35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const BusScheduleScreen(
                                            payload: "busSchedule",
                                          )),
                                );
                              },
                              child: Container(
                                height: context.percentWidth * 20,
                                width: context.percentWidth * 20,
                                decoration: BoxDecoration(
                                  color: AppColors.kSkyBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.directions_bus,
                                  size: context.percentWidth * 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            10.heightBox,
                            "Bus Schedule"
                                .text
                                .xl2
                                .color(Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.kLightGray
                                    : AppColors.kDeepBlue)
                                .bold
                                .make()
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                width: context.percentWidth * 100,
                height: context.percentHeight * 9,
                color: AppColors.kSkyBlue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    10.heightBox,
                    "For any query or suggestion".text.black.bold.xl.make(),
                    TextButton(
                        onPressed: () {
                          ContactController.mail("srksifat.dev@gmail.com");
                        },
                        child: "contact with developer"
                            .text
                            .xl
                            .bold
                            .black
                            .underline
                            .make())
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
