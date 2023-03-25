import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mybu/common/converter.dart';
import 'package:mybu/models/schedule.dart';
import 'package:mybu/theme/theme/app_color.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class NextSchedule extends StatefulWidget {
  final List<Schedule> schedules;
  final int index;
  const NextSchedule(this.schedules, this.index, {super.key});

  @override
  State<NextSchedule> createState() => _NextScheduleState();
}

DateTime? nextScheduleTime;
DateTime previousScheduleTime = DateTime.now();
int? totalDateTime;
int? consumeDateTime;
double percent = 0.0;

Schedule nextSchedule(List<Schedule> schedulesForNextSchedule) {
  if (DateTime.now().isBefore(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          schedulesForNextSchedule[0].hour!,
          schedulesForNextSchedule[0].minute!)) ||
      DateTime.now().isAtSameMomentAs(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          schedulesForNextSchedule[0].hour!,
          schedulesForNextSchedule[0].minute!))) {
    final dateTimes = [];
    for (Schedule schedule in schedulesForNextSchedule) {
      dateTimes
          .add(AppConverter.int2DateTime(schedule.hour!, schedule.minute!));
    }
    nextScheduleTime =
        dateTimes.where((date) => date.isAfter(DateTime.now())).first;

    int indexOfNextDateTime = dateTimes.indexOf(nextScheduleTime);
    return schedulesForNextSchedule[indexOfNextDateTime];
  } else {
    final dateTimes = [];
    for (Schedule schedule in schedulesForNextSchedule) {
      dateTimes
          .add(AppConverter.int2DateTime(schedule.hour!, schedule.minute!));
    }
    nextScheduleTime =
        dateTimes.where((date) => date.isAfter(DateTime.now())).first;
    previousScheduleTime =
        dateTimes.where((date) => date.isBefore(DateTime.now())).last;

    int indexOfNextDateTime = dateTimes.indexOf(nextScheduleTime);
    return schedulesForNextSchedule[indexOfNextDateTime];
  }
}

double percentDateTime(List<Schedule> schedulesForPercent) {
  if (DateTime.now().isBefore(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          schedulesForPercent[0].hour!,
          schedulesForPercent[0].minute!)) ||
      DateTime.now().isAtSameMomentAs(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          schedulesForPercent[0].hour!,
          schedulesForPercent[0].minute!))) {
    final dateTimes = [];
    for (Schedule schedule in schedulesForPercent) {
      dateTimes
          .add(AppConverter.int2DateTime(schedule.hour!, schedule.minute!));
    }
    nextScheduleTime =
        dateTimes.where((date) => date.isAfter(DateTime.now())).first;
    totalDateTime =
        AppConverter.dateTime2minute(previousScheduleTime, nextScheduleTime!);
    consumeDateTime =
        AppConverter.dateTime2minute(previousScheduleTime, DateTime.now());
    percent = consumeDateTime! / totalDateTime!;
    return percent;
  } else {
    final dateTimes = [];
    for (Schedule schedule in schedulesForPercent) {
      dateTimes
          .add(AppConverter.int2DateTime(schedule.hour!, schedule.minute!));
    }
    nextScheduleTime =
        dateTimes.where((date) => date.isAfter(DateTime.now())).first;
    previousScheduleTime =
        dateTimes.where((date) => date.isBefore(DateTime.now())).last;
    int totalDateTime =
        AppConverter.dateTime2minute(previousScheduleTime, nextScheduleTime!);
    int consumeDateTime =
        AppConverter.dateTime2minute(previousScheduleTime, DateTime.now());
    percent = consumeDateTime / totalDateTime;
    return percent;
  }
}

String durationInHM(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return duration.inHours == 0
      ? "$twoDigitMinutes m left"
      : "${twoDigits(duration.inHours)} h $twoDigitMinutes m left";
}

// double percentDateTime(List<Schedule> schedulesForPercent) {
//   final dateTimes = [];
//   for (Schedule schedule in schedulesForPercent) {
//     dateTimes.add(AppConverter.int2DateTime(schedule.hour!, schedule.minute!));
//   }
//   DateTime nextDateTime =
//       dateTimes.where((date) => date.isAfter(DateTime.now())).first;
//   DateTime previousDateTime =
//       dateTimes.where((date) => date.isBefore(DateTime.now())).last;
//   int totalDateTime =
//       AppConverter.dateTime2minute(previousDateTime, nextDateTime);
//   int consumeDateTime =
//       AppConverter.dateTime2minute(DateTime.now(), nextScheduleTime!);
//   double percent = consumeDateTime / totalDateTime;
//   return percent;
// }

class _NextScheduleState extends State<NextSchedule> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        percentDateTime(widget.schedules);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Schedule nxtSchedule = nextSchedule(widget.schedules);
    Duration timeLeft = nextScheduleTime!.difference(DateTime.now());
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.all(8),
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: widget.index.isOdd
            ? AppColors.kLightRed.withOpacity(0.3)
            : AppColors.kSkyBlue.withOpacity(0.3),
      ),
      child: Column(
        children: [
          "Route No. ${nxtSchedule.routeNo}".toString().text.bold.make(),
          2.heightBox,
          "${nxtSchedule.from} - ${nxtSchedule.to}".text.bold.xl.make(),
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.center,
            children: nxtSchedule.buses!
                .map((e) => Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8)),
                        child:
                            e.toString().text.xl.make().pSymmetric(h: 5, v: 2))
                    .py(4))
                .toList(),
          ),
          5.heightBox,
          durationInHM(timeLeft).text.bold.xl.make(),
          LinearPercentIndicator(
            animation: true,
            backgroundColor: Colors.white,
            barRadius: const Radius.circular(5),
            lineHeight: context.percentHeight * 1,
            percent: percentDateTime(widget.schedules),
            animateFromLastPercent: true,
            progressColor:
                widget.index.isOdd ? AppColors.kLightRed : AppColors.kSkyBlue,
            leading: previousScheduleTime.minute == 00
                ? "${previousScheduleTime.hour > 12 ? previousScheduleTime.hour - 12 : previousScheduleTime.hour} : ${previousScheduleTime.minute}0 ${previousScheduleTime.hour >= 12 ? 'pm' : 'am'}"
                    .text
                    .bold
                    .make()
                : "${previousScheduleTime.hour > 12 ? previousScheduleTime.hour - 12 : previousScheduleTime.hour} : ${previousScheduleTime.minute} ${previousScheduleTime.hour >= 12 ? 'pm' : 'am'}"
                    .text
                    .bold
                    .make(),
            trailing: nextScheduleTime!.minute == 00
                ? "${nextScheduleTime!.hour > 12 ? nextScheduleTime!.hour - 12 : nextScheduleTime!.hour} : ${nextScheduleTime!.minute}0 ${nextScheduleTime!.hour >= 12 ? 'pm' : 'am'}"
                    .text
                    .bold
                    .make()
                : "${nextScheduleTime!.hour > 12 ? nextScheduleTime!.hour - 12 : nextScheduleTime!.hour} : ${nextScheduleTime!.minute} ${nextScheduleTime!.hour >= 12 ? 'pm' : 'am'}"
                    .text
                    .bold
                    .make(),
          ),
        ],
      ),
    );
  }
}
