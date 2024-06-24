import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../constant/font_helper.dart';
import 'auth_base_view.dart';
import 'buttons/my_button.dart';

class TermsAndCondition extends GetView<AuthController> {
  TermsAndCondition({this.isForRegisteration = false, super.key});
  final bool isForRegisteration;
  final RxBool isPC = false.obs;
  final RxBool isTC = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: AuthBaseView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.height * .05),
                Center(
                  child: SvgPicture.asset(
                    "assets/logo.svg",
                    height: context.height * .12,
                  ),
                ),
                SizedBox(height: context.height * .05),
                Text(
                  "Terms of Service",
                  style: GlobalFonts.ts32px600w,
                ),
                Text(
                  "Updated on 02 March 2023",
                  style: GlobalFonts.ts12px500w(),
                ),
                const SizedBox(height: 20),
                Text(
                  "1. Terms and Conditions",
                  style: GlobalFonts.ts16px700w(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "Terms and conditions are aimed at protecting the business (you). They give business owners the opportunity to set their rules (within applicable law) of how their service or product may be used including, but not limited to, things like copyright conditions, age limits, and the governing law of the contract. While terms are generally not legally required (like the privacy policy), it is essential for protecting your interests as a business owner.",
                    style: GlobalFonts.ts14px500w,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "2. Privacy Policy",
                  style: GlobalFonts.ts16px700w(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "Most websites make their privacy policies available to site visitors.  A privacy page should specify any Personally identifiable information that is gathered, such as name, address and credit card number, as well as other things like order history, browsing habits, uploads and downloads.  The policy should also explain if data may be left on a user’s computer, such as cookies. According to best practices, the policy should disclose if data may be shared with or sold to third parties and if so, what the purpose is.",
                    style: GlobalFonts.ts14px500w,
                  ),
                ),
                !isForRegisteration
                    ? const SizedBox()
                    : Column(
                        children: [
                          SizedBox(height: context.height * .02),
                          Row(
                            children: [
                              Obx(() {
                                return Checkbox(
                                  value: isTC.value,
                                  onChanged: (val) {
                                    isTC.value = val!;
                                  },
                                );
                              }),
                              Text(
                                "I agree with the Terms & Conditions",
                                style: GlobalFonts.ts12px700w,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Obx(() {
                                return Checkbox(
                                  value: isPC.value,
                                  onChanged: (val) {
                                    isPC.value = val!;
                                  },
                                );
                              }),
                              Text(
                                "I agree with the Privacy Policy",
                                style: GlobalFonts.ts12px700w,
                              ),
                            ],
                          ),
                          SizedBox(height: context.height * .02),
                          MyButton(
                            text: "Accept",
                            height: 56,
                            textStyle:
                                GlobalFonts.ts20px500w(color: Colors.white),
                            onPressed: () async {
                              // controller.senOTP();
                              // Get.to(
                              //   () => const OTPScreen(),
                              // );
                            },
                          ),
                          SizedBox(height: context.height * .01),
                          MyButton(
                            text: "Decline",
                            color: Colors.transparent,
                            height: 56,
                            textStyle: GlobalFonts.ts20px500w(
                                color: const Color(0xFF166351)),
                            textColor: const Color(0xFF166351),
                            onPressed: () async {
                              Get.back();
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
