import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/colors.dart';
import 'package:news_flutter_app/common/customtext.dart';
import 'package:news_flutter_app/pages/onboardpages/onboard_screens.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView(this.index, {super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            height: MediaQuery.sizeOf(context).height * 0.5,
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/images/onboarding${index + 1}.png'),
          ),
          CustomText(
            text: '${onBoardScreens[index]['title']}',
            textAlign: TextAlign.start,
            color: AppColors.heading,
            height: 1.1,
            fontSize: 33,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          CustomText(
            text: '${onBoardScreens[index]['description']}',
            textAlign: TextAlign.start,
            fontFamily: 'outfit',
            color: AppColors.text,
            height: 1,
            maxLines: 6,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
