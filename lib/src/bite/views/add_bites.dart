import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/save_submit_dialog.dart';
import '../../../utils/common/appbar.dart';
import '../../../utils/common/common_button.dart';
import '../../../utils/common/common_check_box_list.dart';
import '../../../utils/common/list_data_radio_button.dart';
import '../../../utils/common/new_common_date_time_picker.dart';
import '../../../utils/common/newchecklistbox.dart';
import '../../../utils/common/title_textfield.dart';
import '../../../utils/common/yes_or_no_radio_button.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../../utils/common/space.dart';
import '../../emo_user/model/emo_lookup_model.dart';
import '../../hang/model/hanging_model.dart';
import '../../hang/model/look_up.dart';
import '../../hospital/controller/hospital_controller.dart';
import '../../prem/controller/prem_controller.dart';
import '../../prem/controller/prem_controller.dart';
import '../controller/bites_controller.dart';
import '../model/bites_modelGet.dart';
import '../model/look_up_bites.dart';
import '../model/request_model.dart' as bites;

class BitesFormPage extends StatefulWidget {
  final String? id;
  final String? triageId;
  final bool? prem;
  final int? refFormId;
  final String? refId;

  const BitesFormPage(
      {super.key,
      this.id,
      this.triageId,
      this.prem = false,
      this.refId,
      this.refFormId});

  @override
  State<BitesFormPage> createState() => _BitesFormPageState();
}

class _BitesFormPageState extends State<BitesFormPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BitesController bitesController = Get.put(BitesController());
  final PremController prem = Get.put(PremController());
  HospitalController hospitalController = Get.put(HospitalController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    debugPrint(prem.refId.toString() + "kbfsdkfb");
    Future.delayed(Duration.zero, () async {
      bitesController.bitesModelRequest.value = bites.BitesStingsRequestModel(
          bitesStings: bites.BitesStings(),
          outcome: bites.OutcomeModel() // or whatever field your model contains
          );
      await hospitalController.getHospitalListData();

      await bitesController.getBitesLookup();
      if (widget.prem == true) {
        await bitesController.getBitesByTriageId(id: widget.triageId!);
      } else {
        await bitesController.getBitesByTriageId(id: widget.triageId!);
      }
      if (widget.id != null) {
        await bitesController.getBitesById(id: widget.id!);
      }
      if (widget.id == null) {
        bitesController.bitesModelRequest.update((val) {
          val?.bitesStings?.dateTimeOfEntry = DateTime.now().toIso8601String();
          val?.bitesStings?.dateOfAdmit = DateTime.now().toIso8601String();
        });
      }
    });
  }

  RxInt durationOfHospitalStay = 1.obs;

