import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/providers/products_provider.dart';
import 'package:shop_application/screens/new_product_screen.dart';

class UserProductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductsItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final navigator = Navigator.of(context);
    return Container(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      NewProductScreen.routeName,
                      arguments: id,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text('Delete Item'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Are you sure want to delete them ?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.green,
                              child: Text('Confirm'),
                              onPressed: () async {
                                try {
                                  await Provider.of<Products>(context)
                                      .deleteProduct(id);
                                  navigator.pop();
                                } catch (error) {
                                  return showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                'Cant delete the product',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .errorColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Oke'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
