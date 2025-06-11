import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors/colors.dart';


class LabeledMandatoryTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isMandatory;
  final bool enabled;

  const LabeledMandatoryTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isMandatory = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: oBlack,
              ),
              children: [
                TextSpan(text: label),
                if (isMandatory)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: oRed,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: enabled,
            validator: (value) {
              if (isMandatory && (value == null || value.isEmpty)) {
                return 'Mandatory to fill this field';
              }
              return validator?.call(value);
            },
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: oBlack,
            ),
            cursorColor: oBlack,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: oBlackOpacity),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: oBlackOpacity),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: oBlackOpacity),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: oRed),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: oRed),
                borderRadius: BorderRadius.circular(10),
              ),
              errorStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: oRed,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: oBlackOpacity),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
