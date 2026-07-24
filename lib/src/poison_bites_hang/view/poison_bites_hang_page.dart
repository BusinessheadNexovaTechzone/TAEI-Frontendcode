import 'package:flutter/material.dart';
import 'package:taei_gov/src/bite/views/bites_List.dart';
import 'package:taei_gov/src/hang/view/hang_list.dart';
import 'package:taei_gov/src/poison/view/poison_list_page.dart';
import 'package:taei_gov/utils/common/space.dart';

class PoisonBitesHangPage extends StatefulWidget {
  const PoisonBitesHangPage({super.key});

  @override
  State<PoisonBitesHangPage> createState() => _PoisonBitesHangPageState();
}

class _PoisonBitesHangPageState extends State<PoisonBitesHangPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Space(
          height: 8,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
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
            tabs: const [
              Tab(text: 'Poisoning'),
              Tab(text: 'Bites & Stings'),
              Tab(text: 'Hanging'),
            ],
          ),
        ),
        Space(height: 2),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TabBarView(
              controller: tabController,
              children: const [
                Center(
                  child: PoisonListPage(
                    appBar: false,
                  ),
                ),
                Center(
                  child: BitesListPage(
                    appBar: false,
                  ),
                ),
                Center(
                  child: HangingListPage(
                    appBar: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
