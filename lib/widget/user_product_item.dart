import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../screens/add_product_screen.dart';

class UserProductItems extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItems({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProviders>(context);
    final scaffold = ScaffoldMessenger.of(context);
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          radius: 20.r,
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: SizedBox(
          width: 100.w,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      AddProductScreen.addProductScreen,
                      arguments: id);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await product.deleteProduct(id);
                  } catch (error) {
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(const SnackBar(
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xffB1BDC5),
                        elevation: 4,
                        content: Text('Delete product failed')));
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
