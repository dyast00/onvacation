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

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get(),
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
            String image = userData['imageUrl'];

            return Padding(
              padding: EdgeInsets.only(top: 25.0, left: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            '${userData['imageUrl']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${userData['name']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    // onTap: navigateToWeatherDetail,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            AppColor.secondaryColor,
                            AppColor.primaryColor,
                          ],
                        ),
                      ),
                      margin: EdgeInsets.all(3.0),
                      padding: EdgeInsets.all(3.0),
                      child: Column(
                        children: <Widget>[
                          if (isLoading)
                            CircularProgressIndicator()
                          else if (weatherData.isNotEmpty)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    '$cityName',
                                    style: TextStyle(
                                      color: AppColor.whiteColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: 3,
                                        itemBuilder: (context, index) {
                                          var forecast = weatherData[index * 1];
                                          var dateTime = DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  forecast['dt'] * 1000);

                                          var description = forecast['weather']
                                              [0]['description'];
                                          var iconCode =
                                              forecast['weather'][0]['icon'];

                                          return ListTile(
                                            title: Row(
                                              children: [
                                                weatherIcon(iconCode),
                                                Text(
                                                  '${dateTime.hour}:00 - ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          AppColor.whiteColor),
                                                ),
                                                Text(
                                                  '$description',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          AppColor.whiteColor),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // SizedBox(width: 20),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: weatherData.isNotEmpty
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  weatherIcon(weatherData[0]
                                                      ['weather'][0]['icon']),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    '${(weatherData[0]['main']['temp'] - 273.15).round()}°C',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColor
                                                            .whiteColor),
                                                  ),
                                                  Text(
                                                    '${weatherData[0]['weather'][0]['description']}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColor
                                                            .whiteColor),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 300,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return WeatherDetailPage();
                                        // Tindakan yang akan dijalankan saat tombol ditekan
                                      }));
                                    },
                                    child: Text(
                                      'Lihat Cuaca Daerah Sekitar',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.secondaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(
                                            color: AppColor.primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
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
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: widgetajah,
                  )
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: displayedMenus.length,
                  //     itemBuilder: (context, index) {
                  //       final menu = displayedMenus[index];
                  //       return InkWell(
                  //         onTap: () {
                  //           navigateToMenuDetail(menu);
                  //         },
                  //         child: Container(
                  //           margin:
                  //               EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  //           decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(8),
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: Colors.grey.withOpacity(0.3),
                  //                 spreadRadius: 2,
                  //                 blurRadius: 5,
                  //                 offset: Offset(0, 3),
                  //               ),
                  //             ],
                  //           ),
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             children: [
                  //               Container(
                  //                 margin: EdgeInsets.fromLTRB(0, 0, 11, 2.5),
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.center,
                  //                   children: [
                  //                     Container(
                  //                       margin: EdgeInsets.fromLTRB(10, 0, 0, 8),
                  //                       width: 84,
                  //                       height: 84,
                  //                       decoration: BoxDecoration(
                  //                         shape: BoxShape.circle,
                  //                         boxShadow: [
                  //                           BoxShadow(
                  //                             color: Colors.grey.withOpacity(0.3),
                  //                             spreadRadius: 2,
                  //                             blurRadius: 5,
                  //                             offset: Offset(0, 3),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       child: ClipOval(
                  //                         child: Image.network(
                  //                           menu.imageUrl,
                  //                           width: 84,
                  //                           height: 84,
                  //                           fit: BoxFit.cover,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Container(
                  //                       margin: EdgeInsets.fromLTRB(10, 0, 0, 8),
                  //                       width: 70,
                  //                       height: 4,
                  //                       decoration: BoxDecoration(
                  //                         shape: BoxShape.rectangle,
                  //                         borderRadius: BorderRadius.circular(20),
                  //                         boxShadow: [
                  //                           BoxShadow(
                  //                             color:
                  //                                 Colors.black.withOpacity(0.3),
                  //                             spreadRadius: 2,
                  //                             blurRadius: 5,
                  //                             offset: Offset(0, 3),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 10),
                  //               Expanded(
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text(
                  //                       menu.name,
                  //                       style: TextStyle(
                  //                         fontSize: 18,
                  //                         fontWeight: FontWeight.bold,
                  //                       ),
                  //                     ),
                  //                     Text(
                  //                       menu.kategori,
                  //                       style: TextStyle(
                  //                         fontSize: 16,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            );
          },
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
