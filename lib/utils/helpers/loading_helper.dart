// loading animation

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void loadingIndicator(BuildContext ctx) {
  showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext context) {
        return const Center(
          child: CupertinoActivityIndicator(
            radius: 20.0,
            color: Colors.white,
          ),
        );
      });
}
