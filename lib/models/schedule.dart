import 'package:intl/intl.dart';

class Schedule {
  int? id;
  int? routeNo;
  String? from;
  String? to;
  int? hour;
  int? minute;
  List<dynamic>? buses;
  Schedule({
    this.id,
    this.routeNo,
    this.from,
    this.to,
    this.hour,
    this.minute,
    this.buses,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "routeNo": routeNo,
        "from": from,
        "to": to,
        "hour": hour,
        "minute": minute,
        "buses": buses,
      };

  factory Schedule.fromJson(Map<String, dynamic> data) {
    return Schedule(
    id:
    data["id"] ?? "",
    routeNo:
    data["routeNo"] ?? 0,
    from:
    data["from"] ?? "",
    to:
    data["to"] ?? "",
    hour:
    data["hour"] ?? 0,
    minute:
    data["minute"] ?? 0,
    buses:
    data["buses"],);
  }
}

class TimeFormat {
  static String d2t(DateTime dateTime) {
    final String formattedTime = DateFormat.Hm().format(dateTime);
    final int hour = dateTime.hour;
    return formattedTime;
  }

  static String tWith0(int time) {
    return time.toString().length > 1
        ? time.toString()
        : time.toString().padLeft(2, "0");
  }
}
