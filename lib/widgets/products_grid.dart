import 'package:flutter/material.dart';
import 'package:shop_application/providers/products_provider.dart';
import 'package:shop_application/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorite;

  ProductsGrid(this.showFavorite);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    final products =
        showFavorite ? productsData.favoriteProducts : productsData.items;

    return GridView.builder(
      itemCount: products.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.7 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
    );
  }
}
