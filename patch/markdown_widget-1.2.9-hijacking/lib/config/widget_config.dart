// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as m;

/// you can use [WidgetConfig] to custom your tag widget
class WidgetConfig {
  WidgetBuilder? p;
  WidgetBuilder? pre;
  WidgetBuilder? ul;
  WidgetBuilder? ol;
  WidgetBuilder? block;
  WidgetBuilder? hr;
  WidgetBuilder? table;

  WidgetConfig({
    this.p,
    this.pre,
    this.ul,
    this.ol,
    this.block,
    this.hr,
    this.table,
  });
}

typedef WidgetBuilder = Widget Function(m.Element node);
