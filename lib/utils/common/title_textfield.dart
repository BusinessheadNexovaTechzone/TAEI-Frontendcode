import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui';

class TitleTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? title;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final OutlineInputBorder? border;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool? value1;
  final bool? filled;
  final Color? fillColor;
  final String? suffixText;
  final bool isRequired;

  const TitleTextFormField({
    super.key,
    this.title,
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.border,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.maxLines,
    this.value1,
    this.suffixText,
    this.filled = false,
    this.fillColor,
    this.isRequired = false,
  });

  @override
  State<TitleTextFormField> createState() => _TitleTextFormFieldState();
}

class _TitleTextFormFieldState extends State<TitleTextFormField> {
  late bool _obscure;
  late TextEditingController _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _internalController = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant TitleTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null &&
        widget.initialValue != null &&
        widget.initialValue != oldWidget.initialValue) {
      _internalController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   widget.title ?? '',
        //   style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       color: widget.isRequired ? Colors.red : Colors.black),
        // ),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (widget.isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),
        TextFormField(
          readOnly: widget.readOnly ?? false,
          maxLines: widget.maxLines ?? 1,
          controller: _effectiveController,
          keyboardType: widget.keyboardType,
          obscureText: _obscure,
          maxLength: widget.maxLength,
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.maxLength),
            ...?widget.inputFormatters,
          ],
          decoration: InputDecoration(
            /*suffix: widget.suffixText != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.suffixText!),
                      Icon(widget.suffixIcon),
                    ],
                  )
                : null,*/
            filled: widget.filled,
            fillColor: widget.fillColor,
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon:
                widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : widget.suffixIcon != null
                    ? Icon(widget.suffixIcon)
                    : null,
            border: widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: widget.validator,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}

class liquidTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? title;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final OutlineInputBorder? border;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLength;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const liquidTextFormField({
    super.key,
    this.title,
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.border,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLength,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  State<liquidTextFormField> createState() => _liquidTextFormFieldState();
}

class _liquidTextFormFieldState extends State<liquidTextFormField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null && widget.title!.isNotEmpty)
          Text(
            widget.title!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        if (widget.title != null) const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                readOnly: widget.readOnly ?? false,
                initialValue: widget.initialValue,
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                obscureText: _obscure,
                maxLength: widget.maxLength,
                style: const TextStyle(color: Colors.black),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(widget.maxLength),
                  ...?widget.inputFormatters,
                ],
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  labelStyle: const TextStyle(color: Colors.black87),
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(widget.prefixIcon, color: Colors.black87)
                      : null,
                  suffixIcon: widget.obscureText
                      ? IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  // No border since we use glass effect
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                validator: widget.validator,
                onChanged: widget.onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
