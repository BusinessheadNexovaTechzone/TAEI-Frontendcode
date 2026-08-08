import 'package:flutter/material.dart';

class YesNoRadio extends StatefulWidget {
  final String title;
  final ValueChanged<bool> onChanged; // Callback to return true/false

  const YesNoRadio({super.key, required this.title, required this.onChanged});

  @override
  _YesNoRadioState createState() => _YesNoRadioState();
}

class _YesNoRadioState extends State<YesNoRadio> {
  bool? isYes; // null = not selected yet

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isYes,
              onChanged: (value) {
                setState(() => isYes = value);
                widget.onChanged(true);
              },
            ),
            Text('Yes'),
            SizedBox(width: 20),
            Radio<bool>(
              value: false,
              groupValue: isYes,
              onChanged: (value) {
                setState(() => isYes = value);
                widget.onChanged(false);
              },
            ),
            Text('No'),
          ],
        ),
      ],
    );
  }
}

class TitleYesRadio extends FormField<String> {
  final String? title;

  TitleYesRadio({
    super.key,
    this.title,
    super.initialValue,
    required ValueChanged<String> onChanged,
    String? firstValue = 'Yes',
    String? secondValue = 'No',
    super.validator,
  }) : super(
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                firstValue != 'Yes' && secondValue != 'No'
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: "Yes",
                                groupValue: state.value,
                                onChanged: (value) {
                                  state.didChange(value);
                                  onChanged(value!);
                                },
                              ),
                              Text(firstValue!),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: "No",
                                groupValue: state.value,
                                onChanged: (value) {
                                  state.didChange(value);
                                  onChanged(value!);
                                },
                              ),
                              Text(secondValue!),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Radio<String>(
                            value: "Yes",
                            groupValue: state.value,
                            onChanged: (value) {
                              state.didChange(value);
                              onChanged(value!);
                            },
                          ),
                          Text(firstValue!),
                          SizedBox(width: 20),
                          Radio<String>(
                            value: "No",
                            groupValue: state.value,
                            onChanged: (value) {
                              state.didChange(value);
                              onChanged(value!);
                            },
                          ),
                          Text(secondValue!),
                        ],
                      ),
                if (state.hasError) // Show error if validation fails
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      state.errorText ?? '',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}

class NewTitleYesRadio extends FormField<bool?> {
  final String? title;
  final String firstLabel;
  final String secondLabel;
  final bool isRequired;

  NewTitleYesRadio({
    Key? key,
    this.title,
    bool? initialValue,
    required ValueChanged<bool> onChanged,
    this.firstLabel = 'Yes',
    this.secondLabel = 'No',
    this.isRequired = false,
    FormFieldValidator<bool?>? validator,
  }) : super(
          key: key,
          initialValue: initialValue, // ✅ IMPORTANT
          validator: validator,
          builder: (FormFieldState<bool?> state) {
            final context = state.context;
            final bool isDesktop = MediaQuery.of(context).size.width > 900;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null && title!.isNotEmpty)
                  // Text(
                  //   title!,
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: isRequired ? Colors.red : Colors.black),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        if (isRequired)
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
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: state.value,
                      onChanged: (value) {
                        state.didChange(value);
                        onChanged(value!);
                      },
                    ),
                    Text(firstLabel),
                    SizedBox(
                      width: isDesktop
                          ? MediaQuery.of(context).size.width / 6
                          : 20,
                    ),
                    Radio<bool>(
                      value: false,
                      groupValue: state.value,
                      onChanged: (value) {
                        state.didChange(value);
                        onChanged(value!);
                      },
                    ),
                    Text(secondLabel),
                  ],
                ),
                const SizedBox(height: 10),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}

/*class NewTitleYesRadio extends FormField<bool> {

  final String? title;
  final String firstLabel;
  final String secondLabel;

  NewTitleYesRadio({
    Key? key,
    this.title,
    bool? initialValue,
    required ValueChanged<bool> onChanged,
    this.firstLabel = 'Yes',
    this.secondLabel = 'No',
    FormFieldValidator<bool>? validator,
  }) : super(
    key: key,
    initialValue: initialValue ?? false,
    validator: validator,
    builder: (FormFieldState<bool> state) {
      final context = state.context; // ✅ Access BuildContext properly

      final bool isDesktop =
          MediaQuery.of(context).size.width > 900; // ✅ Safe desktop check

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title!.isNotEmpty)
            Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: state.value,
                onChanged: (value) {
                  state.didChange(value);
                  onChanged(value ?? false);
                },
              ),
              Text(firstLabel),
              SizedBox(width: isDesktop ? MediaQuery.of(context).size.width/6 : 20),
              Radio<bool>(
                value: false,
                groupValue: state.value,
                onChanged: (value) {
                  state.didChange(value);
                  onChanged(value ?? false);
                },
              ),
              Text(secondLabel),
            ],
          ),
          SizedBox(height: 10,),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                state.errorText ?? '',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
    },
  );
}*/
