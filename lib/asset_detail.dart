import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class asset_details extends StatefulWidget {
  const asset_details({Key? key}) : super(key: key);

  @override
  State<asset_details> createState() => _asset_detailsState();
}

class _asset_detailsState extends State<asset_details> {
  final _url = 'http://192.168.0.125:3000';
  TextEditingController tcLocation = TextEditingController();
  TextEditingController tcRoom = TextEditingController();
  String code = '';
  String detail = '';
  String location = '';
  String room = '';

//radio
  bool _isButtonEnabled = true;
  int status = 0;
  int gValue = 0;

  //radio button
  void changeRadio(int? value) {
    setState(() {
      gValue = value!;
    });
  }

  //disabled button
  void disable() {
    setState(() {
      _isButtonEnabled = false;
    });
  }

  //showdetails
  void initState() {
    show_details();
    super.initState();
  }

  void show_details() async {
    Uri url = Uri.parse(_url + '/show_item/');
    http.Response response = await http.get(url);
    print(response.statusCode);
    final asset = List<Map<String, dynamic>>.from(jsonDecode(response.body));

    String inven_code = (asset[0]['Inventory_Number'] ?? '');
    String inven_detail = (asset[0]['Asset_Description'] ?? '');
    String inven_location = (asset[0]['Location'] ?? '');
    String inven_room = (asset[0]['Room'] ?? '');
    int inven_status = (asset[0]['Status'] ?? '');
    setState(() {
      code = inven_code;
      detail = inven_detail;
      location = inven_location;
      room = inven_room;
      status = inven_status;
    });
  }

  //update details
  void update_details() async {
    Uri url = Uri.parse(_url + '/update_data/');

    try {
      http.Response response = await http.post(url, body: {
        'location': tcLocation.text,
        'room': tcRoom.text,
        'status': gValue.toString()
      });

      print(response.body);
      if (response.statusCode == 200) {
      } else {}
    } on TimeoutException catch (e) {
      //show alert dialog
      print('Timeout error :$e');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Details'),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: [
              Text('Inventory Number:'),
              SizedBox(height: 10),
              TextFormField(
                controller: tcLocation,
                enabled: _isButtonEnabled,
                initialValue: '',
                decoration: InputDecoration(
                  labelText: 'Building',
                  //errorText: 'Error message',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.error,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: tcRoom,
                enabled: _isButtonEnabled,
                initialValue: '',
                decoration: InputDecoration(
                  labelText: 'Room',
                  //errorText: 'Error message',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.error,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: gValue,
                        onChanged: !_isButtonEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  gValue = 0;
                                });
                              },
                      ),
                      Text('Lost')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: gValue,
                        onChanged: !_isButtonEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  gValue = 1;
                                });
                              },
                      ),
                      Text('Normal')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: gValue,
                        onChanged: !_isButtonEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  gValue = 2;
                                });
                              },
                      ),
                      Text('Degraded')
                    ],
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Success',
                    content: Column(
                      children: [
                        const Text('Asset check!'),
                        OutlinedButton(
                          onPressed: () {
                            update_details();
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    ),
                    barrierDismissible: false,
                  );
                },
                child: Text('Check'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
