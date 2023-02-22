import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mybu/common/converter.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../common/my_snackbar.dart';
import '../../../models/schedule.dart';
import '../../bus_schedule/repository/bus_schedule_repository.dart';
import '../../home/screen/home_screen.dart';
import '../repository/notification_repository.dart';

final providerOfNotificationController = Provider(
  (ref) {
    final providerOfNotificationRepo =
        ref.watch(providerOfNotificationRepository);
    return NotificationController(
        notificationRepository: providerOfNotificationRepo, ref: ref);
  },
);

final StateProvider<bool> providerOfNotificationForRouteOne = StateProvider(
    (ref) => GetStorage().read("notificationForRouteOne") ?? false);
final StateProvider<bool> providerOfNotificationForRouteTwo = StateProvider(
    (ref) => GetStorage().read("notificationForRouteTwo") ?? false);
final StateProvider<bool> providerOfNotificationForRouteThree = StateProvider(
    (ref) => GetStorage().read("notificationForRouteThree") ?? false);

Future<void> initializeService() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("initialized");
  final service = FlutterBackgroundService();

// / OPTIONAL, using custom notification channel id
  // const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //   'my_foreground', // id
  //   'MY FOREGROUND SERVICE', // title
  //   description:
  //       'This channel is used for important notifications.', // description
  //   importance: Importance.low, // importance must be at low or higher level
  // );

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

// if (Platform.isIOS) {
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       iOS: IOSInitializationSettings(),
//     ),
//   );
// }

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      // notificationChannelId: 'my_foreground',
      // initialNotificationTitle: 'AWESOME SERVICE',
      // initialNotificationContent: 'Initializing',
      // foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      // onBackground: onIosBackground,
    ),
  );

  service.startService();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// List<int> timesForRouteOne = [15, 30];

List<int> times = [];

// Future<void> _showProgressNotification(int maxProgress) async {
//   print("Progress Notification called");
//   // id++;
//   // final int progressId = id;
//   // const int maxProgress = 100;
//   for (int it = 0; it <= maxProgress; it++) {
//     await Future<void>.delayed(const Duration(seconds: 1), () async {
//       final AndroidNotificationDetails androidNotificationDetails =
//           AndroidNotificationDetails('progress channel', 'progress channel',
//               channelDescription: 'progress channel description',
//               channelShowBadge: false,
//               importance: Importance.max,
//               priority: Priority.high,
//               onlyAlertOnce: true,
//               showProgress: true,
//               maxProgress: maxProgress,
//               progress: it);
//       final NotificationDetails notificationDetails =
//           NotificationDetails(android: androidNotificationDetails);
//       await flutterLocalNotificationsPlugin.show(
//           1,
//           'progress notification title',
//           'progress notification body',
//           notificationDetails,
//           payload: 'item x');
//     });
//   }
// }

// Future<void> _showProgressNotification({
//   required int routeNo,
// }) async {
//   var datas = GetStorage().read("schedules");
//   List<Schedule> schedules = [];
//   for (Map<String, dynamic> data in datas) {
//     schedules.add(Schedule.fromJson(data));
//   }

//   print(datas);
//   print(schedules);

//   // Route One
//   List<Schedule> routeOne =
//       schedules.where((schedule) => schedule.routeNo == 1).toList();

//   // List<int> timesForRouteOne = [15];

//   for (Schedule schedule in routeOne) {
//     List<DateTime> allDateTime = [];
//     allDateTime.add(Converter.int2DateTime(schedule.hour!, schedule.minute!));

//     for (i = 0; i < (allDateTime.length - 1); i++) {
//       timesForRouteOne
//           .add(Converter.dateTime2minute(allDateTime[i], allDateTime[i + 1]));
//     }
//   }

//   // Route Two

//   List<Schedule> routeTwo =
//       schedules.where((schedule) => schedule.routeNo == 2).toList();

//   List<int> timesForRouteTwo = [15];

//   for (Schedule schedule in routeTwo) {
//     List<DateTime> allDateTime = [];
//     allDateTime.add(Converter.int2DateTime(schedule.hour!, schedule.minute!));

//     for (i = 0; i < (allDateTime.length - 1); i++) {
//       timesForRouteTwo
//           .add(Converter.dateTime2minute(allDateTime[i], allDateTime[i + 1]));
//     }
//   }

