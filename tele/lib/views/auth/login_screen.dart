import 'package:flutter/material.dart';
import 'package:tele/views/auth/register_screen.dart';
import 'package:tele/views/screens/main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 9, 130, 13),
      body: Stack(

        children: [
          // Background with Gradient
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            decoration: const BoxDecoration(
             color: Color.fromARGB(255, 9, 130, 13)
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
                    // "Already have an account?",
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
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Colors.black26,
                      //     blurRadius: 10,
                      //     spreadRadius: 2,
                      //   )
                      // ],
                    ),
                    child: CircleAvatar(
                      radius: 26, // Slightly reduced to create a gap
                      backgroundColor: Colors
                          .white, // Matches the container to create a gap effect
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          width: 52, // Adjust according to the avatar size
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // **White Container for the Form**
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
                    child: Column(
                      children: [
                        buildTextField(Icons.person, 'Username or Email'),
                        const SizedBox(height: 15),
                        buildPasswordField('Password'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 9, 130, 13),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 140, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()),
                            );
                          },
                          child: const Text(
                            "Log In",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Color.fromARGB(255, 9, 130, 13)),
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
                            backgroundColor: Color.fromARGB(255, 9, 130, 13),
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
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
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
}

// Function to build text fields
Widget buildTextField(IconData icon, String hint) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 9, 130, 13)),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.green)),
      ),
    ),
  );
}

Widget buildPasswordField(String hint) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 9, 130, 13)),
        suffixIcon: const Icon(Icons.visibility, color: Color.fromARGB(255, 9, 130, 13)),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Colors.green, width: 2), // Border when focused
        ),
      ),
    ),
  );
}
