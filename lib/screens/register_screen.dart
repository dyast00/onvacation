import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onvocation/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final name = nameController.text;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Pendaftaran berhasil, arahkan ke halaman Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'imageUrl':
            'https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/pngaaa.com-263419.png?alt=media&token=4ca5674e-cce4-4a03-82b6-25cda92ea6cd&_gl=1*1qrj9p3*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NjMwMTU2OC4zMC4xLjE2ODYzMDE3MjAuMC4wLjA.',
        'name': name,
        'email': email,
        'phone': '',
        'city': '',
        'address': '',
        'country': '',
      });

      // Menampilkan SnackBar pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil mendaftar! Silakan login.'),
          backgroundColor: Colors.green,
        ),
      );

      // Berhasil mendaftar, lanjutkan ke layar lain atau tindakan lainnya
      // misalnya menampilkan pesan sukses atau mengarahkan ke beranda.
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Kata sandi terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        print('Email sudah digunakan.');
      }

      // Menampilkan SnackBar pesan gagal registrasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendaftar! Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(102, 218, 255, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: [
              Container(
                child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Group%201744.png?alt=media&token=95198e97-b7e5-49ab-8004-61d877a6c31b&_gl=1*ukaioh*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NTUzOTE2Mi4xOS4xLjE2ODU1NDAwMzAuMC4wLjA.",
                  width: 245,
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: screenHeight * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(35),
                    topLeft: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    Container(),
                    SizedBox(height: 16.0),
                    Container(
                      width: 230,
                      height: 45,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Nama Lengkap',
                          labelStyle: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          hintText: 'Masukkan nama',
                          hintStyle: TextStyle(fontSize: 12),
                          prefixIcon: Icon(Icons.people),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: 230,
                      height: 45,
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          hintText: 'Email Address',
                          hintStyle: TextStyle(fontSize: 12),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: 230,
                      height: 45,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          hintText: 'Masukkan Password',
                          hintStyle: TextStyle(fontSize: 12),
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200.0, 35.0),
                        primary: Color.fromRGBO(20, 0, 92, 1.0),
                      ),
                      onPressed: () => _register(context),
                      child: Text('Sign Up'),
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Already Have Account ? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Tambahkan tindakan yang ingin Anda lakukan saat teks "Sign Up" ditekan
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    Text(''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
