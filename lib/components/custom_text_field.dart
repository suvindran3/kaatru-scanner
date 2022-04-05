import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.hintText,
    this.visibility = false,
    required this.iconData,
    this.controller,
    required this.validator, this.inputFilters, required this.inputType,
  }) : super(key: key);

  final String hintText;
  final bool visibility;
  final IconData iconData;
  final String? Function(String) validator;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFilters;
  final TextInputType inputType;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.visibility? hide : false,
      controller: widget.controller,
      style: Theme
          .of(context)
          .textTheme
          .bodyText2
          ?.copyWith(fontWeight: FontWeight.bold),
      validator: (input) => widget.validator(input ?? ''),
      inputFormatters: widget.inputFilters,
      keyboardType : widget.inputType,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        hintStyle:
        Theme
            .of(context)
            .textTheme
            .bodyText2
            ?.copyWith(color: Colors.grey),
        prefixIcon: Icon(
          widget.iconData,
          color: Colors.grey,
        ),
        suffixIcon: widget.visibility
            ? IconButton(
          splashRadius: 10,
          onPressed: () {
            setState(() => hide = !hide);
          },
          icon: Icon(
            hide ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        )
            : null,
        fillColor: const Color(0xffF1F1F3),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
