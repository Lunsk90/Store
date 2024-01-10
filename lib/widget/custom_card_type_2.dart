// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomCardType2 extends StatefulWidget {
  final String imageUrl;
  final String? name;
  final String? price;
  final String? description;
  final VoidCallback? onAddToCartPressed;

  const CustomCardType2({
    Key? key,
    required this.imageUrl,
    this.name,
    this.price,
    this.description,
    this.onAddToCartPressed,
  }) : super(key: key);

  @override
  _CustomCardType2State createState() => _CustomCardType2State();
}

class _CustomCardType2State extends State<CustomCardType2> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 30,
      child: Column(
        children: [
          FadeInImage(
            image: NetworkImage(widget.imageUrl),
            placeholder: const AssetImage('assets/jar-loading.gif'),
            width: double.infinity,
            height: 230,
            fit: BoxFit.scaleDown,
            fadeInDuration: const Duration(milliseconds: 300),
          ),
          if (widget.name != null || widget.price != null || widget.description != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Text('Title: ${widget.name ?? 'No title'}'),
                  ),
                ),
                if (widget.price != null)
                  Container(
                    padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                    child: Text('Price: \$${widget.price ?? 'No price'}'),
                  ),
                if (widget.description != null)
                  Expanded(
                    flex: 2, // Ajusta el flex según tus necesidades
                    child: Container(
                      padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                      child: Text('Description: ${widget.description ?? 'No description'}'),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 65, right: 65, bottom: 15, top: 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Producto añadido a la cesta'),
                        content: const Text('Este producto se ha añadido a su cesta.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Cierra el AlertDialog
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                  setState(() {
                    _isSelected = !_isSelected;
                  });
                  widget.onAddToCartPressed?.call(); // Llama a la función del botón "Add to Cart"
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
              ),
            ),
        ],
      ),
    );
  }
}
