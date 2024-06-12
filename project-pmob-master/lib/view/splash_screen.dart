// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:trash_solver/utils/routes/routes_names.dart';
import 'package:provider/provider.dart';
import 'package:trash_solver/viewmodel/login_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loginViewModel.isLoggedIn) {
        if (loginViewModel.userRole == 'users') {
          Navigator.pushReplacementNamed(context, RouteNames.dashboardUser);
        } else if (loginViewModel.userRole == 'admin') {
          Navigator.pushReplacementNamed(context, RouteNames.dashboardAdmin);
        }
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightGreen[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Daur Ulang Untuk Lingkungan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Dapatkan informasi mengenai pemilahan sampah untuk didaur ulang ditempat yang sudah disediakan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Image.asset(
                'assets/recycling_image.png', // Pastikan Anda memiliki gambar ini di folder assets
                height: 200,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text(
                  'Login Sekarang',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun?',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.register);
                    },
                    child: Text(
                      'Daftar Sekarang',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
