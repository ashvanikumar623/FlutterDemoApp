import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MyCustomButton extends StatelessWidget {
  const MyCustomButton({
    super.key,
    required this.btnText,
    this.mainTextAlign = TextAlign.center,
    this.width = double.infinity,
    this.btnSubText = "",
    this.rightText = "",
    this.backgroundColor = AppColors.blue,
    this.textColor = AppColors.white,
    this.btnSubTextColor = AppColors.white,
    this.preImageColor,
    this.borderRadius = 10,
    this.textSize = 18,
    this.fontWeight = FontWeight.w500,
    this.btnSubTextSize = 18,
    this.textPadding = const EdgeInsets.symmetric(vertical: 12.0),
    this.btnSubTextPadding = const EdgeInsets.symmetric(vertical: 10.0),
    this.margin = const EdgeInsets.symmetric(vertical: 16),
    required this.onClick,
    this.preImage = "",
    this.postImage,
    this.preImageHeight = 20,
    this.preImageWidth = 20,
    this.spaceBetween = false,
    this.borderColor,
    this.textFontWeight,
    this.isLoading = false,
    this.loadingColor = AppColors.blue,
  });

  final String btnText;
  final TextAlign mainTextAlign;
  final String btnSubText;
  final String rightText;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final Color? preImageColor;
  final Color? borderColor;
  final Color btnSubTextColor;
  final double textSize;
  final double preImageHeight;
  final double preImageWidth;
  final FontWeight fontWeight;
  final double btnSubTextSize;
  final double borderRadius;
  final EdgeInsetsGeometry textPadding;
  final EdgeInsetsGeometry btnSubTextPadding;
  final EdgeInsetsGeometry margin;
  final VoidCallback onClick;
  final String preImage;
  final Widget? postImage;
  final bool spaceBetween;
  final FontWeight? textFontWeight;
  final bool isLoading;
  final Color loadingColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: TextButton(
        onPressed: () {
          if (!isLoading) {
            onClick();
          }
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: AppColors.white,
          backgroundColor: backgroundColor,
          // disabledForegroundColor: AppColors.grey.withOpacity(0.38),
          disabledForegroundColor: Colors.grey.withOpacity(0.38),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? backgroundColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            color: loadingColor,
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: rightText.isEmpty ? Alignment.center : null,
              padding: textPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (preImage.isNotEmpty) ...[
                    Image.asset(
                      preImage,
                      height: preImageHeight,
                      width: preImageWidth,
                      fit: BoxFit.contain,
                      color: preImageColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        btnText,
                        textAlign: mainTextAlign,
                        style: TextStyle(
                          color: textColor,
                          fontSize: textSize,
                          fontWeight: textFontWeight ?? FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  if (spaceBetween) ...[Spacer()],
                  if (rightText.isNotEmpty) ...[
                    SizedBox(width: 10),
                    Text(
                      rightText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: textSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (postImage != null) ...[
                    SizedBox(width: 10),
                    postImage!,
                  ],
                ],
              ),
            ),
            if (btnSubText.isNotEmpty) ...[
              SizedBox(
                height: 5,
              ),
              Container(
                padding: btnSubTextPadding,
                child: Text(
                  btnSubText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: btnSubTextColor,
                    fontSize: btnSubTextSize,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}