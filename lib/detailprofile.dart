import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetalert/sweetalert.dart';
import 'database/handler.dart';
import 'model/profile.dart';
import 'addprofile.dart';
import 'main.dart';
class DetailProfile extends StatefulWidget {
  const DetailProfile({Key? key, required this.getid}) : super(key: key);
  final String getid;

  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  int _counter = 0;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _photoController = TextEditingController();
  late String getAddress,getBirth,getHeight,getWeight;
  String getPhoto = "";
  late File getimage;
  String imagedata = "";
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<int> saveProfiles(context) async {
    int getheight = int.parse(_heightController.text);
    int getweight = int.parse(_weightController.text);
    int thisid = int.parse(widget.getid);
    if(imagedata == ""){
      final inputUser = {
                      "name" : _nameController.text,
                      "address" : _addressController.text,
                      "birth" : _birthController.text,
                      "height" : getheight,
                      "weight" : getweight,
                      "photo" : "-"
                    };
      SweetAlert.show(context,
                                        title: "Berhasil",
                                        subtitle: "Profil telah di edit",
                                        style: SweetAlertStyle.success);              
      return await DatabaseHandler.instance.updateProfile(thisid,inputUser);

    }else{
      final inputUser = {
                      "name" : _nameController.text,
                      "address" : _addressController.text,
                      "birth" : _birthController.text,
                      "height" : getheight,
                      "weight" : getweight,
                      "photo" : imagedata
                    };
      SweetAlert.show(context,
                                        title: "Berhasil",
                                        subtitle: "Profil telah di edit",
                                        style: SweetAlertStyle.success); 
      return await DatabaseHandler.instance.updateProfile(thisid,inputUser);
    }
    
   
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

getback(context){
  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
}

getDetail(){
  final result = DatabaseHandler.instance.getProfilesId(widget.getid);
  result.then((value){
      
      setState(() {
          _nameController..text = value[0]['name'].toString();
          _addressController..text = value[0]['address'].toString();
          _birthController..text = value[0]['birth'].toString();
          _heightController..text = value[0]['height'].toString();
          _weightController..text = value[0]['weight'].toString();
          getPhoto = value[0]['photo'].toString();
          
      });
      print(value[0]['photo']);
      
    }); 


}

void delProfile(context,id)async{
  SweetAlert.show(context,
                                        title: "Berhasil",
                                        subtitle: "Berhasil dihapus",
                                        style: SweetAlertStyle.success);

  await DatabaseHandler.instance.deleteProfile(id);
  
}

   @override
  void initState() {
    _birthController.text = ""; 
    getDetail();
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
    return WillPopScope(
      onWillPop: () async {
       return getback(context);
      },      
    child : Scaffold(
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
                      Icon(Icons.edit,size:20),
                      Text(
                        "Edit",
                        style: TextStyle(fontSize: 14),
                      ),
                    ]),
                ]),
            ),
            Spacer(),

            // Your widgets here
          ],
        ),
      ),
      body: SingleChildScrollView(
                        padding : EdgeInsets.all(20),
                        child : 
                        Column(  
                          children: <Widget>[
                            Container(
                              height: 10,
                            ),
                            
                            Card(
                              elevation: 4,
                              child: Image.memory(base64Decode(getPhoto.toString()),
                              height: 80,),
                            ),
                            
                            Container(
                              height: 10,
                            ),
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration
                                (
                                  labelText: "Nama",
                                  hintText: "Nama"
                                )
                            ),
                            Container(
                                height: 10,
                              ),
                              TextField(
                                controller: _addressController,
                                decoration: InputDecoration
                                  (
                                    labelText: "Alamat",
                                    hintText: "Alamat"
                                  )
                              ),
                              Container(
                                height: 10,
                              ),
                              TextField(
                                controller: _birthController,
                                decoration: InputDecoration( 
                                    icon: Icon(Icons.calendar_today), 
                                    labelText: "Pilih tanggal" 
                                  ),
                                  readOnly: true,  
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context, initialDate: DateTime.now(),
                                        firstDate: DateTime(1980),
                                        lastDate: DateTime(2101)
                                    );
                                    
                                    if(pickedDate != null ){
                                        print(pickedDate);  
                                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                                        print(formattedDate);
                                          
                                        setState(() {
                                          _birthController.text = formattedDate;
                                        });
                                    }else{
                                        print("Tanggal belum dipilih");
                                    }
                                  },
                              ),
                              Container(
                                height: 10,
                              ),
                              TextField(
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration
                                  (
                                    labelText: "Tinggi (cm)",
                                    hintText: "Tinggi (cm)"
                                  )
                              ),
                              Container(
                                height: 10,
                              ),
                              TextField(
                                controller: _weightController,
                                decoration: InputDecoration
                                  (
                                    labelText: "Berat (kg)",
                                    hintText: "Berat (kg)"
                                  )
                              ),
                              Container(
                                height: 10,
                              ),
                            InkWell(
                              onTap: (){
                                getImage();
                              },
                              child: Icon(
                                Icons.upload_file,
                                size: 30,
                              ),
                            ),
                            Container(
                              height: 20,
                            ),
                            MaterialButton(
                              elevation: 5,
                              padding: EdgeInsets.all(10),
                              color: Colors.green[400],
                              child: Text(
                                "Simpan"
                              ),
                              onPressed: (){
                                saveProfiles(context);
                            }
                            ),
                            Container(
                              height: 20,
                            ),
                            MaterialButton(
                              elevation: 5,
                              padding: EdgeInsets.all(10),
                              color: Colors.red,
                              child: Text(
                                "Hapus"
                              ),
                              onPressed: (){
                                delProfile(context, widget.getid);
                            }
                            ),
                          ],
                        ),
              )
             
     ),
    );
    
  }
}
