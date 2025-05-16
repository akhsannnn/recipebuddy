import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class UploadRecipeScreen extends StatefulWidget {
  const UploadRecipeScreen({super.key});

  @override
  State<UploadRecipeScreen> createState() => _UploadRecipeScreenState();
}

class _UploadRecipeScreenState extends State<UploadRecipeScreen> {
  final titleController = TextEditingController();
  final durationController = TextEditingController();
  File? selectedImage;
  String? uploadedImageUrl;
  bool isLoading = false;

  // ✅ Upload ke Imgur dan dapatkan URL
  Future<String?> uploadImageToImgur(File imageFile) async {
    const clientId =
        ' Client-ID 5fc1656393e2578'; // GANTI dengan Client ID kamu
    final uri = Uri.parse('https://api.imgur.com/3/image');

    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        uri,
        headers: {'Authorization': ' $clientId'},
        body: {'image': base64Image, 'type': 'base64'},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        return data['data']['link'];
      } else {
        print('Upload failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // ✅ Pilih gambar dari galeri
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => selectedImage = File(pickedFile.path));
    }
  }

  // ✅ Simpan ke Firestore
  Future<void> uploadRecipe() async {
    final title = titleController.text.trim();
    final duration = durationController.text.trim();

    if (title.isEmpty || duration.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lengkapi semua field')));
      return;
    }

    setState(() => isLoading = true);

    final imageUrl = await uploadImageToImgur(selectedImage!);

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal upload gambar ke Imgur')),
      );
      setState(() => isLoading = false);
      return;
    }

    await FirebaseFirestore.instance.collection('recipes').add({
      'title': title,
      'duration': duration,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Berhasil menambahkan resep')));

    // Reset
    titleController.clear();
    durationController.clear();
    setState(() {
      selectedImage = null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EF),
      appBar: AppBar(
        title: const Text("Tambah Resep"),
        backgroundColor: const Color(0xFFF8F3EF),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Judul Resep",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(
                labelText: "Durasi (contoh: 20 menit)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            selectedImage != null
                ? Image.file(selectedImage!, height: 150)
                : const Text("Belum ada gambar"),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pilih Gambar"),
            ),
            const SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: uploadRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD3B8AA),
                  ),
                  child: const Text("Upload Resep"),
                ),
          ],
        ),
      ),
    );
  }
}
