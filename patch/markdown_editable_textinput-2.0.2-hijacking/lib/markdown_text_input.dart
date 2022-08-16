// ignore_for_file: public_member_api_docs

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';

/// Widget with markdown buttons
class MarkdownTextInput extends StatefulWidget {
  /// Callback called when text changed
  final Function onTextChanged;

  /// Initial value you want to display
  final String initialValue;

  /// Validator for the TextFormField
  final String? Function(String? value)? validators;

  /// String displayed at hintText in TextFormField
  final String? label;

  /// Change the text direction of the input (RTL / LTR)
  final TextDirection? textDirection;

  /// The maximum of lines that can be display in the input
  final int? maxLines;

  final int? minLines;

  final FocusNode focusNode;

  /// List of action the component can handle
  final List<MarkdownType> actions;

  /// Optionnal controller to manage the input
  final TextEditingController? controller;

  /// Optionnal add other widgets
  final Widget? children;
  final Widget? childrenBefore;

  /// Constructor for [MarkdownTextInput]
  MarkdownTextInput(
    this.onTextChanged,
    this.initialValue, {
    this.label = '',
    this.validators,
    this.textDirection = TextDirection.ltr,
    this.maxLines,
    this.minLines = 5,
    required this.focusNode,
    this.childrenBefore,
    this.actions = const [
      MarkdownType.bold,
      MarkdownType.italic,
      MarkdownType.title,
      MarkdownType.link,
      MarkdownType.list
    ],
    this.controller,
    this.children
  });

  @override
  _MarkdownTextInputState createState() => _MarkdownTextInputState(controller ?? TextEditingController());
}

class _MarkdownTextInputState extends State<MarkdownTextInput> {
  final TextEditingController _controller;
  TextSelection textSelection = const TextSelection(baseOffset: 0, extentOffset: 0);
  bool focus = false;
  _MarkdownTextInputState(this._controller);

  void onTap(MarkdownType type, {int titleSize = 1}) {
    final basePosition = textSelection.baseOffset;
    var noTextSelected = (textSelection.baseOffset - textSelection.extentOffset) == 0;

    final result = FormatMarkdown.convertToMarkdown(
        type, _controller.text, textSelection.baseOffset, textSelection.extentOffset,
        titleSize: titleSize);

    _controller.value = _controller.value
        .copyWith(text: result.data, selection: TextSelection.collapsed(offset: basePosition + result.cursorIndex));

    if (noTextSelected) {
      _controller.selection = TextSelection.collapsed(offset: _controller.selection.end - result.replaceCursorIndex);
    }
  }

  @override
  void initState() {
    _controller.text = widget.initialValue;
    _controller.addListener(() {
      if (_controller.selection.baseOffset != -1) textSelection = _controller.selection;
      widget.onTextChanged(_controller.text);
    });
    widget.focusNode.addListener(() {
      setState(() {
        focus = widget.focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: (focus ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor), width: (focus ? 2 : 1)),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          ...(widget.childrenBefore != null ? [
            widget.childrenBefore!,
            Divider(height:1,thickness: 0.5,color: focus ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor)
          ] : []),
          TextFormField(
            textInputAction: TextInputAction.newline,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            controller: _controller,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            validator: widget.validators,
            cursorColor: Theme.of(context).colorScheme.primary,
            textDirection: widget.textDirection,
            decoration: InputDecoration(
              enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: focus ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor)),
              focusedBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: focus ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor)),
              hintText: widget.label,
              hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
            focusNode: widget.focusNode,
          ),
          SizedBox(
            height: 44,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.actions.map((type) {
                  return type == MarkdownType.title
                      ? ExpandableNotifier(
                          child: Expandable(
                            key: Key('H#_button'),
                            collapsed: ExpandableButton(
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'H#',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            expanded: Container(
                              color: Colors.white10,
                              child: Row(
                                children: [
                                  for (int i = 1; i <= 6; i++)
                                    InkWell(
                                      key: Key('H${i}_button'),
                                      onTap: () => onTap(MarkdownType.title, titleSize: i),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'H$i',
                                          style: TextStyle(fontSize: (18 - i).toDouble(), fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ExpandableButton(
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.close,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          key: Key(type.key),
                          onTap: () => onTap(type),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(type.icon),
                          ),
                        );
                }).toList(),
              ),
            ),
          ),
          ...(widget.children != null ? [widget.children!] : [])
        ],
      ),
    );
  }
}
