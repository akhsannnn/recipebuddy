import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserEdit extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> currentData;

  const AdminUserEdit({
    super.key,
    required this.userId,
    required this.currentData,
  });

  @override
  State<AdminUserEdit> createState() => _AdminUserEditState();
}

class _AdminUserEditState extends State<AdminUserEdit> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.currentData['username'];
    emailController.text = widget.currentData['email'];
  }

  void updateUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update({
          'username': usernameController.text,
          'email': emailController.text,
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("User berhasil diperbarui")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EF),
      appBar: AppBar(
        title: const Text("Edit User"),
        backgroundColor: const Color(0xFFF8F3EF),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: updateUser, child: const Text("Update")),
          ],
        ),
      ),
    );
  }
}
