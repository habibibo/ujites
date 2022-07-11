import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image_picker/image_picker.dart';
import 'database/handler.dart';
import 'model/profile.dart';
import 'addprofile.dart';
import 'detailprofile.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Group',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Add Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _photoController = TextEditingController();
  late File getimage;
  late String imagedata;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<int> saveProfiles() async {
    int getheight = int.parse(_heightController.text);
    int getweight = int.parse(_weightController.text);
    final inputUser = {
                      "name" : _nameController.text,
                      "address" : _addressController.text,
                      "birth" : _birthController.text,
                      "height" : getheight,
                      "weight" : getweight,
                      "photo" : imagedata
                    };
    return await DatabaseHandler.instance.insertProfile(inputUser);
  }

Future getImage() async {
     try {
          var pickedFile = await ImagePicker().pickImage(
            source: ImageSource.gallery,
          );
          setState(() {
            getimage = File(pickedFile!.path);
           imagedata = base64Encode(getimage.readAsBytesSync()).toString();
          });
          print(imagedata);
          return imagedata;
        } catch (e) {
          setState(() {
          
          });
        }
    
}

   @override
  void initState() {
    _birthController.text = ""; 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 7, 100, 175),
        toolbarHeight: 45,
        automaticallyImplyLeading: false, // Don't show the leading button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children : [
                      Icon(Icons.home,size:20),
                      Text(
                        "Home",
                        style: TextStyle(fontSize: 14),
                      ),
                    ]),
                ]),
            ),
            Spacer(),

            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProfile()),
                );
              },
            ),

            // Your widgets here
          ],
        ),
      ),
      body: 
      FutureBuilder(
        future: DatabaseHandler.instance.getProfiles(),
        builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await DatabaseHandler.instance.deleteProfile(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: 
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailProfile(getid : snapshot.data![index].id.toString())),
                      );
                    },
                    child :
                      Card(
                         elevation: 5,
                         child: ListTile(
                            contentPadding: EdgeInsets.all(8.0),
                            leading: Image.memory(base64Decode(snapshot.data![index].photo),
                              height: 80,),
                            title: Text(snapshot.data![index].name),
                            subtitle: Text(snapshot.data![index].address)
                        ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    
    );
    
  }
}
