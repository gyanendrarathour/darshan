import 'package:flutter/material.dart';

class AdminVew extends StatefulWidget {
  const AdminVew({super.key});

  @override
  State<AdminVew> createState() => _AdminVewState();
}

class _AdminVewState extends State<AdminVew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login'), centerTitle: true,),
    );
  }
}