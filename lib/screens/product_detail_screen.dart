import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    //   mendapatkan id yang dikirimkan melalui pushNamed di product item
    final String productId = ModalRoute.of(context).settings.arguments;

    // listen
    // agar kalau misal kita menambah product di Product listener , widget ini tidak rebuild
    final loadedProduct = Provider.of<Products>(context, listen: false)
        .findById(productId); //(method yang sudah ada di products providers)

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