//   //Route Three

//   List<Schedule> routeThree =
//       schedules.where((schedule) => schedule.routeNo == 3).toList();

//   List<int> timesForRouteThree = [15];

//   for (Schedule schedule in routeThree) {
//     List<DateTime> allDateTime = [];
//     allDateTime.add(Converter.int2DateTime(schedule.hour!, schedule.minute!));

//     for (i = 0; i < (allDateTime.length - 1); i++) {
//       timesForRouteThree
//           .add(Converter.dateTime2minute(allDateTime[i], allDateTime[i + 1]));
//     }
//   }

//   if (routeNo == 1) {
//     if (DateTime.now().weekday == DateTime.sunday ||
//         DateTime.now().weekday == DateTime.monday ||
//         DateTime.now().weekday == DateTime.tuesday ||
//         DateTime.now().weekday == DateTime.wednesday ||
//         DateTime.now().weekday == DateTime.thursday) {
//       // if (DateTime.now() ==
//       //     (Converter.int2DateTime(routeOne[0].hour!, routeOne[0].minute!)
//       //         .subtract(Duration(minutes: 15)))) {
//       for (int i = 0; i < timesForRouteOne.length; i++) {
//         await Future<void>.delayed(const Duration(minutes: 1), () async {
//           final AndroidNotificationDetails androidNotificationDetails =
//               AndroidNotificationDetails(
//             "1",
//             "Route One",
//             channelDescription: "Notification of route no one bus schedules.",
//             channelShowBadge: false,
//             importance: Importance.max,
//             priority: Priority.max,
//             onlyAlertOnce: true,
//             showProgress: true,
//             maxProgress: timesForRouteOne[i],
//             progress: i,
//           );

//           final NotificationDetails notificationDetails =
//               NotificationDetails(android: androidNotificationDetails);

//           await flutterLocalNotificationsPlugin.show(
//             1,
//             "from ${routeOne[i].from} to ${routeOne[i].to}",
//             "${routeOne[i].buses.toString()} departure at ${routeOne[i].hour}:${routeOne[i].minute}",
//             notificationDetails,
//             payload: "busSchedule",
//           );
//         });
//       }
//     }
//     // }
//   } else if (routeNo == 2) {
//   } else {}
// }

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

int id = 0;

List<DateTime> dates = [
  DateTime(2023, 02, 23, 23, 45),
  DateTime(2023, 02, 23, 23, 50),
  DateTime(2023, 02, 23, 00, 00)
];

int nextMaxProgress(List<DateTime> dateTimes) {
  print("dates: $dates");
  print("next Max Progress executed");
  DateTime nextDateTime =
      dateTimes.where((date) => date.isAfter(DateTime.now())).first;
  print(nextDateTime);
  int result = Converter.dateTime2minute(DateTime.now(), nextDateTime);
  print(result);
  return result;
}

List<DateTime> allDateTimeForRouteOne = [];
List<DateTime> allDateTimeForRouteTwo = [];
List<DateTime> allDateTimeForRouteThree = [];


