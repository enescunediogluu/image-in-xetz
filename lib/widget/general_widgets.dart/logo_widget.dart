import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'modified_text.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 35,
          width: 35,
          child: Image.network(
            "https://cdn-icons-png.flaticon.com/512/2081/2081618.png",
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 5),
        const ModifiedText(
          text: "ImageIn",
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: primaryColor,
        ),
      ],
    );
  }
}
