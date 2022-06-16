import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: GetPlatform.isIOS
            ? Column(
                children: [
                  CupertinoActivityIndicator(
                    animating: true,
                  ),
                  Text('Please wait...')
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoActivityIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Please wait...')
                  ],
                ),
              ));
  }
}
