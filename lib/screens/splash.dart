import 'package:flutter/material.dart';
import 'package:todo/constants/app_colors.dart';
import 'package:todo/utils/sizes_helpers.dart';
import 'package:todo/widgets/background.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  SplashState createState() {
    return SplashState();
  }
}

class SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Background(
      children: [
        SizedBox(
            height: displayHeight(context),
            child: const Center(child: CircularProgressIndicator())),
      ],
    );
  }
}
