import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:islandmfb_flutter_version/components/shared/app_alert_dialogue.dart';
import 'package:islandmfb_flutter_version/components/shared/app_button.dart';
import 'package:islandmfb_flutter_version/components/shared/app_textfield.dart';
import 'package:islandmfb_flutter_version/pages/home_page.dart';
import 'package:islandmfb_flutter_version/requests/account_request.dart';
import 'package:islandmfb_flutter_version/state/account_state_controller.dart';
import 'package:islandmfb_flutter_version/state/loading_state_controller.dart';
import 'package:islandmfb_flutter_version/state/token_state_controller.dart';
import 'package:islandmfb_flutter_version/state/user_state_controller.dart';

import 'package:islandmfb_flutter_version/utilities/colors.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final passwordTextController = TextEditingController();
  final loginIdController = TextEditingController();

  // State controllers
  final tokenState = Get.put(TokenStateController());
  final accountState = Get.put(AccountStateController());
  final userState = Get.put(UserStateController());

  @override
  Widget build(BuildContext context) {
    void userLoginOnClick() async {
      
      context.loaderOverlay.show();

      final token = tokenState.tokenState;
      final user = userState.user;
      await tokenState.setTokenFromLogin(
        loginIdController.text,
        passwordTextController.text,
      );

      if (token.containsKey("access_token")) {
        await userState.setUserStateFromLogin(token["access_token"]);
      }

      // if (user.containsKey("customer_no")) {
      //   print("has customer no");
      //   await accountState
      //       .setAccountStateFromLogin(user["customer_no"].toString());
      // }

      context.loaderOverlay.hide();

      if (token.containsKey("access_token") && user.isNotEmpty) {
        showDialog(
            context: context,
            builder: (_) => AppAlertDialogue(
                  content: "Login Successful",
                  contentColor: successColor,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          color: blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
            barrierDismissible: true);
        Get.to(HomePage());
      } else {
        showDialog(
            context: context,
            builder: (_) => AppAlertDialogue(
                  content: token["error_description"],
                  contentColor: primaryColor,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          color: blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
            barrierDismissible: true);
      }
    }

    return LoaderOverlay(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      SvgPicture.asset("assets/images/logo.svg",
                          semanticsLabel: 'Island Logo'),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Use your email address, phone number or account number sd your login id",
                        style: TextStyle(
                          color: greyColor,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AppTextField(
                        label: "Login ID",
                        hint: "login id",
                        key: Key(1.toString()),
                        textController: loginIdController,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AppTextField(
                        label: "Password",
                        hint: "***********",
                        key: Key(2.toString()),
                        textController: passwordTextController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: const TextSpan(
                            text: "Forgot Password?",
                            style: TextStyle(color: blackColor)),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppButton(text: "Sign In", onPress: userLoginOnClick),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: blackColor),
                              ),
                              TextSpan(
                                text: "Get Started",
                                style: TextStyle(color: successColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
