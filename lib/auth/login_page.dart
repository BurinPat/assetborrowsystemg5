import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // ✅ ใช้ AuthService เดิม
import 'register_page.dart'; // ✅ หน้า Register
import '../Frontend/Staff/staff_main.dart'; // ✅ ใช้ร่วมกับ Lecturer
import '../Frontend/Student/student_main.dart'; // ✅ หน้านักศึกษา
import '../Frontend/Lecturer/lecturer_main.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // ✅ Controller สำหรับช่องกรอกข้อมูล
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🔷 Blue box top-left
          Positioned(
            top: -50,
            left: -50,
            child: Transform.rotate(
              angle: 0.2,
              child: PhysicalModel(
                color: Colors.blue,
                elevation: 6,
                borderRadius: BorderRadius.zero,
                shape: BoxShape.rectangle,
                child: const SizedBox(width: 200, height: 200),
              ),
            ),
          ),

          // 🔷 Blue triangle bottom-right
          Positioned(
            bottom: 0,
            right: -20,
            child: Transform.rotate(
              angle: 3.14,
              child: PhysicalShape(
                clipper: BlueClipper(),
                color: Colors.blue,
                elevation: 6,
                child: const SizedBox(width: 200, height: 200),
              ),
            ),
          ),

          // 🔹 Login Form
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Username Field
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      suffixIcon:
                          const Icon(Icons.person_outline, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon:
                          const Icon(Icons.lock_outline, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final username = usernameController.text.trim();
                      final password = passwordController.text.trim();

                      if (username.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('⚠️ Please fill in all fields'),
                          ),
                        );
                        return;
                      }

                      try {
                        final response = await AuthService.login(
                          username: username,
                          password: password,
                        );

                        final data = jsonDecode(response.body);

                        if (response.statusCode == 200 && data['token'] != null) {
                          final fullName =
                              data['full_name']?.toString() ?? 'Unknown User';
                          final role =
                              data['role']?.toString().toUpperCase() ?? '';

                          if (role == 'STAFF') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StaffMain(fullName: fullName, role: role),
                              ),
                            );
                            } else if (role == 'LECTURER') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LecturerMain(fullName: fullName, role: role),
                              ),
                            );
                          } else if (role == 'STUDENT') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StudentMain(fullName: fullName, role: role),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('⚠️ Unknown role or unauthorized')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '❌ ${data['message'] ?? "Login failed"}'),
                            ),
                          );
                        }
                      } catch (e) {
                        print('❌ Login error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔹 Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 สร้างคลาสสำหรับวาดสามเหลี่ยมฟ้า
class BlueClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
