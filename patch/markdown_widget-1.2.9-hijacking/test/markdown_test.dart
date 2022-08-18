// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:markdown/markdown.dart' as m;
import 'package:flutter_test/flutter_test.dart';
import 'package:html/dom.dart' as h;
import 'package:html/parser.dart';

void printNode(m.Node? node, int deep) {
  if (node == null) return;
  if (node is m.Text) {
    final text = node.text;
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

    if (text.contains(exp)) {
      h.Document document = parse(text);
      if (kDebugMode) {
        print('GET:${document.nodes.length}');
      }
      for (var element in document.nodes) {
        htmlPrintNode(element, 0);
      }
    }
    if (kDebugMode) {
      print('${'  ' * deep}Text:${node.text}');
    }
  } else if (node is m.Element) {
    if (kDebugMode) {
      print('${'  ' * deep}Tag:${node.tag}   attr:${node.attributes}');
    }
    if (node.children == null) return;
    for (var n in node.children!) {
      printNode(n, deep + 1);
    }
  }
}

void htmlPrintNode(h.Node? node, int deep) {
  if (node == null) return;
  if (node is h.Text) {
    if (kDebugMode) {
      print('${'  ' * deep}h.Text:${node.text}');
    }
  } else if (node is h.Element) {
    if (kDebugMode) {
      print('${'  ' * deep}h.Tag:${node.localName}   h.attr:${node.attributes}');
    }
    if (node.nodes.isEmpty) return;
    for (var n in node.nodes) {
      htmlPrintNode(n, deep + 1);
    }
  } else
    if (kDebugMode) {
      print('I am not:$node');
    }
}

void main() {
  test('test for markdown', () {
    final current = Directory.current;
//    final markdownPath = p.join(current.path,'demo_en.md');
    final markdownPath = '${current.path}/example/assets/editor.md';
    if (kDebugMode) {
      print(markdownPath);
    }
    File mdFile = File(markdownPath);
    if (!mdFile.existsSync()) return;
    final content = mdFile.readAsStringSync();

    final m.Document document = m.Document(
        extensionSet: m.ExtensionSet.gitHubFlavored, encodeHtml: false);

    final List<String> lines = content.split(RegExp(r'\r?\n'));

    final nodes = document.parseLines(lines);
    for (var node in nodes) {
      if (node is m.Element) {
        printNode(node, 0);
      } else {
        printNode(node, 0);
      }
    }
  });
}
