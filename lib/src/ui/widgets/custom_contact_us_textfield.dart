import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors/colors.dart';

class ContactUsLabeledMandatoryTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isMandatory;
  final int maxLines;
  final int maxLength;
  final bool enabled;

  const ContactUsLabeledMandatoryTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isMandatory = false,
    this.maxLines = 1, // Default to single line
    this.maxLength = 5000,
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
                fontSize: 13,
                color: oWhite,
              ),
              children: [
                TextSpan(text: label),
                if (isMandatory)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: oWhite,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines, // Now using maxLines instead of maxLength
            maxLength: maxLength,
            enabled: enabled,
            validator: (value) {
              if (isMandatory && (value == null || value.isEmpty)) {
                return 'Mandatory to fill this field';
              }
              return validator?.call(value);
            },
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: oWhite,
            ),
            cursorColor: oWhite,
            decoration: InputDecoration(
              //filled: true,
              //fillColor: oWhite,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: oWhite),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: oWhite),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: oWhite),
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
                borderSide: BorderSide(color: oWhite),
                borderRadius: BorderRadius.circular(10),
              ),
              counterText: ''
            ),
          ),
        ],
      ),
    );
  }
}
