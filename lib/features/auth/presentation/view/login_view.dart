// lib/features/auth/presentation/view/login_view.dart

import 'package:bidding_bazar/features/auth/presentation/view/signup_view.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // --- Theme Colors (Consistent with Signup View) ---
  static const Color primaryColor = Color(0xFF4CAF50); // A vibrant, eco-friendly green
  static const Color accentColor = Color(0xFF81C784);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Logo and Header ---
                Image.asset("assets/logo/bidding_logo.png", height: 120),
                const SizedBox(height: 16),
                const Text(
                  "Welcome Back!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const Text(
                  "Log in to continue your bidding journey",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // --- Form ---
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // --- Email TextField ---
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          prefixIcon: const Icon(Icons.email_outlined, color: primaryColor),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: primaryColor, width: 2.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // --- Password TextField ---
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          prefixIcon: const Icon(Icons.lock_outline, color: primaryColor),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: primaryColor, width: 2.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // --- Forgot Password ---
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                           
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Login Button ---
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginViewModel>().add(
                                    LoginIntoSystemEvent(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- OR Divider ---
                      const Row(
                        children: [
                          Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR", style: TextStyle(color: Colors.black45)),
                          ),
                          Expanded(child: Divider(thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- Google Login Button ---
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement Google Sign-In
                          },
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                          label: const Text(
                            "Continue with Google",
                            style: TextStyle(
                                fontSize: 16, color: textColor, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Signup Redirect ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?",
                              style: TextStyle(color: Colors.black54)),
                          TextButton(
                            onPressed: () {
                              context.read<LoginViewModel>().add(
                                    NavigateToSignupView(
                                      context: context,
                                      destination: SignupView(),
                                    ),
                                  );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}