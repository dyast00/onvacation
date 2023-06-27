import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onvocation/screens/DetailWisata/air_terjun_telunjuk_raung.dart';
import 'package:onvocation/screens/DetailWisata/air_terjun_tujuh_bidadari.dart';
import 'package:onvocation/screens/DetailWisata/gunung_gambir.dart';
import 'package:onvocation/screens/DetailWisata/kawah_ijen.dart';
import 'package:onvocation/screens/DetailWisata/pantai_papuma.dart';
import 'package:onvocation/screens/DetailWisata/pantai_payangan.dart';
import 'package:onvocation/screens/DetailWisata/rembangan.dart';
import 'package:onvocation/screens/MapWisata/map_screen.dart';
import 'DetailWisata/detil_watu_ulo.dart';
import 'DetailWisata/air_terjun_tancak.dart';
import 'viewall_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:onvocation/custom/appcolor.dart';
import 'weatherdetil_screen.dart';
import 'share_foto.dart';

class Menu {
  final String id;
  final String imageUrl;
  final String name;
  final String kategori;

  Menu({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.kategori,
  });
}

class Viewallscreen extends StatefulWidget {
  Viewallscreen({Key? key}) : super(key: key);

  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<Viewallscreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<Menu> allMenus = [];
  List<Menu> displayedMenus = [];
  String selectedCategory = '';
  String searchQuery = '';
  String apiKey = "e4b2057dc1c953be9043355664a278ab";
  double latitude = 0.0;
  double longitude = 0.0;
  List<dynamic> weatherData = [];
  String cityName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMenus();
    getLocation();
  }

  Future<void> fetchMenus() async {
    CollectionReference menuCollection =
        FirebaseFirestore.instance.collection('menus');

    try {
      QuerySnapshot querySnapshot = await menuCollection.get();

      setState(() {
        allMenus = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return Menu(
            id: doc.id,
            imageUrl: data['imageUrl'],
            name: data['name'],
            kategori: data['kategori'],
          );
        }).toList();

        displayedMenus = allMenus;
      });
    } catch (e) {
      print('Error fetching menus: $e');
    }
  }

  void filterMenus(String filterText) {
    setState(() {
      selectedCategory = filterText;
      displayedMenus = allMenus
          .where(
              (menu) => menu.kategori.toLowerCase() == filterText.toLowerCase())
          .toList();
    });
  }

  void searchMenus(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        displayedMenus = allMenus;
      } else {
        displayedMenus = allMenus
            .where(
                (menu) => menu.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> getLocation() async {
    final PermissionStatus permissionStatus =
        await Permission.location.request();

    if (permissionStatus.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      await getWeather();
    } else {
      setState(() {
        latitude = 0.0;
        longitude = 0.0;
      });
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Filter'),
          content: Text('Choose a filter for the menu'),
          actions: [
            TextButton(
              onPressed: () {
                filterMenus('pegunungan');
                Navigator.pop(context); // Tutup dialog
              },
              child: Text('Pegunungan'),
            ),
            TextButton(
              onPressed: () {
                filterMenus('pantai');
                Navigator.pop(context); // Tutup dialog
              },
              child: Text('Pantai'),
            ),
            TextButton(
              onPressed: () {
                filterMenus('air terjun');
                Navigator.pop(context); // Tutup dialog
              },
              child: Text('Air Terjun'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getWeather() async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(
        "http://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey");
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    setState(() {
      if (data['list'] != null) {
        weatherData = data['list'];
        cityName = data['city']['name'];
      } else {
        weatherData = [];
        cityName = '';
      }
      isLoading = false;
    });
  }

  Widget weatherIcon(String iconCode) {
    String iconUrl = "http://openweathermap.org/img/w/$iconCode.png";
    return Image.network(
      iconUrl,
      width: MediaQuery.of(context).size.width / 7,
      height: MediaQuery.of(context).size.height / 20,
    );
  }

  void navigateToWeatherDetail() {
    Navigator.pushNamed(context, '/weatherDetail');
  }

  void navigateToMenuDetail(Menu menu) {
    if (menu.name == "Pantai Watu Ulo") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Watu_ulo(),
        ),
      );
    } else if (menu.name == "Air Terjun Tancak") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Air_terjun_tancak(),
        ),
      );
    } else if (menu.name == "Air Terjun Tujuh Bidadari") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Air_terjun_tujuh_bidadari(),
        ),
      );
    } else if (menu.name == "Pantai Payangan") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Pantai_payangan(),
        ),
      );
    } else if (menu.name == "Rembangan Public Bath") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Rembangan(),
        ),
      );
    } else if (menu.name == "Air Terjun Telunjuk Raung") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Air_terjun_telunjuk_raung(),
        ),
      );
    } else if (menu.name == "Pantai Papuma") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Pantai_papuma(),
        ),
      );
    } else if (menu.name == "Gunung Gambir") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Gunung_gambir(),
        ),
      );
    } else if (menu.name == "Kawah Ijen") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Kawah_ijen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetajah = [];
    for (var i = 0; i < displayedMenus.length; i++) {
      final menu = displayedMenus[i];
      widgetajah.add(InkWell(
        onTap: () {
          navigateToMenuDetail(menu);
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 11, 2.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 8),
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          menu.imageUrl,
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 8),
                      width: 70,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      menu.kategori,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }
    ;
    return Scaffold(
      backgroundColor: Color.fromRGBO(102, 218, 255, 1.0),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 25.0, left: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Group%201527.png?alt=media&token=28a1f57a-a9bc-4278-bee9-f29486e8d431&_gl=1*uiugvu*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NjU5MzU1Ny40NC4xLjE2ODY1OTM2MTkuMC4wLjA.',
                      height: 55,
                      width: 55,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: searchMenus,
                                decoration: InputDecoration(
                                  hintText: 'Cari Tempat Wisata .....',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                searchMenus(searchQuery);
                              },
                              icon: Icon(Icons.search),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kawasan Wisata',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Viewallscreen(),
                        ),
                      );
                    },
                    child: ElevatedButton(
                      onPressed: _showFilterDialog,
                      child: Text('Select Filter'),
                    ),
                  ),
                ],
              ),
              Column(
                children: widgetajah,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            iconSize: 20.0,
            selectedIconTheme: IconThemeData(size: 28.0),
            selectedItemColor: Color.fromARGB(255, 46, 90, 172),
            unselectedItemColor: Colors.black,
            selectedFontSize: 16.0,
            unselectedFontSize: 12,
            currentIndex: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: Icon(Icons.home),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Viewallscreen()),
                    );
                  },
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: Icon(Icons.navigation),
                  onTap: () {},
                ),
                label: "Map",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: Icon(Icons.person),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
