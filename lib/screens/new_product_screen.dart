import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/product.dart';
import 'package:shop_application/providers/products_provider.dart';

class NewProductScreen extends StatefulWidget {
  static const routeName = '/add-product';
  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final String _productId = ModalRoute.of(context).settings.arguments;

      if (_productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(_productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //   'imageUrl': _editedProduct.imageUrl
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  // memory leak jadi harus di dispose
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    //   save form
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();
    // Jika kita punya id , dan tidak kosong
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false).updateProduct(
        _editedProduct.id,
        _editedProduct,
      );
    } else {
      // harus di bawah form state
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      appBar: AppBar(
        title: Text('Add Product'),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveForm(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 500,
          padding: EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Container(
                    height: 500,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(
                            labelText: 'Title',
                          ),
                          //   agar kalo di tekan enter , ke form selanjutnya tidak di submit
                          textInputAction: TextInputAction.next,
                          // setelah di klik , pindah ke price form
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Title can\'t be null';
                            }
                            // jika tidak ada error berarti sukses panjul
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description,
                              title: value,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(
                            labelText: 'Price',
                          ),
                          keyboardType: TextInputType.number,
                          //   agar kalo di tekan enter , ke form selanjutnya tidak di submit
                          textInputAction: TextInputAction.next,
                          // di tangkap focus
                          focusNode: _priceFocusNode,

                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Price can\'t be null';
                            }

                            if (double.tryParse(value) == null) {
                              return 'Please Enter a valid number';
                            }

                            if (double.parse(value) <= 0) {
                              return 'Please a number greater';
                            }
                            // jika tidak ada error berarti sukses panjul
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description,
                              title: _editedProduct.title,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Description can\'t be null';
                            }
                            if (value.length < 5) {
                              return 'Tidak boleh lebih kecil dari 5';
                            }
                            // jika tidak ada error berarti sukses panjul
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              description: value,
                              title: _editedProduct.title,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              //   preview image
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter Text')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            //   harus di wrap pakai expanded kalo textfield dalam row
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Image Url',
                                ),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Image Url can\'t be null';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please Enter a Valid Url';
                                  }
                                  // jika tidak ada error berarti sukses panjul
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    price: _editedProduct.price,
                                    imageUrl: value,
                                    description: _editedProduct.description,
                                    title: _editedProduct.title,
                                    isFavorite: _editedProduct.isFavorite,
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
