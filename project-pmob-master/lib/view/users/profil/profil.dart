import 'package:flutter/material.dart';
import 'package:trash_solver/utils/routes/routes_names.dart';
import 'package:trash_solver/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool isEditingNama = false;
  bool isEditingAlamat = false;
  bool isEditingNoHp = false;
  bool isEditingPoints = false;

  @override
  Widget build(BuildContext context) {
    final viewModelAkun = context.watch<LoginViewModel>();

    if (!viewModelAkun.isLoggedIn) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.greenAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'PROFILE',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CircleAvatar(
            //   radius: 80,
            //   backgroundColor: Colors.white, // Tambahkan warna latar belakang
            //   child: Stack(
            //     children: const [
            //       // ClipOval(
            //       //   child: Image.asset(
            //       //     'assets/profile_image.png',
            //       //     width: 150, // Atur lebar gambar sesuai kebutuhan Anda
            //       //     height: 150, // Atur tinggi gambar sesuai kebutuhan Anda
            //       //     fit: BoxFit.cover,
            //       //   ),
            //       // ),
            //       // Align(
            //       //   alignment: Alignment.bottomRight,
            //       //   child: CircleAvatar(
            //       //     backgroundColor: Colors.green,
            //       //     radius: 25,
            //       //     child: Icon(
            //       //       Icons.camera_alt,
            //       //       color: Colors.white,
            //       //       size: 20,
            //       //     ),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileItem(
                    title: 'Nama',
                    controller: viewModelAkun.namaController,
                    isEditing: isEditingNama,
                    onEdit: () {
                      setState(() {
                        isEditingNama = !isEditingNama;
                      });
                    },
                  ),
                  ProfileItem(
                    title: 'Alamat',
                    controller: viewModelAkun.alamatController,
                    isEditing: isEditingAlamat,
                    onEdit: () {
                      setState(() {
                        isEditingAlamat = !isEditingAlamat;
                      });
                    },
                  ),
                  ProfileItem(
                    title: 'No HP',
                    controller: viewModelAkun.noHpController,
                    isEditing: isEditingNoHp,
                    onEdit: () {
                      setState(() {
                        isEditingNoHp = !isEditingNoHp;
                      });
                    },
                  ),
                  ProfileItem(
                    title: 'Point',
                    controller: viewModelAkun.pointsController,
                    isEditing: isEditingPoints,
                    onEdit: () {
                      setState(() {
                        isEditingPoints = !isEditingPoints;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: viewModelAkun.updateUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Update Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Konfirmasi"),
                      content: Text("Apakah Anda yakin ingin Keluar?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () {
                            viewModelAkun.logout();
                            Navigator.pushNamed(context, RouteNames.login);
                          },
                          child: Text("iya"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.logout, color: Colors.blue),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool isEditing;
  final VoidCallback onEdit;

  ProfileItem({
    required this.title,
    required this.controller,
    required this.isEditing,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.edit, size: 16),
              onPressed: onEdit,
            ),
          ],
        ),
        SizedBox(height: 5),
        isEditing
            ? TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              )
            : Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                child: Text(controller.text),
              ),
        SizedBox(height: 10),
      ],
    );
  }
}
