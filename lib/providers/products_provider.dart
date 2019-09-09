import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/product.dart';

class Products extends ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'G302',
      description: 'Mouse Logitech G302!',
      price: 29.99,
      imageUrl:
          'https://i5.walmartimages.com/asr/75ca782b-cd3b-4d67-a143-6d39259a5477_1.6e295ef14632472e60f093e395e7ee05.jpeg?odnHeight=450&odnWidth=450&odnBg=FFFFFF',
    ),
    Product(
      id: 'p2',
      title: 'Leaf Beast',
      description:
          'Leaf Beast Wireless Bluetooth Headphones with mic and 30 Hour Battery Life',
      price: 59.99,
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/8131QjX7ThL._SX425_.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Macbook',
      description: 'Macbook pro',
      price: 450.99,
      imageUrl:
          'https://cdnblob.moshi.com/uploadedfiles/photo/v3/productImages/791/01.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Chroma',
      description: 'Razer Cynosa Chroma Keyboard',
      price: 49.99,
      imageUrl:
          'https://groundzeronet.com/wp-content/uploads/2017/10/blackwidow-tournament-edition-chroma-v2_c4cb1618450db16c.jpg',
    ),
  ];

  var _showFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteProducts {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  void addProduct(Product product) {
    final newProduct = Product(
      description: product.description,
      id: DateTime.now().toString(),
      price: product.price,
      imageUrl: product.imageUrl,
      title: product.title,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }
}
