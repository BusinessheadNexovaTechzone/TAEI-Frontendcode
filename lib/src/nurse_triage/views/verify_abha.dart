import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/controller/verify_controller.dart';
import 'verify_mobile_abha.dart';
import 'verify_aadhaar_abha.dart';
import 'verify_abha_number.dart';
import 'verify_abha_address.dart';
import 'verify_otp.dart';

class _TabItem {
  const _TabItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class VerifyAbhaScreen extends StatefulWidget {
  const VerifyAbhaScreen({super.key});

  @override
  State<VerifyAbhaScreen> createState() => _VerifyAbhaScreenState();
}

class _VerifyAbhaScreenState extends State<VerifyAbhaScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final VerifyAbhaController _controller;
  late final NurseTriageController _nurseController;
  int _selectedIndex = 0;

  final List<_TabItem> _tabs = const [
    _TabItem('Mobile Number', Icons.phone_android_outlined),
    _TabItem('Aadhaar Number', Icons.verified_user_outlined),
    _TabItem('ABHA Number', Icons.medical_services_outlined),
    _TabItem('ABHA Address', Icons.badge_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<VerifyAbhaController>()
        ? Get.find<VerifyAbhaController>()
        : Get.put(VerifyAbhaController());
    _nurseController = Get.isRegistered<NurseTriageController>()
      ? Get.find<NurseTriageController>()
      : Get.put(NurseTriageController());
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openOtpScreen({required String message}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VerifyOtpScreen(
          message: message,
          onResendOtp: () async {
            await _controller.resendOtp();
          },
          onVerify: (otp) async {
            return _controller.verifyOtp(otp: otp);
          },
        ),
      ),
    );

    final selectedProfile = _nurseController.selectedAbhaProfile.value;
    if (!mounted || selectedProfile == null) return;

    _nurseController.selectedAbhaProfile.value = null;
    debugPrint('[ABHA PROFILE] Profile data passed successfully');
    Navigator.of(context).pop(selectedProfile);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        toolbarHeight: 86,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verify ABHA',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Secure healthcare identity verification',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x0F000000),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: List.generate(_tabs.length, (index) {
                        final isActive = _selectedIndex == index;
                        final tab = _tabs[index];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _tabController.animateTo(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                color: isActive ? const Color(0xFFEF4444) : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isActive ? Colors.transparent : const Color(0xFFE5E7EB),
                                ),
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: const Color(0x1Fef4444),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(tab.icon, size: 18, color: isActive ? Colors.white : const Color(0xFF374151)),
                                  const SizedBox(width: 8),
                                  Text(
                                    tab.label,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isActive ? Colors.white : const Color(0xFF374151),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: IndexedStack(
                        key: ValueKey<int>(_selectedIndex),
                        index: _selectedIndex,
                        children: [
                          VerifyMobileAbhaScreen(onNext: (message) => _openOtpScreen(message: message)),
                          VerifyAadhaarAbhaScreen(onNext: (message) => _openOtpScreen(message: message)),
                          VerifyAbhaNumberScreen(onNext: (message) => _openOtpScreen(message: message)),
                          VerifyAbhaAddressScreen(onNext: (message) => _openOtpScreen(message: message)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
