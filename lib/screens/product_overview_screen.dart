import 'package:flutter/material.dart';
import 'package:shop_application/widgets/products_grid.dart';

import '../widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caslevania'),
        backgroundColor: Colors.green,
      ),
      body: ProductsGrid(),
    );
  }
}
