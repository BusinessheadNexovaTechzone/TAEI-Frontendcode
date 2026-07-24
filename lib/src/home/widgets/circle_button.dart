import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/helpers/space.dart';

// ignore: must_be_immutable
class CircleButton extends StatelessWidget {
  String? title;
  IconData? icon;
  Function()? onPress;
  CircleButton({super.key, this.title, this.icon, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[300],
          child: IconButton(
            onPressed: onPress,
            icon: Icon(
              icon ?? CupertinoIcons.news_solid,
              color: Colors.black,
              size: 27,
            ),
          ),
        ),
        Space(height: 5),
        SizedBox(
          height: 70,
          width: 90,
          child: Text(
            textAlign: TextAlign.center,
            (title ?? '').replaceAll(' ', '\n'),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
