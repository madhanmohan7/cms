import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/commuinities_model.dart';
import '../../ui/widgets/custom_textfields.dart';
import '../../utils/colors/colors.dart';


class EditCommunityFormScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController communityNameController;
  final TextEditingController communityCodeController;
  final TextEditingController communityTotalChargersController;
  final Function(Uint8List?) onFileSelected;
  final Communities communities;

  const EditCommunityFormScreen({
    Key? key,
    required this.formKey,
    required this.communityNameController,
    required this.communityCodeController,
    required this.communityTotalChargersController,
    required this.onFileSelected,
    required this.communities,
  }) : super(key: key);

  @override
  _EditCommunityFormScreenState createState() => _EditCommunityFormScreenState();
}

class _EditCommunityFormScreenState extends State<EditCommunityFormScreen> {
  String? _pdfFileName;
  Uint8List? _pdfFileBytes;

  @override
  void initState() {
    super.initState();
    widget.communityNameController.text =
        widget.communities.organizationName ?? '';
    widget.communityCodeController.text =
        widget.communities.organizationCode ?? '';
    widget.communityTotalChargersController.text =
        widget.communities.totalChargers.toString();

    // Set the existing PDF file name if available
    //_pdfFileName = widget.communities.license;
  }

  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfFileName = result.files.single.name;
        _pdfFileBytes = result.files.single.bytes; // This will be non-null on web
        widget.onFileSelected(_pdfFileBytes); // Call the callback
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.35,
      height: MediaQuery
          .of(context)
          .size
          .width * 0.2,
      child: Scaffold(
        backgroundColor: oTransparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: widget.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabeledMandatoryTextField(
                    label: 'Community Name',
                    controller: widget.communityNameController,
                    validator: (value) {
                      if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value ?? '')) {
                        return 'Enter a valid name with alphabets only';
                      }
                      return null;
                    },
                    isMandatory: true,
                  ),

                  LabeledMandatoryTextField(
                    label: 'Community Code',
                    controller: widget.communityCodeController,
                    validator: (value) {
                      if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value ?? '')) {
                        return 'Enter a valid community code';
                      }
                      return null;
                    },
                    isMandatory: true,
                  ),

                  LabeledMandatoryTextField(
                    label: 'Permitted chargers for community',
                    controller: widget.communityTotalChargersController,
                    validator: (value) {
                      if (!RegExp(r"^[0-9]+$").hasMatch(value ?? '')) {
                        return 'Enter a permitted chargers';
                      }
                      return null;
                    },
                    isMandatory: true,
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 0.6, color: oBlackOpacity),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [

                        Text(
                          _pdfFileName != null
                              ? '$_pdfFileName'
                              : 'Select a updated license file (if available*)',
                          style: GoogleFonts.poppins(
                            color: _pdfFileName != null
                                ? oBlue
                                : oBlackOpacity,
                            fontSize: 14,
                          ),
                        ),
                        //const SizedBox(width: 10),
                        const Spacer(),
                        TextButton(
                          onPressed: _pickPdfFile,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              oBlack,
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: Text(
                            'Upload',
                            style: GoogleFonts.poppins(
                              color: oWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}