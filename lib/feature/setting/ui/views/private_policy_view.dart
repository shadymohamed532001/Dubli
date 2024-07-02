import 'package:dupli/core/helper/naviagtion_extentaions.dart';
import 'package:dupli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PrivatePolicyView extends StatelessWidget {
  const PrivatePolicyView({super.key});

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
              'Private policy',
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
                'Effective Date: 20/1/2024',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.whiteColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Thank you for using DUPLI. This Privacy Policy outlines the information we collect, how we use it, and the choices you have concerning your data. By using our services, you consent to the practices described in this policy.',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorManager.whiteColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '1. Information We Collect',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.whiteColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1.1 Information You Provide',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.whiteColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Personal Information: When you interact with DUPLI, we may collect personal information such as your name, email address, and other contact details.\n\nUser-Generated Content: We may collect information that you voluntarily share with DUPLI, such as messages, preferences, and other content.',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorManager.whiteColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '1.2 Information from AI Interactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.whiteColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'AI-Generated Data: DUPLI operates by processing and analyzing data to create an AI-generated twin. This may include information from your interactions with the AI, such as queries, preferences, and patterns.\n\nUsage Data: We collect information about your usage of DUPLI, including log data, device information, and other analytics to improve our services.',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorManager.whiteColor,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
