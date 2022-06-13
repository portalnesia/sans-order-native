import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget createLoadingDialog(BuildContext context) => Dialog(
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        CupertinoActivityIndicator(),
        SizedBox(height: 15),
        Text('Mohon tunggu...',style: TextStyle(fontSize: 18))
      ],
    ),
  ),
);
