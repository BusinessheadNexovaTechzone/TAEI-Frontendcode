import 'package:flutter/material.dart';

Widget pageLoader() {
  return Center(
    child: SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        // value: 20,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        backgroundColor: const Color.fromARGB(255, 126, 126, 126),
      ),
    ),
  );

  //  const Center(child: SpinKitChasingDots(color: Colors.white)
  //     // CupertinoActivityIndicator(
  //     //   radius: 20.0,
  //     //   color: Colors.white,
  //     // ),
  //     );
}
