import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';

class AppTextfiled extends StatelessWidget {
  const AppTextfiled(
      {Key? key,
        this.controller,
        this.validation,
        this.title,
        this.maxLine,
        this.keyboardType,
        this.onchanged,
        this.input,
        this.text, required
        this.obscureText

      })
      : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validation;
  final Widget? title;
  final int? maxLine;
  final TextInputType? keyboardType;
  final void Function(String)? onchanged;
  final List<TextInputFormatter>? input;
  final String? text;
  final bool obscureText ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        validator: validation,
        maxLines: maxLine,
        onChanged: onchanged,
        inputFormatters: input,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            label: title,
            hintText: text,hintStyle: TextStyle(color: Colors.white),

             focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:Colors.white )),
             enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
             focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white )),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white))),
      ),
    );
  }
}
