import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:taei_gov/src/stemi/controller/stemi_controller.dart';
import 'package:taei_gov/src/stemi/model/request_model.dart';
import 'package:taei_gov/utils/common/common_drop_down.dart';
import 'package:taei_gov/utils/common/title_textfield.dart';

class ReusableAddressWidget extends StatefulWidget {
  final String title;
  final OpPatient? op;
  final StemiController? stemiController;

  const ReusableAddressWidget({
    Key? key,
    required this.title,
    this.op,
    this.stemiController,
  }) : super(key: key);

  @override
  State<ReusableAddressWidget> createState() => _ReusableAddressWidgetState();
}

class _ReusableAddressWidgetState extends State<ReusableAddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 25,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextFormField(
          initialValue: widget.op?.addressLine,
          maxLines: 3,
          onChanged: (val) => widget.op?.addressLine = val,
        ),
        Obx(() {
          final list = widget.stemiController?.stemiLookup.value.triageResponse
              ?.district ??
              [];
          if (list.isEmpty) return const Text("No districts available");

          return NewTitleDropdown(
            title: "District",
            hint: "Select District",
            items: list.map((e) => {"id": e.id, "name": e.name}).toList(),
            selectedId: widget.op?.district,
            onChanged: (val) {
              widget.op?.district = val;
              widget.stemiController?.stemiModel.refresh();
            },
          );
        }),
        Obx(() {
          final list =
              widget.stemiController?.stemiLookup.value.triageResponse?.state ??
                  [];
          if (list.isEmpty) return const Text("No states available");

          return NewTitleDropdown(
            title: "State",
            hint: "Select State",
            items: list.map((e) => {"id": e.id, "name": e.name}).toList(),
            selectedId: widget.op?.state,
            onChanged: (val) {
              widget.op?.state = val;
              widget.stemiController?.stemiModel.refresh();
            },
          );

        }),
        TitleTextFormField(
          title: "Pincode",
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          initialValue: widget.op?.pincode,
          onChanged: (val) => widget.op?.pincode = val,
        ),
      ],
    );
  }
}
