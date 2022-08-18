// ignore_for_file: depend_on_referenced_packages

import '../config/style_config.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as m;
import 'package:highlight/highlight.dart' as hi;

///Tag: pre
///the pre widget
class PreWidget extends StatelessWidget {
  final m.Node node;

  const PreWidget({
    Key? key,
    required this.node,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final preConfig = StyleConfig().preConfig;
    final preWidget = Container(
      decoration: preConfig?.decoration ??
          BoxDecoration(
            color: defaultPreBackground,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
      margin: preConfig?.margin,
      padding: preConfig?.padding ?? const EdgeInsets.fromLTRB(10, 20, 10, 20),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: HighlightView(
          node.textContent,
          language: preConfig?.language ?? 'dart',
          autoDetectionLanguage: preConfig?.autoDetectionLanguage ?? false,
          theme: preConfig?.theme ?? defaultHighLightCodeTheme,
          textStyle: preConfig?.textStyle ?? const TextStyle(fontSize: 14),
          tabSize: preConfig?.tabSize ?? 8,
        ),
      ),
    );

    return preConfig?.preWrapper?.call(preWidget, node.textContent) ??
        preWidget;
  }
}

///config class for [PreWidget]
class PreConfig {
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final PreWrapper? preWrapper;

  ///see package:flutter_highlight/themes/
  final Map<String, TextStyle>? theme;

  final String? language;

  ///set [autoDetectionLanguage] `true` to enable language auto detection, but it will cause performance issue
  ///so it is not recommended
  ///see https://github.com/git-touch/highlight/blob/251505aae568e95ad941e023c110495fa5ad0a16/highlight/lib/src/highlight.dart#L247
  final bool? autoDetectionLanguage;
  final int? tabSize;

  PreConfig({
    this.padding,
    this.decoration,
    this.margin,
    this.textStyle,
    this.textAlign,
    this.textDirection,
    this.theme,
    this.language,
    this.tabSize,
    this.preWrapper,
    this.autoDetectionLanguage,
  });
}

typedef PreWrapper = Widget Function(Widget preWidget, String text);

class HighlightView extends StatelessWidget {
  /// The original code to be highlighted
  final String source;

  final String? language;
  final bool? autoDetectionLanguage;

  /// Highlight theme
  ///
  /// [All available themes](https://github.com/pd4d10/highlight/blob/master/flutter_highlight/lib/themes)
  final Map<String, TextStyle>? theme;

  /// Text styles
  ///
  /// Specify text styles such as font family and font size
  final TextStyle? textStyle;

  HighlightView(
    String input, {Key? key, 
    this.language,
    this.autoDetectionLanguage,
    this.theme = const {},
    this.textStyle,
    // ignore: todo
    int tabSize = 8, // TODO: https://github.com/flutter/flutter/issues/50087
  }) : source = input.replaceAll('\t', ' ' * tabSize), super(key: key);

  List<TextSpan> _convert(List<hi.Node> nodes) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    _traverse(hi.Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(text: node.value, style: theme![node.className!]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans
            .add(TextSpan(children: tmp, style: theme![node.className!]));
        stack.add(currentSpans);
        currentSpans = tmp;

        for (var n in node.children!) {
          _traverse(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        }
      }
    }

    for (var node in nodes) {
      _traverse(node);
    }
    return spans;
  }

  static const _rootKey = 'root';
  static const _defaultFontColor = Color(0xff000000);

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    var _textStyle = TextStyle(
      color: theme![_rootKey]?.color ?? _defaultFontColor,
    );
    if (textStyle != null) {
      _textStyle = _textStyle.merge(textStyle);
    }

    return SelectableText.rich(
      TextSpan(
        style: _textStyle,
        children: _convert(hi.highlight
            .parse(source,
                language: autoDetectionLanguage! ? null : language,
                autoDetection: autoDetectionLanguage!)
            .nodes!),
      ),
      textAlign: StyleConfig().preConfig?.textAlign,
      textDirection: StyleConfig().preConfig?.textDirection,
      scrollPhysics: const NeverScrollableScrollPhysics(),
    );
  }
}
