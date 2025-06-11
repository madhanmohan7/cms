import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/logger.dart';
import '../../../widgets/custom_contact_us_buttons.dart';
import '../../../widgets/custom_contact_us_textfield.dart';


class ContactUsSection extends StatefulWidget {
  const ContactUsSection({super.key});

  @override
  State<ContactUsSection> createState() => _ContactUsSectionState();
}

class _ContactUsSectionState extends State<ContactUsSection> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    final String name = nameController.text;
    final String phone = phoneNumberController.text;
    final String email = emailController.text;
    final String description = descriptionController.text;

    // Encode query parameters to avoid issues with special characters
    final Uri mailUrl = Uri(
      scheme: 'mailto',
      path: 'mohanmadhan624@gmail.com',
      query: Uri.encodeFull(
        'subject=Contact from $name&body=Name: $name\nPhone: $phone\nEmail: $email\n\nDescription:\n$description',
      ),
    );

    // Debug statement to check the generated mailto URL
    LoggerUtil.getInstance.print('Mailto URL: $mailUrl');

    try {
      if (await canLaunchUrl(mailUrl)) {
        print('Launching mail client...');
        await launchUrl(mailUrl);

        // Clear text fields after successful email launch
        nameController.clear();
        phoneNumberController.clear();
        emailController.clear();
        descriptionController.clear();

        // Show success message
        LoggerUtil.getInstance.print('Mail sent successfully!');
      } else {
        LoggerUtil.getInstance.print('Could not launch mail client.');

      }
    } catch (e) {
      LoggerUtil.getInstance.print('Error launching mail client: $e');

    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width * 0.38,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/contact.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(25),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Us",
                  style: GoogleFonts.poppins(
                    color: oWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 650,
                  height: MediaQuery.of(context).size.width * 0.305,
                  decoration: BoxDecoration(
                    gradient: oTransparentGradient1,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ContactUsLabeledMandatoryTextField(
                                label: 'Name',
                                controller: nameController,
                                validator: (value) {
                                  if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value ?? '')) {
                                    return 'Enter a valid name with alphabets only';
                                  }
                                  return null;
                                },
                                isMandatory: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ContactUsLabeledMandatoryTextField(
                                label: 'Phone Number',
                                controller: phoneNumberController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (value) {
                                  if (!RegExp(r'^(\+91|1)?[0-9]{10}$').hasMatch(value ?? '')) {
                                    return 'Enter a valid phone number';
                                  }
                                  return null;
                                },
                                isMandatory: true,
                              ),
                            ),
                          ],
                        ),
                        ContactUsLabeledMandatoryTextField(
                          label: 'Email ID',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            const pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            if (!RegExp(pattern).hasMatch(value ?? '')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          isMandatory: true,
                        ),
                        ContactUsLabeledMandatoryTextField(
                          label: 'Description',
                          controller: descriptionController,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                          isMandatory: true,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _sendEmail();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(oTransparent),
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                                  (Set<MaterialState> states) {
                                return const BorderSide(color: oWhite, width: 1);
                              },
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            maximumSize: MaterialStateProperty.all(const Size(180, 50)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'icons/send.svg',
                                  color: oWhite,
                                  width: 22,
                                  height: 22,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Send Us",
                                  style: GoogleFonts.poppins(
                                    color: oWhite,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                ChatButton(
                  imagePath: 'icons/chat1.png',
                  buttonText: 'Chat Us',
                ),
                const SizedBox(height: 15),
                ChatButton(
                  imagePath: 'icons/mail.png',
                  buttonText: 'Mail Us',
                ),
                const SizedBox(height: 15),
                ChatButton(
                  imagePath: 'icons/call.png',
                  buttonText: 'Call Us',
                ),
                const SizedBox(height: 15),
                ChatButton(
                  imagePath: 'icons/sms.png',
                  buttonText: 'SMS Us',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                // TextButton(
                //     onPressed: (){
                //       Navigation.navigate(context, ChatScreen());
                //     },
                //     child: Text(
                //       "AI CHAT",
                //       style: GoogleFonts.poppins(
                //         color: oWhite,
                //         fontSize: 20
                //       ),
                //     )
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
