import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/models/http_exception.dart';
import 'package:shop_application/providers/product.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class Products extends ChangeNotifier {
  List<Product> _items = [];

  final String authToken;

  final String userId;

  Products(
    this.authToken,
    this.userId,
    this._items,
  );

  var _showFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteProducts {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterUserProduct = false]) async {
    final filterString =
        filterUserProduct ? 'orderBy="userId"&equalTo="$userId"' : "";

    var url =
        'https://crescentia-b307e.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      // di ovverwrite
      url =
          'https://crescentia-b307e.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

      final favoriteResponse = await http.get(url);

      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProduct = [];

      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          description: prodData['description'],
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });

      _items = loadedProduct;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    //   async mengembalikan future

    final url =
        'https://crescentia-b307e.firebaseio.com/products.json?auth=$authToken';
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
            'userId': userId,
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
      final url =
          'https://crescentia-b307e.firebaseio.com/products/$id.json?auth=$authToken';

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
    final url =
        'https://crescentia-b307e.firebaseio.com/products/$id.json?auth=$authToken';

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
