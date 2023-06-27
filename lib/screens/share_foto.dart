import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';

class PhotoSharingPage extends StatefulWidget {
  @override
  _PhotoSharingPageState createState() => _PhotoSharingPageState();
}

class _PhotoSharingPageState extends State<PhotoSharingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  List<String> _imageUrls = [];
  File? _imageFile;
  bool _canDelete = false;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('image_7bidadari').get();
    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    setState(() {
      _imageUrls =
          documents.map((doc) => doc.get('imageUrl') as String).toList();
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

    await _firestore.collection('images').add({
      'imageUrl': imageUrl,
    });

    setState(() {
      _imageUrls.add(imageUrl);
      _canDelete = true;
    });
  }

  Future<void> _deleteImage(int index) async {
    if (!_canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot delete previous images')),
      );
      return;
    }

    final String imageUrl = _imageUrls[index];
    final QuerySnapshot snapshot = await _firestore
        .collection('images')
        .where('imageUrl', isEqualTo: imageUrl)
        .get();
    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    if (documents.isNotEmpty) {
      final DocumentReference docRef = documents.first.reference;

      await docRef.delete();

      final Reference imageRef = _storage.refFromURL(imageUrl);
      await imageRef.delete();

      setState(() {
        _imageUrls.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image deleted successfully')),
      );
    }
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
                  final imageUrl = _imageUrls[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Container(
                        width: 400,
                        height: 100,
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
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Component%209.png?alt=media&token=03fddb1b-4f7e-4f2d-96b5-fff79a3e33f2&_gl=1*1e3ptf3*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NjY1ODk2MS41MS4xLjE2ODY2NjAyMzEuMC4wLjA.", // Ganti dengan URL gambar avatar
                              ),
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
