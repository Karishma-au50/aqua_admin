import 'package:admin/model/pond_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../shared/constant/font_helper.dart';
import '../../../shared/constant/global_variables.dart';
import '../../../shared/widgets/auth_base_view.dart';
import '../../../shared/widgets/bottom_TnC.dart';
import '../../../shared/widgets/buttons/my_button.dart';
import '../../../shared/widgets/inputs/my_text_field.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PondModel? pond;

  final formKey = GlobalKey<FormState>();

  final AuthController controller = Get.isRegistered<AuthController>()
      ? Get.find()
      : Get.put(AuthController());

  TextEditingController mobileController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  RxBool isRememberMe = false.obs;

  final scrollKey = GlobalKey();

  RxBool isPC = false.obs;

  RxBool isTC = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        primary: true,
        child: Form(
          key: formKey,
          child: SizedBox(
            height: context.height,
            child: AuthBaseView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            SizedBox(height: context.height * .15),
                            SvgPicture.asset(
                              "assets/images/logo.svg",
                              color: greenColor,
                              height: context.height * .16,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.height * .05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Enter registered mobile number and password",
                              style: GlobalFonts.ts16px700w(),
                            ),
                            const SizedBox(height: 20),
                            MyTextField(
                              controller: mobileController,
                              hintText: "Mobile Number",
                              textInputType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              isValidate: false,
                              onTap: () {
                                // controller.ensureVisibleOnTextArea(
                                //     textfieldKey: controller.scrollKey);
                              },
                            ),
                            MyTextField(
                              controller: passwordController,
                              hintText: "Password",
                              isValidate: true,
                              validator: (val) {
                                RegExp re = RegExp(r'^[0-9]{10}$');

                                RegExp regex = RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                if (val.isEmpty &&
                                    mobileController.text.isNotEmpty) {
                                  return "Mobile and Password is required";
                                } else if (!re
                                        .hasMatch(mobileController.text) &&
                                    !regex.hasMatch(val)) {
                                  return "Enter a valid mobile number and password";
                                } else if (!regex.hasMatch(val)) {
                                  return "Enter a valid password";
                                }
                                return "";
                              },
                              isPass: true,
                              onTap: () {},
                            ),
                            SizedBox(height: context.height * .01),
                            MyButton(
                              text: "Login",
                              height: 56,
                              textStyle:
                                  GlobalFonts.ts20px500w(color: Colors.white),
                              onPressed: () async {
                                await controller.login(
                                    mobile: mobileController.text,
                                    password: passwordController.text);
                              },
                            ),
                            SizedBox(height: context.height * .02),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const BottomTnC(),
                      SizedBox(
                        key: scrollKey,
                        height: context.height * .02,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
