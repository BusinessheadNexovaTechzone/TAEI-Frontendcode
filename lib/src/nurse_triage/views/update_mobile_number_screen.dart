import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateMobileNumberScreen extends StatefulWidget {
  const UpdateMobileNumberScreen({
    super.key,
    required this.flowId,
    required this.currentMobile,
    required this.onSendOtp,
    required this.onVerify,
  });

  final String flowId;
  final String currentMobile;
  final Future<bool> Function(String mobile) onSendOtp;
  final Future<bool> Function(String otp) onVerify;

  @override
  State<UpdateMobileNumberScreen> createState() =>
      _UpdateMobileNumberScreenState();
}

class _UpdateMobileNumberScreenState extends State<UpdateMobileNumberScreen> {
  static const int _maxOtpRequests = 3;
  static const int _maxVerificationAttempts = 3;
  static const Duration _resendCooldown = Duration(seconds: 60);
  static const Duration _lockoutDuration = Duration(minutes: 30);

  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());

  Timer? _resendTimer;
  Timer? _lockoutTimer;
  String? _sentMobile;
  String? _errorMessage;
  int _otpRequestCount = 0;
  int _verificationAttempts = 0;
  int _resendSeconds = 0;
  Duration _lockoutRemaining = Duration.zero;
  bool _isSending = false;
  bool _isVerifying = false;
  bool _isResending = false;

  String get _otp =>
      _otpControllers.map((controller) => controller.text).join();

  bool get _canVerify =>
      _otp.length == 6 &&
      !_isVerifying &&
      _lockoutRemaining == Duration.zero &&
      _verificationAttempts < _maxVerificationAttempts;

  @override
  void initState() {
    super.initState();
    final currentMobile = widget.currentMobile.trim();
    _mobileController.text =
        currentMobile.toLowerCase() == 'not available' ? '' : currentMobile;
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _lockoutTimer?.cancel();
    _mobileController.dispose();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_isSending || !_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    final mobile = _mobileController.text;
    try {
      final sent = await widget.onSendOtp(mobile);
      if (!mounted) return;
      if (sent) {
        setState(() {
          _sentMobile = mobile;
          _otpRequestCount = 1;
          _errorMessage = null;
        });
        _startResendTimer();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
        });
      } else {
        setState(() {
          _errorMessage = 'Unable to send the OTP. Please try again.';
        });
      }
    } catch (error) {
      debugPrint(
          '[ABHA][UI][FLOW:${widget.flowId}] Failed to send mobile update OTP: $error');
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to send the OTP. Please try again.';
        });
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _resendOtp() async {
    final mobile = _sentMobile;
    if (mobile == null ||
        _isResending ||
        _isVerifying ||
        _resendSeconds > 0 ||
        _otpRequestCount >= _maxOtpRequests ||
        _lockoutRemaining > Duration.zero) {
      return;
    }

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final sent = await widget.onSendOtp(mobile);
      if (!mounted) return;
      if (sent) {
        setState(() {
          _otpRequestCount++;
          _errorMessage = null;
        });
        _clearOtp();
        _startResendTimer();
      } else {
        setState(() {
          _errorMessage = 'Unable to resend the OTP. Please try again.';
        });
      }
    } catch (error) {
      debugPrint(
          '[ABHA][UI][FLOW:${widget.flowId}] Failed to resend mobile update OTP: $error');
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to resend the OTP. Please try again.';
        });
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = _resendCooldown.inSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSeconds <= 1) {
        timer.cancel();
        setState(() => _resendSeconds = 0);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (!_canVerify) {
      if (_lockoutRemaining > Duration.zero) {
        setState(() => _errorMessage = _lockoutMessage());
      }
      return;
    }

    setState(() {
      _isVerifying = true;
      _verificationAttempts++;
      _errorMessage = null;
    });

    try {
      final verified = await widget.onVerify(_otp);
      if (!mounted) return;
      if (verified) {
        Navigator.of(context).pop(_sentMobile);
        return;
      }
      _clearOtp();
      if (_verificationAttempts >= _maxVerificationAttempts) {
        _startLockout();
      } else {
        setState(() {
          _errorMessage =
              'The OTP you entered is invalid. Please check it and try again.';
        });
      }
    } catch (error) {
      debugPrint(
          '[ABHA][UI][FLOW:${widget.flowId}] Mobile update OTP verification failed: $error');
      if (!mounted) return;
      _clearOtp();
      if (_verificationAttempts >= _maxVerificationAttempts) {
        _startLockout();
      } else {
        setState(() {
          _errorMessage =
              'Unable to verify the OTP. Please check it and try again.';
        });
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  void _startLockout() {
    _lockoutTimer?.cancel();
    setState(() {
      _lockoutRemaining = _lockoutDuration;
      _errorMessage = _lockoutMessage();
    });
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final remaining = _lockoutRemaining - const Duration(seconds: 1);
      if (remaining <= Duration.zero) {
        timer.cancel();
        setState(() {
          _lockoutRemaining = Duration.zero;
          _verificationAttempts = 0;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _lockoutRemaining = remaining;
          _errorMessage = _lockoutMessage();
        });
      }
    });
  }

  String _lockoutMessage() {
    final minutes = _lockoutRemaining.inMinutes;
    final seconds = _lockoutRemaining.inSeconds % 60;
    final remaining = minutes > 0
        ? '$minutes minute${minutes == 1 ? '' : 's'}'
        : '$seconds seconds';
    return 'You have entered an invalid OTP $_maxVerificationAttempts times. '
        'Please try again after 30 minutes. Time remaining: $remaining.';
  }

  void _clearOtp() {
    for (final controller in _otpControllers) {
      controller.clear();
    }
    if (mounted) setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
    });
  }

  void _onOtpChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      if (_otpControllers[index].text.isNotEmpty) {
        _otpControllers[index].clear();
      } else if (index > 0) {
        _otpFocusNodes[index - 1].requestFocus();
      }
    } else {
      _otpControllers[index].value = TextEditingValue(
        text: digits.substring(digits.length - 1),
        selection: const TextSelection.collapsed(offset: 1),
      );
      if (index < _otpFocusNodes.length - 1) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    }
    setState(() {});
  }

  void _onOtpKey(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _otpControllers[index].text.isEmpty &&
        index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOtpStep = _sentMobile != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Update Mobile Number'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F3F7)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child:
                    isOtpStep ? _buildOtpStep(theme) : _buildMobileStep(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileStep(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeading(theme, 'Enter your new mobile number'),
          const SizedBox(height: 24),
          TextFormField(
            controller: _mobileController,
            autofocus: true,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              labelText: 'New mobile number',
              counterText: '',
              prefixIcon: const Icon(Icons.phone_android_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || !RegExp(r'^\d{10}$').hasMatch(value)) {
                return 'Enter a valid 10-digit mobile number';
              }
              return null;
            },
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            _buildErrorMessage(),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSending ? null : _sendOtp,
              icon: _isSending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.sms_outlined),
              label: Text(_isSending ? 'Sending OTP...' : 'Send OTP'),
              style: _primaryButtonStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep(ThemeData theme) {
    final digitWidth =
        ((MediaQuery.of(context).size.width - 96) / 6).clamp(36.0, 52.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeading(theme, 'Verify your new mobile number'),
        const SizedBox(height: 8),
        Text(
          'Enter the 6-digit OTP sent to your mobile number.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'OTP requests: $_otpRequestCount/$_maxOtpRequests',
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: digitWidth,
              height: 58,
              child: Focus(
                onKeyEvent: (node, event) {
                  _onOtpKey(index, event);
                  return KeyEventResult.ignored;
                },
                child: TextFormField(
                  controller: _otpControllers[index],
                  focusNode: _otpFocusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLength: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFFEF4444), width: 2),
                    ),
                  ),
                  onChanged: (value) => _onOtpChanged(index, value),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Text(
          'Verification attempts: $_verificationAttempts/$_maxVerificationAttempts',
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            TextButton(
              onPressed: _isResending ||
                      _isVerifying ||
                      _resendSeconds > 0 ||
                      _otpRequestCount >= _maxOtpRequests ||
                      _lockoutRemaining > Duration.zero
                  ? null
                  : _resendOtp,
              child: Text(
                _otpRequestCount >= _maxOtpRequests
                    ? 'Resend limit reached'
                    : _isResending
                        ? 'Sending...'
                        : 'Resend OTP',
                style: const TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
            Text(
              _otpRequestCount >= _maxOtpRequests
                  ? 'No more resends'
                  : _resendSeconds > 0
                      ? 'Resend in ${_resendSeconds}s'
                      : 'Resend available',
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 4),
          _buildErrorMessage(),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _canVerify ? _verifyOtp : null,
            icon: _isVerifying
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.verified_rounded),
            label: Text(_isVerifying ? 'Verifying...' : 'Verify and Update'),
            style: _primaryButtonStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildHeading(ThemeData theme, String title) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.phone_android_outlined,
            color: Color(0xFFEF4444),
            size: 24,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Text(
      _errorMessage!,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.red, height: 1.3),
    );
  }

  ButtonStyle get _primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEF4444),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      );
}
