import 'package:flutter/material.dart';
import 'package:taei_gov/src/responsive.dart';

class CommonSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool isDesktop;
  final String hintText;
  final Color accentColor;

  const CommonSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.isDesktop = false,
    this.hintText = "Search",
    this.accentColor = Colors.blueAccent,
  });

  @override
  State<CommonSearchBar> createState() => _CommonSearchBarState();
}

class _CommonSearchBarState extends State<CommonSearchBar> {
  bool _showClear = false;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_updateClearIcon);
  }

  void _updateClearIcon() {
    setState(() {
      _showClear = widget.controller.text.isNotEmpty;
    });
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_updateClearIcon);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.isDesktop ? 320.0 : double.infinity;
    return Align(
      alignment: Alignment.topLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: width,
        height: 52,
        transform: Matrix4.identity()..scale(_isFocused ? 1.02 : 1.0),
        // slight zoom effect
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withOpacity(_isFocused ? 0.35 : 0.15),
              blurRadius: _isFocused ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            onChanged: widget.onChanged,
            cursorColor: widget.accentColor,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: widget.accentColor,
                size: 22,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.accentColor.withOpacity(0.3),
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.accentColor,
                  width: 1.6,
                ),
              ),
              suffixIcon: _showClear
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.redAccent),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onChanged?.call('');
                        setState(() => _showClear = false);
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

////////////

class NewCommonSearchField extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String hint;
  final double borderRadius;
  final EdgeInsets? padding;
  final IconData icon;

  const NewCommonSearchField({
    super.key,
    this.initialValue,
    this.onChanged,
    this.hint = "Search...",
    this.borderRadius = 12,
    this.padding,
    this.icon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    // Detect screen width
    final double width = MediaQuery.of(context).size.width;

    // Auto height, padding, font size
    final double fieldHeight = context.isDesktop ? 46 : 46;
    final double fontSize = context.isDesktop ? 15 : 14;
    final EdgeInsets contentPadding = context.isDesktop
        ? const EdgeInsets.symmetric(horizontal: 14, vertical: 14)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

    return Container(
      height: fieldHeight,
      width: context.isDesktop ? 320.0 : width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          prefixIcon: Icon(icon,
              color: Colors.blueGrey, size: context.isDesktop ? 22 : 20),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: fontSize,
          ),
          border: InputBorder.none,
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}
