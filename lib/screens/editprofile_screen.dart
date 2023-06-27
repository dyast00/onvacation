import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onvocation/custom/appcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'profile_screen.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _currentImageUrl;
  @override
  void initState() {
    super.initState();
    // Fetch the user data from Firestore and set the initial values of the text fields
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        var userData = snapshot.data()!;
        _nameController.text = userData['name'];
        _emailController.text = userData['email'];
        _phoneController.text = userData['phone'] ?? '';
        _addressController.text = userData['address'] ?? '';
        _cityController.text = userData['city'] ?? '';
        _countryController.text = userData['country'] ?? '';
        setState(() {
          _currentImageUrl = userData['imageUrl'];
        });
      }
    });
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

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _updateProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Save the updated profile data to Firestore
      FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'country': _countryController.text,
      }).then((_) async {
        // Upload the profile image to Firebase Storage if an image is selected
        if (_image != null) {
          String fileName = user!.uid + DateTime.now().toString() + '.jpg';
          firebase_storage.Reference ref =
              firebase_storage.FirebaseStorage.instance.ref().child(fileName);

          await ref.putFile(_image!);

          String downloadURL = await ref.getDownloadURL();

          // Save the download URL to Firestore or use it as needed
          FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
            'imageUrl': downloadURL,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        ); // Go back to the profile screen
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(102, 218, 255, 1.0),
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: _image != null
                        ? ClipOval(
                            child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ))
                        : _currentImageUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  _currentImageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(bottom: 16.0),
                                child: CircleAvatar(
                                  radius: 60.0,
                                ),
                              ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showImagePickerDialog(),
                        child: Text('Select Photo'),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.whiteColor,
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.whiteColor,
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.whiteColor,
                        labelText: 'Phone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.whiteColor,
                        labelText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.whiteColor,
                              labelText: 'City',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _countryController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.whiteColor,
                              labelText: 'Country',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => _updateProfile(context),
                    child: Text('Update Profile'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
