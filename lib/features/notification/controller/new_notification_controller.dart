import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../models/schedule.dart';

final StateProvider<bool> providerOfNotificationForRouteOne = StateProvider(
    (ref) => GetStorage().read("notificationForRouteOne") ?? false);
final StateProvider<bool> providerOfNotificationForRouteTwo = StateProvider(
    (ref) => GetStorage().read("notificationForRouteTwo") ?? false);
final StateProvider<bool> providerOfNotificationForRouteThree = StateProvider(
    (ref) => GetStorage().read("notificationForRouteThree") ?? false);

final StateProvider<int> providerOfTimeForRouteOne =
    StateProvider((ref) => GetStorage().read("timeForRouteOne") ?? 10);

final StateProvider<int> providerOfTimeForRouteTwo =
    StateProvider((ref) => GetStorage().read("timeForRouteTwo") ?? 10);

final StateProvider<int> providerOfTimeForRouteThree =
    StateProvider((ref) => GetStorage().read("timeForRouteThree") ?? 10);

class NewNotificationController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> scheduleNotification(
      List<Schedule> schedules, int subtractedTime) async {
    for (Schedule schedule in schedules) {
      tz.TZDateTime nextInstanceOfTime() {
        final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
        tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year,
            now.month, now.day, schedule.hour!, schedule.minute!);
          while (scheduledDate.weekday == DateTime.friday ||
              scheduledDate.weekday == DateTime.saturday || scheduledDate.isBefore(now)) {
                  scheduledDate = scheduledDate.add(const Duration(days: 1));
            
          }
        return scheduledDate.subtract(Duration(minutes: subtractedTime));
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
          schedule.id!,
          "from ${schedule.from} to ${schedule.to}",
          schedule.minute == 00
              ? "${schedule.buses} departure @ ${schedule.hour! > 12 ? schedule.hour! - 12 : schedule.hour} : ${schedule.minute}0 ${schedule.hour! >= 12 ? 'pm' : 'am'}"
              : "${schedule.buses} departure @ ${schedule.hour! > 12 ? schedule.hour! - 12 : schedule.hour} : ${schedule.minute} ${schedule.hour! >= 12 ? 'pm' : 'am'}",
          nextInstanceOfTime(),
          NotificationDetails(
            android: AndroidNotificationDetails(
              schedule.from!.toLowerCase() == "campus"
                  ? "${schedule.routeNo.toString()}1"
                  : schedule.routeNo!.toString(),
              schedule.from!.toLowerCase() == "campus"
                  ? "From Campus ${schedule.routeNo}"
                  : "To Campus ${schedule.routeNo}",
              channelDescription: "Bus notification",
              icon: "@mipmap/ic_stat_bu_logo",
              enableLights: true,
              importance: Importance.max,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    }
  }

  Future<void> cancelNotification(List<Schedule> schedules) async {
    for (Schedule schedule in schedules) {
      flutterLocalNotificationsPlugin.cancel(schedule.id!);
    }
  }
}
