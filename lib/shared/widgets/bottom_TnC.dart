import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/font_helper.dart';
import 'terms_condition.dart';

class BottomTnC extends StatelessWidget {
  const BottomTnC({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => TermsAndCondition());
      },
      child: Center(
        child: RichText(
          text: TextSpan(
            style: GlobalFonts.ts12px600w,
            children: [
              TextSpan(
                text: "Aquagenixpro® ",
                style: GlobalFonts.ts12px700w,
              ),
              TextSpan(
                text: "Privacy Policy",
                style: GlobalFonts.ts12px700w
                    .copyWith(color: const Color(0xFF006BFE)),
              ),
              TextSpan(
                text: " and ",
                style: GlobalFonts.ts12px700w,

                // style: TextStyle(color: Colors.black, fontSize: 10),
              ),
              TextSpan(
                text: "Terms & Conditions",
                style: GlobalFonts.ts12px700w
                    .copyWith(color: const Color(0xFF006BFE)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
