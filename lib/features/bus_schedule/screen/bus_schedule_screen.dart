import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mybu/common/my_snackbar.dart';
import 'package:mybu/features/bus_schedule/screen/route_1.dart';
import 'package:mybu/features/bus_schedule/screen/route_2.dart';
import 'package:mybu/features/bus_schedule/screen/route_3.dart';
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/scroll_navigation.dart';
import 'package:scroll_navigation/navigation/title_scroll_navigation.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../theme/theme/app_color.dart';
import '../controller/bus_schedule_controller.dart';
import '../repository/bus_schedule_repository.dart';

class BusScheduleScreen extends ConsumerStatefulWidget {
  final String routeName = "/busSchedule";
  final String? payload;
  const BusScheduleScreen({
    Key? key,
    required this.payload,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BusScheduleScreenState();
}

class _BusScheduleScreenState extends ConsumerState<BusScheduleScreen>
    with SingleTickerProviderStateMixin {
  late StreamSubscription internetSubscription;
  bool hasInternet = false;
  @override
  void initState() {
    internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    var datas = ref.watch(providerOfBusSchedules) as List;

    final busScheduleController = ref.watch(providerOfBusScheduleController);

    return DefaultTabController(
      initialIndex: ref.read(providerOfTabIndex),
      length: 3,
      child: Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.kBackground
              : AppColors.kLightGray,
          appBar: AppBar(
            title: "Bus Schedule".text.make(),
            actions: [
              IconButton(
                  onPressed: () {
                    if (hasInternet) {
                      setState(() {
                        isLoading = true;
                      });
                      busScheduleController
                          .getAllSchedules(context: context, ref: ref)
                          .then((_) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    } else {
                      mySnackbar(context, "There is no internet connection");
                    }
                  },
                  icon: const Icon(Icons.download))
            ],
          ),
          body: isLoading
              ? const CircularProgressIndicator(
                  color: AppColors.kSkyBlue,
                  strokeWidth: 5,
                )
              : datas.length < 2
                  ? SizedBox(
                      height: context.percentHeight * 100,
                      width: context.percentWidth * 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          "There is no bus schedules! Please"
                              .text
                              .xl
                              .bold
                              .color(AppColors.kSkyBlue)
                              .make(),
                          TextButton(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(AppColors.kSkyBlue),
                            ),
                            onPressed: () {
                              if (hasInternet) {
                                setState(() {
                                  isLoading = true;
                                });
                                busScheduleController
                                    .getAllSchedules(context: context, ref: ref)
                                    .then((_) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              } else {
                                mySnackbar(
                                    context, "There is no internet connection");
                              }
                            },
                            child: const Text(
                              "Download it",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        TabBar(
                            onTap: (val) {
                              ref
                                  .read(providerOfTabIndex.notifier)
                                  .update((state) => state = val);
                              GetStorage().write("tabIndex", val);
                            },
                            indicator: BoxDecoration(
                                color: AppColors.kDeepBlue,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16))),
                            indicatorWeight: 2,
                            tabs: [
                              Tab(
                                text: ref.watch(providerOfTabIndex) == 0
                                    ? "Route 1     √"
                                    : "Route 1",
                              ),
                              Tab(
                                text: ref.watch(providerOfTabIndex) == 1
                                    ? "Route 2     √"
                                    : "Route 2",
                              ),
                              Tab(
                                text: ref.watch(providerOfTabIndex) == 2
                                    ? "Route 3     √"
                                    : "Route 3",
                              )
                            ]),
                        Expanded(
                          child:
                              TabBarView( children: [
                            RouteOne(),
                            RouteTwo(),
                            RouteThree(),
                          ]),
                        )
                      ],
                    )
          // : TitleScrollNavigation(
          //     identiferStyle: NavigationIdentiferStyle(
          //         color: Theme.of(context).brightness == Brightness.light
          //             ? AppColors.kDeepBlue
          //             : AppColors.kLightGray,
          //         borderRadius: const BorderRadius.only(
          //             topLeft: Radius.circular(5),
          //             topRight: Radius.circular(5))),
          //     barStyle: TitleNavigationBarStyle(
          //       background: Colors.transparent,
          //       elevation: -50,
          //       style: const TextStyle(fontSize: 20),
          //       activeColor:
          //           Theme.of(context).brightness == Brightness.light
          //               ? AppColors.kDeepBlue
          //               : AppColors.kLightGray,
          //       deactiveColor:
          //           Theme.of(context).brightness == Brightness.light
          //               ? AppColors.kLightRed.withOpacity(0.3)
          //               : AppColors.kSkyBlue.withOpacity(0.3),
          //       padding: const EdgeInsets.symmetric(vertical: 10),
          //       spaceBetween: 40,
          //     ),
          //     titles: const ["Route-1", "Route-2", "Route-3"],
          //     pages: const [RouteOne(), RouteTwo(), RouteThree()],
          //   ),
          ),
    );
  }
}
