import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/nurse_triage/models/triage_details_model.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';
import '../../../constants/constant.dart';
import '../../../utils/helpers/local_data_helper.dart';
import '../../emo_user/model/emo_details_model.dart';
import '../../login/models/user_model.dart';
import '../models/triage_details_model.dart';

class pdfController extends GetxController {
  static final _client = CustomHttpHelper();

  final downloadingId = ''.obs;

  static pw.Font? _cachedNotoFont;
  static final _imageCache = <String, pw.MemoryImage>{};

  Future<void> downloadFullCasePdf({
    required String id,
    bool emoB = false,
  }) async {
    downloadingId.value = id; // 🔄 START loader

    try {
      final assets = await _loadAllAssets();

      final notoFont = assets['font'] as pw.Font;
      final logo1 = assets['logo1'] as pw.MemoryImage;
      final logo2 = assets['logo2'] as pw.MemoryImage;
      final logo3 = assets['logo3'] as pw.MemoryImage;
      final body = assets['body'] as pw.MemoryImage;
      final emojis = assets['emojis'] as List<pw.MemoryImage>;

      final triageFuture = _client.get(Uri.parse(Urls.getTriageDetails + id));

      final emoFuture =
      !emoB ? _client.get(Uri.parse(Urls.getEmoDetails + id)) : null;

      // ── Parallel execution ──────────────────
      final responses = await Future.wait([
        triageFuture,
        if (emoFuture != null) emoFuture,
      ]);

      final triageResponse = responses[0];
      final emoResponse = !emoB && responses.length > 1 ? responses[1] : null;

      // ── Parse responses ─────────────────────
      final triage = triageResponse.body.isNotEmpty
          ? TriageDetailsModel.fromJson(jsonDecode(triageResponse.body))
          : null;

      final emo = emoResponse != null && emoResponse.body.isNotEmpty
          ? EmoDetailsModel.fromJson(jsonDecode(emoResponse.body))
          : null;

      // ── Generate PDF ─────────────────────────
      await _generateFullPdf(
        triage: triage,
        emo: emo,
        notoFont: notoFont,
        emojis: emojis,
        logo1: logo1,
        logo2: logo2,
        logo3: logo3,
        body: body,
        emoB: emoB,
      );
    } catch (e, st) {
      Fluttertoast.showToast(msg: "PDF generation failed");
      log("PDF error", error: e, stackTrace: st);
    } finally {
      downloadingId.value = '';
    }
  }

  int pdfCount = 1; // keep this outside (state/global)

  pw.Widget blankLine({int len = 20}) {
    return pw.Text(" " * len);
  }

  Future<void> _generateFullPdf({
    required TriageDetailsModel? triage,
    EmoDetailsModel? emo,
    required pw.Font notoFont,
    required List<pw.MemoryImage> emojis,
    required pw.MemoryImage logo1,
    required pw.MemoryImage logo2,
    required pw.MemoryImage logo3,
    required pw.MemoryImage body,
    bool? emoB,
  }) async {
    final pdf = pw.Document(
      compress: true,
    );
    pdf.addPage(
      pw.MultiPage(
        margin:
        const pw.EdgeInsets.only(top: 20, bottom: 20, left: 60, right: 18),
        build: (_) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logo1, width: 45),
              pw.Image(logo2, width: 45),
              pw.Image(logo3, width: 45),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text(
              "DEPARTMENT OF EMERGENCY MEDICINE / TAEI CASE SHEET",
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          ),
          if (triage != null)
            _buildTriageCase(triage, notoFont,
                emo?.emo?.isMlc?.toString() ?? "", emojis, emo),
          if (emo != null)
            ..._buildEmoCase(
              emo,
              notoFont,
              emojis,
              triage,
            )
          else
            ..._buildEmoCasetest(
              notoFont,
              emojis,
              triage,
            ),
          pw.NewPage(),
          drugsAdvisedSection(),
          pw.SizedBox(height: 20),
          _abcdeTable(),
          pw.SizedBox(height: 20),
          secondarySurveySection(body),
          pw.SizedBox(height: 17),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: const {
              0: pw.FlexColumnWidth(),
              1: pw.FixedColumnWidth(70),
              2: pw.FlexColumnWidth(),
              3: pw.FixedColumnWidth(70),
            },
            children: [
              _legendRow("Abrasion", "//", "Fracture", "#"),
              _legendRow("Amputation", "Amp", "Tender", "T"),
              _legendRow("Burns", "B", "Laceration", "/"),
              _legendRow("Contusion", "C", "Sutured", "////"),
            ],
          ),
          pw.SizedBox(height: 20),
          treatmentAndAssessmentExact(),
          pw.SizedBox(height: 20),
          observationChart(),
          pw.SizedBox(height: 20),
          injuryLegendAndSummary(),
          pw.SizedBox(height: 25),
          pw.Text(
            "Referrals Given:",
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: const {
              0: pw.FixedColumnWidth(120),
              1: pw.FixedColumnWidth(180),
              2: pw.FixedColumnWidth(120),
              3: pw.FixedColumnWidth(120),
            },
            children: [
              pw.TableRow(children: [
                _headerCell("Signature"),
                _headerCell("Consultant Name"),
                _headerCell("Time of referral"),
                _headerCell("Seen by / Time"),
              ]),
              pw.TableRow(children: [
                pw.Container(height: 45),
                pw.Container(height: 45),
                pw.Container(height: 45),
                pw.Container(height: 45),
              ]),
            ],
          ),

          pw.SizedBox(height: 20),
          // ================= DISPOSITION =================
          // pw.Text(
          //   "Disposition: Admitted / Discharged / DAMA / Deceased / Follow-up",
          //   style: const pw.TextStyle(fontSize: 11),
          // ),
          dispositionSection(
            dispositionValue: emo?.outcome?.outcome, // or API field
            notoFont: notoFont,
          ),
          // dispositionSection(dispositionValue: '', notoFont: null)
          pw.SizedBox(height: 20),
          pw.Text(
            "If admitted, Department: __________  Consultant: __________  Ward/ICU: __________",
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Condition at time of Discharge / Transfer: __________________",
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.SizedBox(height: 20),

          pw.Row(children: [
            pw.Expanded(
                child:
                pw.Text("Date:", style: const pw.TextStyle(fontSize: 11))),
            pw.Expanded(
                child: pw.Text("Hospital Name:",
                    style: const pw.TextStyle(fontSize: 11))),
            pw.Expanded(
                child: pw.Text("Reason:",
                    style: const pw.TextStyle(fontSize: 11))),
          ]),

          pw.SizedBox(height: 20),

          pw.Row(children: [
            pw.Expanded(
                child: pw.Text("Sensorium:",
                    style: const pw.TextStyle(fontSize: 11))),
            pw.Expanded(
                child: pw.Text("Pulse Rate:",
                    style: const pw.TextStyle(fontSize: 11))),
            pw.Expanded(
                child: pw.Text("BP:", style: const pw.TextStyle(fontSize: 11))),
          ]),
          pw.SizedBox(height: 30),
          signatureRow(),
        ],
      ),
    );
    final bytes = await pdf.save();

    final rawName = triage?.triageDetails?.nameOfPatient;

    final safeFileName = (rawName != null && rawName.isNotEmpty)
        ? rawName
        // .replaceAll(RegExp(r'[^\w\s-]'), '') // remove special chars
        // .replaceAll(' ', '_')               // replace spaces
        : 'Unknown';

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute("download", "$safeFileName.pdf")
        ..click();

      html.Url.revokeObjectUrl(url);
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/$safeFileName.pdf");

      await file.writeAsBytes(bytes);

      Fluttertoast.showToast(
        msg: "PDF saved to ${file.path}",
      );
    }
  }

  Future<pw.MemoryImage> _getCachedImage(String path) async {
    if (_imageCache.containsKey(path)) {
      return _imageCache[path]!;
    }
    final data = await rootBundle.load(path);
    final img = pw.MemoryImage(data.buffer.asUint8List());
    _imageCache[path] = img;
    return img;
  }

  Future<pw.Font> _getNotoFont() async {
    if (_cachedNotoFont != null) return _cachedNotoFont!;
    final data = await rootBundle.load("assets/DejaVuSans.ttf");
    _cachedNotoFont = pw.Font.ttf(data);
    return _cachedNotoFont!;
  }

  double _labelW = 95;
  static const double _valueW = 185;
  pw.Widget labelCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      alignment: pw.Alignment.centerLeft,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget valueCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      alignment: pw.Alignment.centerLeft,
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9),
      ),
    );
  }

  pw.Widget addressValueCell({double width = _valueW}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          dottedLine(),
          pw.SizedBox(height: 11),
          dottedLine(),
        ],
      ),
    );
  }

  pw.TableRow row5(
      String leftLabel,
      String leftValue, [
        String? rightLabel,
        String? rightValue,
      ]) {
    final bool isAddress = leftLabel.toLowerCase() == "address";

    return pw.TableRow(
      children: [
        labelCell(leftLabel),
        isAddress ? addressValueCell() : valueCell(leftValue),
        rightLabel != null ? labelCell(rightLabel) : pw.Container(),
        rightLabel != null ? valueCell(rightValue ?? "") : pw.Container(),
      ],
    );
  }

  pw.Widget infoTable(List<pw.TableRow> rows) {
    return pw.Table(
      // border: pw.TableBorder.all(width: 0.8),
      columnWidths: {
        0: pw.FixedColumnWidth(_labelW),
        1: pw.FixedColumnWidth(_valueW),
        2: pw.FixedColumnWidth(_labelW),
        3: pw.FixedColumnWidth(_valueW),
      },
      children: rows,
    );
  }

  // Faster parallel loading with caching
  Future<Map<String, dynamic>> _loadAllAssets() async {
    final futures = [
      _getNotoFont(),
      _getCachedImage('assets/logo/test2.jpeg'),
      _getCachedImage('assets/logo/tn_logo.png'),
      _getCachedImage('assets/logo/taei_logo.jpeg'),
      _getCachedImage('assets/emojis/body_1.png'),
      Future.wait([
        for (var i = 32; i <= 37; i++) _getCachedImage('assets/emojis/$i.png'),
      ]),
    ];

    final results = await Future.wait(futures);

    return {
      'font': results[0],
      'logo1': results[1],
      'logo2': results[2],
      'logo3': results[3],
      'body': results[4],
      'emojis': results[5],
    };
  }
}

