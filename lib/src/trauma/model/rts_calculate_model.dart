// import 'trauma_model.dart';
//
// extension TraumaCalculation on TraumaModel {
//   int get gcsTotal {
//     final eye = int.tryParse(gcsEye.toString() ?? "0") ?? 0;
//     final verbal = int.tryParse(gcsVerbal.toString() ?? "0") ?? 0;
//     final motor = int.tryParse(gcsMotor.toString() ?? "0") ?? 0;
//     return eye + verbal + motor;
//   }
//
//   int _calculateF1() {
//     final total = gcsTotal;
//     if (total >= 13 && total <= 15) return 4;
//     if (total >= 9 && total <= 12) return 3;
//     if (total >= 6 && total <= 8) return 2;
//     if (total >= 4 && total <= 5) return 1;
//     if (total <= 3) return 0;
//     return 0;
//   }
//
//   int _calculateF2() {
//     final sbp = traumaValues?.bpSystolic ?? 0;
//     if (sbp > 89) return 4;
//     if (sbp >= 76 && sbp <= 89) return 3;
//     if (sbp >= 50 && sbp <= 75) return 2;
//     if (sbp >= 1 && sbp <= 49) return 1;
//     if (sbp == 0) return 0;
//     return 0;
//   }
//
//   int _calculateF3() {
//     final rr = int.tryParse(traumaValues?.rr?.toString() ?? "0") ?? 0;
//     if (rr > 29) return 3;
//     if (rr >= 10 && rr <= 29) return 4;
//     if (rr >= 6 && rr <= 9) return 2;
//     if (rr >= 1 && rr <= 5) return 1;
//     if (rr == 0) return 0;
//     return 0;
//   }
//
//   double get totalTraumaScore {
//     final f1 = _calculateF1();
//     final f2 = _calculateF2();
//     final f3 = _calculateF3();
//     return (0.9368 * f1) + (0.7326 * f2) + (0.2908 * f3);
//   }
//
//   String get traumaColor {
//     final score = totalTraumaScore;
//     if (score >= 0 && score <= 3) return "red";
//     if (score > 3 && score <= 6) return "yellow";
//     if (score > 6) return "green";
//     return "";
//   }
// }
