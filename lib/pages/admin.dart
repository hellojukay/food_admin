import 'package:flutter/material.dart';
import 'package:food_admin/modes/food.dart';

import '../widgets/editor.dart';

class Admin extends StatefulWidget {
  const Admin({this.menu, super.key});
  final FoodMenu? menu;
  @override
  State<StatefulWidget> createState() {
    return AdminState();
  }
}

class AdminState extends State<Admin> {
  int? currentCategory;

  void addCategory(CategoryItem item) {
    List<int?> ids = widget.menu!.category!.map((e) => e.id).toList();
    int i = 0;
    for (; true; i++) {
      if (!ids.contains(i)) {
        break;
      }
    }
    item.id = i;
    widget.menu?.category?.add(item);
  }

  void updateCategory(CategoryItem item) {
    var length = widget.menu?.category?.length ?? 0;
    for (var i = 0; i < length; i++) {
      if (widget.menu?.category?[i].id == item.id) {
        widget.menu?.category?[i] = item;
        break;
      }
    }
  }

  void remove(Item food) {
    widget.menu!.list =
        widget.menu?.list?.where((element) => element.id != food.id).toList();
  }

  String? deleteCategory(int id) {
    if (widget.menu!.list!
        .where((element) => element.catId == id)
        .toList()
        .isNotEmpty) {
      return "不允许删除,请先移除关联菜品";
    }
    widget.menu!.category =
        widget.menu!.category!.where((element) => element.id != id).toList();
    return null;
  }

  void updateFood(Item food) {
    var length = widget.menu?.list?.length ?? 0;
    for (var i = 0; i < length; i++) {
      if (widget.menu?.list?[i].id == food.id) {
        widget.menu?.list?[i] = food;
        break;
      }
    }
  }

  void addFood(Item food) {
    if (food.id != null) {
      return updateFood(food);
    }
    List<int?> ids = widget.menu!.list!.map((e) => e.id).toList();
    int i = 0;
    for (; true; i++) {
      if (!ids.contains(i)) {
        break;
      }
    }
    food.id = i;
    widget.menu?.list?.add(food);
  }

  ListView getCategoryList() {
    return ListView(
      children: [
        ...widget.menu!.category
            ?.map((item) => ListTile(
                title: TextButton(
                  onPressed: () {
                    setState(() {
                      currentCategory = item.id;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (item.id == currentCategory) {
                        return Theme.of(context).primaryColor;
                      }
                      return Colors.white;
                    }),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item.name!,
                        style: const TextStyle(color: Colors.black),
                      )),
                ),
                trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      switch (value) {
                        case "delete":
                          setState(() {
                            String? message =
                                deleteCategory(item.id!) ?? "删除成功";
                            SnackBar snackBar =
                                SnackBar(content: Text(message));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                          return;
                        case "edit":
                          var newItem = await editCategory(item);
                          if (newItem != null) {
                            setState(() {
                              updateCategory(newItem);
                            });
                          }
                          break;
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem(
                              value: "delete", child: Icon(Icons.delete)),
                          const PopupMenuItem(
                              value: "edit", child: Icon(Icons.edit))
                        ])))
            .toList() as List<Widget>,
        IconButton(
            onPressed: () async {
              CategoryItem? cate = await editCategory(null);
              if (cate != null) {
                setState(() {
                  addCategory(cate);
                });
              }
            },
            icon: const Icon(Icons.create))
      ],
    );
  }

  ListView getItemList(int? id) {
    return ListView(
      children: [
        ...id == null
            ? []
            : widget.menu?.list
                ?.where((element) => element.catId == id)
                .toList()
                .map((e) => ListTile(
                      leading: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 150),
                        child: Text(e.title ?? ""),
                      ),
                      title: Text("${e.price!.toString()}￥"),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            var food = await editFood(e);
                            setState(() {
                              updateFood(food!);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever_rounded),
                          onPressed: () {
                            setState(() {
                              remove(e);
                            });
                          },
                        )
                      ]),
                    ))
                .toList() as List<Widget>,
        IconButton(
            onPressed: () async {
              var food = await editFood(null);
              if (food != null && food.id == null) {
                setState(() {
                  addFood(food);
                });
              }
            },
            icon: const Icon(Icons.create)),
      ],
    );
  }

  Future<CategoryItem?> editCategory(CategoryItem? cate) async {
    return await showDialog(
        context: context,
        builder: (context) {
          TextEditingController nameController =
              TextEditingController(text: cate?.name);

          var edit = CategoryEditor(
            nameController: nameController,
          );
          return AlertDialog(
            title: const Text('编辑菜品'),
            contentPadding: const EdgeInsets.all(10),
            content: edit,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(cate);
                  },
                  child: const Text('取消')),
              TextButton(
                  onPressed: () {
                    if (!edit.validate()) {
                      return;
                    }
                    if (cate != null) {
                      cate?.name = nameController.text;
                    } else {
                      cate = CategoryItem(name: nameController.text);
                    }
                    Navigator.of(context).pop(cate);
                  },
                  child: const Text('确定'))
            ],
          );
        });
  }

  Future<Item?> editFood(Item? food) async {
    return await showDialog(
        context: context,
        builder: (context) {
          TextEditingController priceController =
              TextEditingController(text: food?.price?.toString());
          TextEditingController titleController =
              TextEditingController(text: food?.title);
          var edit = FoodEditor(
            priceController: priceController,
            nameController: titleController,
          );
          return AlertDialog(
            title: const Text('编辑菜品'),
            contentPadding: const EdgeInsets.all(10),
            content: edit,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(food);
                  },
                  child: const Text('取消')),
              TextButton(
                  onPressed: () {
                    if (!edit.validate()) {
                      return;
                    }
                    if (food != null) {
                      food!.price = double.tryParse(priceController.text);
                      food!.title = titleController.text;
                    } else {
                      food = Item(
                          title: titleController.text,
                          price: double.tryParse(priceController.text),
                          catId: currentCategory);
                    }
                    Navigator.of(context).pop(food);
                  },
                  child: const Text('确定'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    currentCategory ??= widget.menu?.category?[0].id;
    return Scaffold(
      appBar: AppBar(title: const Text('菜单管理')),
      body: Row(
        children: [
          SizedBox(
            width: 280,
            child: getCategoryList(),
          ),
          Expanded(child: getItemList(currentCategory))
        ],
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () {
            //print('called on tap');
          },
          child: SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: TextButton(
                onPressed: () {},
                child: const Text("提交",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
