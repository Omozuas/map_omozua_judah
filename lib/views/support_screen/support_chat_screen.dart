import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mappingapp/api/riverpod/chate_data/chat_provider.dart';
import 'package:mappingapp/api/riverpod/history_data/history_data.dart';
import 'package:mappingapp/api/riverpod/map_data/map_provider.dart';
import 'package:mappingapp/common/app_style.dart';
import 'package:mappingapp/common/custom_textfield.dart';

class SupportChatScreen extends ConsumerStatefulWidget {
  const SupportChatScreen({super.key});

  @override
  ConsumerState<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends ConsumerState<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isEmpty = true;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        isEmpty = _messageController.text.trim().isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      ref.read(chatMessagesProvider.notifier).sendMessage(message);
      _messageController.clear();

      // Auto-scroll to the latest message
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    ref.watch(navigationHistoryProvider);
    ref.watch(locationProvider);
    ref.watch(markerProvider);
    ref.watch(routeProvider);
    ref.watch(cameraPositionProvider);
    ref.watch(mapControllerProvider);
    ref.watch(destinationProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Support Chat",
          textAlign: TextAlign.center,
          style: appStyle(20, Colors.black, FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final bool isUser = index.isEven; // Simulating user/support
                  final String message = messages[index];
                  final String time = DateFormat(
                    'hh:mm a',
                  ).format(DateTime.now());

                  return Row(
                    mainAxisAlignment:
                        isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) _buildUserImage(false), // Support Image
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 8.w,
                          ),
                          padding: EdgeInsets.all(12.r),
                          constraints: BoxConstraints(maxWidth: 200.w),
                          decoration: BoxDecoration(
                            color:
                                isUser ? Colors.orange[300] : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.r),
                              topRight: Radius.circular(15.r),
                              bottomLeft:
                                  isUser ? Radius.circular(15.r) : Radius.zero,
                              bottomRight:
                                  isUser ? Radius.zero : Radius.circular(15.r),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isUser ? "You" : "Support",
                                style: appStyle(
                                  14,
                                  Colors.black87,
                                  FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                message,
                                style: appStyle(
                                  14,
                                  Colors.black,
                                  FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  time,
                                  style: appStyle(
                                    11,
                                    Colors.black54,
                                    FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isUser) _buildUserImage(true), // User Image
                    ],
                  );
                },
              ),
            ),

            // Message Input Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFields(
                      firstText: '',
                      hintText: "Type a message....",
                      controller: _messageController,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: Icon(
                      isEmpty ? Icons.mic : Icons.send,
                      color: Colors.orange,
                      size: 30.sp,
                    ),
                    onPressed: isEmpty ? () {} : sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **User Image Widget**
  Widget _buildUserImage(bool isUser) {
    return Padding(
      padding: EdgeInsets.only(left: isUser ? 8.w : 0, right: isUser ? 0 : 8.w),
      child: CircleAvatar(
        radius: 20.r,
        backgroundImage: NetworkImage(
          isUser
              ? "https://s3-alpha-sig.figma.com/img/a8d8/954b/ba2b7eae3424827e8cfd5fe495122704?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=oHGpzuE6vVl1k-~4q8YL0HcA3G1xmYQnbE~BM8h6G0Oz4RO0ZfNgwYA5yFRWJ638W9lV1JcZr14QSOU4lwx6mMsOFHJPxRHa8CEiYPDsAXuS-Yx~L9cI5dyRZK6jmUb8aynux6zfQnxH5skZi-5TDdp4GxCLrDBe~7hVZvMYUL63ac9o0b5lE0bZlpwSa5rXp5PMoIOve-oVMn6faz9Hr-4-Pj46bBJhnv13KnVZ1A8leG5WsI8O7yxmBxojWRDoQ~rLzrHI77365XjZa1TdKQYNBm7p3g342Pkf6hefIKHJvx9XBr5X80Q2qcFBtFWOnszu-y14bzw1dC5WCBV6yQ__"
              : "https://s3-alpha-sig.figma.com/img/10d3/485b/88529eca86995eb903c90420b7ea4485?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=ey40qpa4UWvlrlDisvBy-VCRCHlKo~aKB3qFbxZXxtPv0P7J~BPSHvHG8Aapje8B7H~02tkUZD3it-tEIIdSWrMQD4~sZ50c7tMfdCObX8z4B4H8ykLfrnTFl~ZAOaFxIal3ZY~PyN3BVbdMFeusPNBcnwpQuAg~~qjyIBU2o8aauE7UVkh3Fo8quvpAx4uq4pshFg-IERWPUcf4oTQH0oWugjHKcNr3VCn0mEdQy7zuZPSzrYcmq1erUIOlArZEQNTiau0T2bug~FulcUNNZ~-AyL-5N4OuBOh3uAS9y2WSgu7kkBVD6REoB6JKpxd5xw7WwEP~icQQPH5KmLnX4A__",
        ),
      ),
    );
  }
}
