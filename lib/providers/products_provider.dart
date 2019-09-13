import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/models/http_exception.dart';
import 'package:shop_application/providers/product.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class Products extends ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'G302',
    //   description: 'Mouse Logitech G302!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://i5.walmartimages.com/asr/75ca782b-cd3b-4d67-a143-6d39259a5477_1.6e295ef14632472e60f093e395e7ee05.jpeg?odnHeight=450&odnWidth=450&odnBg=FFFFFF',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Leaf Beast',
    //   description:
    //       'Leaf Beast Wireless Bluetooth Headphones with mic and 30 Hour Battery Life',
    //   price: 59.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/8131QjX7ThL._SX425_.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Macbook',
    //   description: 'Macbook pro',
    //   price: 450.99,
    //   imageUrl:
    //       'https://cdnblob.moshi.com/uploadedfiles/photo/v3/productImages/791/01.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Chroma',
    //   description: 'Razer Cynosa Chroma Keyboard',
    //   price: 49.99,
    //   imageUrl:
    //       'https://groundzeronet.com/wp-content/uploads/2017/10/blackwidow-tournament-edition-chroma-v2_c4cb1618450db16c.jpg',
    // ),
  ];

  var _showFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteProducts {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://crescentia-b307e.firebaseio.com/products.json';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          description: prodData['description'],
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
        ));
      });

      _items = loadedProduct;

      if (_items.isEmpty) {
        return;
      }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    //   async mengembalikan future

    const url = 'https://crescentia-b307e.firebaseio.com/products.json';
    // memberitahu dart bahwa tunggu kode ini selesai , baru boleh eksekusi code di bawahnya
    try {
      // try untuk catch error
      // code yang memungkinkan error
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      final newProduct = Product(
        description: product.description,
        id: json.decode(response.body)['name'],
        price: product.price,
        imageUrl: product.imageUrl,
        title: product.title,
      );

      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    // invisibly wrap with then block
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://crescentia-b307e.firebaseio.com/products/$id.json';

      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price
        }),
      );

      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://crescentia-b307e.firebaseio.com/products/$id.json';

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);

    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