// When calculating duration
  void autoCalculation(String? dateOfAdmit, String? dischargeDate) {
    try {
      if (dateOfAdmit != null && dischargeDate != null) {
        final admit = DateTime.tryParse(dateOfAdmit);
        final discharge = DateTime.tryParse(dischargeDate);
        if (admit != null && discharge != null) {
          durationOfHospitalStay.value = discharge.difference(admit).inDays;
        } else {
          durationOfHospitalStay.value = 0;
        }
      } else {
        durationOfHospitalStay.value = 0;
      }
      setState(() {});
    } catch (_) {
      durationOfHospitalStay.value = 0;
    }
  }


  bool validateBitesStingsForm({required bool outcome}) {
    final bites = bitesController.bitesModelRequest.value;
    final modelBites = bites.bitesStings;
    final modelBitesOutcome = bites.outcome;

    // Step 0: Validation for all fields (single page form)
    // Since this is a single page form, we validate all required fields

    // 1. Patient Admission Validation
    if (modelBites?.patientAdmitted == null) {
      showValidationError("Please specify if patient was admitted");
      return false;
    }

    // If admitted is true, additional fields are required
    if (modelBites?.patientAdmitted == true) {
      if (modelBites?.nameOfDept == null ||
          modelBites!.nameOfDept!.isEmpty) {
        showValidationError("Name of The Admitting Department is required when patient is admitted");
        return false;
      }

      if (modelBites?.dateOfAdmit == null) {
        showValidationError("Date of Admission is required when patient is admitted");
        return false;
      }
    }

    // 2. Type of Bite/Sting Validation
    if (modelBites?.typeOfBiteSting == null) {
      showValidationError("Type of Bite/Sting is required");
      return false;
    }

    // 3. Type of Organism Validation
    if (modelBites?.typeOfOrganism == null) {
      showValidationError("Type of Organism is required");
      return false;
    }

    // 4. Venomous Type Validation (required field based on your UI with red asterisk)
    if (modelBites?.venomousType == null) {
      showValidationError("Venomous type selection is required");
      return false;
    }

    // If venomous type is "Other" (id: 6), validate other specification
    if (modelBites?.venomousType == 6 &&
        (modelBites?.oth_venomous_type == null ||
            modelBites!.oth_venomous_type!.isEmpty)) {
      showValidationError("Please specify other venom type");
      return false;
    }

    // 5. Symptoms at Presentation Validation
    if (modelBites?.symptomsAtPresentation == null ||
        modelBites!.symptomsAtPresentation!.isEmpty) {
      showValidationError("Please select at least one symptom at presentation");
      return false;
    }

    // 6. Anti-venom or anti-allergy treatment Validation
    if (modelBites?.antiVenomOrAllergyTreatmentName == null ||
        modelBites!.antiVenomOrAllergyTreatmentName!.isEmpty) {
      showValidationError("Anti-venom or anti-allergy treatment details are required");
      return false;
    }

    // // 7. Supportive Care Provided Validation
    // if (modelBites?.supportiveCareProvided == null) {
    //   showValidationError("Supportive Care Provided selection is required");
    //   return false;
    // }

    // // 8. Counseling before discharge Validation
    // if (modelBites?.counsellingProvidedBeforeDischarge == null) {
    //   showValidationError("Counseling provided before discharge status is required");
    //   return false;
    // }

    // 9. Duration of Hospital Stay Validation
    // if (durationOfHospitalStay.value <= 0) {
    //   showValidationError("Duration of hospital stay calculation is required");
    //   return false;
    // }

    // 10. Outcome Validation (only for non-prem mode)
    if (outcome == true) {
      if (modelBitesOutcome?.outcome == null) {
        showValidationError("Outcome is required");
        return false;
      }

      // switch (modelBitesOutcome?.outcome) {
      //   case 1: // Discharged
      //   case 2: // Outcome 2
      //   case 3: // Outcome 3
      //     if (modelBitesOutcome?.dischargeDate == null) {
      //       showValidationError("Discharge date is required for this outcome");
      //       return false;
      //     }
      //     break;
      //
      //   case 4: // Absconded
      //     if (modelBitesOutcome?.abscondedDate == null) {
      //       showValidationError("Absconded date is required");
      //       return false;
      //     }
      //     break;
      //
      //   case 5: // Death
      //     if (modelBitesOutcome?.deathDate == null) {
      //       showValidationError("Date of death is required");
      //       return false;
      //     }
      //
      //     if (modelBitesOutcome?.causeOfDeath == null ||
      //         modelBitesOutcome!.causeOfDeath!.isEmpty) {
      //       showValidationError("Cause of death is required");
      //       return false;
      //     }
      //     break;
      //
      //   case 6: // Referred
      //     if (modelBitesOutcome?.hospitalType == null) {
      //       showValidationError("Hospital type is required for referral");
      //       return false;
      //     }
      //
      //     if (modelBitesOutcome?.hospitalType == 1) {
      //       // TAEI Hospital
      //       if (modelBitesOutcome?.destinationHospital == null) {
      //         showValidationError("Destination TAEI hospital is required");
      //         return false;
      //       }
      //     } else if (modelBitesOutcome?.hospitalType == 2) {
      //       // Non-TAEI Hospital
      //       if (modelBitesOutcome?.destinationHospital == null) {
      //         showValidationError("Destination hospital is required for non-TAEI referral");
      //         return false;
      //       }
      //     }
      //
      //     if (modelBitesOutcome?.reasonForReferral == null) {
      //       showValidationError("Reason for referral is required");
      //       return false;
      //     }
      //
      //     if (modelBitesOutcome?.conditionOfPatient == null) {
      //       showValidationError("Condition of patient at referral is required");
      //       return false;
      //     }
      //
      //     if (modelBitesOutcome?.referringDoctor == null ||
      //         modelBitesOutcome!.referringDoctor!.isEmpty) {
      //       showValidationError("Referring doctor name is required");
      //       return false;
      //     }
      //
      //     if (modelBitesOutcome?.documentedTaeiSheet == null) {
      //       showValidationError(
      //           "Documentation in TAEI case sheet status is required");
      //       return false;
      //     }
      //     break;
      // }
    }

    return true;
  }


  void showValidationError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,

      // Mobile (Android/iOS)
      backgroundColor: const Color(0xFFD32F2F),
      // Material Design red 700
      textColor: Colors.white,

      // Web fix (very important!)
      webBgColor: "#d32f2f",
      // hex red
      webShowClose: false,

      fontSize: context.isDesktop ? 18.0 : 15.0,
    );
  }


