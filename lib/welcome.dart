import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_scan/qr_code.dart';
import 'asset_detail.dart';
import 'package:http/http.dart' as http;


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //text form validiation
  final _formKey = GlobalKey<FormState>();
  
  final _url = 'http://192.168.0.125:3000';

  int lost = 0;
  int normal = 0;
  int degraded = 0;

  TextEditingController tcNumber = TextEditingController();

  //clear text
  void clearText() {
    tcNumber.clear();
  }

  void initState() {
    item_lost();
    item_normal();
    item_degraded();
    super.initState();
  }

//------Lost-------
  void item_lost() async {
    Uri url = Uri.parse(_url + '/lost/');
    http.Response response = await http.get(url);
    print(response.statusCode);
    final asset = List<Map<String, dynamic>>.from(jsonDecode(response.body));

    int iLost = (asset[0]['COUNT(Status)'] ?? '');

    setState(() {
      lost = iLost;
    });
  }

//--------Normal--------
  void item_normal() async {
    Uri url = Uri.parse(_url + '/normal/');
    http.Response response = await http.get(url);
    print(response.statusCode);
    final asset = List<Map<String, dynamic>>.from(jsonDecode(response.body));

    int iNormal = (asset[0]['COUNT(Status)'] ?? '');

    setState(() {
      normal = iNormal;
    });
  }

  //-------Degraded----------
  void item_degraded() async {
    Uri url = Uri.parse(_url + '/degraded/');
    http.Response response = await http.get(url);
    print(response.statusCode);
    final asset = List<Map<String, dynamic>>.from(jsonDecode(response.body));

    int iDegraded = (asset[0]['COUNT(Status)'] ?? '');

    setState(() {
      degraded = iDegraded;
    });
  }

//------Inventory-------
  void check_inventory() async {
    Uri url = Uri.parse(_url + '/inventory/' + tcNumber.text);
    http.Response response = await http.get(url);
    //print(response.statusCode);
    if (response.statusCode == 500) {
      //print('No data');
      Get.defaultDialog(
        title: 'Error',
        content: Column(
          children: [
            const Text('Asset not found in our system'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('close'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else if (response.statusCode == 200) {
      Get.to(() => asset_details(), arguments: tcNumber.text);
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT School Asset Checking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: [
              Text('Summary of asset checking status'),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Lost:' + lost.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  Text(
                    'Normal:' + normal.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  Text(
                    'Degraded:' + degraded.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              const Divider(
                height: 20,
                thickness: 1,
                indent: 10,
                endIndent: 0,
                //color: Colors.black,
              ),
              SizedBox(height: 10),
              Text('Choose asset checking method'),
              SizedBox(height: 5),
              Text('1. Input 15-digits inventory number'),
              SizedBox(height: 15),
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some numbers';
                    } else if (value.length < 15) {
                      return 'Please enter 15-digit numbers';
                    }
                    return null;
                  },
                  //initialValue: '',
                  maxLength: 15,
                  controller: tcNumber,
                  decoration: const InputDecoration(
                    labelText: 'Inventory Number',
                    //errorText: 'Error message',
                    border: OutlineInputBorder(),
                    // suffixIcon: Icon(
                    //   Icons.error,
                    // ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: clearText,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.blue,
                      size: 24.0,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // background
                      onPrimary: Colors.blue, // foreground
                    ),
                    label: const Text(
                      'Clear',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Success')),
                        // );
                        setState(() {
                          check_inventory();
                        });
                      }
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.blue,
                      size: 24.0,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // background
                      onPrimary: Colors.blue, // foreground
                    ),
                    label: Text(
                      'Check',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 50,
                thickness: 1,
                indent: 20,
                endIndent: 0,
                //color: Colors.black,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('---- QR ----'),
                  Text('2. QR Code scan of asset'),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => qrScan()),
                      );
                    },
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.blue,
                      size: 24.0,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // background
                      onPrimary: Colors.blue, // foreground
                    ),
                    label: Text(
                      'Scan',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
