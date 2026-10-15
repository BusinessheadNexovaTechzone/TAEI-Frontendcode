import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateMobileOtpDialog extends StatefulWidget {
  const UpdateMobileOtpDialog({
    super.key,
    required this.flowId,
    required this.profileId,
    required this.txnId,
    required this.message,
    required this.onVerify,
    required this.onResend,
  });

  final String flowId;
  final int profileId;
  final String txnId;
  final String message;
  final Future<bool> Function(String otp) onVerify;
  final Future<bool> Function() onResend;

  @override
  State<UpdateMobileOtpDialog> createState() => _UpdateMobileOtpDialogState();
}

class _UpdateMobileOtpDialogState extends State<UpdateMobileOtpDialog> {
  static const int _maxOtpRequests = 3;
  static const int _maxVerificationAttempts = 3;
  static const Duration _resendCooldown = Duration(seconds: 60);
  static const Duration _lockoutDuration = Duration(minutes: 30);

  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());

  Timer? _resendTimer;
  Timer? _lockoutTimer;
  String? _errorMessage;
  int _otpRequestCount = 1;
  int _verificationAttempts = 0;
  int _resendSeconds = _resendCooldown.inSeconds;
  Duration _lockoutRemaining = Duration.zero;
  bool _isVerifying = false;
  bool _isResending = false;

  String get _otp => _otpControllers.map((controller) => controller.text).join();

  bool get _hasTransaction => widget.profileId > 0 && widget.txnId.isNotEmpty;

  bool get _canVerify =>
      _hasTransaction &&
      _otp.length == 6 &&
      !_isVerifying &&
      _lockoutRemaining == Duration.zero &&
      _verificationAttempts < _maxVerificationAttempts;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) FocusScope.of(context).requestFocus(_otpFocusNodes.first);
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _lockoutTimer?.cancel();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
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

  Future<void> _resendOtp() async {
    if (_isResending ||
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
      final sent = await widget.onResend();
      if (!mounted) return;
      if (sent) {
        setState(() => _otpRequestCount++);
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

  Future<void> _verifyOtp() async {
    if (!_canVerify) return;

    setState(() {
      _isVerifying = true;
      _verificationAttempts++;
      _errorMessage = null;
    });

    try {
      final verified = await widget.onVerify(_otp);
      if (!mounted) return;
      if (verified) return;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) FocusScope.of(context).requestFocus(_otpFocusNodes.first);
    });
  }

  void _onOtpChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 1) {
      for (var i = 0; i < _otpControllers.length; i++) {
        _otpControllers[i].text = i < digits.length ? digits[i] : '';
      }
      FocusScope.of(context).requestFocus(
        _otpFocusNodes[digits.length.clamp(0, _otpFocusNodes.length - 1)],
      );
    } else {
      _otpControllers[index].text = digits;
      if (digits.isNotEmpty && index < _otpFocusNodes.length - 1) {
        FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
      } else if (digits.isEmpty && index > 0) {
        FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
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
    final digitWidth =
        ((MediaQuery.of(context).size.width - 112) / 6).clamp(36.0, 52.0);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                'Verify mobile number',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.message,
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpControllers.length, (index) {
                  return SizedBox(
                    width: digitWidth,
                    height: 58,
                    child: Focus(
                      onKeyEvent: (node, event) {
                        _onOtpKey(index, event);
                        return KeyEventResult.ignored;
                      },
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFEF4444),
                              width: 2,
                            ),
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
                'Verification attempts: '
                '$_verificationAttempts/$_maxVerificationAttempts',
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
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, height: 1.3),
                ),
              ] else if (!_hasTransaction) ...[
                const SizedBox(height: 4),
                const Text(
                  'Unable to verify this OTP request. Please request a new OTP.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, height: 1.3),
                ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
