import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../provider/order_provider.dart';
import '../widget/app_drawer.dart';
import '../widget/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const orderScreen = 'OrderScreen';
  const OrderScreen({Key? key}) : super(key: key);

  // var _isInit = true;
  // var _isLoading = false;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<OrdersProvider>(context, listen: false)
  //         .fetchAndGetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     ((_) async {
  //       setState(() {
  //         _isLoading = true;
  //       });
  //       await Provider.of<OrdersProvider>(context, listen: false)
  //           .fetchAndGetOrders();
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<OrdersProvider>(context);
    print('builder run');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order Data'),
          elevation: 5,
          backgroundColor: const Color(0xffB1BDC5),
        ),
        drawer: const AppDrawer(),
        backgroundColor: const Color(0xffFAF8FF),
        body: FutureBuilder(
          future: Provider.of<OrdersProvider>(context, listen: false)
              .fetchAndGetOrders(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  width: 100.w,
                  height: 90.h,
                  child: LiquidCircularProgressIndicator(
                    value: 0.4, // Defaults to 0.5.
                    valueColor: const AlwaysStoppedAnimation(Color(
                        0xffB1BDC5)), // Defaults to the current Theme's accentColor.
                    backgroundColor: Colors
                        .white, // Defaults to the current Theme's backgroundColor.
                    borderColor: Colors.grey,
                    borderWidth: 2.0,
                    direction: Axis
                        .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                    center: const Text(
                      "Products",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              );
            }
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text('Error Occurred'),
              );
            } else {
              return Consumer<OrdersProvider>(
                builder: (context, value, child) => ListView.builder(
                  itemBuilder: (context, index) =>
                      OrderItems(orderItem: value.order[index]),
                  itemCount: value.order.length,
                ),
              );
            }
          },
        ));
  }
}