//// helper

double tableWidth = 520;
double wLabel = 110;
double wValueLarge = 170;
double wValueSmall = 130;

pw.Widget tableRow(List<pw.Widget> children) {
  return pw.Container(
    width: tableWidth,
    child: pw.Row(children: children),
  );
}

/// triage
///
String safe(dynamic value) {
  if (value == null) return "...................................";
  if (value.toString().trim().isEmpty)
    return "...................................";
  return value.toString();
}

String address(dynamic value) {
  if (value != null && value.toString().trim().isNotEmpty) {
    return value.toString();
  }

  return "................................\n"
      "................................";
}

bool hasValue(String? v) => v != null && v.trim().isNotEmpty;

pw.Widget _buildTriageCase(TriageDetailsModel data, pw.Font notoFont,
    String text, List<pw.MemoryImage> emojis, EmoDetailsModel? emo) {
  final t = data.triageDetails;
  final b = data.triageBy108Details;
  final d = data.triageDtlsDetails;
  final isCMCHIS = hasValue(t?.hmisId);
  final isABHA = !isCMCHIS && hasValue(t?.abhaCard);
  final isPHR = !isCMCHIS && !isABHA && hasValue(t?.phrId);

  final String hospitalName = getHospitalName();
  final String districtName = getDistrictName();

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      triageHeader(
          hospitalName: hospitalName,
          districtName: districtName,
          notoFont: notoFont,
          text: text), // ✅ injected here

      pw.SizedBox(height: 8),

      pw.Align(
        alignment: pw.Alignment.topLeft,
        child: sectionTitle("PERSONAL INFORMATION AND ID DETAILS", bold: true),
      ),
      pw.SizedBox(height: 2),

      pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 0.6),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ================= LEFT COLUMN =================
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Name
                pw.Row(children: [
                  pw.Container(
                      width: 90,
                      child: pw.Text("Name", style: pw.TextStyle(fontSize: 9))),
                  pw.Container(
                      width: 180,
                      child: pw.Text(safe(t?.nameOfPatient),
                          style: pw.TextStyle(fontSize: 9))),
                ]),

                pw.SizedBox(height: 10),

                // Age
                pw.Row(children: [
                  pw.Container(
                      width: 90,
                      child: pw.Text("Age", style: pw.TextStyle(fontSize: 9))),
                  pw.Container(
                    width: 180,
                    child: pw.Text(
                      "${t?.ageYear ?? "..."}/ ${t?.ageMonth ?? "..."} Mths",
                      style: pw.TextStyle(fontSize: 9),
                    ),
                  ),
                ]),

                pw.SizedBox(height: 10),

                // Gender
                pw.Row(children: [
                  pw.Container(
                      width: 90,
                      child:
                      pw.Text("Gender", style: pw.TextStyle(fontSize: 9))),
                  pw.Container(
                      width: 180,
                      child: pw.Text(safe(t?.gender),
                          style: pw.TextStyle(fontSize: 9))),
                ]),

                pw.SizedBox(height: 10),

                // Marital Status
                pw.Row(children: [
                  pw.Container(
                      width: 90,
                      child: pw.Text("Marital Status",
                          style: pw.TextStyle(fontSize: 9))),
                  pw.Container(
                      width: 180,
                      child: pw.Text(safe(t?.maritalStatus),
                          style: pw.TextStyle(fontSize: 9))),
                ]),

                pw.SizedBox(height: 10),

                // Mobile No
                pw.Row(children: [
                  pw.Container(
                      width: 90,
                      child: pw.Text("Mobile No",
                          style: pw.TextStyle(fontSize: 9))),
                  pw.Container(
                      width: 180,
                      child: pw.Text(safe(t?.patientMobileNumber),
                          style: pw.TextStyle(fontSize: 9))),
                ]),

                pw.SizedBox(height: 10),
                // Address (2 dotted lines)
                pw.Row(children: [
                  pw.Container(
                      margin: pw.EdgeInsets.only(bottom: 31),
                      width: 90,
                      child: pw.Text("Address", style: pw.TextStyle(fontSize: 9))),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        // pw.SizedBox(height: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            ...((t?.addressLine ?? "")
                                .split(',')
                                .where((e) => e.trim().isNotEmpty)
                                .map(
                                  (e) => pw.Text(
                                e.trim(),
                                style: pw.TextStyle(fontSize: 9),
                              ),
                            )
                                .toList()),
                            if ((t?.district ?? "").isNotEmpty)
                              pw.Text(
                                t!.district!,
                                style: pw.TextStyle(fontSize: 9),
                              ),
                            if ((t?.state ?? "").isNotEmpty)
                              pw.Text(
                                t!.state!,
                                style: pw.TextStyle(fontSize: 9),
                              ),
                            if ((t?.pincode ?? "").isNotEmpty)
                              pw.Text(
                                t!.pincode!,
                                style: pw.TextStyle(fontSize: 9),
                              ),
                          ],
                        ),
                        if(t?.addressLine == null || t?.addressLine == "")...[
                          pw.Container(
                              width: 180,
                              child:
                              pw.Text("...................................")),
                          pw.SizedBox(height: 18),
                          pw.Container(
                              width: 180,
                              child:
                              pw.Text("...................................")),
                        ]
                      ]),
                ]),
              ],
            ),

            // ================= GAP =================
            pw.SizedBox(width: 35),
            // ================= RIGHT COLUMN =================
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Father/Mother
                pw.Row(children: [
                  pw.Container(
                      width: 90,
                      child: pw.Text("Father/Mother",
                          style: pw.TextStyle(fontSize: 9))),
                  pw.Container(
                      width: 180,
                      child: pw.Text(safe(t?.fathername),
                          style: pw.TextStyle(fontSize: 9))),
                ]),

                pw.SizedBox(height: 10),

                // Occupation
                pw.Row(children: [
                  pw.Container(
                      width: 90,
                      child: pw.Text("Occupation",
                          style: pw.TextStyle(fontSize: 9))),
                  pw.Container(
                      width: 180,
                      child: pw.Text("...................................",
                          style: pw.TextStyle(fontSize: 9))),
                ]),

                pw.SizedBox(height: 10),

                // Education
                pw.Row(children: [
                  pw.Container(
                      width: 90,
                      child: pw.Text("Education",
                          style: pw.TextStyle(fontSize: 9))),
                  pw.Container(
                      width: 180,
                      child: pw.Text("...................................",
                          style: pw.TextStyle(fontSize: 9))),
                ]),

                pw.SizedBox(height: 10),

                // Income
                pw.Row(children: [
                  pw.Container(
                      width: 90,
                      child:
                      pw.Text("Income", style: pw.TextStyle(fontSize: 9))),
                  pw.Container(
                      width: 180,
                      child: pw.Text("...................................",
                          style: pw.TextStyle(fontSize: 9))),
                ]),

                pw.SizedBox(height: 10),

                // EHR
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // ── Upper layer : TICKS ─────────────────
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.SizedBox(width: 120),
                        if(t?.abhaCard != null && t?.abhaCard != "")...[
                          tickBox(true,notoFont),
                        ]else...[
                          tickBox(false,notoFont),
                        ],
                        if(t?.cmchisCard != null && t?.cmchisCard != "")...[
                          tickBox(true,notoFont),
                        ]else...[
                          tickBox(false,notoFont),
                        ],
                        if(t?.phrId != null && t?.phrId != "")...[
                          tickBox(true,notoFont),
                        ]else...[
                          tickBox(false,notoFont),
                        ]
                      ],
                    ),
                    // pw.SizedBox(height: ),
                    pw.Row(
                      children: [
                        pw.Container(
                            width: 90,
                            child: pw.Text("EHR ID Name",
                                style: pw.TextStyle(fontSize: 9))),
                        pw.Text("ABHA/", style: pw.TextStyle(fontSize: 9)),
                        pw.Text("CMCHIS/", style: pw.TextStyle(fontSize: 9)),
                        pw.Text("PHR", style: pw.TextStyle(fontSize: 9)),
                      ],
                    ),

                    // pw.SizedBox(height: 6),
                    //
                    // // ── Label ────────────────────────────────
                    // pw.Container(
                    //   width: 180,
                    //   child: pw.Text(
                    //     "ABHA / CMCHIS / PHR",
                    //     style: pw.TextStyle(fontSize: 9),
                    //   ),
                    // ),
                  ],
                ),

                pw.SizedBox(height: 16),

                // ID NO
                pw.Row(
                  children: [
                    pw.Container(
                      width: 90,
                      child: pw.Text(
                        "ID NO",
                        style: pw.TextStyle(fontSize: 9),
                      ),
                    ),
                    pw.Container(
                      width: 180,
                      child: pw.Text(
                        (t?.hmisId != null && t!.hmisId!.trim().isNotEmpty)
                            ? t!.hmisId!
                            : (t?.abhaCard != null && t!.abhaCard!.trim().isNotEmpty)
                            ? t!.abhaCard!
                            : (t?.phrId != null && t!.phrId!.trim().isNotEmpty)
                            ? t!.phrId!
                            : "-",
                        style: pw.TextStyle(fontSize: 9),
                      ),
                    ),
                  ],
                ),


                pw.SizedBox(height: 12),

                // HMIS
                pw.Row(children: [
                  pw.Container(
                      width: 90,
                      child:
                      pw.Text("HMIS ID", style: pw.TextStyle(fontSize: 9))),
                  pw.Container(
                      width: 180,
                      child: pw.Text(safe(t?.hmisId),
                          style: pw.TextStyle(fontSize: 9))),
                ]),
              ],
            ),
          ],
        ),
      ),

      pw.SizedBox(height: 11),

      // ================= INCIDEaNT =================

      pw.Align(
        alignment: pw.Alignment.topLeft,
        child: sectionTitle("MODE OF ARRIVAL & INCIDENT DETAILS", bold: true),
      ),
      pw.SizedBox(height: 2),

      pw.Table(
        border: pw.TableBorder.all(width: 0.6),
        columnWidths: {
          0: const pw.FlexColumnWidth(1),
          1: const pw.FlexColumnWidth(1),
        },
        children: [
          pw.TableRow(children: [
            // LEFT COLUMN
            pw.Column(children: [
              cell(
                "Mode of Arrival: ${safe(t?.modeOfArrival)}",
              ),
              cell("Time of Arrival: ${safe("")}", bold: false),
              cell("Time of Incident: ${safe(t?.dateAndTimeOfIncident)}",
                  bold: false),
              cell("Referral from: ${safe(t?.patienrRecievedFrom)}",
                  bold: false),
              cell(
                "Relationship to the Patient:${safe("")}",
              ),
              cell("Condition of the Patient: ${safe(t?.conditionOfPatient)}",
                  bold: false),
            ]),

            // RIGHT COLUMN
            pw.Column(children: [
              cell("Type of Incident: ${safe("")}", bold: false),
              cell("Brought by: ${safe("")}", bold: false),
              cell("Address and Phone No: ${safe("")}", bold: false),
              cell("Previous admission: ${safe("")}", bold: false),
              pw.SizedBox(height: 32), // spacing to balance height
            ]),
          ]),
        ],
      ),
      pw.SizedBox(height: 11),
      pw.Align(
        alignment: pw.Alignment.topLeft,
        child: sectionTitle("Vitals", bold: true),
      ),
      pw.SizedBox(height: 2),

      buildVitalsExact(d,b),

      pw.SizedBox(height: 11),
      pw.Align(
          alignment: pw.Alignment.topLeft,
          child: sectionTitle("TRIAGE DETAILS", bold: true)),
      pw.SizedBox(height: 16),
      buildTriageCategory(d?.triageFlag, notoFont),
      pw.SizedBox(height: 22),
      painAssessmentScaleSmall(
        notoFont: notoFont,
        emojis: emojis,
        selectedScore: emo?.emo?.painScore is int
            ? emo?.emo?.painScore
            : int.tryParse("${emo?.emo?.painScore}"),
      ),
      pw.SizedBox(height: 18),
      // ================= 108 DETAILS =================
      pw.Align(
        alignment: pw.Alignment.topLeft,
        child: pw.Text(
          "Transit care (108 - Pre-arrival intimation)",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        ),
      ),

      pw.SizedBox(height: 12),

      pw.Column(
        children: [
          // ───────── Row 1 ─────────
          tableRow([
            box("Call ID", width: wLabel),
            box(b?.callId ?? "", width: wValueLarge),
            box("District", width: wLabel),
            box(b?.districtName ?? "", width: wValueSmall),
          ]),

          // ───────── Row 2 ─────────
          tableRow([
            box("City", width: wLabel),
            box(b?.cityName ?? "", width: wValueLarge),
            box("Taluk", width: wLabel),
            box(b?.taluk ?? "", width: wValueSmall),
          ]),

          // ───────── Row 3 ─────────
          tableRow([
            box("Vehicle Assigned\nDate & Time", width: wLabel, height: 40),
            box(b?.vehicleAssignedDateTime ?? "",
                width: wValueLarge, height: 40),
            box("Chief Complaint", width: wLabel, height: 40),
            box(b?.chiefComplaint ?? "", width: wValueSmall, height: 40),
          ]),

          // ───────── Row 4 ─────────
          tableRow([
            box("Emergency Type", width: wLabel, height: 36),
            box(b?.emergencyType ?? "", width: wValueLarge, height: 36),
            box("Emergency Sub type", width: wLabel, height: 36),
            box(b?.emergencySubType ?? "", width: wValueSmall, height: 36),
          ]),

          // ───────── Row 5 (Vitals) ─────────
          tableRow([
            box("Temperature: ${b?.temperature ?? ""}", width: 130),
            box("RR: ${b?.rr ?? ""}", width: 60),
            box(
              "BP: ${b?.bpSbp != null ? "${b?.bpSbp}/${b?.bpDbp ?? ""}" : ""}",
              width: 75,
            ),
            box("Pulse: ${b?.pulse ?? ""}", width: 75),
            box(
              "Condition of Patient: ${b?.conditionOfPatient ?? ""}",
              width: 180,
            ),
          ]),
        ],
      ),
    ],
  );
}

