import 'package:markdown_widget/config/highlight_themes.dart' as theme;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:sans_order/controllers/settings.dart';
import 'package:sans_order/utils/main.dart';
import 'package:sans_order/widget/dialog.dart';

class CustomMarkdownEditor extends StatefulWidget {
  const CustomMarkdownEditor({
    Key? key,
    required this.onChange,
    this.initialValue = "",
    this.actions = const [
      MarkdownType.title,
      MarkdownType.bold,
      MarkdownType.italic,
      MarkdownType.link,
      MarkdownType.list,
      MarkdownType.blockquote,
      MarkdownType.code,
      MarkdownType.separator,
      MarkdownType.strikethrough
    ],
    this.validators,
    this.label,
    required this.focusNode
  }) : super(key: key);

  final void Function(String value) onChange;
  final String initialValue;
  final List<MarkdownType> actions;
  final String? Function(String?)? validators;
  final String? label;
  final FocusNode focusNode;
  
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CustomMarkdownEditor> {
  String str = "";

  void onTextChange(String value) {
    setState(() {
      str = value;
    });
    widget.onChange(value);
  }

  @override
  void initState() {
    setState(() {
      str = widget.initialValue;
    });
    super.initState();
  }

  Widget previewBuilder(BuildContext context) {
    return MyDialog(
      canBack: true,
      title: "Preview",
      children: [
        CustomMarkdown(data: str)
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    void onPreview() {
      showCupertinoModalPopup(context: context, builder: previewBuilder);
    }

    return MarkdownTextInput(
      onTextChange, 
      widget.initialValue,
      validators: widget.validators,
      label: widget.label,
      focusNode: widget.focusNode,
      actions: widget.actions,
      childrenBefore: Column(
        children: [
          SizedBox(
            height: 35,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: onPreview,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Preview",style: TextStyle(height: 1.1),),
                    ),
                  ),
                  InkWell(
                    onTap: ()=>openUrl("https://portalnesia.com/blog/markdown-guide"),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Help",style: TextStyle(height: 1.1),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMarkdown extends StatelessWidget {

  const CustomMarkdown({
    Key? key,
    required this.data
  }) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingControllers>(builder: ((setting) => MarkdownWidget(
      physics: const NeverScrollableScrollPhysics(),
      data: data,
      shrinkWrap: true,
      styleConfig: StyleConfig(
        markdownTheme: (setting.theme == ThemeMode.dark || (setting.theme == ThemeMode.system && Get.theme.brightness == Brightness.dark)) ? MarkdownTheme.darkTheme : MarkdownTheme.lightTheme,
        pConfig: PConfig(
          textStyle: Get.textTheme.bodyText1,
          selectable: true,
          linkStyle: TextStyle(
            color: Colors.transparent,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: Get.theme.colorScheme.primary,
            shadows: [
              Shadow(
                color: Get.theme.colorScheme.primary.withAlpha(200),
                offset: const Offset(0, -3)
              )
            ]
          ),
          onLinkTap: (url) => openUrl(url.toString()),
        ),
        titleConfig: TitleConfig(
          h1: Get.textTheme.headline1,
          h2: Get.textTheme.headline2,
          h3: Get.textTheme.headline3,
          h4: Get.textTheme.headline4,
          h5: Get.textTheme.headline5,
          h6: Get.textTheme.headline6,
          divider: const Divider(thickness: 1.5)
        ),
        imgBuilder: (url,attributes) {
          return CachedNetworkImage(imageUrl: photoUrl(url),width: double.infinity,fit: BoxFit.contain,cacheKey: 'url');
        },
        preConfig: PreConfig(
          autoDetectionLanguage: true,
          theme: (setting.theme == ThemeMode.dark || (setting.theme == ThemeMode.system && Get.theme.brightness == Brightness.dark)) ? theme.a11yDarkTheme : theme.a11yLightTheme
        ),
        hrConfig: HrConfig(height: 1.5,color: Get.theme.dividerColor),
        blockQuoteConfig: BlockQuoteConfig(
          blockColor: Get.theme.colorScheme.primary,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          blockStyle: Get.textTheme.headline6,
        ),
        olConfig: OlConfig(
          leftSpacing: 5
        ),
        ulConfig: UlConfig(
          textStyle: Get.textTheme.bodyText1!.copyWith(height:1.4),
          dotMargin: const EdgeInsets.symmetric(horizontal: 5,vertical: 6)
        )
      ),
    )));
  }
}