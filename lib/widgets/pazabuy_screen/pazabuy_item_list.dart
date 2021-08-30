import 'package:flutter/material.dart';
import 'package:pazada/widgets/shared/layout_type.dart';


class Pazabuy {
  Pazabuy({this.name, this.price});
  final String name;
  final String price;
}

class PazabuyItem extends StatelessWidget implements HasLayoutGroup {
  PazabuyItem({Key key, this.layoutGroup, this.onLayoutToggle}) : super(key: key);
  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Pazbuy Item"),
        ),
      body: Container(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
        itemCount: allPazabuy.length,
        itemBuilder: (BuildContext content, int index) {
          Pazabuy contact = allPazabuy[index];
          return PazabuyListTile(contact);
        });
  }
}

class PazabuyListTile extends ListTile {
  PazabuyListTile(Pazabuy pazabuy)
      : super(
    title: Text(pazabuy.name),
    subtitle: Text(pazabuy.price),
    leading: CircleAvatar(child: Text(pazabuy.name[0])),
  );
}

List<Pazabuy> allPazabuy = [
  Pazabuy(name: 'Talong', price: '25php per kilo'),
  Pazabuy(name: 'Sitaw', price: '25php per kilo'),
  Pazabuy(name: 'Repolyo', price: '25php per kilo'),
  Pazabuy(name: 'Ampalaya', price: '25php per kilo'),
  Pazabuy(name: 'Kamatis', price: '25php per kilo'),
  Pazabuy(name: 'Bawang', price: '25php per kilo'),
  Pazabuy(name: 'Sibuyas', price: '25php per kilo'),
  Pazabuy(name: 'Carrots', price: '25php per kilo'),
  Pazabuy(name: 'Patatas', price: '25php per kilo'),
  Pazabuy(name: 'Sayote', price: '25php per kilo'),
  Pazabuy(name: 'Kangkong', price: '25php per kilo'),
  Pazabuy(name: 'Patola', price: '25php per kilo'),
  Pazabuy(name: 'Kalabasa', price: '25php per kilo'),
  Pazabuy(name: 'Sibuyas', price: '25php per kilo'),
  Pazabuy(name: 'Bawang', price: '25php per kilo'),
  Pazabuy(name: 'Luya', price: '25php per kilo'),
  Pazabuy(name: 'Sili', price: '25php per kilo'),
  Pazabuy(name: 'Munggo', price: '25php per kilo'),
  Pazabuy(name: 'Petsay', price: '25php per kilo'),
  Pazabuy(name: 'Kalamansi', price: '25php per kilo'),
];