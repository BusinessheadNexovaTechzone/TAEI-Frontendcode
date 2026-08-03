import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/verify_controller.dart';
import 'verify_mobile_abha.dart';
import 'verify_aadhaar_abha.dart';
import 'verify_abha_number.dart';
import 'verify_otp.dart';

class VerifyAbhaScreen extends StatefulWidget {
  const VerifyAbhaScreen({super.key});

  @override
  State<VerifyAbhaScreen> createState() => _VerifyAbhaScreenState();
}

class _VerifyAbhaScreenState extends State<VerifyAbhaScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final VerifyAbhaController _controller;
  int _selectedIndex = 0;

  final List<String> _tabs = [
    'Mobile Number',
    'Aadhaar Number',
    'ABHA Number',
  ];

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<VerifyAbhaController>()
        ? Get.find<VerifyAbhaController>()
        : Get.put(VerifyAbhaController());
    _tabController = TabController(length: 3, vsync: this);
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Verify ABHA'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF212121),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final isActive = _selectedIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _tabController.animateTo(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.red : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _tabs[index],
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xFF616161),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    VerifyMobileAbhaScreen(
                        onNext: (message) => _openOtpScreen(message: message)),
                    VerifyAadhaarAbhaScreen(
                        onNext: (message) => _openOtpScreen(message: message)),
                    VerifyAbhaNumberScreen(
                        onNext: (message) => _openOtpScreen(message: message)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
