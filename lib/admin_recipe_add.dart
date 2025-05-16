import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AdminRecipeAdd extends StatefulWidget {
  const AdminRecipeAdd({super.key});

  @override
  State<AdminRecipeAdd> createState() => _AdminRecipeAddState();
}

class _AdminRecipeAddState extends State<AdminRecipeAdd> {
  final titleController = TextEditingController();
  final durationController = TextEditingController();
  final descriptionController = TextEditingController();
  File? image;
  bool isLoading = false;

  Future<String?> uploadImageToImgur(File imageFile) async {
    const clientId = '5fc1656393e2578'; // Client ID kamu
    final uri = Uri.parse('https://api.imgur.com/3/image');

    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      uri,
      headers: {'Authorization': 'Client-ID $clientId'},
      body: {'image': base64Image, 'type': 'base64'},
    );

    final data = jsonDecode(response.body);
    return data['success'] ? data['data']['link'] : null;
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => image = File(picked.path));
  }

  Future<void> saveRecipe() async {
    if (titleController.text.isEmpty ||
        durationController.text.isEmpty ||
        image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lengkapi semua field")));
      return;
    }

    setState(() => isLoading = true);
    final imageUrl = await uploadImageToImgur(image!);

    await FirebaseFirestore.instance.collection('recipes').add({
      'title': titleController.text.trim(),
      'duration': durationController.text.trim(),
      'description': descriptionController.text.trim(),
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Berhasil menambahkan resep")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EF),
      appBar: AppBar(
        title: const Text("Tambah Resep"),
        backgroundColor: const Color(0xFFF8F3EF),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Judul Resep"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: "Durasi"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            const SizedBox(height: 12),
            image != null
                ? Image.file(image!, height: 150)
                : const Text("Belum ada gambar"),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pilih Gambar"),
            ),
            const SizedBox(height: 12),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: saveRecipe,
                  child: const Text("Simpan Resep"),
                ),
          ],
        ),
      ),
    );
  }
}
