import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    Key? key,
    required this.hintText,
    this.textController,
    required this.autoFocus,
    required this.borderRadius,
    required this.focusedBorderColor,
    required this.borderColor,
    required this.borderWidth,
    required this.focusedBorderWidth,
    required this.focusedborderRadius,
    required this.obsecureText,
    required this.enabledBorderWidth,
    this.icon,
    this.keyboardType,
    this.validator,
    this.onSaved,
    this.textAlign,
    this.minLines,
    this.initialValue,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLines,
    this.textInputAction,
  }) : super(key: key);
  final String hintText;
  final TextAlign? textAlign;
  final bool autoFocus;
  final String? initialValue;
  final bool obsecureText;
  final Color focusedBorderColor;
  final Color borderColor;
  final double borderRadius;
  final TextInputType? keyboardType;
  final double focusedborderRadius;
  final double focusedBorderWidth;
  final double enabledBorderWidth;
  final double borderWidth;
  final IconData? icon;
  final FormFieldValidator<String>? validator;
  final TextEditingController? textController;
  final void Function(String?)? onSaved;
  final int? minLines;
  final int? maxLines;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.grey,
      obscureText: obsecureText,
      controller: textController,
      validator: validator,
      autofocus: autoFocus,
      onSaved: onSaved,
      textAlign: textAlign!,
      initialValue: initialValue!,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.black54),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black38,
          letterSpacing: 0.5,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(focusedborderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: focusedBorderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            width: enabledBorderWidth,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}
