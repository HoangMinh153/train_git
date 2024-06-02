import 'package:flutter/material.dart';

class DataListPage extends StatelessWidget {
  const DataListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataList = List.generate(10, (index) => 'Item $index');

    return Scaffold(
      appBar: AppBar(
        title: Text('Data List Page'),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dataList[index]),
            subtitle: Text('Additional information'),
          );
        },
      ),
    );
  }
}
