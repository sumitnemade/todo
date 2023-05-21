import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {Key? key,
      required this.buttonText,
      required this.onTap,
      this.backgroundColor = AppColors.buttonBlue,
      this.fontSize = 14,
      this.textColor = Colors.white})
      : super(key: key);
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final Function onTap;
  final double fontSize;

  @override
  CustomButtonState createState() {
    return CustomButtonState();
  }
}

class CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!_isLoading) {
          setState(() {
            _isLoading = true;
          });
          await widget.onTap();

          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: widget.backgroundColor == Colors.white
                  ? AppColors.primary
                  : widget.backgroundColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(2)),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: widget.textColor,
                ),
              )
            : Text(
                widget.buttonText.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }
}
