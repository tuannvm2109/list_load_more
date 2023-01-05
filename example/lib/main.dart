import 'package:flutter/material.dart';

import 'package:list_load_more/list_load_more/list_load_more.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'List Load More Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'List Load More'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ListLoadMoreState> _key = GlobalKey();
  ListLoadMoreStatus _status = ListLoadMoreStatus.none;

  @override
  void initState() {
    super.initState();
    _loadData(skip: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListLoadMore<Employee>(
          key: _key,
          status: _status,
          total: 1003,
          itemBuilder: (item, index) => _employeeWidget(item),
          onLoadMore: (int currentTotal) async {
            await _loadData(skip: currentTotal);
          },
          onRefresh: () async {
            await _loadData(skip: 0);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _key.currentState?.removeItem(index: 2);
        },
      ),
    );
  }

  Widget _employeeWidget(Employee item) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          children: [
            Image.asset('assets/ic_employee.png', width: 60, height: 60),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name),
                const SizedBox(height: 5),
                Text('Code: ${item.hashCode}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _loadData({required int skip}) async {
    if (skip == 0) {
      setState(() {
        _status = ListLoadMoreStatus.loadRefresh;
      });
    }

    try {
      final employees = await _loadEmployees(skip: skip);
      _key.currentState?.addData(employees);

      setState(() {
        _status = ListLoadMoreStatus.none;
      });
    } catch (e) {
      setState(() {
        _status = ListLoadMoreStatus.error;
      });
    }
  }

  /// This function will fake data response from API
  /// We will load 100 items per 1 request
  Future<List<Employee>> _loadEmployees({int skip = 0}) async {
    // Let assume we have total 1003 employees
    const int totalEmployee = 1003;
    const int sizePerRequest = 100;

    await Future.delayed(const Duration(seconds: 2));

    final numberOfEmployeeReturn = ((skip + sizePerRequest) >= totalEmployee)
        ? (totalEmployee - skip + 1)
        : sizePerRequest;

    final list = [
      for (var i = skip; i < skip + numberOfEmployeeReturn; i += 1) i
    ].map<Employee>((i) {
      return Employee(
        i,
        'Employee name $i',
      );
    }).toList();

    return list;
  }
}

class Employee {
  int id;
  String name;

  Employee(this.id, this.name);
}
