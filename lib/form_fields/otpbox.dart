import 'package:flutter/material.dart';

class OtpBox extends StatefulWidget {
  final FocusNode? focusNodePrevious;
  final FocusNode focusNodeCurrent;
  final FocusNode? focusNodeNext;
  final TextEditingController textController;
  final Function? onTextChanged;

  const OtpBox(
      {super.key,
      required this.focusNodePrevious,
      required this.focusNodeCurrent,
      required this.focusNodeNext,
      required this.textController,
      this.onTextChanged});

  @override
  State<OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<OtpBox> {
  //TextEditingController textEditingController = TextEditingController();
  bool isFocused = false;
  @override
  void initState() {
    super.initState();
    //move cursor to end of text in the text field on receiving focus
    widget.focusNodeCurrent.addListener(() {
      if (widget.focusNodeCurrent.hasFocus) {
        widget.textController.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.textController.text.length));
      }
      //Change border colour of focused box
      if (widget.focusNodeCurrent.hasFocus != isFocused) {
        isFocused = widget.focusNodeCurrent.hasFocus;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1.5,
                    color: isFocused ? Colors.black : Colors.black26)),
          ),
          width: MediaQuery.of(context).size.shortestSide * 0.13,
          child: TextField(
            enableInteractiveSelection: false,
            controller: widget.textController,
            focusNode: widget.focusNodeCurrent,
            showCursor: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            onChanged: (str) {
              setState(() {
                if (str.length == 1) {
                  FocusScope.of(context).requestFocus(widget.focusNodeNext);
                } else if (str.isEmpty) {
                  FocusScope.of(context).requestFocus(widget.focusNodePrevious);
                }
              });
              if (widget.onTextChanged != null) widget.onTextChanged!();
            },
            /*style: kTextStyleTitle,
            decoration: kDecorationInputOTP,*/
          ),
        ),
      ],
    );
  }
}