String firstNonEmpty(String? a, String? b, String? c) {
  for (final v in [a, b, c]) {
    if (v != null && v.trim().isNotEmpty) {
      return v;
    }
  }
  return "-";
}


pw.Widget box(
    String text, {
      bool bold = false,
      double width = double.infinity,
      double height = 28,
      pw.EdgeInsets padding = const pw.EdgeInsets.all(4),
    }) {
  return pw.Container(
    width: width,
    height: height,
    padding: padding,
    alignment: pw.Alignment.centerLeft,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(width: 0.6),
    ),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 9,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
      maxLines: 2,
    ),
  );
}

pw.Widget tickBox(bool checked, pw.Font notoFont) {
  return pw.Container(
    width: 10,
    height: 10,
    // decoration: pw.BoxDecoration(
    //   border: pw.Border.all(width: 1),
    // ),
    alignment: pw.Alignment.center,
    child: checked == true
        ? pw.Text("✓",
        style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            font: notoFont
        ))
        : pw.SizedBox(),
  );
}

/// emo

List<pw.Widget> _buildEmoCase(
    EmoDetailsModel? data,
    pw.Font notoFont,
    List<pw.MemoryImage> emojis,
    TriageDetailsModel? triage,
    ) {
  final e = data?.emo;
  final o = data?.outcome;

  return [
    // ================= PAGE 1 =================
    pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 14),
        centeredTitle("EMO CASE DETAILS"),
        pw.SizedBox(height: 2),
        buildPastMedicalHistory(e, notoFont),
        pw.SizedBox(height: 14),
        pw.Table(
          border: pw.TableBorder.all(width: 0.6),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(4),
          },
          children: [
            pw.TableRow(children: [
              cell("Past history"),
              cell(" "),
            ]),
            pw.TableRow(children: [
              cell("Alcohol Consumption"),
              cell(" "),
            ]),
            pw.TableRow(children: [
              cell("Drug Abuse"),
              cell(" "),
            ]),
            pw.TableRow(children: [
              cell("Examined By"),
              cell(" "),
            ]),
          ],
        ),
        pw.SizedBox(height: 14),
        pw.Text(
          "1. Chief Complaint",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(
          triage?.triageBy108Details?.chiefComplaint ?? "",
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          "2. Presenting Complaints test",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(
          triage?.triageDtlsDetails?.pcMedicalEmergency ?? "",
        ),
      ],
    ),

    // ✅ REAL PAGE BREAK (WORKS)
    pw.NewPage(),

    // ================= PAGE 2 =================
    pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "3. Cardiac Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        pw.Text(
          "4. Respiratory Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        pw.Text(
          "5. General Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        pw.Text(
          "6. Physical Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        pw.Text(
          "7. Abdominal Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        pw.Text(
          "8. Neurological Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.Text(
          "Current Medication:",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        diagnosisSection(),
      ],
    ),
  ];
}

