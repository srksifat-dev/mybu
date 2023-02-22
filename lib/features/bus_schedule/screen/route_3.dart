import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as n;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mybu/features/notification/controller/notification_controller.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/schedule.dart';
import '../../../theme/theme/app_color.dart';
import '../../home/screen/home_screen.dart';
import '../repository/bus_schedule_repository.dart';

class RouteThree extends ConsumerWidget {
  const RouteThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var datas = ref.watch(providerOfBusSchedules);
    // List<Schedule> schedules = [];
    // for (Map<String, dynamic> data in datas) {
    //   schedules.add(Schedule.fromJson(data));
    // }
    List<Schedule> routeThree =
        schedules.where((schedule) => schedule.routeNo == 3).toList();
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: n.Neumorphic(
            style: n.NeumorphicStyle(
                color: Colors.transparent,
                boxShape: n.NeumorphicBoxShape.roundRect(BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32)))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                10.heightBox,
                Text(
                  "Notification",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                10.heightBox,
                FlutterSwitch(
                  width: 100,
                  height: 40,
                  valueFontSize: 20,
                  toggleSize: 45.0,
                  value: ref.watch(providerOfNotificationForRouteThree),
                  borderRadius: 30.0,
                  padding: 8.0,
                  showOnOff: true,
                  activeColor: AppColors.kSkyBlue,
                  inactiveColor: AppColors.kLightRed,
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  onToggle: (val) {
                    ref
                        .read(providerOfNotificationForRouteThree.notifier)
                        .update((state) => !state);
                    GetStorage().write("notificationForRouteThree", val);
                  },
                ),
                20.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: context.percentWidth * 33,
                        child: "নথুল্লাবাদ".text.bold.white.xl2.makeCentered()),
                    SizedBox(
                        width: context.percentWidth * 33,
                        child: "⇄".text.bold.white.xl2.makeCentered()),
                    SizedBox(
                      width: context.percentWidth * 33,
                      child: "বিশ্ববিদ্যালয়".text.bold.white.xl2.makeCentered(),
                    ),
                  ],
                ),
                Text(
                  "নথুল্লাবাদ ব্রীজের ঢাল ⇄ কলেজ এভিনিউ ⇄ টিটিসি মুল গেট ⇄ চৌমাথার মোড় ⇄ থানা কাউন্সিলের মুল গেট ⇄ আমতলার মোড় ⇄ রূপাতলী হাউজিং ⇄ কাঁঠাল তলা ⇄ টোল ঘর ⇄ বিশ্ববিদ্যালয়",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                5.heightBox,
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: SizedBox(
            height: context.percentHeight * 58,
            width: context.percentWidth * 100,
            child: ListView.builder(
              itemCount: routeThree.length,
              itemBuilder: (context, index) {
                final DateTime dateTime = DateTime.parse(
                    "0000-00-00 ${TimeFormat.tWith0(routeThree[index].hour!)}:${TimeFormat.tWith0(routeThree[index].minute!)}:00");
                int hour = routeThree[index].hour!;
                bool am = false;
                if (hour < 12) {
                  am = true;
                } else {
                  am = false;
                }
                DateTime notificationDateTime =
                    dateTime.subtract(const Duration(minutes: 10));
                int notificationHour = notificationDateTime.hour;
                int notificationMinute = notificationDateTime.minute;
                String stringHour = TimeFormat.tWith0(hour);
                String stringMinute =
                    TimeFormat.tWith0(routeThree[index].minute!);
                switch (routeThree[index].hour) {
                  case 13:
                    stringHour = "01";
                    break;
                  case 14:
                    stringHour = "02";
                    break;
                  case 15:
                    stringHour = "03";
                    break;
                  case 16:
                    stringHour = "04";
                    break;
                  case 17:
                    stringHour = "05";
                    break;
                  case 18:
                    stringHour = "06";
                    break;
                  case 19:
                    stringHour = "07";
                    break;
                  case 20:
                    stringHour = "08";
                    break;
                  case 21:
                    stringHour = "09";
                    break;
                  case 22:
                    stringHour = "10";
                    break;
                  case 23:
                    stringHour = "11";
                    break;
                  case 00:
                    stringHour = "12";
                    break;
                  default:
                }
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
                              color: AppColors.kLightGray,
                              borderRadius: BorderRadius.circular(5)),
                          child: "$stringHour:$stringMinute ${am ? 'am' : 'pm'}"
                              .text
                              .size(10)
                              .bold
                              .black
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
                                      horizontal: 5, vertical: 3),
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
                                            style: TextStyle(
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
                                  horizontal: 5, vertical: 3),
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
                                        style: TextStyle(
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
