import 'package:flutter/material.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:qr_scan/asset_detail.dart';

class qrScan extends StatefulWidget {
  qrScan({Key? key}) : super(key: key);

  @override
  _qrScanState createState() => _qrScanState();
}

class _qrScanState extends State<qrScan> {
  Result? currentResult;
  final _url = 'http://192.168.0.125:3000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRCodeDartScanView(
        scanInvertedQRCode: true,
        onCapture: (Result result) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const asset_details()),
          );
          setState(() {
            currentResult = result;
          });
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Text: ${currentResult?.text ?? 'Not found'}'),
                Text('Format: ${currentResult?.barcodeFormat ?? 'Not found'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