// // In your UI
//   Obx(() {
//   return TitleTextFormField(
//   title: 'Duration of Hospital Stay (Days)',
//   hintText: 'Auto-calculated',
//   controller: bitesController.durationController.value,
//   readOnly: true,
//   keyboardType: TextInputType.number,
//   );
//   }),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
      appBar: CommonAppBar(id: widget.triageId, title: 'Bites/Stings Form'),
      body: Obx(() {
        if (bitesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final modelBites = bitesController.bitesModelRequest.value.bitesStings;
        final modelBitesOutcome =
            bitesController.bitesModelRequest.value.outcome;

        bitesController.bitesModelRequest.value.bitesStings?.refFormId =
            widget.refFormId == null ? 1 : widget.refFormId;
        bitesController.bitesModelRequest.value.bitesStings?.refId =
            widget.refId == null
                ? prem.refId
                : int.parse(widget.refId.toString());
        bitesController.bitesModelRequest.value.bitesStings?.triageId =
            int.parse(widget.triageId.toString());
        // bitesController.bitesModelRequest.value.outcome?.deathDate = null;
        // bitesController.bitesModelRequest.value.outcome?.abscondedDate = null;
        // bitesController.bitesModelRequest.value.outcome?.patientExitDate = null;
        // bitesController.bitesModelRequest.value.outcome?.dischargeDate = null;
        // bitesController.bitesModelRequest.value.outcome?.hospitalType = 1;
        // bitesController.bitesModelRequest.value.outcome?.destinationHospital =
        //     1;
        // bitesController.bitesModelRequest.value.outcome?.reasonForReferral = 1;
        // bitesController.bitesModelRequest.value.outcome?.conditionOfPatient = 1;
        //
        // bitesController.bitesModelRequest.value.bitesStings?.siteOfBiteSting =
        //     1;
        modelBitesOutcome?.deathDate = null;
        modelBitesOutcome?.deathDate = null;

        modelBitesOutcome?.causeOfDeath = null;
        modelBitesOutcome?.abscondedDate = null;

        // modelBitesOutcome?.;

        // bitesController.bitesModelRequest.value.outcome?.destinationHospital = 1;

        // bitesController.bitesModelRequest.value.outcome?.triageId = 111;

        // model
        // ..opPatient = OpPatient()
        // ..stemiAdmission = StemiAdmission()
        // ..stemiClinicalAssessment = StemiClinicalAssessment()

        // try {
        //   if (modelBites?.dateOfAdmit != null) {
        //     final admitDate = DateTime.tryParse(modelBites!.dateOfAdmit!);
        //     if (admitDate != null) {
        //       final dischargeDate = DateTime.now().add(const Duration(days: 5));
        //       durationOfStay = dischargeDate.difference(admitDate).inDays;
        //     }
        //   }
        // } catch (_) {
        //   durationOfStay = 0;
        // }

        return SafeArea(
          child: Container(
            margin: context.isDesktop
                ? EdgeInsets.only(left: 300, right: 300, top: 25, bottom: 20)
                : EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: context.isDesktop
                      ? Color(0xFF052B3A)
                      : Colors.transparent, // border color
                  width: 0.3 // border thickness
                  ),
            ),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                padding: context.isDesktop
                    ? EdgeInsets.only(left: 30, right: 30, top: 8, bottom: 8)
                    : EdgeInsets.all(10),
                child: Column(
                  spacing: 22,
                  children: [
                    const SizedBox(height: 8),
                    CommonDateTimeWidget(
                      title: "Date of Entry",
                      dateTime: modelBites?.dateTimeOfEntry ?? "",
                      onChanged: (picked) {
                        modelBites?.dateTimeOfEntry = picked;
                        bitesController.bitesModelRequest.refresh();
                      },
                    ),
                    // Patient Admitted
                    NewTitleYesRadio(
                      isRequired: true,
                      initialValue: modelBites?.patientAdmitted ?? false,
                      title: "Admission Details",
                      onChanged: (value) {
                        modelBites?.patientAdmitted = value;
                        bitesController.bitesModelRequest.refresh();
                      },
                    ),
                    if (modelBites?.patientAdmitted == true) ...[
                      TitleTextFormField(
                        isRequired: true,
                        title: "Name of Department",
                        hintText: "Enter Department",
                        initialValue: modelBites?.nameOfDept ?? "",
                        onChanged: (value) => modelBites?.nameOfDept = value,
                      ),
                      CommonDateTimeWidget(
                        isRequired: true,
                        title: "Date of Admission",
                        dateTime: modelBites?.dateOfAdmit ?? "",
                        onChanged: (picked) {
                          modelBites?.dateOfAdmit = picked;
                          autoCalculation(
                              bitesController.bitesModelRequest.value
                                  .bitesStings?.dateOfAdmit,
                              bitesController.bitesModelRequest.value.outcome
                                  ?.dischargeDate);
                          bitesController.bitesModelRequest.refresh();
                        },
                      ),
                    ],
                    // Type of Sting
                    // Obx(() {
                    //   final list =
                    //       bitesController.bitesLookUp.value.typeOfBiteSting ?? [];
                    //   return list.isEmpty
                    //       ? const Text("No Type of Sting available")
                    //       : NewTitleDropdown(
                    //           title: 'Type of Sting',
                    //           hint: 'Select Type',
                    //           items: list
                    //               .map((e) => {"id": e.id, "name": e.name})
                    //               .toList(),
                    //           selectedId: modelBites?.typeOfBiteSting,
                    //           onChanged: (val) {
                    //             modelBites?.typeOfBiteSting = val;
                    //             bitesController.bitesModelRequest.refresh();
                    //           },
                    //         );
                    // }),
                    // Obx(() {
                    //   final list =
                    //       bitesController.bitesLookUp.value.typeOfOrganism ?? [];
                    //   return list.isEmpty
                    //       ? const Text("No Type of Organism available")
                    //       : NewTitleDropdown(
                    //           title: 'Type of Organism',
                    //           hint: 'Select Type',
                    //           items: list
                    //               .map((e) => {"id": e.id, "name": e.name})
                    //               .toList(),
                    //           selectedId: modelBites?.typeOfOrganism,
                    //           onChanged: (val) {
                    //             modelBites?.typeOfOrganism = val;
                    //             bitesController.bitesModelRequest.refresh();
                    //           },
                    //         );
                    // }),
                    Obx(() {
                      final biteList =
                          bitesController.bitesLookUp.value.typeOfBiteSting ??
                              [];

                      if (biteList.isEmpty) {
                        return const Text(
                            "No Type of Bite/Sting values available");
                      }

                      // Selected Bite ID
                      final selectedBiteId = modelBites?.typeOfBiteSting;

                      // Selected Bite Name from lookup
                      final selectedBiteName = biteList
                          .firstWhere(
                            (d) => d.id == selectedBiteId,
                            orElse: () => TypeOfBiteSting(
                                id: 0, name: 'Types of Organisms'),
                          )
                          .name;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // 🩸 Type of Bite/Sting Dropdown
                          NewTitleDropdown(
                            isRequired:true,
                            title: "Type of Bite/Sting",
                            hint: 'Select Type',
                            items: biteList
                                .map((e) => {"id": e.id, "name": e.name})
                                .toList(),
                            selectedId: selectedBiteId,
                            onChanged: (value) {
                              // Update main type
                              modelBites?.typeOfBiteSting = value;
                              modelBites?.typeOfOrganism =
                                  null; // reset organism
                              bitesController.bitesModelRequest.refresh();

                              // Filter organisms based on selected bite
                              bitesController
                                  .filteredOrganismRefs.value = (bitesController
                                          .bitesLookUp.value.typeOfOrganism ??
                                      [])
                                  .where(
                                      (ref) => ref.typeOfBiteStingId == value)
                                  .toList();

                              debugPrint("Selected Bite/Sting ID: $value");
                            },
                          ),

                          const SizedBox(height: 16),

                          // 🧬 Type of Organism Dropdown (filtered)
                          Obx(() {
                            final filteredRefs =
                                bitesController.filteredOrganismRefs.value;

                            if (filteredRefs.isEmpty) {
                              return const Text(
                                  "No Type of Organism available");
                            }

                            // Remove duplicate IDs if any
                            final uniqueRefs = {
                              for (var e in filteredRefs) e.id: e
                            }.values.toList();

                            // Selected Organism ID
                            final selectedOrganismId =
                                modelBites?.typeOfOrganism;

                            // Ensure the selected ID exists in the current items
                            final isSelectedValid = uniqueRefs
                                .any((e) => e.id == selectedOrganismId);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NewTitleDropdown(
                                  isRequired: true,
                                  title:
                                      selectedBiteName ?? "Types of Organisms",
                                  hint: "Select Organism",
                                  items: uniqueRefs
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: isSelectedValid
                                      ? selectedOrganismId
                                      : null,
                                  // reset if invalid
                                  onChanged: (value) {
                                    modelBites?.typeOfOrganism = value;
                                    bitesController.bitesModelRequest.refresh();
                                    debugPrint("Selected Organism ID: $value");
                                  },
                                ),
                              ],
                            );
                          }),
                        ],
                      );
                    }),

                    Obx(() {
                      final list =
                          bitesController.bitesLookUp.value.venomousType ?? [];
                      if (list.isEmpty) {
                        return const Text("No Type of Sting available");
                      }
                      final selectedId = modelBites?.venomousType;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title:  Row(
                              children: [
                                Text(
                                  'If venomous, select the applicable type(s):',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
                                ),
                              ],
                            ),
                            initiallyExpanded: true,
                            tilePadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            childrenPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            children: list.map<Widget>((option) {
                              return RadioListTile<int>(
                                title: Text(option.name ?? ""),
                                value: option.id ?? 0,
                                groupValue: selectedId,
                                onChanged: (value) {
                                  if (value != null) {
                                    modelBites?.venomousType = value;
                                    bitesController.bitesModelRequest.refresh();
                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                    if (modelBites?.venomousType == 6) ...[
                      TitleTextFormField(
                        title: 'Other Venom Type',
                        hintText: '',
                        initialValue: modelBites?.oth_venomous_type ?? "",
                        onChanged: (val) {
                          modelBites?.oth_venomous_type = val.toString();
                          bitesController.bitesModelRequest.refresh();
                        },
                      ),
                    ],

                    Obx(() {
                      final lookupList = bitesController
                              .bitesLookUp.value.symptomsPresentation ??
                          [];

                      if (lookupList.isEmpty) {
                        return const Text(
                            "No Type of Signs/Symptoms available");
                      }

                      final options = lookupList
                          .map((e) => LooksUpItem(id: e.id, name: e.name))
                          .toList();

                      final selectedIds =
                          modelBites?.symptomsAtPresentation ?? [];

                      return NewCheckboxList(
                        isRequired: true,
                        title: "Symptoms at presentation",
                        options: options,
                        initialSelectedIndexes: selectedIds,
                        onChanged: (selectedValues) {
                          modelBites?.symptomsAtPresentation = selectedValues;
                          bitesController.bitesModelRequest.refresh();
                        },
                      );
                    }),

                    Obx(() {
                      final list =
                          bitesController.bitesLookUp.value.timeInterval ?? [];
                      return list.isEmpty
                          ? const Text("No Type of Organism available")
                          : NewTitleDropdown(
                              title:
                                  'Time elapsed between bite/sting and arrival at health facility: ',
                              hint: 'Select Type',
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId: 1,
                              onChanged: (val) {
                                modelBites?.timeinterval = val;
                                bitesController.bitesModelRequest.refresh();
                              },
                            );
                    }),
                    TitleTextFormField(
                      title: 'Signs of envenomation/allergic reaction',
                      hintText: '',
                      initialValue:
                          modelBites?.signsOfEnvenomationAllergicReaction ?? "",
                      // readOnly: true,
                      onChanged: (val) {
                        modelBites?.signsOfEnvenomationAllergicReaction =
                            val.toString();
                        bitesController.bitesModelRequest.refresh();
                      },
                    ),
                    TitleTextFormField(
                      title: 'Investigations performed (labs, toxicology)',
                      hintText: '',
                      initialValue: modelBites?.investigationsPerformed ?? "",
                      onChanged: (val) {
                        modelBites?.investigationsPerformed = val.toString();
                        bitesController.bitesModelRequest.refresh();
                      },
                    ),
                    NewTitleYesRadio(
                      title: "First aid given before arrival (Tourniquet)",
                      initialValue: modelBites?.firstAidGiven == 1,
                      onChanged: (bool value) {
                        modelBites?.firstAidGiven = value ? 1 : 0;
                        bitesController.bitesModelRequest.refresh();
                      },
                    ),
                    TitleTextFormField(
                      isRequired: true,
                      title:
                          'Anti-venom or anti-allergy treatment given (name, dosage, timing)',
                      hintText: '',
                      initialValue:
                          modelBites?.antiVenomOrAllergyTreatmentName ?? "",
                      onChanged: (val) {
                        modelBites?.antiVenomOrAllergyTreatmentName =
                            val.toString();
                        bitesController.bitesModelRequest.refresh();
                      },
                    ),
                    // Obx(() {
                    //   final list =
                    //       bitesController.bitesLookUp.value. ?? [];
                    //   return list.isEmpty
                    //       ? const Text("No Type of Organism available")
                    //       : NewTitleDropdown(
                    //     title: 'Symptoms at presentation',
                    //     hint: 'Select Type',
                    //     items: list
                    //         .map((e) => {"id": e.id, "name": e.name})
                    //         .toList(),
                    //     selectedId: modelBites?.siteOfBiteSting,
                    //     onChanged: (val) {
                    //       modelBites?.siteOfBiteSting = val;
                    //       bitesController.bitesModelRequest.refresh();
                    //     },
                    //   );
                    // }),
                    Obx(() {
                      final options = (bitesController
                                  .bitesLookUp.value.supportiveCareProvided ??
                              [])
                          .map((e) => LooksUpItem(id: e.id, name: e.name))
                          .toList();
                      return options.isEmpty
                          ? const Text("No supportive care options available")
                          : NewCustomRadioList(
                              title: 'Supportive Care Provided',
                              options: options,
                              initialId: modelBites?.supportiveCareProvided,
                              onChanged: (val) {
                                modelBites?.supportiveCareProvided = val;
                                bitesController.bitesModelRequest.refresh();
                              },
                            );
                    }),
                    NewTitleYesRadio(
                      title: "First aid given before arrival (Tourniquet)",
                      initialValue:
                          modelBites?.counsellingProvidedBeforeDischarge == 1,
                      onChanged: (bool value) {
                        modelBites?.counsellingProvidedBeforeDischarge =
                            value ? 1 : 0;
                        bitesController.bitesModelRequest.refresh();
                      },
                    ),
                    const Space(height: 12),
                    Obx(() {
                      return TitleTextFormField(
                        title: 'Duration of Hospital Stay (Days)',
                        hintText: 'Auto-calculated',
                        readOnly: true,
                        controller: TextEditingController(
                          text: durationOfHospitalStay.value.toString(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) {
                          modelBites?.counsellingProvidedBeforeDischarge =
                              int.parse(
                                  durationOfHospitalStay.value.toString());
                          bitesController.bitesModelRequest.refresh();
                        }, // prevent edits
                      );
                    }),
                    if (widget.prem == false) ...[
                      Obx(() {
                        final list =
                            bitesController.bitesLookUp.value.outcome ?? [];
                        return list.isEmpty
                            ? const Text("No Outcome available")
                            : NewTitleDropdown(
                          isRequired: true,
                                title: 'Outcome',
                                hint: 'Select Outcome',
                                items: list
                                    .map((e) => {"id": e.id, "name": e.name})
                                    .toList(),
                                selectedId: modelBitesOutcome?.outcome,
                                onChanged: (val) {
                                  bitesController.bitesModelRequest
                                      .update((req) {
                                    req ??= bites.BitesStingsRequestModel();
                                    req.outcome ??= bites.OutcomeModel();
                                    req.outcome!.outcome = val;
                                  });
                                  bitesController.bitesModelRequest.refresh();
                                },
                              );
                      }),
                      buildOutcomeFields(modelBitesOutcome),
                    ],

                    const SizedBox(height: 20),
                    widget.prem == true
                        ? CommonElevatedButtonM(
                            text: bitesController.notFound == true
                                ? 'Submit From Prem'
                                : 'Update From Prem',
                            onPressed: () async {
                              final reqData =
                                  bitesController.bitesModelRequest.value;
                              bool success = false;

                              if (bitesController.notFound == true) {
                                // Create new record
                                success = await bitesController.createBites(
                                    data: reqData);
                              } else {
                                debugPrint(
                                    "Updating record with ID: ${widget.id}");
                                success = await bitesController.updateBites(
                                  data: reqData,
                                  id: bitesController
                                      .bitesModelRequest.value.bitesStings!.id
                                      .toString(),
                                );
                              }
                              if (success) {
                                Navigator.pop(context, true);
                                Navigator.pop(context,
                                    true); // Close form and return success
                              }
                            },
                          )
                        : CommonElevatedButtonM(
                            text: widget.id == null ? 'Submit' : 'Update',
                            onPressed: () async {
                              final reqData =
                                  bitesController.bitesModelRequest.value;
                              bool success = false;
                              //
                              // if (widget.id == null) {
                              //   // Create new record
                              //   success = await bitesController.createBites(
                              //       data: reqData);
                              // } else {
                              //   debugPrint(
                              //       "Updating record with ID: ${widget.id}");
                              //   success = await bitesController.updateBites(
                              //     data: reqData,
                              //     id: widget.id!,
                              //   );
                              // }
                              //
                              // if (success) {
                              //   Navigator.pop(context,
                              //       true); // Close form and return success
                              // }

                              /// Save or Submit
                              showDialog(
                                context: context,
                                builder: (context) => SaveOrSubmitDialog(
                                  title: 'Save or Submit',
                                  content: 'Do you want to save or submit?',
                                  onSave: () async {
                                    if(!validateBitesStingsForm(outcome: false))return;
                                    bool success = false;
                                    reqData.outcome!.isDischarged = false;
                                    if (widget.id == null) {
                                      // Create new record

                                      success = await bitesController
                                          .createBites(data: reqData);
                                      Get.back();
                                    } else {
                                      debugPrint(
                                          "Updating record with ID: ${widget.id}");
                                      success =
                                          await bitesController.updateBites(
                                        data: reqData,
                                        id: widget.id!,
                                      );
                                      Get.back();
                                    }

                                    if (success) {
                                      Navigator.pop(context,
                                          true); // Close form and return success
                                    }
                                  },
                                  onSubmit: () async {
                                    if(!validateBitesStingsForm(outcome: true))return;

                                    bool success = false;
                                    reqData.outcome!.isDischarged = true;

                                    if (widget.id == null) {
                                      // Create new record
                                      success = await bitesController
                                          .createBites(data: reqData);
                                      Get.back();
                                    } else {
                                      debugPrint(
                                          "Updating record with ID: ${widget.id}");
                                      success =
                                          await bitesController.updateBites(
                                        data: reqData,
                                        id: widget.id!,
                                      );
                                      Get.back();
                                    }

                                    if (success) {
                                      Navigator.pop(context,
                                          true); // Close form and return success
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildOutcomeFields(bites.OutcomeModel? model1) {
    final now = DateTime.now();

    switch (model1?.outcome) {
      case 1: // Discharged
      case 2: // Discharge at Request
      case 3: // DAMA
        return CommonDateTimeWidget(
          title: "Date & Time of Discharge",
          dateTime: model1?.dischargeDate ?? now.toIso8601String(),
          onChanged: (picked) {
            bitesController.bitesModelRequest.update((req) {
              req ??= bites.BitesStingsRequestModel();
              req.outcome ??= bites.OutcomeModel();
              req.outcome!.dischargeDate = picked;
            });

            autoCalculation(
              bitesController.bitesModelRequest.value.bitesStings?.dateOfAdmit,
              bitesController.bitesModelRequest.value.outcome?.dischargeDate,
            );
          },
        );

      case 4: // Absconded
        return CommonDateTimeWidget(
          title: "Date & Time Absconded",
          dateTime: model1?.abscondedDate ?? now.toIso8601String(),
          onChanged: (picked) {
            bitesController.bitesModelRequest.update((req) {
              req ??= bites.BitesStingsRequestModel();
              req.outcome ??= bites.OutcomeModel();
              req.outcome!.abscondedDate = picked;
            });
          },
        );

      case 5: // Death
        return Column(
          children: [
            CommonDateTimeWidget(
              title: "Date & Time of Death",
              dateTime: model1?.deathDate ?? now.toIso8601String(),
              onChanged: (picked) {
                bitesController.bitesModelRequest.update((req) {
                  req ??= bites.BitesStingsRequestModel();
                  req.outcome ??= bites.OutcomeModel();
                  req.outcome!.deathDate = picked;
                });
              },
            ),
            TitleTextFormField(
              title: "Cause of Death",
              hintText: "Enter Cause",
              initialValue: model1?.causeOfDeath,
              onChanged: (val) {
                bitesController.bitesModelRequest.update((req) {
                  req ??= bites.BitesStingsRequestModel();
                  req.outcome ??= bites.OutcomeModel();
                  req.outcome!.causeOfDeath = val;
                });
              },
            ),
          ],
        );

      case 6: // Transferred to Other Hospital
        return Column(
          children: [
            Obx(() {
              final list = bitesController.bitesLookUp.value.hospitalType ?? [];
              if (list.isEmpty)
                return const Text("No hospital types available");
              return NewTitleDropdown(
                title: 'Hospital Type',
                hint: 'Select Type',
                items: list.map((e) => {"id": e.id, "name": e.name}).toList(),
                selectedId: model1?.hospitalType,
                onChanged: (val) {
                  bitesController.bitesModelRequest.update((req) {
                    req ??= bites.BitesStingsRequestModel();
                    req.outcome ??= bites.OutcomeModel();
                    req.outcome!.hospitalType = val;
                  });
                },
              );
            }),
            Obx(() => Column(
                  children: [
                    if (bitesController
                            .bitesModelRequest.value.outcome?.hospitalType ==
                        1)
                      NewTitleDropdown(
                        title: "Destination Hospital",
                        hint: "Select Destination Type",
                        items: hospitalController.hospitalList
                            .map((e) => e.toJson())
                            .toList(),
                        // ✅ convert to List<Map>
                        selectedId: model1?.destinationTaeiHospital,
                        onChanged: (val) {
                          bitesController.bitesModelRequest.update((req) {
                            req ??= bites.BitesStingsRequestModel();
                            req.outcome ??= bites.OutcomeModel();
                            req.outcome!.destinationTaeiHospital = val;
                          });
                        },
                      ),
                    if (bitesController
                            .bitesModelRequest.value.outcome?.hospitalType ==
                        2)
                      TitleTextFormField(
                        title: "Destination Non TAEI Hospital",
                        hintText: "Enter Destination Non TAEI Hospital",
                        initialValue: model1?.destinationHospital,
                        onChanged: (val) {
                          bitesController.bitesModelRequest.update((req) {
                            req ??= bites.BitesStingsRequestModel();
                            req.outcome ??= bites.OutcomeModel();
                            req.outcome!.destinationHospital = val;
                          });
                        },
                      ),
                  ],
                )),
            // Obx(() {
            //   final list =
            //       bitesController.bitesLookUp.value.destinationHospital ?? [];
            //   if (list.isEmpty)
            //     return const Text("No destination hospitals available");
            //   return NewTitleDropdown(
            //     title: 'Destination Hospital',
            //     hint: 'Select Hospital',
            //     items: list.map((e) => {"id": e.id, "name": e.name}).toList(),
            //     selectedId: model1?.destinationHospital,
            //     onChanged: (val) {
            //       bitesController.bitesModelRequest.update((req) {
            //         req ??= bites.BitesStingsRequestModel();
            //         req.outcome ??= bites.OutcomeModel();
            //         req.outcome!.destinationHospital = val;
            //       });
            //     },
            //   );
            // }),

            Obx(() {
              final list =
                  bitesController.bitesLookUp.value.reasonForReferral ?? [];
              if (list.isEmpty)
                return const Text("No referral reasons available");
              return NewTitleDropdown(
                title: "Reason for Referral",
                hint: 'Select Reason',
                items: list.map((e) => {"id": e.id, "name": e.name}).toList(),
                selectedId: model1?.reasonForReferral,
                onChanged: (val) {
                  bitesController.bitesModelRequest.update((req) {
                    req ??= bites.BitesStingsRequestModel();
                    req.outcome ??= bites.OutcomeModel();
                    req.outcome!.reasonForReferral = val;
                  });
                },
              );
            }),
            Obx(() {
              final list =
                  bitesController.bitesLookUp.value.conditionOfPatient ?? [];
              if (list.isEmpty)
                return const Text("No condition options available");
              return NewTitleDropdown(
                title: 'Condition of Patient',
                hint: 'Select Condition',
                items: list.map((e) => {"id": e.id, "name": e.name}).toList(),
                selectedId: model1?.conditionOfPatient,
                onChanged: (val) {
                  bitesController.bitesModelRequest.update((req) {
                    req ??= bites.BitesStingsRequestModel();
                    req.outcome ??= bites.OutcomeModel();
                    req.outcome!.conditionOfPatient = val;
                  });
                },
              );
            }),
            TitleTextFormField(
              title: "Referring Doctor (Name)",
              hintText: "Enter Name",
              initialValue: model1?.referringDoctor,
              onChanged: (val) {
                bitesController.bitesModelRequest.update((req) {
                  req ??= bites.BitesStingsRequestModel();
                  req.outcome ??= bites.OutcomeModel();
                  req.outcome!.referringDoctor = val;
                });
              },
            ),
            NewTitleYesRadio(
              initialValue: model1?.documentedTaeiSheet ?? false,
              title: "Details documented in TAEI Case Sheet",
              onChanged: (value) {
                bitesController.bitesModelRequest.update((req) {
                  req ??= bites.BitesStingsRequestModel();
                  req.outcome ??= bites.OutcomeModel();
                  req.outcome!.documentedTaeiSheet = value;
                });
              },
            ),
          ],
        );

      case 7: // Treated as OP
        return CommonDateTimeWidget(
          title: "Date & Time of Patient Exit",
          dateTime: model1?.patientExitDate ?? now.toIso8601String(),
          onChanged: (picked) {
            bitesController.bitesModelRequest.update((req) {
              req ??= bites.BitesStingsRequestModel();
              req.outcome ??= bites.OutcomeModel();
              req.outcome!.patientExitDate = picked;
            });
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
