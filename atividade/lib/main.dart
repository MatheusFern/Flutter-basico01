import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


//GERACAO DE DADOS ALEATORIOS
class Utils {
  static String generateRandomString(int len) {
    var random = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[random.nextInt(_chars.length)])
        .join();
  }

  static bool generateRandomEnabledState() {
    var random = Random();
    return random.nextInt(2) == 0 ? false : true;
  }
}

//CLASE DO ITEM DA LISTA
class ItemList {
  final int id;
  final String content;
  bool isChecked;

  ItemList(this.id, this.content, [bool isChecked = false])
      : isChecked = isChecked;
}

class Repository {
  List<ItemList> getItems({bool Cache = false}) {
    return DataSource().getItems(Cache: Cache);
  }
}

// CLASSE PARA GERAR OS DADOS
class DataSource {
  static final List<ItemList> items = [];

  List<ItemList> getItems({bool Cache = false}) {
    if (Cache) {
      items.clear();
    }
    if (items.isEmpty) {
      generateItems();
    }
    return items;
  }

  generateItems() {
    for (var i = 0; i <= 1000; i++) {
      items.add(ItemList(i, Utils.generateRandomString(30),
          Utils.generateRandomEnabledState()));
    }
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Atividade'),
          backgroundColor: Colors.blueGrey,
          elevation: 0,
        ),
        body: const EditItem(),
      ),
    );
  }
}

class EditItem extends StatefulWidget {
  const EditItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateItems();
  }
}

class StateItems extends State<EditItem> {
  List<ItemList> items = Repository().getItems();

  handleResetButton() {
    setState(() {
      items = Repository().getItems(Cache: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: handleResetButton,
                child: const Text("resetar todos os itens")),
          ],
        ),
        Expanded(
            child: ListView.builder(
          padding: const EdgeInsets.all(1),
          itemCount: items.length,
          itemBuilder: (_, int index) => ItemWidget(item: items[index]),
        ))
      ],
    );
  }
}

class ItemWidget extends StatefulWidget {
  const ItemWidget({Key? key, required ItemList item})
      : item = item,
        super(key: key);
  final ItemList item;

  @override
  State<ItemWidget> createState() => ItemState();
}

class ItemState extends State<ItemWidget> {
  handleCheckbox(bool? isChecked) {
    setState(() {
      widget.item.isChecked = isChecked ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.item.isChecked ? Colors.blueGrey : null,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Row(
            children: [
              Checkbox(value: widget.item.isChecked, onChanged: handleCheckbox),
              Text(
                widget.item.content,
                style: TextStyle(
                    color: (widget.item.isChecked ? Colors.white : null)),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}
