// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';

// class SharingPage extends StatefulWidget {
//   @override
//   _SharingPageState createState() => _SharingPageState();
// }

// class _SharingPageState extends State<SharingPage> {
//   TextEditingController _userNameController = TextEditingController();
//   late File _imageFile;

//   CollectionReference _usersCollection =
//       FirebaseFirestore.instance.collection('users');

//   Future<void> _uploadImage() async {
//     String userName = _userNameController.text;

//     if (userName.isEmpty || _imageFile == null) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text('Please enter your name and select an image.'),
//             actions: [
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }

//     // Upload image to Firebase Storage
//     String imageURL = await _uploadImageToStorage(_imageFile);

//     // Save image data to Firestore
//     await _usersCollection.doc(userName).set({
//       'imageURL': imageURL,
//     });

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Success'),
//           content: Text('Image shared successfully.'),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _userNameController.clear();
//                 setState(() {
//                   _imageFile = null;
//                 });
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<String> _uploadImageToStorage(File image) async {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference reference =
//         FirebaseStorage.instance.ref().child('images/$fileName.jpg');
//     UploadTask uploadTask = reference.putFile(image);
//     TaskSnapshot storageTaskSnapshot = await uploadTask;
//     String imageURL = await storageTaskSnapshot.ref.getDownloadURL();
//     return imageURL;
//   }

//   Future<void> _getImageFromCamera() async {
//     final picker = ImagePicker();
//     PickedFile pickedFile =
//         await picker.getImage(source: ImageSource.camera);

//     setState(() {
//       if (pickedFile != null) {
//         _imageFile = File(pickedFile.path);
//       }
//     });
//   }

//   Future<void> _getImageFromGallery() async {
//     final picker = ImagePicker();
//     PickedFile pickedFile =
//         await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _imageFile = File(pickedFile.path);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Sharing'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextFormField(
//               controller: _userNameController,
//               decoration: InputDecoration(labelText: 'Your Name'),
//             ),
//             SizedBox(height: 16.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     child: Text('Take Photo'),
//                     onPressed: _getImageFromCamera,
//                   ),
//                 ),
//                 SizedBox(width: 16.0),
//                 Expanded(
//                   child: ElevatedButton(
//                     child: Text('Select Photo'),
//                     onPressed: _getImageFromGallery,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             _imageFile != null
//                 ? Image.file(_imageFile, height: 200.0)
//                 : SizedBox(height: 0),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               child: Text('Share Image'),
//               onPressed: _uploadImage,
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Shared Images:',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8.0),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _usersCollection.snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   }

//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   }

//                   if (snapshot.hasData) {
//                     final users = snapshot.data.docs;

//                     return ListView.builder(
//                       itemCount: users.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final user = users[index].data();
//                         final userName = users[index].id;
//                         final imageURL = user['imageURL'];

//                         return ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: NetworkImage(imageURL),
//                           ),
//                           title: Text(userName),
//                         );
//                       },
//                     );
//                   }

//                   return Text('No shared images yet.');
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
