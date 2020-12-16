import 'package:majascan/majascan.dart';
import 'package:digimobile/components/reusable_card.dart';
import 'package:digimobile/constants.dart';
import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
    String cameraScanResult;

    _scanQRCode() async {
        cameraScanResult = await MajaScan.startScan(
          title: "Scannez le QR code du masque",
        );
        print(cameraScanResult);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digimask'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.bottomLeft,
              child: Text(
                'Scannez le QR code sur votre masque',
                style: kTitleTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(onPressed: _scanQRCode)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
