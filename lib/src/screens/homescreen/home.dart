import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:secur/src/controllers/totp_controller.dart';
import 'package:secur/src/services/barcode_scan.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:secur/src/themes/theme.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(context),
      body: homeBody(context),
      appBar: appBar(context),
    );
  }
}

Widget appBar(context) => AppBar(
      title: RichText(
        text: TextSpan(
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Circular-Std",
            ),
            children: [
              TextSpan(
                  text: 'Sec',
                  style: TextStyle(color: Theme.of(context).accentColor)),
              TextSpan(text: 'ur', style: TextStyle(color: Colors.white))
            ]),
      ),
      centerTitle: true,
    );

Widget homeBody(BuildContext context) => SafeArea(
      child: Container(
          child: GetBuilder<TOTPController>(
        init: TOTPController(),
        builder: (controller) {
          var values = controller.db.values.toList();
          if (values.isEmpty) {
            return Center(
              child: Text('Nothing to see here'),
            );
          } else {
            return _buildBody(context, values);
          }
        },
      )),
    );

FloatingActionButton buildFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      _bottomSheet(context);
    },
    tooltip: 'Add secret',
    child: Icon(
      Icons.add,
      color: Colors.white,
    ),
    elevation: 1.0,
  );
}

void _bottomSheet(context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    builder: (BuildContext bc) {
      return Container(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(MaterialCommunityIcons.qrcode_scan),
              title: Text("Scan QR code"),
              onTap: () async => await scanBarcode(),
            ),
            ListTile(
              leading: Icon(MaterialCommunityIcons.keyboard),
              title: Text("Enter a provided key"),
              onTap: () {
                navigator.pop();
                Get.snackbar(
                  'TODO',
                  'To be implemented',
                  barBlur: 0.5,
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.black87,
                  icon: Icon(Icons.error_outline, color: Colors.red),
                  animationDuration: Duration(milliseconds: 500),
                  backgroundColor: Colors.white,
                  duration: Duration(seconds: 3),
                  borderRadius: 10,
                  maxWidth: 420,
                  isDismissible: true,
                  shouldIconPulse: false,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildBody(BuildContext context, List values) {
  return ListView.builder(
      itemCount: values.length,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Dismissible(
              onDismissed: (direction) {
                values.removeAt(index);
              },
              direction: DismissDirection.endToStart,
              background: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CupertinoColors.destructiveRed,
                ),
                height: 130,
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Icon(Icons.delete_outline),
                ),
              ),
              key: ValueKey(index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: deepBlueSecondary,
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                height: 130,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 2),
                          height: MediaQuery.of(context).size.height /14.5 ,
                          width: MediaQuery.of(context).size.width /8,
                          alignment: Alignment.center,
                          child: Icon(FontAwesome.google,color: neonGreen,size: 35,),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        Container(
                          child: Column(),
                        ),
                        Container(),
                      ],
                    ),
                    Row(),
                  ],
                ),
              )),
        );
      });
}