List<pw.Widget> _buildEmoCasetest(
    pw.Font notoFont,
    List<pw.MemoryImage> emojis,
    TriageDetailsModel? triage,
    ) {
  EmoDetailsModel? data;

  final e = data?.emo;
  final o = data?.outcome;

  return [
    // ================= PAGE 1 =================
    pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 14),
        centeredTitle("EMO CASE DETAILS"),
        pw.SizedBox(height: 2),
        buildPastMedicalHistory(e, notoFont),
        pw.SizedBox(height: 14),
        pw.Table(
          border: pw.TableBorder.all(width: 0.6),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(4),
          },
          children: [
            pw.TableRow(children: [
              cell("Past history"),
              cell(" "),
            ]),
            pw.TableRow(children: [
              cell("Alcohol Consumption"),
              cell(" "),
            ]),
            pw.TableRow(children: [
              cell("Drug Abuse"),
              cell(" "),
            ]),
            pw.TableRow(children: [
              cell("Examined By"),
              cell(" "),
            ]),
          ],
        ),
        pw.SizedBox(height: 14),
        pw.Text(
          "1. Chief Complaint",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(
          triage?.triageBy108Details?.chiefComplaint ?? "",
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          "2. Presenting Complaints",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(
           triage?.triageDtlsDetails?.pcMedicalEmergency??"",
        ),
      ],
    ),

    // ✅ REAL PAGE BREAK (WORKS)
    pw.NewPage(),

    // ================= PAGE 2 =================
    pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "3. Cardiac Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        pw.Text(
          "4. Respiratory Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        pw.Text(
          "5. General Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        pw.Text(
          "6. Physical Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        pw.Text(
          "7. Abdominal Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        pw.Text(
          "8. Neurological Examination",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.Text(
          "Current Medication:",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        presentingComplaints(""),
        pw.SizedBox(height: 12),
        diagnosisSection(),
      ],
    ),
  ];
}

