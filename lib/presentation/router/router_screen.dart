import 'package:flutter/material.dart';

import '../pages/operation_page/screens/operation_screen.dart';

class RouterScreen extends StatefulWidget {
  const RouterScreen({Key? key}) : super(key: key);

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  int _selectedPage = 1;

  void onSelectedPage(int index) {
    if (_selectedPage == index) return;
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fin Plan'),
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: const [
          Text('статистика'),
          OperationScreen(), // операции
          Text('планирование'), // планирование
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.query_stats), label: 'статистика'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'операции'),
          BottomNavigationBarItem(
              icon: Icon(Icons.draw), label: 'планирование'),
        ],
        onTap: onSelectedPage,
      ),
    );
  }
}
