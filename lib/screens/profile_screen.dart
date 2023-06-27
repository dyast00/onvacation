import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onvocation/screens/editprofile_screen.dart';
import 'package:onvocation/screens/home_screen.dart';

class ProfileScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigasi ke halaman login atau halaman lain yang sesuai setelah logout
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(102, 218, 255, 1.0),
      // appBar: AppBar(
      //   title: Text('Home'),
      // ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('No data available');
          }

          var userData = snapshot.data!.data()!;
          String name = userData['name'];
          String email = userData['email'];
          String image = userData['imageUrl'];

          return Padding(
            padding: EdgeInsets.only(top: 30.0, left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 27),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()),
                          );
                          // Aksi yang ingin dijalankan saat tombol edit ditekan
                        },
                        child: Container(
                          width: 50,
                          height: 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Group%201749.png?alt=media&token=0258af01-8d69-4cc7-ab26-94657b821ba3&_gl=1*198w287*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NTY3Njc4My4yNC4xLjE2ODU2NzcyOTkuMC4wLjA.'),
                              fit: BoxFit
                                  .contain, // Ganti URL dengan URL gambar edit yang diinginkan
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                InkWell(
                  // onTap: () => Navigator.pushNamed(context, '/login'),
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 200,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Group%201737.png?alt=media&token=3a3e7814-71b9-4621-b64a-4ce4c811eb1b&_gl=1*1dx894e*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NTYxNTIzMC4yMy4xLjE2ODU2MTg4ODUuMC4wLjA."),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: ClipOval(
                                  child: Image.network(
                                    userData['imageUrl'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      FittedBox(
                                        child: Text(
                                          userData['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              10), // Jarak antara nama dan kolom berikutnya
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.email,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 2),
                                          FittedBox(
                                            child: Text(
                                              userData['email'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              5), // Jarak antara kolom email dan kolom berikutnya
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 2),
                                          FittedBox(
                                            child: Text(
                                              userData['phone'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              5), // Jarak antara kolom phone dan kolom berikutnya
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_pin,
                                            color: Colors.white,
                                          ),
                                          FittedBox(
                                            child: RichText(
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: userData['address'],
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: ', ',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: userData['city'],
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  // TextSpan(
                                                  //   text: userData['country'],
                                                  //   style: const TextStyle(
                                                  //     fontSize: 12,
                                                  //     color: Colors.white,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Center(
                  child: Container(
                    width: 350,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Group%201748.png?alt=media&token=271ba97a-615f-4b26-84ce-bf0ae6d2a148&_gl=1*b42mgq*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NTY3Njc4My4yNC4xLjE2ODU2NzY5MDUuMC4wLjA."), // Ganti URL dengan URL gambar latar belakang yang diinginkan
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () => _logout(context),
                      child: Text(''),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              iconSize: 20.0,
              selectedIconTheme: IconThemeData(size: 28.0),
              selectedItemColor: Color.fromARGB(255, 46, 90, 172),
              unselectedItemColor: Colors.black,
              selectedFontSize: 16.0,
              unselectedFontSize: 12,
              currentIndex: 2,
              // onTap: OnTapped,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: GestureDetector(
                    child: Icon(Icons.home),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.navigation),
                  label: "map",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ]),
        ),
      ),
    );
    // );
  }
}
