import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateMobileOtpDialog extends StatefulWidget {
  const UpdateMobileOtpDialog({
    super.key,
    required this.flowId,
    required this.onVerify,
    this.onResend,
    this.message,
    this.profileId,
    this.txnId,
  });

  final String flowId;
  final Future<bool> Function(String otp) onVerify;
  final Future<bool> Function()? onResend;
  final String? message;
  final int? profileId;
  final String? txnId;

  @override
  State<UpdateMobileOtpDialog> createState() => _UpdateMobileOtpDialogState();
}

class _UpdateMobileOtpDialogState extends State<UpdateMobileOtpDialog> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;
  bool _isResending = false;
  bool _completed = false;
  int _verificationAttempts = 0;
  Duration _lockoutRemaining = Duration.zero;
  Timer? _lockoutTimer;
  String? _errorMessage;

  static const int _maxVerificationAttempts = 3;
  static const Duration _lockoutDuration = Duration(minutes: 30);

  String get otp => _controllers.map((c) => c.text).join();

  bool get isOtpComplete => otp.length == 6;

  bool get canVerify => isOtpComplete && !_isVerifying;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '[ABHA][UI][FLOW:${widget.flowId}] [OTP] update-mobile OTP dialog opened');
    debugPrint(
        '[ABHA][UI][FLOW:${widget.flowId}] [OTP] OTP fields initialized');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      debugPrint(
          '[ABHA][UI][FLOW:${widget.flowId}] [OTP] focusing first field');
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _clearOtp() {
    for (final controller in _controllers) {
      controller.clear();
    }

    if (mounted) {
      setState(() {});
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNodes[0].requestFocus();
    });
  }

  void _updateOtpState() {
    final valueLength = otp.length;
    final otpComplete = valueLength == 6;

    debugPrint(
        '[ABHA][UI][FLOW:${widget.flowId}] [OTP] OTP length: $valueLength');
    debugPrint(
        '[ABHA][UI][FLOW:${widget.flowId}] [OTP] OTP complete: $otpComplete');

    if (otpComplete) {
      debugPrint(
          '[ABHA][UI][FLOW:${widget.flowId}] [OTP] Verify button enabled');
    }
  }

  void _onOtpChanged(int index, String value) {
    if (!mounted) return;

    final rawDigit = value.replaceAll(RegExp(r'\D'), '');
    final digit =
        rawDigit.isNotEmpty ? rawDigit.substring(rawDigit.length - 1) : '';

    if (_controllers[index].text != digit) {
      _controllers[index].value = TextEditingValue(
        text: digit,
        selection: TextSelection.collapsed(offset: digit.length),
      );
    }

    debugPrint(
        '[ABHA][UI][FLOW:${widget.flowId}] [OTP] entered digit at index $index');
    _updateOtpState();

    if (digit.isNotEmpty && index < 5) {
      debugPrint(
          '[ABHA][UI][FLOW:${widget.flowId}] [OTP] moving focus ${index} → ${index + 1}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _focusNodes[index + 1].requestFocus();
      });
    }

    if (index == 5 && digit.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onOtpKey(int index, RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        debugPrint(
            '[ABHA][UI][FLOW:${widget.flowId}] [OTP] backspace from empty field -> focus ${index - 1}');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _focusNodes[index - 1].requestFocus();
        });
      } else if (_controllers[index].text.isEmpty && index == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _focusNodes[0].requestFocus();
        });
      }
    }
  }

  Future<void> _resend() async {
    if (_isResending || _isVerifying || !mounted) return;
    if (_lockoutRemaining > Duration.zero) {
      setState(() => _errorMessage = _lockoutMessage());
      return;
    }

    _isResending = true;
    setState(() {});

    try {
      debugPrint('[ABHA][UI][FLOW:${widget.flowId}] [OTP] Resend pressed');
      _clearOtp();

      if (widget.onResend != null) {
        final sent = await widget.onResend!();
        if (!mounted) return;
        if (sent) {
          debugPrint(
              '[ABHA][UI][FLOW:${widget.flowId}] [OTP] OTP resent successfully');
        }
      }
    } finally {
      if (mounted) {
        _isResending = false;
        setState(() {});
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (!mounted) return;

    if (_lockoutRemaining > Duration.zero) {
      setState(() => _errorMessage = _lockoutMessage());
      return;
    }

    if (_isVerifying) {
      debugPrint(
        '[ABHA][UI][FLOW:${widget.flowId}] [OTP] Duplicate verification ignored',
      );
      return;
    }

    final enteredOtp = otp;

    if (enteredOtp.length != 6) {
      return;
    }

    _isVerifying = true;
    _verificationAttempts++;
    setState(() {});

    try {
      debugPrint('[ABHA][UI][FLOW:${widget.flowId}] [OTP] Verify pressed');
      debugPrint(
          '[ABHA][WORKFLOW][FLOW:${widget.flowId}] MOBILE OTP VERIFICATION STARTED');
      debugPrint(
          '[ABHA][WORKFLOW][FLOW:${widget.flowId}] Calling update-mobile/verify-otp');

      final success = await widget.onVerify(enteredOtp);

      if (!mounted) return;

      if (success) {
        debugPrint(
            '[ABHA][API][FLOW:${widget.flowId}] update-mobile/verify-otp SUCCESS');
        debugPrint(
            '[ABHA][WORKFLOW][FLOW:${widget.flowId}] MOBILE UPDATE SUCCESS');
        debugPrint(
            '[ABHA][UI][FLOW:${widget.flowId}] [OTP] Closing OTP dialog');
        debugPrint(
            '[ABHA][NAVIGATION][FLOW:${widget.flowId}] Opening abha_address_creation.dart');

        if (!_completed) {
          _completed = true;
          Navigator.of(context).pop(true);
        }
      } else {
        debugPrint(
            '[ABHA][UI][FLOW:${widget.flowId}] [OTP] verification failed; dialog remains open');
        if (_verificationAttempts >= _maxVerificationAttempts) {
          _startLockout();
        } else {
          setState(() => _errorMessage =
              'The OTP you entered is invalid. Please check the OTP and try again.');
        }
        _clearOtp();
      }
    } catch (e) {
      debugPrint(
          '[ABHA][UI][FLOW:${widget.flowId}] [OTP] verification exception: $e');
      if (_verificationAttempts >= _maxVerificationAttempts) {
        _startLockout();
      } else {
        setState(() => _errorMessage =
            'The OTP you entered is invalid. Please check the OTP and try again.');
      }
      _clearOtp();
    } finally {
      if (mounted) {
        _isVerifying = false;
        setState(() {});
      }
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
    return 'You have entered an invalid OTP $_maxVerificationAttempts times. Please try again after 30 minutes.\n\nTime remaining: $remaining.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify Mobile Number',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.message ??
                    'Enter the OTP sent to your registered mobile number.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF616161),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 44,
                    height: 52,
                    child: Focus(
                      onKey: (node, event) {
                        _onOtpKey(index, event);
                        return KeyEventResult.ignored;
                      },
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) => _onOtpChanged(index, value),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1.2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE53935),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, height: 1.3),
                ),
                const SizedBox(height: 16),
              ],
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: canVerify ? () async => _verifyOtp() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(_isVerifying ? 'Verifying...' : 'Verify'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _isVerifying || _isResending ? null : _resend,
                  child: const Text('Resend OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
