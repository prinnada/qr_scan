import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_scan/qr_code.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //text form validiation
  final _formKey = GlobalKey<FormState>();
  final fieldText = TextEditingController();

  String lost = '';
  String normal = '';
  String degraded = '';

  //clear text
  void clearText() {
    fieldText.clear();
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
                    'Lost:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  Text(
                    'Normal:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  Text(
                    'Degraded:',
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
                  controller: fieldText,
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Success')),
                        );
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
                        MaterialPageRoute(
                            builder: (context) => qrScan()),
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
