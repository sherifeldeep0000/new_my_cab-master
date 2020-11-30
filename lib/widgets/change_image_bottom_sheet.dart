import 'package:flutter/material.dart';

void changeImageBottomSheet(
    BuildContext context, void Function(bool changePhoto) changePhotoSelected) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              onTap: () {
                Navigator.pop(context);
                changePhotoSelected(true);
              },
              title: Text("تغيير الصورة")),
          ListTile(
              onTap: () {
                Navigator.pop(context);
                changePhotoSelected(false);
              },
              title: Text("عرض الصورة")),
        ],
      );
    },
  );
}
