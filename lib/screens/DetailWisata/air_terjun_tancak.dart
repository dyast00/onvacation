import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onvocation/screens/MapWisata/a_tancak.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onvocation/sharedfoto/image_tancak.dart';

class Menu {
  final String id;
  final String imageUrl;
  final String name;
  final String kategori;
  final String alamat;
  final String jam;
  final String harga;
  final String deskripsi;

  Menu({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.kategori,
    required this.alamat,
    required this.jam,
    required this.harga,
    required this.deskripsi,
  });
}

class Air_terjun_tancak extends StatefulWidget {
  @override
  _YourPageState createState() => _YourPageState();
}

class _YourPageState extends State<Air_terjun_tancak> {
  List<Menu> allMenus = [];
  List<Menu> displayedMenus = [];

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    CollectionReference menuCollection =
        FirebaseFirestore.instance.collection('menus');

    try {
      QuerySnapshot querySnapshot = await menuCollection
          .where('name', isEqualTo: 'Air Terjun Tancak')
          .get();

      setState(() {
        allMenus = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return Menu(
            id: doc.id,
            imageUrl: data['imageUrl'] ?? '',
            name: data['name'] ?? '',
            kategori: data['kategori'] ?? '',
            alamat: data['alamat'] ?? '',
            harga: data['harga'] ?? '',
            deskripsi: data['deskripsi'] ?? '',
            jam: data['jam'] ?? '',
          );
        }).toList();

        displayedMenus = allMenus;
      });
    } catch (e) {
      print('Error fetching menus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: displayedMenus.length,
        itemBuilder: (BuildContext context, int index) {
          Menu menu = displayedMenus[index];

          return Stack(
            children: [
              Image.network(
                menu.imageUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/btn_back.png?alt=media&token=0387507b-cb93-4e14-bf96-0894af3f0389&_gl=1*1swxcur*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NjMxNzkxNi4zMS4xLjE2ODYzMTc5NDMuMC4wLjA.',
                        width: 40,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/btn_share.png?alt=media&token=7632ca82-48eb-4dc6-962e-4b794e538b0e&_gl=1*1qhjdzl*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NjMxNzkxNi4zMS4xLjE2ODYzMTc5OTQuMC4wLjA.',
                        width: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 154),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menu.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          menu.kategori,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Icon(
                                  Icons.star_half,
                                  color: Colors.amber,
                                ),
                                Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                            Spacer(),
                            SizedBox(width: 16),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageTancak()),
                                );
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  'Review Foto Lainnya',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  8.0), // Tambahkan jarak di setiap sisi gambar
                              child: Image.network(
                                menu.imageUrl,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          // jlwatuulono37watuulosumberrejo (44:733)
                          right: 24,
                          top: 176,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 72,
                              height: 36,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      30.0, // Menambahkan jarak 10cm di sisi kanan
                                ),
                                child: Text(
                                  menu.alamat,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    letterSpacing: -0.1650000066,
                                    color: Color(0xff0a0a0a),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // jlwatuulono37watuulosumberrejo (44:733)
                          right: 24,
                          top: 176,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 72,
                              height: 36,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      30.0, // Menambahkan jarak 10cm di sisi kanan
                                ),
                                child: Text(
                                  'harga: RP. ' + menu.harga,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    letterSpacing: -0.1650000066,
                                    color: Color(0xff0a0a0a),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 18),
                        Text(
                          'Deskripsi obyek wisata',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 12),
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            menu.deskripsi,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          'Jam buka',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 12),
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            menu.jam,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => A_tancak()),
                    ); // Aksi yang akan dijalankan saat tombol ditekan
                  },
                  child: Icon(Icons.location_on),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
