import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/products_provider.dart';
import 'package:shop_application/screens/new_product_screen.dart';
import 'package:shop_application/widgets/app_drawer.dart';
import 'package:shop_application/widgets/user_products_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('infinte loop');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // ...
              Navigator.of(context).pushNamed(
                NewProductScreen.routeName,
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProduct(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Consumer<Products>(
                        builder: (context, products, child) => ListView.builder(
                          itemCount: products.items.length,
                          itemBuilder: (context, i) => UserProductsItem(
                            id: products.items[i].id,
                            title: products.items[i].title,
                            imageUrl: products.items[i].imageUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

// child: ListView.builder(
//   itemCount: productsData.items.length,
//   itemBuilder: (ctx, i) => UserProductsItem(
//     title: productsData.items[i].title,
//     imageUrl: productsData.items[i].imageUrl,
//   ),
// ),
