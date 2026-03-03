import 'package:carehome/core/route/route_name.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/image_strings.dart';
import '../../../layout/bottom_navegation_bar.dart';

class ChooseAccountTypeScreen extends StatelessWidget {
  const ChooseAccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Header Image
            Container(
              height: 200,

              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(TImages.logoRemove)),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Title
            const Text(
              "Choose Account Type",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              "Select the type of account you want to create",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// 🔹 Locum Account
            _accountCard(
              context: context,
              icon: Icons.sync_alt,
              title: "Locum Account",
              subtitle: "Register as a Locum (PSW)",
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) => CBottomNavigationBar(role: "PSW"),
                // ));
                Navigator.pushNamed(context, RouteNames.PSWregister);
              },
            ),

            const SizedBox(height: 20),

            /// 🔹 Organisation Account
            _accountCard(
              context: context,
              icon: Icons.groups,
              title: "Care Home Account",
              subtitle: "Register as a Care Home",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.registerOrganization);
              },
            ),

            const Spacer(),

            /// 🔹 Sign In
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an account? ", style: TextStyle(fontSize: 15)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, RouteNames.login);
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 15,
                      color: TColors.PrimaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _accountCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: TColors.primary, width: 2),
          ),
          child: Row(
            children: [
              /// Icon Circle
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffF5F5F5),
                ),
                child: Icon(icon, size: 30, color: TColors.primary),
              ),

              const SizedBox(width: 15),

              /// Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
