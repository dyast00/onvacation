import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onvocation/screens/register_screen.dart';
import 'package:onvocation/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Berhasil login, pindah ke halaman home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );

      // Menampilkan SnackBar pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil login!'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Pengguna dengan email tersebut tidak ditemukan.');
      } else if (e.code == 'wrong-password') {
        print('Password yang dimasukkan salah.');
      }

      // Menampilkan SnackBar pesan gagal login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal login! Silakan periksa email dan password.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  bool isLoggedIn() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    // Cek status login
    if (isLoggedIn()) {
      return HomeScreen();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false, // Menonaktifkan tombol back
      child: Scaffold(
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
                  height: screenHeight * 0.4,
                  child: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Group%201743.png?alt=media&token=64df1d5d-ed4d-4061-929c-57cb15fa06c4&_gl=1*1matcp8*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NTU1NDA1OC4yMS4xLjE2ODU1NTQwODcuMC4wLjA.",
                    width: screenWidth * 0.8,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Container(
                  height: screenHeight * 0.46,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(20, 0, 92, 1.0), width: 1.0),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(screenWidth * 0.08),
                      topLeft: Radius.circular(screenWidth * 0.08),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(screenWidth * 0.08),
                      topLeft: Radius.circular(screenWidth * 0.08),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(),
                          SizedBox(height: screenHeight * 0.07),
                          Container(
                            width: screenWidth * 0.6,
                            height: screenHeight * 0.065,
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
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
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                            width: screenWidth * 0.6,
                            height: screenHeight * 0.065,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: 'Masukkan password',
                                hintStyle: TextStyle(fontSize: 12),
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(screenWidth * 0.5, screenHeight * 0.05),
                              primary: Color.fromRGBO(20, 0, 92, 1.0),
                            ),
                            onPressed: () => _login(context),
                            child: Text('Log In'),
                          ),
                          Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
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
                                            builder: (context) =>
                                                RegisterScreen()),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
