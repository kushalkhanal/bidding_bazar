import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:bidding_bazar/view/home_view.dart';

import 'package:bidding_bazar/features/auth/presentation/view/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatelessWidget {
   LoginView({super.key});


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Image.asset("assets/logo/bidding_logo.png", height: 150),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          labelText: "Username",
                          labelStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          hintText: "Password",
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (){
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
                            backgroundColor: const Color(0xFFFB3F39),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.red,
                          ),
                          label: const Text(
                            "Login with Google",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
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
