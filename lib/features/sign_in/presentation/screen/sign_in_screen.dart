import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/constants/values_manager.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/features/sign_in/data/auth.dart';
import 'package:team_egypt_v3/features/splash/presentation/screen/splash_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController emailCtrl = TextEditingController(
    text: "yomnahagag43@gmail.com",
  );
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: ScreenSize.width * 0.35,
          padding: EdgeInsets.all(AppPadding.p12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(RadiusSize.r12),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Login', style: Theme.of(context).textTheme.displayLarge),

              SizedBox(height: AppSize.s10),

              CustomTextField(controller: emailCtrl, hint: "Email"),

              SizedBox(height: AppSize.s10),

              CustomTextField(controller: passwordCtrl, hint: "Password"),

              SizedBox(height: AppSize.s10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(AppPadding.p4),
                  ),
                  onPressed: () async {
                    final auth = AuthService();
                    try {
                      final res = await auth.signIn(
                        email: emailCtrl.text.trim(),
                        password: passwordCtrl.text,
                      );
                      if (res != null && res.user != null) {
                        // Navigate to your home page or dashboard
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SplashScreen(),
                          ),
                        );
                      }
                    } catch (e) {
                      // Show an error snackbar/dialog
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },

                  child: Text('Login'),
                ),
              ),
              SizedBox(height: AppSize.s10),
            ],
          ),
        ),
      ),
    );
  }
}
