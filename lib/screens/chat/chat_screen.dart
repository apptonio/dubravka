import 'package:animate_do/animate_do.dart';
import 'package:dubravka/constants/colors.dart';
import 'package:dubravka/constants/text_styles.dart';
import 'package:dubravka/screens/chat/chat_controller.dart';
import 'package:dubravka/widgets/buttons/wide_button.dart';
import 'package:dubravka/widgets/textfields/regular_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          body: GestureDetector(
        onVerticalDragStart: (_) {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BounceInDown(
                            delay: const Duration(milliseconds: 200),
                            child: Text(
                              '${controller.greeting.value}, ${controller.user.value!.firstName}.',
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
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BounceInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Learn about your health below.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18.sp)
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragStart: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    onVerticalDragUpdate: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];
                        final role = message['role'];
                        final content = message['content'];

                        final isAssistant = role == 'assistant';
                        final messageAlignment = isAssistant
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end;
                        final messageColor = isAssistant
                            ? MyColors.chatBoxLight
                            : MyColors.themeDark;
                        final borderRadius = BorderRadius.only(
                          topLeft: isAssistant
                              ? const Radius.circular(0.0)
                              : const Radius.circular(16.0),
                          topRight: isAssistant
                              ? const Radius.circular(16.0)
                              : const Radius.circular(0.0),
                          bottomLeft: const Radius.circular(16.0),
                          bottomRight: const Radius.circular(16.0),
                        );

                        return index == 0
                            ? const SizedBox.shrink()
                            : ZoomIn(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      isAssistant ? 0 : Get.width * 0.15,
                                      8.h,
                                      isAssistant ? Get.width * 0.15 : 0,
                                      8.h),
                                  child: Column(
                                    crossAxisAlignment: messageAlignment,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: messageColor,
                                            borderRadius: borderRadius,
                                          ),
                                          child: isAssistant &&
                                                  index ==
                                                      controller
                                                              .messages.length -
                                                          1 &&
                                                  index != 1

                                              //     controller.messages
                                              //             .length -
                                              //         1 &&
                                              // controller
                                              //         .messages.length !=
                                              //     2
                                              ? Obx(
                                                  () => Text(
                                                    controller.myVar.value,
                                                    style: MyTextStyles.medium
                                                        .copyWith(
                                                            color: isAssistant
                                                                ? MyColors.black
                                                                : MyColors
                                                                    .white),
                                                  ),
                                                )
                                              : Text(
                                                  content,
                                                  style: MyTextStyles.medium
                                                      .copyWith(
                                                          color: isAssistant
                                                              ? MyColors.black
                                                              : MyColors.white),
                                                )),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                FadeInUp(
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Expanded(
                          child: MyRegularTextfield(
                            name: 'chat',
                            label: 'Type a message ...',
                            controller: controller.textEditingController,
                          ),
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        WideButton(
                          title: 'Send',
                          onPressed: () => controller.sendMessage(),
                          width: 100.w,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
