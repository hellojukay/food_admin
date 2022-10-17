import 'package:flutter/material.dart';

class FoodEditor extends StatefulWidget {
  FoodEditor(
      {required this.priceController, required this.nameController, super.key});
  final TextEditingController priceController;
  final TextEditingController nameController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() {
    return FoodEditorState();
  }

  validate() {
    return formKey.currentState!.validate();
  }
}

class FoodEditorState extends State<FoodEditor> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            decoration: const InputDecoration(
                hintText: '请输入价格',
                prefix: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text('价格'),
                )),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  double.tryParse(value) == null) {
                return '价格必须是一个合法的数字';
              }
              return null;
            },
            controller: widget.priceController,
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: '请输入菜名',
                prefix: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text('菜名'),
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '菜名名字不能为空';
              }
              return null;
            },
            controller: widget.nameController,
          )
        ]));
  }
}

class CategoryEditor extends StatefulWidget {
  const CategoryEditor(
      {super.key, required this.nameController, required this.keyState});
  final TextEditingController nameController;
  final GlobalKey<FormState> keyState;
  @override
  State<StatefulWidget> createState() {
    return CategoryEditorState();
  }
}

class CategoryEditorState extends State<CategoryEditor> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "分类名字不能为空";
            }
            return null;
          },
          controller: widget.nameController,
        )
      ],
    ));
  }
}
