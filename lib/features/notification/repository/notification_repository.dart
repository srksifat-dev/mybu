import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

final providerOfNotificationRepository = Provider(
    (ref) => NotificationRepository(flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin()));

// final providerOfBool = StateProvider.family<bool, int>((notification, id) {
//   bool? storage = GetStorage().read(id.toString());
//   // print(storage);
//   if (storage != null && storage == true) {
//     // GetStorage().write(id.toString(), true);
//     return true;
//   } else {
//     // GetStorage().write(id.toString(), false);

//     return false;
//   }
// });

class NotificationRepository {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationRepository({
    required this.flutterLocalNotificationsPlugin,
  });
  
}
