import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ITSchool Asset Checking'),
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
              Divider(
                height: 10,
                thickness: 1,
                indent: 10,
                endIndent: 0,
                //color: Colors.black,
              ),
              SizedBox(height: 15),
              Text('Choose asset checking method'),
              SizedBox(height: 5),
              Text('1. Input 15-digits inventory number'),
              SizedBox(height: 15),
              TextFormField(
                //controller: tcLocation,
                initialValue: '',
                decoration: InputDecoration(
                  labelText: 'Inventory Number',
                  //errorText: 'Error message',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