/// helper

String blank([int count = 16]) => '_' * count;

pw.Widget cell(
    String? text, {
      bool bold = false,
      pw.TextAlign align = pw.TextAlign.left,
      pw.Font? notoFont,
    }) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(6),
    alignment: pw.Alignment.centerLeft,
    child: pw.Text(
      text ?? blank(),
      textAlign: align,
      style: pw.TextStyle(
        fontSize: 9,
        font: notoFont,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}

pw.Widget buildTriageCategory(String? flag, pw.Font notoFont) {
  pw.Widget box(String label, PdfColor color) {
    final selected = flag?.toUpperCase() == label.toUpperCase();
    return pw.Center(
      child: pw.Container(
        height: 20,
        width: 55,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          color: selected ? color : PdfColors.white,
        ),
        child: pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            color: selected ? PdfColors.white : PdfColors.black,
          ),
        ),
      ),
    );
  }

  return pw.Container(
    padding: pw.EdgeInsets.all(24),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(width: 0.6),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Text(
          "Triage Category:",
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(width: 8),
        triageCheckBox("Red", PdfColors.orange,
            checked:flag == "Red"?true:false, notoFont: notoFont),
        pw.SizedBox(width: 6),
        triageCheckBox("Yellow", PdfColors.orange,
            checked: flag == "Yellow"?true:false, notoFont: notoFont),
        pw.SizedBox(width: 6),
        triageCheckBox("Green", PdfColors.green,
            checked: flag == "Green"?true:false, notoFont: notoFont), // example checked
        pw.SizedBox(width: 6),
        triageCheckBox("Black", PdfColors.black,
            checked: flag == "Black"?true:false, notoFont: notoFont),
      ],
    ),
  );
}

pw.Widget dispositionSection({
  required String? dispositionValue, // "ADMITTED", "DISCHARGED", etc.
  required pw.Font notoFont,
}) {
  bool isSelected(String v) =>
      dispositionValue?.toUpperCase() == v.toUpperCase();

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        "Disposition:",
        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 10),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          dispositionCheckBox(
            label: "Admitted",
            checked: isSelected("ADMITTED"),
            notoFont: notoFont,
          ),
          dispositionCheckBox(
            label: "Discharged",
            checked: isSelected("DISCHARGED"),
            notoFont: notoFont,
          ),
          dispositionCheckBox(
            label: "DAMA",
            checked: isSelected("DAMA"),
            notoFont: notoFont,
          ),
          dispositionCheckBox(
            label: "Deceased",
            checked: isSelected("DECEASED"),
            notoFont: notoFont,
          ),
          dispositionCheckBox(
            label: "Follow-up",
            checked: isSelected("FOLLOW-UP"),
            notoFont: notoFont,
          ),
        ],
      ),
    ],
  );
}

pw.Widget dispositionCheckBox({
  required String label,
  required bool checked,
  required pw.Font notoFont,
}) {
  return pw.Row(
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      pw.Container(
        width: 12,
        height: 12,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 1),
        ),
        child: checked
            ? pw.Text(
          "✓",
          style: pw.TextStyle(
            font: notoFont,
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
        )
            : pw.SizedBox(),
      ),
      pw.SizedBox(width: 5),
      pw.Text(
        label,
        style: const pw.TextStyle(fontSize: 9),
      ),
    ],
  );
}

pw.Widget triageCheckBox(
    String label,
    PdfColor color, {
      bool checked = false,
      required pw.Font notoFont,
    }) {
  return pw.Row(
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      pw.Container(
        width: 12,
        height: 12,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.black, width: 1),
          // color: checked ? color : PdfColors.white,
        ),
        alignment: pw.Alignment.center,
        child: checked
            ? pw.Text(
          "✓",
          style: pw.TextStyle(
            font: notoFont,
            fontSize: 9,
            color: PdfColors.black,
            fontWeight: pw.FontWeight.bold,
          ),
        )
            : null,
      ),
      pw.SizedBox(width: 4),
      pw.Text(
        label,
        style: const pw.TextStyle(fontSize: 9),
      ),
    ],
  );
}

