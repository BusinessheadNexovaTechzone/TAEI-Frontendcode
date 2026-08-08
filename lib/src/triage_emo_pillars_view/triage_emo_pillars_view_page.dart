import 'package:flutter/material.dart';
import 'package:taei_gov/src/bite/views/bites_detail_page.dart';
import 'package:taei_gov/src/burn/view/burns_details_page.dart';
import 'package:taei_gov/src/emo_user/view/emo_details_page.dart';
import 'package:taei_gov/src/hang/view/hang_detail_screen.dart';
import 'package:taei_gov/src/nurse_triage/views/triage_details_page.dart';
import 'package:taei_gov/src/poison/view/poision_details_page.dart';
import 'package:taei_gov/src/prem/view/prem_detailPage.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/script/views/script_detail_screen.dart';
import 'package:taei_gov/src/stemi/form_page.dart';
import 'package:taei_gov/src/trauma/views/trauma_details_page.dart';
import 'package:taei_gov/utils/common/appbar.dart';

import '../../utils/common/space.dart';
import '../drowning/views/drowning_detail_page.dart';
import '../stemi/views/stemi_detail_page.dart';

class TriageEmoPillarsViewPage extends StatefulWidget {
  final String from;
  final String triageId;
  final int? emoId;
  final String? pillarId;
  final bool? emo;
  final bool? triage;

  const TriageEmoPillarsViewPage(
      {Key? key,
      required this.from,
      required this.triageId,
      this.emoId,
      this.pillarId,
      this.emo = false,
      this.triage = false})
      : super(
          key: key,
        );

  @override
  State<TriageEmoPillarsViewPage> createState() =>
      _TriageEmoPillarsViewPageState();
}

class _TriageEmoPillarsViewPageState extends State<TriageEmoPillarsViewPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    print('Tab ${widget.pillarId}');
    if (widget.pillarId != null && widget.pillarId != 'null') {
      tabController = TabController(length: 3, vsync: this);
    } else {
      tabController = TabController(length: 2, vsync: this);
    }
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(title: "Patient Details"),
        body: widget.triage == true || widget.emo == true
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TriageDetailsPage(
                    triageId: widget.triageId,
                    isAppbar: false,
                  ),
                ),
              )
            : Column(
                children: [
                  Space(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: context.isDesktop ? 400 : 12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      controller: tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.teal,
                      indicator: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(fontSize: 13),
                      tabs: [
                        Tab(text: 'Triage'),
                        Tab(text: 'EMO'),
                        if (widget.pillarId != null &&
                            widget.pillarId != 'null')
                          Tab(text: widget.from),
                      ],
                    ),
                  ),
                  Space(height: 30),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.isDesktop ? 260 : 12),
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Center(
                            child: TriageDetailsPage(
                              triageId: widget.triageId,
                              isAppbar: false,
                              imman:true
                            ),
                          ),
                          Center(
                            child: EmoDetailsPage(
                              id: widget.triageId,
                              isAppbar: false,
                            ),
                          ),
                          if (widget.pillarId != null &&
                              widget.pillarId != 'null' &&
                              widget.from == 'Trauma')
                            Center(
                              child: TraumaDetailsPage(
                                  triageId: widget.triageId, isAppbar: false),
                            ),
                          if (widget.pillarId != null &&
                              widget.pillarId != 'null' &&
                              widget.from == 'Burns')
                            Center(
                              child: BurnsDetailsPage(
                                  triageId: widget.triageId, isAppbar: false),
                            ),
                          // if (widget.pillarId != null &&
                          //     widget.pillarId != 'null' &&
                          //     widget.from == 'Prem')
                          //   Center(
                          //     child: BurnsDetailsPage(
                          //         triageId: widget.triageId, isAppbar: false),
                          //   ),
                          if (widget.pillarId != null &&
                              widget.pillarId != 'null' &&
                              widget.from == 'Script')
                            Center(
                              child: ScriptDetailScreen(
                                  triageId: widget.triageId, isAppbar: false),
                            ),
                          if (widget.pillarId != null &&
                              widget.pillarId != 'null' &&
                              widget.from == 'Poisoning')
                            Center(
                              child: PoisoningDetailsPage(
                                  triageId: widget.triageId, isAppbar: false),
                            ),
                          if (widget.pillarId != null &&
                              widget.pillarId != 'null' &&
                              widget.from == 'Bites')
                            Center(
                              child: BitesDetailPage(
                                  triageId: widget.triageId, isAppbar: false),
                            ),

                          /// Hang
                          if (widget.pillarId != null &&
                              widget.pillarId != 'null' &&
                              widget.from == 'Hang')
                            Center(
                              child: HangingDetailPage(
                                  triageId: widget.triageId, isAppbar: false),
                            ),

                          if (widget.pillarId != null &&
                              widget.pillarId != 'null' &&
                              widget.from == 'Prem')
                            Center(
                              child: PremDetailPage(
                                  triageId: widget.triageId, isAppbar: false),
                            ),
                          if (widget.pillarId != null &&
                              widget.pillarId != 'null' &&
                              widget.from == 'STEMI')
                              Center(
                                child: StemiDetailPage(
                                    triageId: widget.triageId, isAppbar: false),
                              ),
                          if (widget.pillarId != null &&
                              widget.pillarId != 'null' &&
                              widget.from == 'Drowning')
                            Center(
                              child: DrowningDetailsPage(
                                  triageId: widget.triageId, isAppbar: false),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }
}
