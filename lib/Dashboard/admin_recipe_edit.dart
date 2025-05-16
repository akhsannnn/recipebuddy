import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRecipeEdit extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> currentData;

  const AdminRecipeEdit({
    super.key,
    required this.docId,
    required this.currentData,
  });

  @override
  State<AdminRecipeEdit> createState() => _AdminRecipeEditState();
}

class _AdminRecipeEditState extends State<AdminRecipeEdit> {
  final titleController = TextEditingController();
  final durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.currentData['title'];
    durationController.text = widget.currentData['duration'];
  }

  void updateRecipe() async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.docId)
        .update({
          'title': titleController.text,
          'duration': durationController.text,
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Resep berhasil diperbarui")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EF),
      appBar: AppBar(
        title: const Text("Edit Resep"),
        backgroundColor: const Color(0xFFF8F3EF),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: "Durasi"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateRecipe,
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