pw.Widget sectionTitle(String text, {required bool bold}) {
  return pw.Container(
    width: double.infinity,
    alignment: pw.Alignment.topLeft,
    margin: const pw.EdgeInsets.symmetric(vertical: 6),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pw.Widget triageHeader(
    {required String hospitalName,
      required String districtName,
      required pw.Font notoFont,
      required String text}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.SizedBox(height: 3),
      // Row 1
      pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              "${hospitalName ?? ""} , ${districtName ?? ""}",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.normal,
              ),
            ),
          ),
        ],
      ),

      pw.SizedBox(height: 32),

      // Row 2
      pw.Row(
        children: [
          pw.Expanded(
              child: pw.Text("Date: _______________",
                  style: pw.TextStyle(fontSize: 9))),
          pw.Expanded(
              child: pw.Text("Time: ________________",
                  style: pw.TextStyle(fontSize: 9))),
          pw.Expanded(
              child: pw.Text("UHID/IP NO: ________________",
                  style: pw.TextStyle(fontSize: 9))),
        ],
      ),

      pw.SizedBox(height: 16),

      // MLC / NMLC
      pw.Align(
        alignment: pw.Alignment.centerRight, // ✅ right aligned
        child: pw.Padding(
          padding: const pw.EdgeInsets.only(right: 6), // adjust: 0–10
          child: pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              mlcRowCheckBox(label: 'MLC', notoFont: notoFont, text: text),
              pw.SizedBox(width: 12),
              mlcRowCheckBox1(label: "NMLC", notoFont: notoFont, text: text),
              pw.SizedBox(width: 12),
              pw.Text(
                "NO:_______",
                style: pw.TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

pw.Widget mlcRowCheckBox({
  required String label,
  required pw.Font notoFont,
  required String? text, // value from API (YES / NO / null)
}) {
  // ✅ Tick logic
  final bool checked =
      text == null || text.trim().isEmpty || text.toUpperCase() == "NO";

  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      pw.Container(
        width: 12,
        height: 12,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 1),
        ),
        child: checked
            ? pw.Text(
          "✓",
          style: pw.TextStyle(
            font: notoFont,
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
        )
            : pw.SizedBox(),
      ),
      pw.SizedBox(width: 6),
      pw.Text(
        label,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ],
  );
}

pw.Widget mlcRowCheckBox1({
  required String label,
  required pw.Font notoFont,
  required String? text, // value from API (YES / NO / null)
}) {
  final bool checked =
      text == null || text.trim().isEmpty || text.toUpperCase() == "NO";

  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      pw.Container(
        width: 12,
        height: 12,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 1),
        ),
        child: checked
            ? pw.SizedBox()
            : pw.Text(
          "✓",
          style: pw.TextStyle(
            font: notoFont,
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
      pw.SizedBox(width: 6),
      pw.Text(
        label,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ],
  );
}

pw.Widget cellBoxk(
    String text, {
      double width = 80,
      double height = 24,
      bool bold = false,
      pw.Alignment align = pw.Alignment.centerLeft,
    }) {
  return pw.Container(
    width: width,
    height: height,
    padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    alignment: align,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(width: 0.6),
    ),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 8, // 👈 reduced font
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}

pw.Widget bottomcellBoxk(
    String text, {
      double width = 80,
      double height = 24,
      bool bold = false,
      pw.Alignment align = pw.Alignment.centerLeft,
    }) {
  return pw.Container(
    width: width,
    height: height,
    padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    alignment: align,
    decoration: pw.BoxDecoration(
      border: pw.Border(
        top: pw.BorderSide(width: 0.6),
        left: pw.BorderSide(width: 0.6),
        right: pw.BorderSide(width: 0.6),
        bottom: pw.BorderSide.none, // 👈 bottom removed
      ),
    ),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 8, // 👈 reduced font
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}

pw.Widget rightcellBoxk(
    String text, {
      double width = 80,
      double height = 24,
      bool bold = false,
      pw.Alignment align = pw.Alignment.centerLeft,
    }) {
  return pw.Container(
    width: width,
    height: height,
    padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    alignment: align,
    decoration: pw.BoxDecoration(
      border: pw.Border(
        top: pw.BorderSide(width: 0.6),
        left: pw.BorderSide(width: 0.6),
        right: pw.BorderSide.none,
        bottom: pw.BorderSide(width: 0.6), // 👈 bottom removed
      ),
    ),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 8, // 👈 reduced font
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}

pw.Widget noOutline(
    String text, {
      double width = 80,
      double height = 24,
      bool bold = false,
      pw.Alignment align = pw.Alignment.centerLeft,
    }) {
  return pw.Container(
    width: width,
    height: height,
    padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2),
    alignment: align,
    decoration: pw.BoxDecoration(
      border: pw.Border(
        top: pw.BorderSide.none,
        left: pw.BorderSide.none,
        right: pw.BorderSide.none,
        bottom: pw.BorderSide.none,
      ),
    ),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 8,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}

pw.Widget noOutlinel(
    String text, {
      double width = 80,
      double height = 28,
      bool bold = false,
      pw.Alignment align = pw.Alignment.centerLeft,
    }) {
  return pw.Container(
    width: width,
    height: height,
    padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    alignment: align,
    decoration: pw.BoxDecoration(
      border: pw.Border(
        top: pw.BorderSide.none,
        left: pw.BorderSide.none,
        right: pw.BorderSide(width: 0.6),
        bottom: pw.BorderSide.none,
      ),
    ),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 8,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}

pw.Widget buildVitalsExact(TriageDtlsDetails? d, TriageBy108Details? b) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      // pw.Text(
      //   "Vitals",
      //   style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      // ),
      pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 0.6),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ───────── LEFT BLOCK (260) ─────────
            pw.Container(
              width: 260,
              child: pw.Column(
                children: [
                  pw.Row(children: [
                    cellBoxk("Pulse: ${d?.pulse ?? '-'}", width: 86, bold: false),
                    cellBoxk("BP: 160/${d?.bpDiastolic?? '-'}", width: 86, bold: false),
                    cellBoxk("RR: ${d?.rta ?? '-'}", width: 88, bold: false),
                  ]),
                  pw.Row(children: [
                    cellBoxk("SpO2: ${d?.spo2 ?? '-'}", width: 130, bold: false),
                    cellBoxk("Temp: ${d?.temperature ?? '-'}", width: 130, bold: false),
                  ]),
                  pw.Row(children: [
                    noOutline("GCS:", width: 52, bold: false),
                    noOutline("E", width: 70),
                    noOutline("V", width: 70),
                    noOutline("M", width: 70),
                  ]),
                ],
              ),
            ),

            // ───────── PUPILS COLUMN (56) ─────────
            pw.Container(
              width: 56,
              height: 96,
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(width: 0.6),
                  right: pw.BorderSide(width: 0.6),
                ),
              ),
              child: pw.Text(
                "Pupils",
                style:
                pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              ),
            ),
            pw.Container(
              width: 184,
              child: pw.Column(
                children: [
                  pw.Row(children: [
                    cellBoxk("Right",
                        width: 184 / 1.841,
                        bold: true,
                        align: pw.Alignment.center),
                    rightcellBoxk("Left",
                        width: 184 / 2, bold: true, align: pw.Alignment.center),
                  ]),
                  pw.Row(children: [
                    cellBoxk("Size", width: 50, align: pw.Alignment.center),
                    cellBoxk("Reaction", width: 50, align: pw.Alignment.center),
                    cellBoxk("Size", width: 50, align: pw.Alignment.center),
                    rightcellBoxk("Reaction",
                        width: 50, align: pw.Alignment.center),
                  ]),
                  pw.Row(children: [
                    noOutlinel(b!.pupilRight??"", width: 50, height: 48),
                    noOutlinel("", width: 50, height: 48), // reaction not available
                    noOutlinel(b!.pupilLeft??"", width: 50, height: 48),
                    noOutline("", width: 50, height: 36),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

String getHospitalName() {
  String userJson = LocalDataHelper.getString(Constant.userDetails);

  if (userJson.isNotEmpty) {
    UserModel userDetails = UserModel.fromJson(jsonDecode(userJson));
    return userDetails.user?.hospital?.hospitalname ?? "";
  }
  return "";
}

String getDistrictName() {
  String userJson = LocalDataHelper.getString(Constant.userDetails);

  if (userJson.isNotEmpty) {
    UserModel userDetails = UserModel.fromJson(jsonDecode(userJson));
    return userDetails.user?.hospital?.districtname ?? "";
  }
  return "";
}

pw.Widget presentingComplaints(String? text) {
  final lines = (text ?? '').split('\n');

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.SizedBox(height: 2),

      // First line with text (if available)
      if (lines.isNotEmpty && lines.first.trim().isNotEmpty)
        pw.Text(lines.first, style: const pw.TextStyle(fontSize: 9)),
      dottedLine(),
      pw.SizedBox(height: 16),

      dottedLine(),
      pw.SizedBox(height: 16),

      dottedLine(),
      pw.SizedBox(height: 16),
    ],
  );
}

pw.Widget dottedLine() {
  return pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.symmetric(vertical: 2),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          style: pw.BorderStyle.dotted,
          width: 0.8,
        ),
      ),
    ),
  );
}

