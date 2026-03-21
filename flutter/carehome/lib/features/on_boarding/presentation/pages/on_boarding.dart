import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/route/route_name.dart';
import '../widgets/onboarding_container.dart';

class OnboardingScreen extends StatefulWidget {
  static const routName = '/boarding';

  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  bool isFirstPage = true;

  final List<Widget> pages = [
    OnBoardingContainer(
      boardingnum: 1,
      title: "Find Care Facilities",
      description:
          "      Discover quality care homes across Ontario. Browse facilities, view their specialties, and find the perfect match for your needs. ",
    ),
    OnBoardingContainer(
      boardingnum: 2,
      title: "Connect with Caregivers",
      description:
          "Post job offers and connect with qualified PSW professionals. Review applications and find the best caregivers for your facility.",
    ),

    OnBoardingContainer(
      boardingnum: 3,
      title: "Manage Appointments",
      description:
          "Schedule and track appointments with ease. Stay organized with our intuitive calendar and notification system.",
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToAuth() {
    //   LocalStorgeServices.setBpol(LocalStorgeKey.isFirstTime, false);
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 10,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  isFirstPage = index == 0;
                  isLastPage = index == pages.length - 1;
                });
              },
              itemBuilder: (_, index) => pages[index],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isLastPage) {
                      goToAuth();
                    } else {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    isLastPage ? "Finish" : "Next",
                    style: Theme.of(
                      context,
                    )
                        .textTheme.titleMedium!.copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                ?isFirstPage
                    ? null
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: TColors.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          style: Theme.of(context).elevatedButtonTheme.style
                              ?.copyWith(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                              ),
                          onPressed: () {
                            if (_controller.page! > 0) {
                              _controller.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            "Back",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: TColors.darkBlue),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
