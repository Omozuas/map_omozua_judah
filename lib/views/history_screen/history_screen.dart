import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mappingapp/api/riverpod/chate_data/chat_provider.dart';
import 'package:mappingapp/api/riverpod/history_data/history_data.dart';
import 'package:mappingapp/api/riverpod/map_data/map_provider.dart';
import 'package:mappingapp/common/app_style.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(navigationHistoryProvider);

    ref.watch(locationProvider);
    ref.watch(markerProvider);
    ref.watch(routeProvider);
    ref.watch(cameraPositionProvider);
    ref.watch(mapControllerProvider);
    ref.watch(destinationProvider);
    ref.watch(chatMessagesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Navigation History",
          textAlign: TextAlign.center,
          style: appStyle(18, Colors.black, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body:
          history.isEmpty
              ? Center(
                child: Text(
                  "No history yet",
                  style: appStyle(14, Colors.grey, FontWeight.w500),
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(10.r),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  final timestamp = DateFormat('yyyy-MM-dd HH:mm').format(
                    DateTime.now().subtract(Duration(minutes: index * 5)),
                  );

                  return Dismissible(
                    key: Key(item['from']! + item['to']!),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white, size: 30),
                    ),
                    onDismissed: (direction) {
                      ref
                          .read(navigationHistoryProvider.notifier)
                          .removeHistory(index);
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        leading: CircleAvatar(
                          // ignore: deprecated_member_use
                          backgroundColor: Colors.orange.withOpacity(0.2),
                          child: Icon(Icons.history, color: Colors.orange),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Text(
                                    "From: ${item['from']}",
                                    style: appStyle(
                                      14,
                                      Colors.black,
                                      FontWeight.w500,
                                    ),
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.flag,
                                  color: Colors.red,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Text(
                                    "To: ${item['to']}",
                                    style: appStyle(
                                      14,
                                      Colors.black,
                                      FontWeight.w500,
                                    ),
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Text(
                          timestamp,
                          style: appStyle(12, Colors.grey, FontWeight.w400),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
