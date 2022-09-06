import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import './../models/products.dart';
import './../models/product.dart';

class AddEditProductPage extends StatefulWidget {
  const AddEditProductPage({Key? key}) : super(key: key);
  static const routeName = '/add_edit_product_page';
  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  Product inputData =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _isInit = true;
  var _isLoading = true;
  var _initData = {'title': '', 'description': '', 'price': '', 'imageUrl': ''};
  @override
  void initState() {
    _imgUrlFocusNode.addListener(_updateFocus);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String productId = (ModalRoute.of(context)?.settings.arguments) != null
          ? ModalRoute.of(context)?.settings.arguments as String
          : '';
      if (productId != '') {
        inputData =
            Provider.of<Products>(context, listen: false).findByID(productId);
        _initData = {
          'title': inputData.title,
          'description': inputData.description,
          'price': inputData.price.toString(),
        };
        _imgUrlController.text = inputData.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(_updateFocus);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgUrlController.dispose();
    _imgUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateFocus() {
    if (!_imgUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveProduct() async {
    try {
      var formvalidator = _formKey.currentState?.validate();
      if (!formvalidator!) {
        return;
      }
      _formKey.currentState?.save();
      setState(() {
        _isLoading = false;
      });
      if (inputData.id != '') {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(inputData.id, inputData);
      } else {
        await Provider.of<Products>(context, listen: false)
            .addProduct(inputData);
      }
      setState(() {
        _isLoading = true;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Error Occured!"),
          content: const Text('Something goes wrong please try again'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'))
          ],
        ),
      );
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Product Page'),
        actions: [
          IconButton(onPressed: _saveProduct, icon: const Icon(Icons.save))
        ],
      ),
      body: !_isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initData['title'] as String,
                        decoration: const InputDecoration(label: Text('Title')),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name of product';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          inputData = Product(
                            id: inputData.id,
                            title: value!,
                            price: inputData.price,
                            description: inputData.description,
                            imageUrl: inputData.imageUrl,
                            isFavorite: inputData.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initData['price'] as String,
                        decoration: const InputDecoration(label: Text('Price')),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter price';
                          } else if (double.tryParse(value) == null) {
                            return 'Please enter valid price';
                          } else if (double.parse(value) <= 0) {
                            return 'Please enter price greater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          inputData = Product(
                            id: inputData.id,
                            title: inputData.title,
                            price: double.tryParse(value!) != null
                                ? double.parse(value)
                                : inputData.price,
                            description: inputData.description,
                            imageUrl: inputData.imageUrl,
                            isFavorite: inputData.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initData['description'] as String,
                        decoration:
                            const InputDecoration(label: Text('Description')),
                        textInputAction: TextInputAction.newline,
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description of product';
                          } else if (value.length < 10) {
                            return 'description of product must be at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          inputData = Product(
                            id: inputData.id,
                            title: inputData.title,
                            price: inputData.price,
                            description: value!,
                            imageUrl: inputData.imageUrl,
                            isFavorite: inputData.isFavorite,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 16, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imgUrlController.text.isEmpty
                                ? const Text('Image URL')
                                : FittedBox(
                                    // fit: BoxFit.cover,
                                    child: Image.network(
                                      _imgUrlController.text,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Enter Image URL Only'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imgUrlController,
                              focusNode: _imgUrlFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter product imageUrl';
                                } else if (!value.startsWith('http://') &&
                                    !value.startsWith('https://')) {
                                  return 'wrong image url';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                inputData = Product(
                                  id: inputData.id,
                                  title: inputData.title,
                                  price: inputData.price,
                                  description: inputData.description,
                                  imageUrl: value!,
                                  isFavorite: inputData.isFavorite,
                                );
                              },
                              onFieldSubmitted: (_) {
                                _saveProduct();
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
