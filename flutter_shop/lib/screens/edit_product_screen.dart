import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/product.dart';
import 'package:flutter_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageEditingController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _title = "";
  var _price = 0.0;
  var _description = "";
  var _imageUrl = "";
  var _initValues = {'title': '', 'price': '', 'description': ''};
  var _isInit = true;
  var _productId;
  var _isLoading = false;

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    print("here");
    if (!isValid) return;
    _form.currentState.save();
    final product = Provider.of<Products>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    if (_productId == null) {
      final newProduct = Product(
          title: _title,
          description: _description,
          price: _price,
          imageUrl: _imageUrl,
          id: DateTime.now().toString());
      try {
        await product.addItem(newProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Something went wrong'),
                actions: [
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            });
      }
    } else {
      final updatedProduct = Product(
          title: _title,
          description: _description,
          price: _price,
          imageUrl: _imageUrl,
          id: _productId);
      await product.updateItem(_productId, updatedProduct);
    }
    _popUpScreen(context);
  }

  void _popUpScreen(BuildContext context) {
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _productId = ModalRoute.of(context).settings.arguments as String;
      if (_productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(_productId);
        _initValues = {
          'title': product.title,
          'price': product.price.toString(),
          'description': product.description
        };
        _imageEditingController.text = product.imageUrl;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageEditingController.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      var urlPattern =
          r"(https?|ftp|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
      if (!new RegExp(urlPattern, caseSensitive: false)
          .hasMatch(_imageEditingController.text)) return;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) return "Please enter a Title";
                          return null;
                        },
                        onSaved: (value) {
                          _title = value;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return "Please enter a Price";
                          else if (double.tryParse(value) == null ||
                              double.parse(value) <= 0.0)
                            return "Please enter a correct price";
                          return null;
                        },
                        onSaved: (value) {
                          _price = double.parse(value);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty)
                            return "Please enter a Description";
                          else if (value.length < 10)
                            return "Please enter at least 10 characters";
                          return null;
                        },
                        onSaved: (value) {
                          _description = value;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 10, right: 4),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageEditingController.text.isEmpty
                                ? Text('Enter a Url')
                                : FittedBox(
                                    child: Image.network(
                                      _imageEditingController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocusNode,
                              controller: _imageEditingController,
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (value) {
                                var urlPattern =
                                    r"(https?|ftp|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
                                if (value.isEmpty)
                                  return "Please enter a Price";
                                else if (!new RegExp(urlPattern,
                                        caseSensitive: false)
                                    .hasMatch(value))
                                  return "Please enter a correct URL";
                                return null;
                              },
                              onSaved: (value) {
                                _imageUrl = value;
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