pw.Widget buildPastMedicalHistory(
    EmoDetailsDataModel? e,
    pw.Font notoFont,
    ) {
  final history = (e?.pastHistory ?? "").toLowerCase();
  bool has(String key) => history.contains(key);

  return pw.Container(
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(width: 0.6), // ✅ OUTLINE BOX
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // ───────── TITLE ─────────
        pw.Text(
          "PAST MEDICAL HISTORY",
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
        ),

        pw.SizedBox(height: 6),

        // ───────── CHECKBOX TABLE ─────────
        pw.Table(
          columnWidths: const {
            0: pw.FlexColumnWidth(),
            1: pw.FlexColumnWidth(),
          },
          children: [
            pw.TableRow(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: checkBox("HTN", has("htn"), notoFont),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: checkBox("CAD", has("cad"), notoFont),
              ),
            ]),
            pw.TableRow(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: checkBox("DM", has("dm"), notoFont),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: checkBox("COPD", has("copd"), notoFont),
              ),
            ]),
            pw.TableRow(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: checkBox("CND", has("cnd"), notoFont),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: checkBox("Seizure", has("seizure"), notoFont),
              ),
            ]),
          ],
        ),

        pw.SizedBox(height: 8),

        // ───────── OTHERS LINE ─────────
        pw.Text(
          "Others: ...........................................................................",
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

pw.Widget checkBox(String label, bool checked, pw.Font notoFont) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      pw.Container(
        width: 12,
        height: 12,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 1),
        ),
        child: checked
            ? pw.Text(
          "✓",
          style: pw.TextStyle(
            font: notoFont,
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        )
            : pw.SizedBox(),
      ),
      pw.SizedBox(width: 6),
      pw.Text(label, style: pw.TextStyle(fontSize: 10)),
    ],
  );
}

pw.Widget centeredTitle(String text) {
  return pw.Container(
    width: double.infinity,
    alignment: pw.Alignment.topLeft,
    margin: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pw.Widget painAssessmentScaleSmall({
  required List<pw.MemoryImage> emojis, // must be 6
  required int? selectedScore,
  required pw.Font notoFont,
}) {
  assert(emojis.length == 6);

  const double numberCellWidth = 16;
  const double faceCellWidth = 28;
  const double emojiSize = 30;

  int getSelectedIndex(int? score) {
    if (score == null) return -1;
    final s = score.clamp(0, 10);
    if (s == 0) return 0;
    if (s <= 2) return 1;
    if (s <= 4) return 2;
    if (s <= 6) return 3;
    if (s <= 8) return 4;
    return 5;
  }

  final selectedIndex = getSelectedIndex(selectedScore);

  return pw.Padding(
    padding: pw.EdgeInsets.only(left: 50, right: 50),
    child: pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // ---- TITLE ----
        pw.Text(
          "Pain Assessment Scale",
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
          ),
        ),

        pw.SizedBox(height: 4),

        // ---- NUMBERS 0–10 ----
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: List.generate(11, (i) {
            final isSelected = selectedScore == i;

            return pw.SizedBox(
              width: numberCellWidth,
              child: pw.Column(
                children: [
                  pw.Text(
                    "$i",
                    style: pw.TextStyle(
                      fontSize: 7,
                      fontWeight: isSelected
                          ? pw.FontWeight.bold
                          : pw.FontWeight.normal,
                    ),
                  ),
                  if (isSelected)
                    pw.Container(
                      width: 10,
                      height: 10,
                      alignment: pw.Alignment.center,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 0.8),
                      ),
                      child: pw.Text(
                        "✓",
                        style: pw.TextStyle(
                          font: notoFont,
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),

        pw.SizedBox(height: 3),

        // ---- THIN DIVIDER ----
        pw.Container(
          height: 0.5,
          width: double.infinity,
          color: PdfColors.black,
        ),
        pw.SizedBox(height: 1),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: List.generate(11, (i) {
            final isSelected = selectedScore == i;

            return pw.SizedBox(
              width: numberCellWidth,
              child: pw.Column(
                children: [
                  pw.Text(
                    "|",
                    style: pw.TextStyle(
                      fontSize: 7,
                      fontWeight: isSelected
                          ? pw.FontWeight.bold
                          : pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),

        // ---- EMOJIS ----
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: List.generate(emojis.length, (i) {
            return pw.SizedBox(
              width: faceCellWidth,
              child: pw.Image(
                emojis[i],
                width: emojiSize,
                height: emojiSize,
              ),
            );
          }),
        ),

        pw.SizedBox(height: 4),

        // ---- LABELS ----
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _PainLabelSmall("NO\nHURT"),
            _PainLabelSmall("HURTS\nLITTLE"),
            _PainLabelSmall("HURTS\nMORE"),
            _PainLabelSmall("HURTS\nEVEN MORE"),
            _PainLabelSmall("HURTS\nLOT"),
            _PainLabelSmall("HURTS\nWORST"),
          ],
        ),
      ],
    ),
  );
}

pw.Widget doubleUnderline({double width = 100}) {
  return pw.Container(
    margin: pw.EdgeInsets.only(top: 16, bottom: 6),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(".................................."),
        pw.SizedBox(height: 14),
        pw.Text(".................................."),
      ],
    ),
  );
}

pw.Widget cell1(String text) => pw.Container(
  padding:
  const pw.EdgeInsets.only(top: 10, left: 26, right: 26, bottom: 10),
  child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
);

pw.Widget diagnosisSection() {
  return pw.Table(
    border: pw.TableBorder.all(),
    children: [
      pw.TableRow(children: [
        diagCell("Differential Diagnosis"),
        diagCell("Provisional Diagnosis"),
      ]),
      pw.TableRow(children: [
        diagBox(),
        diagBox(),
      ]),
    ],
  );
}

pw.Widget diagCell(String text) => pw.Container(
  padding: const pw.EdgeInsets.all(6),
  alignment: pw.Alignment.center,
  child: pw.Text(text,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
);

pw.Widget diagBox() => pw.Container(height: 100);

pw.Widget drugsAdvisedSection() {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.SizedBox(height: 5),
      pw.Text("Drugs Advised",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
      pw.SizedBox(height: 8),
      pw.Row(children: [
        drugTable(),
        pw.SizedBox(width: 10),
        drugTable(),
      ]),
    ],
  );
}

pw.Widget drugTable() {
  return pw.Table(
    border: pw.TableBorder.all(),
    children: [
      pw.TableRow(children: [
        cell1("SN"),
        cell1("DRUG"),
        cell1("DOSE/ROUTE"),
      ]),
      for (int i = 0; i < 5; i++)
        pw.TableRow(children: [cell1(""), cell1(""), cell1("")]),
    ],
  );
}

pw.Widget secondarySurveySection(pw.MemoryImage body) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text("Secondary Survey:",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
      pw.SizedBox(height: 8),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          /// LEFT: SECONDARY SURVEY TABLE
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: const {
              0: pw.FixedColumnWidth(200), // ✅ correct column width
            },
            children: [
              for (final part in [
                "Head / Eye / ENT",
                "Face",
                "Neck",
                "Chest",
                "Abdomen",
                "Pelvis",
                "Upper Limb",
                "Lower Limb",
                "Log Roll / Spine / PR",
              ])
                pw.TableRow(
                  children: [
                    secondarySurveyCell(part),
                  ],
                ),
            ],
          ),

          pw.SizedBox(width: 20),

          /// RIGHT: BODY IMAGE
          pw.Container(
            height: 250,
            width: 200,
            alignment: pw.Alignment.center,

            // decoration: pw.BoxDecoration(
            //   border: pw.Border.all(),
            // ),
            child: pw.Image(
              body,
              fit: pw.BoxFit.contain,
            ),
          ),
        ],
      ),
    ],
  );
}

