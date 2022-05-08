import 'package:flutter/material.dart';
import 'dart:convert';
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

  String result = '';
  String check = '';

//radio
  bool _isButtonEnabled = true;
  bool isVisible = true;
  int status = 0;
  int? gValue;
  int? val;

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

  //show details
  void initState() {
    result = Get.arguments;
    show_details();
    super.initState();
  }

  void show_details() async {
    Uri url = Uri.parse(_url + '/inventory/' + result);
    http.Response response = await http.get(url);
    print(response.statusCode);
    final asset = List<Map<String, dynamic>>.from(jsonDecode(response.body));

    String inven_code = (asset[0]['Inventory_Number'] ?? '');
    String inven_detail = (asset[0]['Asset_Description'] ?? '');
    String inven_room = (asset[0]['Room'] ?? '');
    String inven_location = (asset[0]['Location'] ?? '');
    int inven_status = (asset[0]['Status'] ?? '');

    setState(() {
      code = inven_code;
      detail = inven_detail;
      location = inven_location;
      room = inven_room;
      val = inven_status;

      if (inven_status == 1 || inven_status == 2) {
        disable();
        isVisible = !isVisible;
        check = 'Not in checking period or this asset is checked';
      }
    });
  }

  //show dialog
  void show_dialog() {
    Get.defaultDialog(
      title: 'Success',
      content: Column(
        children: [
          const Text('Asset check!'),
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
  }

  //update details
  void update_details() async {
    Uri url = Uri.parse(_url + '/update/' + result);
    print(result);
    try {
      http.Response response = await http.post(url, body: {
        'location': tcLocation.text,
        'room': tcRoom.text,
        'status': val.toString()
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
              Text(code),
              Text(detail),
             
              SizedBox(height: 10),
              TextField(
                controller: tcLocation,
                enabled: _isButtonEnabled,
                decoration: InputDecoration(
                  labelText: 'Building',
                  hintText: location,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  //errorText: 'Error message',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.error,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: tcRoom,
                enabled: _isButtonEnabled,
                
                decoration: InputDecoration(
                  labelText: 'Room',
                  hintText: room,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        groupValue: val,
                        onChanged: !_isButtonEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  val = 0;
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
                        groupValue: val,
                        onChanged: !_isButtonEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  val = 1;
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
                        groupValue: val,
                        onChanged: !_isButtonEnabled
                            ? null
                            : (value) {
                                setState(() {
                                  val = 2;
                                });
                              },
                      ),
                      Text('Degraded')
                    ],
                  ),
                ],
              ),
              Text(check),
            Visibility(
              child: OutlinedButton(
                onPressed: () {
                  update_details();
                  disable();
                  show_dialog();
                  isVisible = !isVisible;
                  check = 'The asset is checked';
                },
                child: Text('Check'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.blue,
                ),
              ),
              visible: isVisible,
            ),
              // OutlinedButton(
              //   onPressed: () {
              //     Get.defaultDialog(
              //       title: 'Success',
              //       content: Column(
              //         children: [
              //           const Text('Asset check!'),
              //           OutlinedButton(
              //             onPressed: () {
              //               update_details();
              //               disable();
              //               show_dialog();
                            
              //             },
                          
              //           ),
              //         ],
              //       ),
              //       barrierDismissible: false,
              //     );
              //   },
                
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
