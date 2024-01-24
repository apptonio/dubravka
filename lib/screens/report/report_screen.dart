import 'package:animate_do/animate_do.dart';
import 'package:dubravka/constants/colors.dart';
import 'package:dubravka/screens/report/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FadeInRight(
        delay: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: () => {controller.getReport()},
          child: const Icon(Icons.add),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BounceInDown(
                            delay: const Duration(milliseconds: 200),
                            child: Text(
                              'Assist your doctor',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 26.sp).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: BounceInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Patient report (summary).',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18.sp)
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                ),
              ),
              BounceInDown(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.black.withOpacity(0.06),
                        offset: const Offset(0, 6),
                        spreadRadius: 2,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                  child: BounceInDown(
                    delay: const Duration(milliseconds: 200),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // Handle text section tap
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColors.themeDark),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Obx(
                              () => SelectableText(
                                controller.userReport.value,
                                style: TextStyle(fontSize: 16.sp),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