Future<void> showProgressNotification(
  List<Schedule> schedulesForNThread,
  int routeNo,
) async {
  print("allDateTimeForRouteOne: $allDateTimeForRouteOne");

  // int indexOfAllTimeForRouteOne = 0;
  // while (indexOfAllTimeForRouteOne < (allDateTimeForRouteOne.length - 1)) {
  //   timesForRouteOne.add(Converter.dateTime2minute(
  //       allDateTimeForRouteOne[indexOfAllTimeForRouteOne],
  //       allDateTimeForRouteOne[indexOfAllTimeForRouteOne + 1]));
  //   indexOfAllTimeForRouteOne++;
  // }

  // print("timesForRouteOne: $timesForRouteOne");

  print("Show progress notification");
  // id++;
  // final int progressId = id;
  // const int maxProgress = 100;
  if (DateTime.now().weekday == DateTime.sunday ||
      DateTime.now().weekday == DateTime.monday ||
      DateTime.now().weekday == DateTime.tuesday ||
      DateTime.now().weekday == DateTime.wednesday ||
      DateTime.now().weekday == DateTime.thursday) {

        //TODO: It will be less than
    if (nextMaxProgress(allDateTimeForRouteOne) > 300) {
      for (int y = 0; y <= nextMaxProgress(allDateTimeForRouteOne); y++) {
        await Future<void>.delayed(const Duration(seconds: 1), () async {
          final AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails(
            'progress channel',
            'progress channel',
            channelDescription: 'progress channel description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: nextMaxProgress(allDateTimeForRouteOne),
            progress: y,
          );
          final NotificationDetails notificationDetails =
              NotificationDetails(android: androidNotificationDetails);
          await flutterLocalNotificationsPlugin.show(
              1,
              'progress notification title',
              'progress notification body',
              notificationDetails,
              payload: 'item x');
        });
      }
    } else if (DateTime.now() ==
        (allDateTimeForRouteOne[0].subtract(Duration(minutes: 30)))) {
      for (int y = 0; y <= nextMaxProgress(allDateTimeForRouteOne); y++) {
        await Future<void>.delayed(const Duration(seconds: 1), () async {
          final AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails(
            'progress channel',
            'progress channel',
            channelDescription: 'progress channel description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: nextMaxProgress(allDateTimeForRouteOne),
            progress: y,
          );
          final NotificationDetails notificationDetails =
              NotificationDetails(android: androidNotificationDetails);
          await flutterLocalNotificationsPlugin.show(
              1,
              'progress notification title',
              'progress notification body',
              notificationDetails,
              payload: 'item x');
        });
      }
    }
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  service.on('stop').listen((event) {
    service.stopSelf();
    print("stop");
  });

  List<Schedule> schedulesForNThread = [];

  service.on("download").listen((event) async {
    List<Map<String, dynamic>> datas = [];
    await Firebase.initializeApp();
    await GetStorage.init();
    var firebaseData = await FirebaseFirestore.instance
        .collection("schedules")
        .orderBy("id")
        .get()
        .then((value) =>
            value.docs.map((e) => Schedule.fromJson(e.data())).toList());
    for (Schedule schedule in firebaseData) {
      datas.add(schedule.toJson());
    }
    await GetStorage().write("schedulesForNotificationThread", datas);
    if (datas != null) {
      for (Map<String, dynamic> data in datas) {
        schedulesForNThread.add(Schedule.fromJson(data));
      }
    }
    
    // Route One
  List<Schedule> routeOne =
      schedulesForNThread.where((schedule) => schedule.routeNo == 1).toList();

  for (Schedule schedule in routeOne) {
    allDateTimeForRouteOne
        .add(Converter.int2DateTime(schedule.hour!, schedule.minute!));

    // print(Converter.dateTime2minute(allDateTime[0], allDateTime[1]));
    // for (int x = 0; x < (allDateTime.length - 1); x++) {
    //   times.add(Converter.dateTime2minute(allDateTime[x], allDateTime[x + 1]));
    // }
  }

  });

  

  print("allDateTimeForRouteOne onStart: $allDateTimeForRouteOne");

  service.on("routeOne").listen((event) async {
    print("schedulesForNThread: $schedulesForNThread");
    await showProgressNotification(schedulesForNThread,1);
    // var datas = GetStorage().read("schedulesForNotificationThread");

    // int test = Converter.dateTime2minute(
    //     allDateTimeForRouteOne[0], allDateTimeForRouteOne[1]);

    // print("timesForRouteOne: $timesForRouteOne");

    // print(allDateTimeForRouteOne);

    // print(test);

    // int i = 0;
    // print("start notification");
    // print("start noti: $i");
    // while (i < timesForRouteOne.length) {
    //   await showProgressNotification(schedulesForNThread).then((_) {
    //     i++;
    //   });
    // .then((_) async {
    //   if (i == timesForRouteOne.length) {
    //     await cancelLastNotifications(1);

    //   }
    // });
    // }
  });

  service.on("cancel").listen((event) async {
    await cancelAllNotifications();
  });

  // service.on("routeOne").listen((event) async {
  //   print("start");
  //   while (i <= (timesForRouteOne.length - 1)) {
  //     await _showProgressNotification().then((_) {
  //       i++;
  //     }).then((_) {
  //       if (i == timesForRouteOne.length) {
  //         _cancelLastNotifications(1);
  //       }
  //     });
  //   }
  // }
  // );
}

class NotificationController {
  final NotificationRepository notificationRepository;
  final ProviderRef ref;
  NotificationController({
    required this.notificationRepository,
    required this.ref,
  });

  // List<int> timesForRouteOne = [15];

  // Future<void> _showProgressNotification({
  //   // required int maxProgress,
  //   // required int channelId,
  //   // required String channelName,
  //   // required String channelDescription,
  //   // required String from,
  //   // required String to,
  //   // required List<String> busses,
  //   required int routeNo,
  // }) async {
  //   var datas = ref.watch(providerOfBusSchedules);
  //   List<Schedule> schedules = [];
  //   for (Map<String, dynamic> data in datas) {
  //     schedules.add(Schedule.fromJson(data));
  //   }

  //   // Route One
  //   List<Schedule> routeOne =
  //       schedules.where((schedule) => schedule.routeNo == 1).toList();

  //   // List<int> timesForRouteOne = [15];

  //   for (Schedule schedule in routeOne) {
  //     List<DateTime> allDateTime = [];
  //     allDateTime.add(Converter.int2DateTime(schedule.hour!, schedule.minute!));

  //     for (i = 0; i < (allDateTime.length - 1); i++) {
  //       timesForRouteOne
  //           .add(Converter.dateTime2minute(allDateTime[i], allDateTime[i + 1]));
  //     }
  //   }

  //   // Route Two

  //   List<Schedule> routeTwo =
  //       schedules.where((schedule) => schedule.routeNo == 2).toList();

  //   List<int> timesForRouteTwo = [15];

  //   for (Schedule schedule in routeTwo) {
  //     List<DateTime> allDateTime = [];
  //     allDateTime.add(Converter.int2DateTime(schedule.hour!, schedule.minute!));

  //     for (i = 0; i < (allDateTime.length - 1); i++) {
  //       timesForRouteTwo
  //           .add(Converter.dateTime2minute(allDateTime[i], allDateTime[i + 1]));
  //     }
  //   }

  //   //Route Three

  //   List<Schedule> routeThree =
  //       schedules.where((schedule) => schedule.routeNo == 3).toList();

  //   List<int> timesForRouteThree = [15];

  //   for (Schedule schedule in routeThree) {
  //     List<DateTime> allDateTime = [];
  //     allDateTime.add(Converter.int2DateTime(schedule.hour!, schedule.minute!));

  //     for (i = 0; i < (allDateTime.length - 1); i++) {
  //       timesForRouteThree
  //           .add(Converter.dateTime2minute(allDateTime[i], allDateTime[i + 1]));
  //     }
  //   }

  //   if (routeNo == 1) {
  //     if (DateTime.now().weekday == DateTime.sunday ||
  //         DateTime.now().weekday == DateTime.monday ||
  //         DateTime.now().weekday == DateTime.tuesday ||
  //         DateTime.now().weekday == DateTime.wednesday ||
  //         DateTime.now().weekday == DateTime.thursday) {
  //       if (DateTime.now() ==
  //           (Converter.int2DateTime(routeOne[0].hour!, routeOne[0].minute!)
  //               .subtract(Duration(minutes: 15)))) {
  //         for (int i = 0; i < timesForRouteOne.length; i++) {
  //           await Future<void>.delayed(const Duration(minutes: 1), () async {
  //             final AndroidNotificationDetails androidNotificationDetails =
  //                 AndroidNotificationDetails(
  //               "1",
  //               "Route One",
  //               channelDescription:
  //                   "Notification of route no one bus schedules.",
  //               channelShowBadge: false,
  //               importance: Importance.max,
  //               priority: Priority.max,
  //               onlyAlertOnce: true,
  //               showProgress: true,
  //               maxProgress: timesForRouteOne[i],
  //               progress: i,
  //             );

  //             final NotificationDetails notificationDetails =
  //                 NotificationDetails(android: androidNotificationDetails);

  //             await ref
  //                 .watch(providerOfNotificationController)
  //                 .notificationRepository
  //                 .flutterLocalNotificationsPlugin
  //                 .show(
  //                   1,
  //                   "from ${routeOne[i].from} to ${routeOne[i].to}",
  //                   "${routeOne[i].buses.toString()} departure at ${routeOne[i].hour}:${routeOne[i].minute}",
  //                   notificationDetails,
  //                   payload: "busSchedule",
  //                 );
  //           });
  //         }
  //       }
  //     }
  //   } else if (routeNo == 2) {
  //   } else {}
  // }

  // Future<void> _cancelLastNotifications(int id) async {
  //   await ref
  //       .watch(providerOfNotificationController)
  //       .notificationRepository
  //       .flutterLocalNotificationsPlugin
  //       .cancel(id);
  // }

  // int i = 0;

  // @pragma('vm:entry-point')
  // void onStart(ServiceInstance service) async {
  //   DartPluginRegistrant.ensureInitialized();

  //   service.on('stop').listen((event) {
  //     service.stopSelf();
  //     print("stop");
  //   });

  //   service.on("routeOne").listen((event) async {
  //     print("start");
  //     while (i <= (timesForRouteOne.length - 1)) {
  //       await _showProgressNotification(routeNo: 1).then((_) {
  //         i++;
  //       }).then((_) {
  //         if (i == timesForRouteOne.length) {
  //           _cancelLastNotifications(1);
  //         }
  //       });
  //     }
  //   });
  // }
  // static final _notifications = FlutterLocalNotificationsPlugin();
  // static final onNotifications = BehaviorSubject<String?>();

  // static Future _notificationDetails(String subText) async {
  //   return NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       "My BU",
  //       "My BU",
  //       channelDescription: "Bus Schedule Notification",
  //       importance: Importance.max,
  //       priority: Priority.max,
  //       playSound: true,
  //       subText: subText,
  //     ),
  //   );
  // }

  // static Future init({bool initScheduled = false}) async {
  //   final android = AndroidInitializationSettings("@drawable/ic_stat_bu_logo");
  //   final settings = InitializationSettings(android: android);
  //   final details = await _notifications.getNotificationAppLaunchDetails();
  //   if (details != null && details.didNotificationLaunchApp) {
  //     onNotifications.add(details.payload);
  //   }
  //   await _notifications.initialize(
  //     settings,
  //     onSelectNotification: (payload) async {
  //       onNotifications.add(payload);
  //     },
  //   );

  //   if (initScheduled) {
  //     tz.initializeTimeZones();
  //     final locationName = await FlutterNativeTimezone.getLocalTimezone();
  //     tz.setLocalLocation(tz.getLocation(locationName));
  //   }
  // }

  // static Future<void> showScheduleNotification({
  //   required int id,
  //   String? title,
  //   String? body,
  //   String? subText,
  //   String? payload,
  //   required Time scheduleTime,
  // }) async {

  //   _notifications.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     _scheduleWeekly(scheduleTime, days: [
  //       DateTime.sunday,
  //       DateTime.monday,
  //       DateTime.tuesday,
  //       DateTime.wednesday,
  //       DateTime.thursday
  //     ]),
  //     await _notificationDetails(subText!),
  //     payload: payload,
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  //   );
  // }

  // static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
  //   tz.TZDateTime scheduleDate = _scheduleDaily(time);

  //   while (!days.contains(scheduleDate.weekday)) {
  //     scheduleDate = scheduleDate.add(Duration(days: 1));
  //   }
  //   return scheduleDate;
  // }

  // static tz.TZDateTime _scheduleDaily(Time time) {
  //   final now = tz.TZDateTime.now(tz.local);
  //   // final now = DateTime.now();
  //   final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
  //       time.hour, time.minute, time.second);
  //   return scheduleDate.isBefore(now)
  //       ? scheduleDate.add(Duration(days: 1))
  //       : scheduleDate;
  // }

  // static void cancel(int id) {
  //   _notifications.cancel(id);
  //   print("Notification off");
  // }

  // Future<bool> on(BuildContext context, int id) async {
  //   try {
  //     await notificationRepository.firestore
  //         .collection("schedules")
  //         .doc(id.toString())
  //         .update({"notification": true});
  //     return true;
  //   } catch (error) {
  //     mySnackbar(context, error.toString());
  //   }
  //   return true;
  // }

  // // static void read(Schedule schedule) {
  // //   GetStorage().read(schedule.id.toString());
  // //   print("Read for ${schedule.id.toString()}");
  // // }

  // Future<bool> off(BuildContext context, int id) async {
  //   try {
  //     await notificationRepository.firestore
  //         .collection("schedules")
  //         .doc(id.toString())
  //         .update({"notification": false});
  //     print("Notification off");
  //   } catch (error) {
  //     mySnackbar(context, error.toString());
  //   }
  //   return false;
  // }
}
