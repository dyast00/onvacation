import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImagePapuma extends StatefulWidget {
  @override
  _PhotoSharingPageState createState() => _PhotoSharingPageState();
}

class _PhotoSharingPageState extends State<ImagePapuma> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  List<String> _imageUrls = [];
  File? _imageFile;
  User? _user;
  String? _userName;
  String? _gambar;
  List<String> _gambars = [];
  List<String> _nama = [];
  @override
  void initState() {
    super.initState();
    _fetchImages();
    _getUser();
  }

  Future<void> _fetchImages() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('image_papuma').get();
    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    setState(() {
      _imageUrls =
          documents.map((doc) => doc.get('imageUrl') as String).toList();
      _gambars = documents.map((doc) => doc.get('gambars') as String).toList();
      _nama = documents.map((doc) => doc.get('username') as String).toList();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _imagePicker.getImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final Reference storageRef =
        _storage.ref().child('images/${DateTime.now()}.jpg');

    final UploadTask uploadTask = storageRef.putFile(_imageFile!);
    final TaskSnapshot snapshot = await uploadTask;
    final String imageUrl = await snapshot.ref.getDownloadURL();

    await _firestore.collection('image_papuma').add({
      'imageUrl': imageUrl,
      'userId': _user!.uid, // Menyimpan ID pengguna yang sudah login
      'username': _userName,
      'gambars': _gambar,
    });

    setState(() {
      _imageUrls.add(imageUrl);
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ImagePapuma()), // Ganti dengan nama halaman Image7BidadariPage
    );
  }

  void _viewImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
            ),
          ),
        );
      },
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Photo'),
          content: Text('Choose the source for the photo'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                _pickImage(ImageSource
                    .camera); // Panggil metode _pickImage dengan sumber kamera
              },
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                _pickImage(ImageSource
                    .gallery); // Panggil metode _pickImage dengan sumber galeri
              },
              child: Text('Gallery'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (snapshot.size > 0) {
        final userData = snapshot.docs.first.data() as Map<String, dynamic>;
        final userName = userData['name'] as String?;
        final gambar = userData['imageUrl'] as String?;
        if (userName != null) {
          setState(() {
            _user = user;
            _userName = userName;
            _gambar = gambar;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(102, 218, 255, 1.0),
      extendBody: true, // Menambahkan ruang di bawah AppBar untuk konten
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Tinggi AppBar yang diinginkan
        child: CustomShapeAppBar(
          child: AppBar(
            backgroundColor: Color.fromRGBO(
                20, 0, 92, 1.0), // Set background AppBar menjadi transparan
            elevation: 0, // Hilangkan bayangan pada AppBar
            title: Text('Photo Sharing'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _imageUrls.length,
                itemBuilder: (context, index) {
                  if (index < _imageUrls.length &&
                      index < _gambars.length &&
                      index < _nama.length) {
                    final imageUrl = _imageUrls[index];
                    final gambarUrl = _gambars[index];
                    final nameUrl = _nama[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Container(
                          width: 400,
                          height: 130,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Group%201737.png?alt=media&token=3a3e7814-71b9-4621-b64a-4ce4c811eb1b&_gl=1*1dx894e*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NTYxNTIzMC4yMy4xLjE2ODU2MTg4ODUuMC4wLjA.",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      gambarUrl, // Ganti dengan URL gambar avatar
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    nameUrl, // Ganti dengan nama yang ingin ditampilkan
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _viewImage(imageUrl),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 4),
            Center(
              child: _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      width: 100, // Ubah ukuran lebar sesuai kebutuhan
                      height: 100, // Ubah ukuran tinggi sesuai kebutuhan
                      fit: BoxFit.contain,
                    )
                  : Container(
                      width: 100, // Ubah ukuran lebar sesuai kebutuhan
                      height: 100, // Ubah ukuran tinggi sesuai kebutuhan
                      color: Colors.white,
                    ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (_imageFile != null) {
                      _uploadImage();
                    } else {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Choose from Gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Take a Photo'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(_imageFile != null ? 'Upload' : 'Tambah Foto'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomShapeAppBar extends StatelessWidget {
  final Widget child;

  const CustomShapeAppBar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AppBarClipper(),
      child: child,
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final height = 40.0; // Ketinggian lengkungan bawah AppBar

    path.moveTo(0, size.height - height);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
