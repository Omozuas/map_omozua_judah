import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mappingapp/common/app_style.dart';

class LargButton extends StatelessWidget {
  const LargButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.textcolor,
    required this.text,
    this.isLoading = false,
    required this.borderColor,
  });
  final void Function() onTap;
  final Color color, textcolor, borderColor;
  final bool isLoading;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 59.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        child: Center(
          child:
              isLoading
                  ? CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: Colors.white,
                    // valueColor: ,
                  )
                  : Text(text, style: appStyle(16, textcolor, FontWeight.w500)),
        ),
      ),
    );
  }
}
