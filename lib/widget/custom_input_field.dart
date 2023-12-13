// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String formProperty;
  final Map<String, String> fromValues;

  const CustomInputField({
    Key? key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.icon,
    this.keyboardType,
    this.isPassword = false,
    required this.formProperty,
    required this.fromValues,
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      initialValue: '',
      textAlign: TextAlign.start,
      textCapitalization: TextCapitalization.words,
      keyboardType: widget.keyboardType,
      style: const TextStyle(color: Colors.white),
      obscureText: widget.isPassword && _obscureText,
      onChanged: (value) => widget.fromValues[widget.formProperty] = value,
      validator: (value) {
        if (value == null) return 'Este campo es requerido';
        return value.length < 3 ? 'Mínimo 3 letras' : null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.white),
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.white),
        helperText: widget.helperText,
        helperStyle: const TextStyle(color: Colors.white),
        icon: widget.icon == null ? null : Icon(widget.icon),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
