import 'package:flutter/material.dart';

import '../screens/order_screen.dart';
import '../screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4,
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        children: [
          AppBar(
            title: const Text('GB-STORE'),
            elevation: 4,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xffB1BDC5),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrderScreen.orderScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manages Products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, UserProductScreen.userProductScreen);
            },
          ),
        ],
      ),
    );
  }
}
