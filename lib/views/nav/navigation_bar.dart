import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mappingapp/common/app_style.dart';
import 'package:mappingapp/controllers/nav_controller.dart';
import 'package:mappingapp/views/history_screen/history_screen.dart';
import 'package:mappingapp/views/map_screen/map_screen.dart';
import 'package:mappingapp/views/menu_screen/menu_screen.dart';
import 'package:mappingapp/views/profile_screen/profile_screen.dart';
import 'package:mappingapp/views/support_screen/support_chat_screen.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MenuScreen(), // Menu items: Profile, Support, History
      MapScreen(), // Google Map with 7 random points
    ];
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavController());
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text("Map App", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange,
          elevation: 0,
          centerTitle: true,
        ),
        drawer: Drawer(
          elevation: 0,
          surfaceTintColor: Colors.white,
          child: Column(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                color: Colors.orange,
                padding: EdgeInsets.all(15.r),
                child: Text(
                  "Menu",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person, size: 25),
                title: Text(
                  "Profile",
                  style: appStyle(15, Colors.black, FontWeight.w500),
                ),
                onTap:
                    () => Get.to(
                      () => ProfileScreen(),
                      transition: Transition.rightToLeftWithFade,
                    ),
              ),
              ListTile(
                leading: Icon(Icons.chat, size: 25),
                title: Text(
                  "Support",
                  style: appStyle(15, Colors.black, FontWeight.w500),
                ),
                onTap:
                    () => Get.to(
                      () => SupportChatScreen(),
                      transition: Transition.rightToLeftWithFade,
                    ),
              ),
              ListTile(
                leading: Icon(Icons.history, size: 25),
                title: Text(
                  "History",
                  style: appStyle(15, Colors.black, FontWeight.w500),
                ),
                onTap:
                    () => Get.to(
                      () => HistoryScreen(),
                      transition: Transition.rightToLeftWithFade,
                    ),
              ),
            ],
          ),
        ),
        body: _screens[controller.tabsIndex], // Switch between Menu & Map
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.tabsIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (v) {
            controller.setnavIndex = v;
          },
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black,
          elevation: 0,
          selectedLabelStyle: appStyle(11, Colors.orange, FontWeight.w500),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
                color: controller.tabsIndex == 0 ? Colors.orange : Colors.black,
              ),
              label: "Menu",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                color: controller.tabsIndex == 1 ? Colors.orange : Colors.black,
              ),
              label: "Map",
            ),
          ],
        ),
      ),
    );
  }
}
