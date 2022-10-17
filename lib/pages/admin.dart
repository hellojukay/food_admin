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

  void remove(Item food) {
    widget.menu!.list =
        widget.menu?.list?.where((element) => element.id != food.id).toList();
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
                  trailing: PopupMenuButton<Icon>(
                      itemBuilder: (context) => <PopupMenuEntry<Icon>>[
                            const PopupMenuItem(
                                value: Icon(Icons.delete),
                                child: Icon(Icons.delete)),
                            const PopupMenuItem(
                                value: Icon(Icons.edit),
                                child: Icon(Icons.edit))
                          ]),
                ))
            .toList() as List<Widget>,
        IconButton(onPressed: () {}, icon: const Icon(Icons.add))
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
                            var food = await edit(e);
                            setState(() {
                              updateFood(food!);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
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
              var food = await edit(null);
              if (food != null && food.id == null) {
                setState(() {
                  addFood(food);
                });
              }
            },
            icon: const Icon(Icons.add)),
      ],
    );
  }

  Future<Item?> edit(Item? food) async {
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
    );
  }
}
