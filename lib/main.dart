import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import '../models/transaction.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      //name of app from task manager dsb
      title: 'Personal Expenses',
      // for theming
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.orangeAccent[700]),
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          bodyText1: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: const TextTheme(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).headline6,
        ),
      ),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List _userTransactions = [
    Transaction(
      id: 't1',
      title: 'Huawei Freebuds 4i',
      amount: 65.2,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Case Huawei Freebuds 4i',
      amount: 70.0,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'Nike Air Max Excee',
      amount: 97.5,
      date: DateTime.now(),
    ),
  ];

  void _addNewTransaction(String title, double amount, DateTime choosenDate) {
    final _transaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: choosenDate,
    );

    setState(() {
      _userTransactions.add(_transaction);
    });
  }

  void _deleteTransaction(id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  void _showAddTransactionForm() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  List get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Expenses'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showAddTransactionForm(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      //make floating action button floating in buttom center of the screen
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionForm(),
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SingleChildScrollView(
        //make scrollable
        child: Column(
          children: [
            WeeklyChart(_recentTransactions),
            Transactionlist(_userTransactions, _deleteTransaction),
          ],
        ),
      ),
    );
  }
}
