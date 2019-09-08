import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/cart.dart';
import 'package:shop_application/providers/product.dart';
import 'package:shop_application/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //   menerima listener dari product provider yang dikirim melalui product item
    final product = Provider.of<Product>(context, listen: false);

    final cart = Provider.of<Cart>(context, listen: false);

    //   agar mengatur border radius , jadi menggunaan clipreact
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        // mengatur bagian bawah grid
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          //   Widget selalu update kalau ada prubahan di dalam product
          //   bakal manggil method yang sesui di product
          leading: Consumer<Product>(
            builder: (ctx, product, ch) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            maxLines: 2,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          //   untuk cart item
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // menambahkan item ke cart state
              cart.addItem(
                product.id,
                product.title,
                product.price,
                product.imageUrl,
              );
              final snackBar = SnackBar(
                content: Text('Yay! A SnackBar!'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Some code to undo the change.
                    cart.undoCart(product.id);
                  },
                ),
              );
              // Find the Scaffold in the widget tree and use
              // it to show a SnackBar.
              Scaffold.of(context).showSnackBar(snackBar);
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
