import 'dart:async';

import 'package:after_layout/after_layout.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants/assets.dart';
import 'package:todo/services/shared_pref.dart';
import '../../utils/sizes_helpers.dart';
import '../constants/app_colors.dart';
import '../constants/enums.dart';
import '../constants/strings.dart';
import '../state/user_state.dart';
import '../utils/utils.dart';
import '../widgets/background.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/spacings.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  AuthState createState() {
    return AuthState();
  }
}

class AuthState extends State<Auth> with AfterLayoutMixin<Auth> {
  bool _isLogin = true;
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  late UserState _userState;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {}

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await _userState.signIn(_email.text, _password.text);
  }

  Future<void> _signup() async {
    await SharedPref.saveString("email", _email.text);
    await SharedPref.saveString("name", _name.text);
    await _userState.signUP(_email.text, _name.text, _password.text);
  }

  Future<void> _googleLogin() async {
    var result = await _userState.signInGoogle();
    if (result != null) {
      await SharedPref.saveString("email", result.user?.email ?? "");
      await SharedPref.saveString(
          "displayName", result.user?.displayName ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    _userState = Provider.of<UserState>(context, listen: false);
    return Background(
      padding: EdgeInsets.zero,
      children: [
        Container(
          height: 180,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.accent,
          ),
          child: Text(
            _isLogin ? Strings.login : Strings.signup,
            style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22),
          ),
        ),
        heightSpace(30),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              heightSpace(displayHeight(context) * 0.02),
              if (!_isLogin)
                CustomTextFiled(
                  controller: _name,
                  labelText: Strings.name,
                  keyboardType: TextInputType.emailAddress,
                ),
              if (!_isLogin) heightSpace(10),
              CustomTextFiled(
                controller: _email,
                labelText: Strings.email,
                keyboardType: TextInputType.emailAddress,
              ),
              heightSpace(10),
              CustomTextFiled(
                controller: _password,
                labelText: Strings.pass,
              ),
              heightSpace(displayHeight(context) * 0.03),
              CustomButton(
                buttonText: _isLogin ? Strings.login : Strings.signup,
                onTap: () async {
                  if (!_isLogin && _name.text.isEmpty) {
                    Utils.showToast(ToastType.ERROR, Strings.enterName);
                  } else if (_isLogin && _email.text.isEmpty) {
                    Utils.showToast(ToastType.ERROR, Strings.enterEmail);
                    return;
                  } else if (_isLogin && _password.text.isEmpty) {
                    Utils.showToast(ToastType.ERROR, Strings.enterPass);
                    return;
                  } else if (_isLogin) {
                    await _login();
                  } else if (!_isLogin) {
                    await _signup();
                  }
                },
              ),
              heightSpace(displayHeight(context) * 0.03),
              TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith(
                        (states) => EdgeInsets.zero),
                  ),
                  onPressed: () async {
                    _isLogin = !_isLogin;
                    setState(() {});
                  },
                  child: Text(
                    "${_isLogin ? Strings.dont : Strings.already} ${Strings.haveAcc} ${_isLogin ? Strings.signup : Strings.login}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  )),
              heightSpace(displayHeight(context) * 0.03),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      Strings.or,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 10,
                      ),
                    ),
                  ],
                ),
              ),
              heightSpace(displayHeight(context) * 0.03),
              OutlinedButton.icon(
                icon: Image.asset(
                  Assets.google,
                  width: 25,
                ),
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    Strings.google,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith((states) =>
                        const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => AppColors.primary),
                    side: MaterialStateProperty.resolveWith((states) =>
                        const BorderSide(color: AppColors.primary))),
                onPressed: _googleLogin,
              ),
              heightSpace(displayHeight(context) * 0.1),
            ],
          ),
        ),
      ],
    );
  }
}
