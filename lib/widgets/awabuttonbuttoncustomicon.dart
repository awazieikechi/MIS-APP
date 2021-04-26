import 'package:flutter_svg/svg.dart';
import 'package:niia_mis_app/widgets/size_config.dart';
import 'package:flutter/material.dart';

class AwaButtonCustomIcon extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final Function onPressed;
  final Icon icon;

  AwaButtonCustomIcon(
      {this.title, this.onPressed, this.color, this.textColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.all(4 * SizeConfig.safeBlockHorizontal)),
          foregroundColor: MaterialStateProperty.all<Color>(color),
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      2.5 * SizeConfig.safeBlockHorizontal),
                  side: BorderSide(color: color)))),
      onPressed: onPressed,
      icon:
          (icon == null) ? SvgPicture.asset("assets/images/loginpx.svg") : icon,
      label: Text(title,
          style: TextStyle(
            fontSize: 2.71 * SizeConfig.safeBlockVertical,
            color: textColor,
          )),
    );
  }
}
