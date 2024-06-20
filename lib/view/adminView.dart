import 'package:darshan/view/adminStateView.dart';
import 'package:flutter/material.dart';

class AdminVew extends StatefulWidget {
  const AdminVew({super.key});

  @override
  State<AdminVew> createState() => _AdminVewState();
}

class _AdminVewState extends State<AdminVew> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter Email"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter Password"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (emailController.text == "gyanendra@fiitjee.com" &&
                      passController.text == "Gyan@1234") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminStateView()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid Entry !!!!")));
                  }
                },
                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    width: double.infinity,
                    height: 50,
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ))))
          ],
        ),
      ),
    );
  }
}
