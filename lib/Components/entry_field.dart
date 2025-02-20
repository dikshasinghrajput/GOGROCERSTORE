import 'package:flutter/material.dart';
import 'package:vendor/Theme/colors.dart';

class EntryField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? image;
  final String? initialValue;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final String? hint;
  final IconData? suffixIcon;
  final Widget? preFixIcon;
  final Function? onTap;
  final TextCapitalization? textCapitalization;
  final Function()? onSuffixPressed;
  final double? horizontalPadding;
  final double? verticalPadding;
  final FontWeight? labelFontWeight;
  final double? labelFontSize;
  final Color? underlineColor;
  final TextStyle? hintStyle;
  final TextInputAction? inputAction;
  final EdgeInsets? contentPading;

  const EntryField({super.key, 
    this.controller,
    this.label,
    this.image,
    this.initialValue,
    this.readOnly,
    this.keyboardType,
    this.maxLength,
    this.hint,
    this.suffixIcon,
    this.maxLines,
    this.onTap,
    this.textCapitalization,
    this.onSuffixPressed,
    this.horizontalPadding,
    this.verticalPadding,
    this.labelFontWeight,
    this.labelFontSize,
    this.underlineColor,
    this.hintStyle,
    this.inputAction,
    this.preFixIcon,
    this.contentPading
  });

  @override
  State<EntryField> createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  bool showShadow = false;
  bool showBorder = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding ?? 10.0,
          vertical: widget.verticalPadding ?? 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(widget.label ?? '',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: widget.labelFontWeight ?? FontWeight.bold,
                  fontSize: widget.labelFontSize ?? 21.7)),
          TextField(
            textCapitalization:
            widget.textCapitalization ?? TextCapitalization.sentences,
            cursorColor: kMainColor,
            autofocus: false,
            onEditingComplete: () {
              setState(() {
                showShadow = false;
              });
            },
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
              setState(() {
                showShadow = true;
                showBorder = true;
              });
            },
            controller: widget.controller,
            readOnly: widget.readOnly ?? false,
            keyboardType: widget.keyboardType,
            textInputAction: widget.inputAction ?? TextInputAction.done,
            minLines: 1,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines ?? 1,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.underlineColor ?? Colors.grey[200]!),
                ),
                suffixIcon: widget.suffixIcon!=null?IconButton(
                  icon: Icon(
                    widget.suffixIcon,
                    size: 40.0,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  onPressed: widget.onSuffixPressed,
                ):null,
                contentPadding: widget.contentPading,
                prefixIcon: widget.preFixIcon,
                counterText: "",
                hintText: widget.hint,
                hintStyle: widget.hintStyle ??
                    Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: kHintColor, fontSize: 18.3)),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
