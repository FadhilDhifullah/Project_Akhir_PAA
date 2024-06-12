import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:trash_solver/utils/utils.dart';

class TambahartikelViewmodel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  XFile? _image;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    _image = pickedImage;
    notifyListeners();
  }

  XFile? get image => _image;

  List<Map<String, dynamic>> _articles = [];

  List<Map<String, dynamic>> get articles => _articles;

  final String apiUrl = "http://192.168.1.13:8000"; // Ganti dengan URL API Anda

  TambahartikelViewmodel() {
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/articles'));

      if (response.statusCode == 200) {
        _articles = List<Map<String, dynamic>>.from(json.decode(response.body));
        notifyListeners();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (error) {
      throw Exception('Failed to load articles: $error');
    }
  }

  Future<void> saveData(BuildContext context) async {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      Utils.showErrorSnackBar(
        Overlay.of(context),
        "Nama dan Deskripsi tidak boleh kosong",
      );
      return;
    }

    if (_image == null) {
      Utils.showErrorSnackBar(
        Overlay.of(context),
        "Image Kosong",
      );
      return;
    }

    try {
      String? imageUrl;

      // Upload image to the server
      final request = http.MultipartRequest("POST", Uri.parse("$apiUrl/articles/upload"));
      request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
      final res = await request.send();
      final resBody = await res.stream.bytesToString();
      print('Upload Response: $resBody');
      
      try {
        final resData = json.decode(resBody);

        if (res.statusCode == 200 && resData['url'] != null) {
          imageUrl = resData['url'];
          print("Image uploaded successfully: $imageUrl");
        } else {
          print("Upload failed with status: ${res.statusCode}");
          Utils.showErrorSnackBar(
            Overlay.of(context),
            "Upload Gagal: ${resData['error'] ?? 'Unknown error'}",
          );
          return;
        }
      } catch (e) {
        print("Failed to decode upload response: $e");
        Utils.showErrorSnackBar(
          Overlay.of(context),
          "Upload Gagal: Response bukan JSON",
        );
        return;
      }

      // Save data to the API
      final response = await http.post(
        Uri.parse('$apiUrl/articles'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': nameController.text,
          'description': descriptionController.text,
          'imageUrl': imageUrl,
        }),
      );

      if (response.statusCode == 201) {
        fetchDataFromApi();
        nameController.clear();
        descriptionController.clear();
        _image = null;
        notifyListeners();
        Utils.showSuccessSnackBar(
          Overlay.of(context),
          "Data telah ditambahkan",
        );
        print("Data telah ditambahkan");
      } else {
        // Tambahkan logging kesalahan
        print("Failed to save data with status: ${response.statusCode}");
        Utils.showErrorSnackBar(
          Overlay.of(context),
          "Gagal menyimpan data: ${response.body}",
        );
      }
    } catch (e) {
      // Tambahkan logging kesalahan
      print("Error uploading data: $e");
      Utils.showErrorSnackBar(
        Overlay.of(context),
        "Error Upload: $e",
      );
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/articles/$id'));

      if (response.statusCode == 200) {
        _articles.removeWhere((article) => article['id'] == id);
        notifyListeners();
      } else {
        // Tambahkan logging kesalahan
        print("Failed to delete article: ${response.body}");
        throw Exception('Failed to delete article');
      }
    } catch (error) {
      print("Error deleting article: $error");
      throw Exception('Failed to delete article: $error');
    }
  }
}
