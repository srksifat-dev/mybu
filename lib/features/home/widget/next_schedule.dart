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
double percent = 0.0;

Schedule nextSchedule(List<Schedule> schedulesForNextSchedule) {
  if (DateTime.now().isBefore(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 07, 30))) {
        final dateTimes = [];
    for (Schedule schedule in schedulesForNextSchedule) {
      dateTimes
          .add(AppConverter.int2DateTime(schedule.hour!, schedule.minute!));
    }
    nextScheduleTime =
        dateTimes.where((date) => date.isAfter(DateTime.now())).first;
    previousScheduleTime =
        DateTime.now();
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
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 07, 30))) {
    final dateTimes = [];
  for (Schedule schedule in schedulesForPercent) {
    dateTimes.add(AppConverter.int2DateTime(schedule.hour!, schedule.minute!));
  }
  DateTime nextDateTime =
      dateTimes.where((date) => date.isAfter(DateTime.now())).first;
  int totalDateTime =
      AppConverter.dateTime2minute(previousScheduleTime, nextDateTime);
  int consumeDateTime =
      AppConverter.dateTime2minute(previousScheduleTime, DateTime.now());
  percent = consumeDateTime / totalDateTime;
  return percent;
  } else{
  final dateTimes = [];
  for (Schedule schedule in schedulesForPercent) {
    dateTimes.add(AppConverter.int2DateTime(schedule.hour!, schedule.minute!));
  }
  DateTime nextDateTime =
      dateTimes.where((date) => date.isAfter(DateTime.now())).first;
  DateTime previousDateTime =
      dateTimes.where((date) => date.isBefore(DateTime.now())).last;
  int totalDateTime =
      AppConverter.dateTime2minute(previousDateTime, nextDateTime);
  int consumeDateTime =
      AppConverter.dateTime2minute(previousDateTime, DateTime.now());
  percent = consumeDateTime / totalDateTime;
  return percent;}
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
    DateTime nextDateTime = nextScheduleTime!;
    DateTime? previousDateTime = previousScheduleTime;
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.all(8),
      width: 250,
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
          "${nxtSchedule.buses}".text.make(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // DateTime.now().isBefore(DateTime(DateTime.now().year,
              //         DateTime.now().month, DateTime.now().day, 07, 30))
              //     ? "00 : 00".text.bold.make()
              //     : 
                  previousDateTime.minute == 00
                      ? "${previousDateTime.hour > 12 ? previousDateTime.hour - 12 : previousDateTime.hour} : ${previousDateTime.minute}0 ${previousDateTime.hour >= 12 ? 'pm' : 'am'}"
                          .text
                          .bold
                          .make()
                      : "${previousDateTime.hour > 12 ? previousDateTime.hour - 12 : previousDateTime.hour} : ${previousDateTime.minute} ${previousDateTime.hour >= 12 ? 'pm' : 'am'}"
                          .text
                          .bold
                          .make(),
              nextDateTime.minute == 00
                  ? "${nextDateTime.hour > 12 ? nextDateTime.hour - 12 : nextDateTime.hour} : ${nextDateTime.minute}0 ${nextDateTime.hour >= 12 ? 'pm' : 'am'}"
                      .text
                      .bold
                      .make()
                  : "${nextDateTime.hour > 12 ? nextDateTime.hour - 12 : nextDateTime.hour} : ${nextDateTime.minute} ${nextDateTime.hour >= 12 ? 'pm' : 'am'}"
                      .text
                      .bold
                      .make(),
            ],
          ).pOnly(bottom: 8),
          LinearPercentIndicator(
            animation: true,
            backgroundColor: Colors.white,
            barRadius: const Radius.circular(5),
            lineHeight: 5,
            percent: percentDateTime(widget.schedules),
            animateFromLastPercent: true,
            progressColor:
                widget.index.isOdd ? AppColors.kLightRed : AppColors.kSkyBlue,
          ),
        ],
      ),
    );
  }
}
