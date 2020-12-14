import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatefulWidget {

  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  User user = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double heightScreen = mediaQuery.size.height;
    double widhtScreen = mediaQuery.size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Home Page"),),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildListItemFireStoreData(heightScreen, widhtScreen, context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBiodata()),
          );
        },
        tooltip: "added",
        child: Icon(Icons.add),
      ),
    );
  }

  _buildListItemFireStoreData(double heightScreen, double widhtScreen, BuildContext context) {
    return Container(
      height: heightScreen,
      width: widhtScreen,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("Hallo, ${user.displayName}"),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection("biodata").snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, int index) {
                      DocumentSnapshot document = snapshot.data.docs[index];
                      Map<String, dynamic> data = document.data();
                        return Card(
                          child: ListTile(
                            title: Image.network(data['url'], height: 200, width: 200,),
                            subtitle: Text("NIM: ${data['nim']}\nNama: ${data['nama']}\nNo HP: ${data['nohp']}"),
                          ),
                        );
                    }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddBiodata extends StatefulWidget {

  @override
  State createState() => AddBiodataState();
}

class AddBiodataState extends State<AddBiodata> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  TextEditingController controllerNim = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNoHp = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  PickedFile pickedFile;
  File imgPicker;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double heightScreen = mediaQuery.size.height;
    double widthScreen = mediaQuery.size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Add Biodata Page")),
      key: globalKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: heightScreen,
              width: widthScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildFormAddBiodata(),
                  RaisedButton(
                    child: Text("Tambah Biodata"),
                    onPressed: () async {
                      String nim = controllerNim.text;
                      String nama = controllerName.text;
                      String nohp = controllerNoHp.text;
                      Map<String,dynamic> data = Map();
                      data['nim'] = nim;
                      data['nama'] = nama;
                      data['nohp'] = nohp;
                      uploadImage(nim).then((value) {
                        value.snapshot.ref.getDownloadURL().then((url) async {
                         data['url'] = url;
                         CollectionReference reference = firestore.collection("biodata");
                         DocumentReference document = await reference.add(data);
                         if(document.id != null) {
                           Navigator.pop(context,true);
                         }
                        });
                      });
                      // await storageReference.getDownloadURL().then((imageUrl) {
                      //   data['imageURL'] = imageUrl;
                      // });

                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: takePhoto,
        tooltip: "take photo",
        child: Icon(Icons.camera),
      ),
    );
  }

  Future<UploadTask> uploadImage(String path) async {
      Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("images/$path.jpg");
      UploadTask uploadTask = storageReference.putFile(File(pickedFile.path));
      return Future.value(uploadTask);
  }

  _buildFormAddBiodata() {
    return Column(
      children: <Widget>[
        TextField(
          controller: controllerNim,
          decoration: InputDecoration(
            labelText: "NIM"
          ),
          style: TextStyle(fontSize: 15),
        ),
        TextField(
          controller: controllerName,
          decoration: InputDecoration(
              labelText: "Nama"
          ),
          style: TextStyle(fontSize: 15),
        ),
        TextField(
          controller: controllerNoHp,
          decoration: InputDecoration(
              labelText: "No Hp"
          ),
          style: TextStyle(fontSize: 15),
        ),
        pickedFile == null ? Text("Ambil gambar") : Image.file(File(pickedFile.path), height: 200, width: 200,),
      ],
    );
  }

  void takePhoto() async {
    pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {

    });
  }
}