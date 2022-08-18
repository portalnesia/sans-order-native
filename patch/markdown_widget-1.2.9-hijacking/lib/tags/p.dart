import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as m;
import 'markdown_tags.dart';
import '../config/html_support.dart';
import '../config/style_config.dart';

///Tag:  p
///the paragraph widget
class PWidget extends StatelessWidget {
  final List<m.Node>? children;
  final m.Node parentNode;
  final TextStyle? textStyle;
  final bool? selectable;
  final TextConfig? textConfig;
  final WrapCrossAlignment crossAxisAlignment;

  const PWidget({
    Key? key,
    this.children,
    required this.parentNode,
    this.textStyle,
    this.selectable,
    this.textConfig,
    this.crossAxisAlignment = WrapCrossAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final configSelectable =
        selectable ?? StyleConfig().pConfig?.selectable ?? true;
    return buildRichText(
        children, parentNode, textStyle, configSelectable, textConfig);
  }

  RichText buildRichText(List<m.Node>? children, m.Node parentNode,
      TextStyle? textStyle, bool selectable, TextConfig? textConfig) {
    final config = StyleConfig().pConfig;
    return RichText(
      softWrap: true,
      text: getBlockSpan(
        children,
        parentNode,
        textStyle ?? config?.textStyle ?? defaultPStyle,
        selectable: selectable,
      ),
      textAlign: textConfig?.textAlign ??
          config?.textConfig?.textAlign ??
          TextAlign.start,
      textDirection:
          textConfig?.textDirection ?? config?.textConfig?.textDirection,
    );
  }

  InlineSpan getBlockSpan(
      List<m.Node>? nodes, m.Node parentNode, TextStyle? parentStyle,
      {bool selectable = true}) {
    if (nodes == null || nodes.isEmpty) return const TextSpan();
    return TextSpan(
      children: List.generate(
        nodes.length,
        (index) {
          bool shouldParseHtml = needParseHtml(parentNode);
          final node = nodes[index];
          if (node is m.Text) {
            return buildTextSpan(
                node, parentStyle, shouldParseHtml, selectable);
          } else if (node is m.Element) {
            if (node.tag == code) return getCodeSpan(node);
            if (node.tag == img) return getImageSpan(node);
            if (node.tag == video) return getVideoSpan(node);
            if (node.tag == a) return getLinkSpan(node);
            if (node.tag == input) return getInputSpan(node);
            if (node.tag == other) return getOtherWidgetSpan(node);
            return getBlockSpan(
              node.children,
              node,
              parentStyle!.merge(getTextStyle(node.tag)),
              selectable: selectable,
            );
          }
          return const TextSpan();
        },
      ),
    );
  }

  InlineSpan buildTextSpan(m.Text node, TextStyle? parentStyle,
      bool shouldParseHtml, bool selectable) {
    final nodes = shouldParseHtml ? parseHtml(node) : [];
    if (nodes.isEmpty) {
      return selectable
          ? WidgetSpan(child: SelectableText(node.text, style: parentStyle))
          : TextSpan(text: node.text, style: parentStyle);
    } else {
      return getBlockSpan(nodes as List<m.Node>?, node, parentStyle,
          selectable: selectable);
    }
  }
}

///config class for [PWidget]
class PConfig {
  final TextStyle? textStyle;
  final TextStyle? linkStyle;
  final TextStyle? delStyle;
  final TextStyle? emStyle;
  final TextStyle? strongStyle;
  final TextConfig? textConfig;
  final bool? selectable;
  final OnLinkTap? onLinkTap;
  final LinkGesture? linkGesture;
  final Custom? custom;

  PConfig({
    this.textStyle,
    this.linkStyle,
    this.delStyle,
    this.emStyle,
    this.strongStyle,
    this.textConfig,
    this.onLinkTap,
    this.selectable,
    this.linkGesture,
    this.custom,
  });
}

///config class for [TextStyle]
class TextConfig {
  final TextAlign? textAlign;
  final TextDirection? textDirection;

  TextConfig({this.textAlign, this.textDirection});
}

typedef OnLinkTap = void Function(String? url);
typedef LinkGesture = Widget Function(Widget linkWidget, String? url);
typedef Custom = Widget Function(m.Element element);
