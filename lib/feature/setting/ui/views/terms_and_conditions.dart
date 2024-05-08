import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: const Row(
          children: [
            Text(
              'Terms and Conditions',
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'Effective Date: 20/1/2024\n\n'
                'Welcome to DUPLI! These terms and conditions ("Terms") govern your use of the DUPLI services, including any associated features, applications, and content (collectively referred to as the "Service"). By accessing or using DUPLI, you agree to comply with and be bound by these Terms.\n\n'
                '1. Acceptance of Terms\n\n'
                'By accessing or using DUPLI, you affirm that you have read, understood, and agree to be bound by these Terms. If you do not agree with any part of these Terms, you may not use DUPLI.\n\n'
                '2. Use of the Service\n\n'
                '2.1 Eligibility: You must be at least 18 years old or have the consent of a parent or legal guardian to use DUPLI.\n\n'
                '2.2 User Account: You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. Notify us immediately of any unauthorized use or security breach.\n\n'
                '2.3 User Conduct: You agree not to engage in any behavior that violates applicable laws, regulations, or these Terms. This includes but is not limited to the unauthorized use of DUPLI, interference with the service, and any form of harassment or abuse.\n\n'
                '3. Intellectual Property\n\n'
                '3.1 Ownership: All content and materials available on DUPLI, including but not limited to text, graphics, logos, images, and software, are the property of DUPLI or its licensors and are protected by intellectual property laws.\n\n'
                '3.2 License: By using DUPLI, you are granted a limited, non-exclusive, non-transferable license to access and use the Service for personal, non-commercial purposes.\n\n'
                '4. Privacy\n\n'
                'Your use of DUPLI is also governed by our Privacy Policy, which can be found [insert link to privacy policy].\n\n'
                '5. Termination\n\n'
                'DUPLI reserves the right to suspend or terminate your access to the Service at any time for any reason, including violation of these Terms.\n\n'
                '6. Limitation of Liability\n\n'
                'To the extent permitted by law, DUPLI and its affiliates shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues.\n\n'
                '7. Changes to Terms\n\n'
                'DUPLI reserves the right to modify or update these Terms at any time. Changes will be effective immediately upon posting to the DUPLI website. Your continued use of the Service after any such changes constitutes acceptance of the new Terms.\n\n'
                '8. Contact Us\n\n'
                'If you have any questions or concerns regarding these Terms, please contact us at dupli.aitwin@gmail.com\n\n'
                'By using DUPLI, you agree to these Terms. This agreement constitutes the entire understanding between you and DUPLI regarding your use of the Service.\n\n'
                'These Terms are effective as of 20/1/2024',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
