import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/schedule.dart';
import '../../../theme/theme/app_color.dart';
import '../../bus_schedule/screen/bus_schedule_screen.dart';
import '../../contacts/controller/contact_controller.dart';
import '../../contacts/screen/faculty_screen.dart';
import 'image_slider.dart';

List<Schedule> schedules = [];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    var datas = GetStorage().read("schedules");
    print("All Schedules: $datas");
    if (datas != null) {
      for (Map<String, dynamic> data in datas) {
        schedules.add(Schedule.fromJson(data));
      }
      print("init bus schedules: $schedules");
    }
    super.initState();
  }
  // @override
  // void didChangeDependencies() {

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: context.percentHeight * 52,
              child: Column(
                children: [
                  CustomImageSlider(),
                  SizedBox(
                    height: context.percentHeight * 22,
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => BusScheduleScreen(
                                              payload: "",
                                            )),
                                  );
                                },
                                child: Container(
                                  height: context.percentWidth * 25,
                                  width: context.percentWidth * 25,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.kSkyBlue, width: 5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.directions_bus,
                                    size: context.percentWidth * 15,
                                    color: AppColors.kSkyBlue,
                                  ),
                                ),
                              ),
                              20.heightBox,
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
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => ContactScreen()),
                                  );
                                },
                                child: Container(
                                  height: context.percentWidth * 25,
                                  width: context.percentWidth * 25,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.kSkyBlue, width: 5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.school,
                                    size: context.percentWidth * 15,
                                    color: AppColors.kSkyBlue,
                                  ),
                                ),
                              ),
                              20.heightBox,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: context.percentWidth * 100,
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
