import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget noDataWidget({String? msg}) {
  return Center(
    child: Text(msg ?? "No data found", style: GoogleFonts.poppins()),
  );
}
