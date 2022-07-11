import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image_picker/image_picker.dart';
import 'database/handler.dart';
import 'model/profile.dart';
import 'main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddProfile extends StatefulWidget {

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {


  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _photoController = TextEditingController();
  late File getimage;
  late String imagedata;
  Color buttonColor = Colors.greenAccent;
  bool disbutton = false;
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 90;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  Future<int> saveProfiles(context) async {
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
      SweetAlert.show(context,
                        title: "Berhasil",
                        subtitle: "Profil berhasil ditambahkan",
                        style: SweetAlertStyle.success);
      
      return await DatabaseHandler.instance.insertProfile(inputUser);
      
    

    _nameController.text = "";
    _addressController.text = "";
    _birthController.text = "";
    _heightController.text = "";
    _weightController.text = "";
      
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

@override
void initState() {
  startTimeout();
  Future.delayed(const Duration(milliseconds: 90000), () {

  // Here you can write your code

    setState(() {
      buttonColor = Colors.grey;
      disbutton = true;
      // Here you can write your code for open new view
    });

  });


}

@override
  Widget build(BuildContext context) {
   
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        getback(context);
                      },
                    ),
                  ]),
            ),
            Spacer(),

            // Your widgets here
          ],
        ),
      ),
      body: 

      Container(
      color: Colors.white,
      child : 
            SingleChildScrollView(
            padding : EdgeInsets.all(20),
            child : 
            Column(  
              children: <Widget>[
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.timer, color: Colors.blue,),
                    SizedBox(
                      width: 5,
                    ),
                    Text(timerText)
                  ],
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
                Container(
                  child: 
                  InkWell(

                    onTap: (){
                    getImage();
                    },
                    child : Card(
                    elevation : 5,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child : Row(
                        children: [
                          Text("Upload file"),
                          Icon(
                              Icons.upload_file, color: Colors.orange,
                              size: 30,
                            ),
                        ],
                      ),
                    ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                ),
                MaterialButton(
                  elevation: 5,
                  padding: EdgeInsets.all(10),
                  color: buttonColor,
                  child: Text(
                    "Simpan"
                  ),
                  onPressed: (){
                    if(_nameController.text == ""){
                        SweetAlert.show(context,
                                        title: "Maaf",
                                        subtitle: "Anda belum memasukkan nama",
                                        style: SweetAlertStyle.error);
                      }else if(_addressController.text == ""){
                        SweetAlert.show(context,
                                        title: "Maaf",
                                        subtitle: "Anda belum memasukkan alamat",
                                        style: SweetAlertStyle.error);
                      }else if(_birthController.text == ""){
                        SweetAlert.show(context,
                                        title: "Maaf",
                                        subtitle: "Anda belum memasukkan tanggal lahir",
                                        style: SweetAlertStyle.error);
                      }else if(_heightController.text == ""){
                        SweetAlert.show(context,
                                        title: "Maaf",
                                        subtitle: "Anda belum memasukkan tinggi badan",
                                        style: SweetAlertStyle.error);
                      }else if(_weightController.text == ""){
                        SweetAlert.show(context,
                                        title: "Maaf",
                                        subtitle: "Anda belum memasukkan berat badan",
                                        style: SweetAlertStyle.error);
                      }else if(disbutton == true){
                        SweetAlert.show(context,
                                        title: "Maaf",
                                        subtitle: "Waktu anda telah habis, silahkan kembali lagi",
                                        style: SweetAlertStyle.error);
                      }else{
                          saveProfiles(context);
                      }
                }
                ),
                
                
              ],
            ),
          ),
          
        ),
      ),
    );
  }

}