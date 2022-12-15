import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../widget/app_drawer.dart';
import '../widget/user_product_item.dart';
import 'add_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const userProductScreen = 'UserProductScreen';
  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductsProviders>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProviders>(context);
    return Scaffold(
      backgroundColor: const Color(0xffFAF8FF),
      appBar: AppBar(
        title: const Text('My Products'),
        elevation: 5,
        backgroundColor: const Color(0xffB1BDC5),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AddProductScreen.addProductScreen,
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        backgroundColor: const Color(0xffB1BDC5),
        color: Colors.white,
        displacement: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (_, i) => UserProductItems(
              id: product.items[i].id,
              title: product.items[i].title,
              imageUrl: product.items[i].imageUrl,
            ),
            itemCount: product.items.length,
          ),
        ),
      ),
    );
  }
}
