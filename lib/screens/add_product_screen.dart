import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:the_north_mart/provider/product_provider.dart';

import '../provider/products.dart';
import '../widget/input_text_field.dart';

class AddProductScreen extends StatefulWidget {
  static const addProductScreen = 'AddProductScreen';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final productId = ModalRoute.of(context)?.settings.arguments as String;
        if (productId != '') {
          _editedProduct =
              Provider.of<ProductsProviders>(context, listen: false)
                  .findByID(productId);
          _initValues = {
            'title': _editedProduct.title,
            'description': _editedProduct.description,
            'price': _editedProduct.price.toString(),
            // 'imageUrl': _editedProduct.imageUrl,
            'imageUrl': '',
          };
          _imageUrlController.text = _editedProduct.imageUrl;
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<ProductsProviders>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<ProductsProviders>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.white,
            title: const Text('An error occurred'),
            content: const Text('Something went wrong!!!'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffB1BDC5),
                  elevation: 4,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("OkeY"),
              ),
            ],
          ),
        );
        // } finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.of(context).pop();
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: SizedBox(
                width: 100.w,
                height: 90.h,
                child: LiquidCircularProgressIndicator(
                  value: 0.4, // Defaults to 0.5.
                  valueColor: const AlwaysStoppedAnimation(Color(
                      0xffB1BDC5)), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors
                      .white, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.grey,
                  borderWidth: 2.0,
                  direction: Axis
                      .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  center: const Text(
                    "Add Products",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    InputTextField(
                      borderRadius: 10.0,
                      hintText: 'Title',
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value!,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                      autoFocus: false,
                      focusedBorderColor: Colors.grey,
                      borderColor: Colors.grey,
                      borderWidth: 1,
                      focusedBorderWidth: 2,
                      focusedborderRadius: 12,
                      obsecureText: false,
                      enabledBorderWidth: 1,
                      textAlign: TextAlign.start,
                      initialValue: _initValues['title'],
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{3,}$');
                        if (value!.isEmpty) {
                          return ("Please Enter Title");
                        } else if (!regex.hasMatch(value)) {
                          return ("Please Enter Title of 3 character");
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputTextField(
                      borderRadius: 10.0,
                      initialValue: _initValues['price'],
                      hintText: 'Price',
                      autoFocus: false,
                      focusedBorderColor: Colors.grey,
                      borderColor: Colors.grey,
                      borderWidth: 1,
                      focusedBorderWidth: 2,
                      focusedborderRadius: 12,
                      obsecureText: false,
                      enabledBorderWidth: 1,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(value!),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    InputTextField(
                        minLines: 3,
                        maxLines: 3,
                        borderRadius: 10.0,
                        hintText: 'Description',
                        initialValue: _initValues['description'],
                        autoFocus: false,
                        focusedBorderColor: Colors.grey,
                        borderColor: Colors.grey,
                        borderWidth: 1,
                        focusedBorderWidth: 2,
                        focusedborderRadius: 12,
                        obsecureText: false,
                        enabledBorderWidth: 1,
                        textAlign: TextAlign.start,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{10,}$');
                          if (value!.isEmpty) {
                            return ("Please Enter Product Description");
                          } else if (!regex.hasMatch(value)) {
                            return ("Please Enter Description of 10 character");
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: value!,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        }),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      'assets/images/imagepreview.png',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Image Url',
                              hintStyle: const TextStyle(
                                color: Colors.black38,
                                letterSpacing: 0.5,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value!,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