pw.Widget secondarySurveyCell(String text) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    alignment: pw.Alignment.centerLeft,
    child: pw.Text(
      text,
      style: const pw.TextStyle(fontSize: 9),
    ),
  );
}

pw.Widget observationChart() {
  return pw.Table(
    border: pw.TableBorder.all(),
    children: [
      pw.TableRow(children: [
        cell("Time"),
        ...[
          "On Arrival",
          "30 Min",
          "1 Hr",
          "1½ Hr",
          "2 Hr",
          "2½ Hr",
          "3 Hr",
          "3½ Hr",
          "4 Hr"
        ].map(cell)
      ]),
      for (final v in ["PR", "BP", "SpO2", "GCS", "U/O", "Sign"])
        pw.TableRow(children: [cell(v), for (int i = 0; i < 9; i++) cell("")])
    ],
  );
}

pw.Widget signatureRow() {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text("ER Physician Name & Signature:",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
      pw.Container(
        padding: pw.EdgeInsets.only(right: 50),
        child: pw.Text("Date & Time:",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
      )
    ],
  );
}

pw.Widget treatmentAndAssessmentExact() {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Table(
        border: pw.TableBorder.all(),
        columnWidths: const {
          0: pw.FlexColumnWidth(),
          1: pw.FlexColumnWidth(),
        },
        children: [
          pw.TableRow(children: [
            _headerCell("Treatment Given"),
            _headerCell("Procedure Done"),
          ]),
          pw.TableRow(children: [
            pw.Container(height: 135),
            pw.Container(height: 135),
          ]),
        ],
      ),

      pw.SizedBox(height: 20),

      // ================= SCORING SYSTEM =================
      pw.Text(
        "Scoring System:",
        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 6),

      pw.Table(
        border: pw.TableBorder.all(),
        columnWidths: const {
          0: pw.FixedColumnWidth(160),
          1: pw.FixedColumnWidth(80),
          2: pw.FixedColumnWidth(160),
          3: pw.FixedColumnWidth(80),
        },
        children: [
          _scoreRow1("Q SOFA", "CURB 65"),
          _scoreRow1("NIHSS", "ABCD2 FOR TIA"),
          _scoreRow1("WELL SCORE", "GOLD CRITERIA FOR COPD"),
          _scoreRow1("CHA2DS2 VASC SCORE", "TIMI SCORE"),
          _scoreRow1(
              "MANGLED EXTREMITY SEVERITY SCORE (MESS Score)", "PERC SCORE"),
        ],
      ),

      // ================= ABCDE TABLE =================
    ],
  );
}

pw.Widget _abcdeTable() {
  return pw.Table(
    border: pw.TableBorder.all(),
    columnWidths: const {
      0: pw.FixedColumnWidth(95),
      1: pw.FixedColumnWidth(260),
      2: pw.FixedColumnWidth(200),
    },
    children: [
      pw.TableRow(children: [
        pw.Container(),
        _headerCell("Assessment"),
        _headerCell("Management"),
      ]),
      _abcRow("Airway"),
      _abcRow("Breathing"),
      _abcRow("Circulation"),
      pw.TableRow(children: [
        pw.Container(
          height: 100,
          alignment: pw.Alignment.center,
          child: _cell("Disability"),
        ),
        pw.Column(children: [
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: const {
              0: pw.FixedColumnWidth(100),
              1: pw.FixedColumnWidth(25),
              2: pw.FixedColumnWidth(25),
              3: pw.FixedColumnWidth(25),
              4: pw.FixedColumnWidth(45),
            },
            children: [
              pw.TableRow(children: [
                _cell1("Level of Consciousness\nGCS"),
                _cell1("E", center: true),
                _cell1("V", center: true),
                _cell1("M", center: true),
                _cell1("Total", center: true),
              ]),
            ],
          ),
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: const {
              0: pw.FixedColumnWidth(100),
              1: pw.FixedColumnWidth(45),
              2: pw.FixedColumnWidth(55),
              3: pw.FixedColumnWidth(30),
              4: pw.FixedColumnWidth(45),
            },
            children: [
              pw.TableRow(children: [
                bottomcellBoxk("RTS"),
                bottomcellBoxk("GCS"),
                bottomcellBoxk("SYS-BP"),
                bottomcellBoxk("RR"),
                bottomcellBoxk("TOTAL"),
              ]),
            ],
          ),
        ]),
        pw.Container(height: 90),
      ]),
      _abcRow("Exposure"),
    ],
  );
}

pw.Widget _headerCell(String text) => pw.Container(
  alignment: pw.Alignment.center,
  padding: const pw.EdgeInsets.all(6),
  child: pw.Text(
    text,
    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
  ),
);

pw.Widget _cell(String text) => pw.Container(
  padding: const pw.EdgeInsets.all(6),
  child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
);

pw.TableRow _abcRow(String title) => pw.TableRow(children: [
  _cell(title),
  pw.Container(height: 50),
  pw.Container(height: 50),
]);

pw.Widget injuryLegendAndSummary() {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      /// INJURY LEGEND TABLE

      pw.Text(
        "Summary of Injuries:",
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      ),
      pw.SizedBox(height: 6),

      pw.Container(
        height: 110,
        width: double.infinity,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
        ),
      ),
    ],
  );
}

pw.TableRow _legendRow(String a, String b, String c, String d) {
  return pw.TableRow(
    children: [
      _legendCell(a),
      _legendCell(b, center: true),
      _legendCell(c),
      _legendCell(d, center: true),
    ],
  );
}

pw.Widget _legendCell(String text, {bool center = false}) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(8),
    alignment: center ? pw.Alignment.center : pw.Alignment.centerLeft,
    child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
  );
}

pw.TableRow _scoreRow1(String left, String right) {
  return pw.TableRow(children: [
    _cell1(left, minHeight: 26),
    pw.Container(),
    _cell1(right, minHeight: 26),
    pw.Container(),
  ]);
}

pw.Widget _cell1(
    String text, {
      bool center = false,
      double? minHeight,
    }) {
  return pw.Container(
    constraints:
    minHeight != null ? pw.BoxConstraints(minHeight: minHeight) : null,
    padding: const pw.EdgeInsets.all(6),
    alignment: center ? pw.Alignment.center : pw.Alignment.centerLeft,
    child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
  );
}

class _PainLabelSmall extends pw.StatelessWidget {
  final String text;
  _PainLabelSmall(this.text);

  @override
  pw.Widget build(pw.Context context) {
    return pw.SizedBox(
      width: 26,
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 6),
      ),
    );
  }
}
