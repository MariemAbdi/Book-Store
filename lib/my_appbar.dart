import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:untitled/shopping_cart.dart';
import 'package:badges/badges.dart' as badges;

class MyAppBar extends StatefulWidget with PreferredSizeWidget{
  MyAppBar({Key? key, required this.pageTitle, required this.items}) : super(key: key);

  final String pageTitle;
  final int items;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}


class _MyAppBarState extends State<MyAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(widget.pageTitle),
      centerTitle: true,
      actions: [
        badges.Badge(
          badgeContent: Text(widget.items.toString(), style: const TextStyle(color: Colors.white),),
          position: badges.BadgePosition.topEnd(top: 0, end: 0,),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.orange
          ),
          child: IconButton(onPressed: (){Get.to(() => const Cart());}, icon: const Icon(Icons.shopping_cart)),
        ),

        IconButton(onPressed: (){
          // Create AlertDialog
          AlertDialog alert = AlertDialog(
          title: const Text("Leave App"),
          content: const Text("Are You Sure You Want To Leave ?"),
          actions: [
          ElevatedButton(
              onPressed: (){Navigator.of(context).pop();}, child: const Text("NO")),
          ElevatedButton(onPressed: (){exit(0);}, child: const Text("YES")),
          ],
          );
          // show the dialog
          showDialog(
          context: context,
          builder: (BuildContext context) {
          return alert;
          },);
          }, icon: const Icon(Icons.power_settings_new_rounded)),
      ],
    );
  }
}
