import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../models/products.dart';
import './../pages/add_edit_product_page.dart';

class ManageProductItem extends StatelessWidget {
  const ManageProductItem(
      {Key? key, required this.id, required this.imageUrl, required this.title})
      : super(key: key);
  final String id;
  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(title),
      trailing: SizedBox(
        width: 100,
        child: Row(children: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.amber,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddEditProductPage.routeName, arguments: id);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                  'Deletion failed',
                  textAlign: TextAlign.center,
                )));
              }
            },
          )
        ]),
      ),
    );
  }
}
