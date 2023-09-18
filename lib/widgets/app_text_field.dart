import 'package:flutter/material.dart';
import 'package:xtradre/constants/app_colors.dart';
import 'package:xtradre/widgets/headers.dart';

Column inputField(
    {TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int maxLines = 1,
    String text = '',
    String hintText = '',
    bool textArea = false,
    TextInputType? keyType}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SubHeader(
        text: text,
        fontWeight: FontWeight.w500,
      ),
      TextFormField(
          cursorColor: AppColors.cAction,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          controller: controller,
          keyboardType:
              keyType ?? const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
                color: AppColors.cAccent,
                fontSize: 13,
                fontWeight: FontWeight.w500),
            constraints:
                BoxConstraints(maxHeight: textArea ? 100 : 50, maxWidth: 350),
            enabledBorder: outlineBorder(color: AppColors.cAccent),
            focusedBorder: outlineBorder(),
            focusedErrorBorder: errBoarder(color: Colors.red),
            errorBorder: errBoarder(),
          )),
    ],
  );
}

OutlineInputBorder errBoarder({Color? color}) {
  return OutlineInputBorder(
      borderSide: BorderSide(color: color ?? Colors.redAccent.withOpacity(0.5)),
      gapPadding: 8,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)));
}

OutlineInputBorder outlineBorder({Color? color}) {
  return OutlineInputBorder(
      borderSide: BorderSide(color: color ?? AppColors.cSecondary),
      borderRadius: const BorderRadius.all(Radius.circular(8)));
}
