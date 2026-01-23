import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class TCustomeFormField extends StatefulWidget {
  const TCustomeFormField({
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.label,
    this.hint,
    this.isObscured = false,
    this.iconData,
    this.textInputType = TextInputType.text,
    this.backgroundColor,
    this.hintTextStyle,
    this.labelTextStyle,
    this.cursorColor,
    this.readOnly = false,
    this.validation,
    this.onTap,
    this.maxLines,
    this.prefixIcon,
    this.borderBackgroundColor,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final bool isObscured;
  final String? label;
  final String? hint;
  final TextInputType textInputType;
  final IconData? iconData;
  final Color? backgroundColor;
  final Color? borderBackgroundColor;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final Color? cursorColor;
  final bool readOnly;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validation;
  final void Function()? onTap;

  @override
  State<TCustomeFormField> createState() => _TCustomeFormFieldState();
}

class _TCustomeFormFieldState extends State<TCustomeFormField> {
  late bool hidden = widget.isObscured;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,

          borderRadius: BorderRadius.circular(16),
        ),
        child: TextFormField(
          maxLines: 1,
          controller: widget.controller,

          style: TextStyle(color: Colors.black),
          obscureText: hidden,
          keyboardType: widget.textInputType,
          obscuringCharacter: '*',
          cursorColor: TColors.primary,

          validator: (value) {
            if (widget.validation == null) {
              setState(() => errorText = null);
            } else {
              setState(() => errorText = widget.validation!(value));
            }
            return errorText;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12),
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isObscured
                ? IconButton(
                    onPressed: () => setState(() => hidden = !hidden),
                    iconSize: 24,
                    isSelected: !hidden,
                    color: widget.cursorColor,
                    selectedIcon: const Icon(Icons.visibility),
                    icon: Icon(Icons.visibility_off),
                  )
                : widget.suffixIcon,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 1.0, color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 1.0, color: Colors.grey),
            ),
            errorStyle: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
