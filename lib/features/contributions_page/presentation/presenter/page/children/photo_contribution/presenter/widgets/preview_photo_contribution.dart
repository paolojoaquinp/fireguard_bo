import 'dart:io';

import 'package:flutter/material.dart';

class PreviewPhotoContribution extends StatelessWidget {
  const PreviewPhotoContribution({
    super.key,
    required this.photoPath,
  });

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text('Preview camera'),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.5,
              child: Image.file(File(photoPath)),
            ),
          ],
        ),
      ),
    );
  }
}
