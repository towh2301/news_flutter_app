import 'package:flutter/material.dart';
import 'package:news_flutter_app/common/colors.dart';
import 'package:news_flutter_app/common/custom_button.dart';
import 'package:news_flutter_app/pages/authenticate_pages/sign_in.dart';
import 'package:news_flutter_app/pages/onboardpages/onboarding_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

List onBoardScreens = [
  {
    'title': 'Welcome!',
    'description': 'First and Foremost',
    'image': 'assets/images/onboarding1.png'
  },
  {
    'title': 'Let\'s explore!',
    'description': 'Second and More',
    'image': 'assets/images/onboarding2.png'
  },
  {
    'title': 'Get started!',
    'description': 'Second and More',
    'image': 'assets/images/onboarding3.png'
  },
];

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: PageView(
              controller: pageController,
              children: List.generate(
                  onBoardScreens.length, (index) => OnboardingView(index)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                SmoothPageIndicator(
                  controller: pageController,
                  count: onBoardScreens.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 20,
                    activeDotColor: AppColors.heading,
                    radius: 100,
                    dotColor: AppColors.lightText,
                  ),
                  onDotClicked: (index) {},
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // const GradientButton(
                    //   text: 'Get Started',
                    //   width: 150,
                    // ),
                    const Spacer(),
                    GradientButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => const AuthGate(),
                          ),
                        );
                      },
                      text: 'Skip',
                      fontSize: 20,
                      gradientColors: const [AppColors.white, AppColors.white],
                      textColor: const Color.fromARGB(255, 26, 26, 26),
                      width: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
