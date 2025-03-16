import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mappingapp/api/riverpod/chate_data/chat_provider.dart';
import 'package:mappingapp/api/riverpod/history_data/history_data.dart';
import 'package:mappingapp/api/riverpod/map_data/map_provider.dart';
import 'package:mappingapp/common/app_style.dart';
import 'package:mappingapp/common/custom_textfield.dart';
import 'package:mappingapp/common/larg_button.dart';

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  void proceed() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(navigationHistoryProvider);
    ref.watch(chatMessagesProvider);
    ref.watch(locationProvider);
    ref.watch(markerProvider);
    ref.watch(routeProvider);
    ref.watch(cameraPositionProvider);
    ref.watch(mapControllerProvider);
    ref.watch(destinationProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          textAlign: TextAlign.center,
          style: appStyle(20, Colors.black, FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                CustomTextFields(
                  firstText: '',
                  hintText: "First Name",
                  controller: firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your First Name';
                    }

                    return null; // Password is valid
                  },
                ),
                SizedBox(height: 20.h),
                CustomTextFields(
                  firstText: '',
                  hintText: "Last Name",
                  controller: lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Last Name';
                    }

                    return null; // Password is valid
                  },
                ),
                SizedBox(height: 20.h),
                CustomTextFields(
                  firstText: '',
                  hintText: "Email",
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Email';
                    }

                    return null; // Password is valid
                  },
                ),
                SizedBox(height: 20),
                LargButton(
                  onTap: proceed,
                  color: Colors.orange,
                  textcolor: Colors.white,

                  text: 'save',
                  borderColor: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
