import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:tele/controllers/auth_controller.dart';
import 'package:tele/views/auth/register_screen.dart';
import 'package:tele/views/screens/main_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 130, 13),
      body: Stack(
        children: [
          // Background
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 9, 130, 13),
            ),
          ),

          // Content
          Column(
            children: [
              const SizedBox(height: 100), // Push content down a bit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // White Container for the Form
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildTextField(Icons.person, 'Username or Email',
                              _emailController),
                          const SizedBox(height: 15),
                          buildPasswordField('Password', _passwordController),
                          const SizedBox(height: 20),
                          Obx(
                            () => authController.isLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 9, 130, 13),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 140, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        // If form is valid, proceed to next screen
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           MainScreen()),
                                        // );
                                        await authController.loginDoctorAndPatient(
                                          _emailController.text.trim(), 
                                          _passwordController.text.trim());
                                      }
                                    },
                                    child: const Text(
                                      "Log In",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 9, 130, 13)),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text("Don't have an account yet?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 9, 130, 13)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 9, 130, 13),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.help, color: Colors.white),
                            label: const Text(
                              "HELP",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to build text fields with validation
  Widget buildTextField(
      IconData icon, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          // prefixIcon: Icon(icon, color: const Color.fromARGB(255, 9, 130, 13)),
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.green),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your email or username";
          }
          return null;
        },
      ),
    );
  }

  // Function to build password field with validation
  Widget buildPasswordField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon:
              // const Icon(Icons.lock, color: Color.fromARGB(255, 9, 130, 13)),
              const Icon(Icons.lock, color: Colors.black),
          suffixIcon: const Icon(Icons.visibility,
              // color: Color.fromARGB(255, 9, 130, 13)),
              color: Colors.black),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your password";
          } else if (value.length < 6) {
            return "Password must be at least 6 characters";
          }
          return null;
        },
      ),
    );
  }
}
