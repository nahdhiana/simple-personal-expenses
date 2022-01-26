// ignore_for_file: unused_field
//convention to import dart lib first, then flutter, then your custom widget
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import '../models/transaction.dart';

void main(List<String> args) {
  //only accept portrait orientation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ],
  // ).then((_) {
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
  // });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

List<Widget> _buildLandscapeContent(
    {required mediaQuery,
    required context,
    required showChart,
    required appBar,
    required recentTransactions,
    required transactionList,
    required onChanged}) {
  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        // .adaptive some widget have this, so it can automatically change
        //based on platform (ios/android)
        Switch.adaptive(
          value: showChart,
          onChanged: onChanged,
        ),
      ],
    ),
    showChart
        ? SizedBox(
            //occupy 40% of screensize - (minus) for appbar and topbar
            //mediaquery....padding.top is space for topbar
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.6,
            child: WeeklyChart(recentTransactions),
          )
        : transactionList
  ];
}

List<Widget> _buildPortraitContent(
    {required mediaQuery,
    required appBar,
    required recentTransactions,
    required transactionList}) {
  return [
    SizedBox(
      //occupy 40% of screensize - (minus) for appbar and topbar
      //mediaquery....padding.top is space for topbar
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.3,
      child: WeeklyChart(recentTransactions),
    ),
    transactionList,
  ];
}

PreferredSizeWidget _buildAppBar(showAddTransactionForm) {
  return Platform.isIOS
      ? CupertinoNavigationBar(
          middle: const Text('Personal Expenses'),
          trailing: Row(
            //row take as much screensize available, so with mainAxisSize.min it will be the constraints
            //the default value is max, so change it to min to take space as small as needed
            mainAxisSize: MainAxisSize.min,
            children: [
              // make custom button cz ios didn't have icon button
              GestureDetector(
                child: const Icon(CupertinoIcons.add),
                onTap: () => showAddTransactionForm(),
              ),
            ],
          ),
        )
      : AppBar(
          title: const Text('Personal Expenses'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => showAddTransactionForm(),
              icon: const Icon(Icons.add),
            ),
          ],
          //to handling error preferred size
        ) as PreferredSizeWidget;
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

  bool _showChart = false;

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
    final _mediaQuery = MediaQuery.of(context);

    final _isLandscape = _mediaQuery.orientation == Orientation.landscape;

    //split appbar into widget then insert into new variable to calculate responsiveness
    final PreferredSizeWidget _appBar = _buildAppBar(_showAddTransactionForm);

    final _transactionList = SizedBox(
      height: (_mediaQuery.size.height -
              _appBar.preferredSize.height -
              _mediaQuery.padding.top) *
          0.7,
      child: Transactionlist(_userTransactions, _deleteTransaction),
    );

    final _body = SafeArea(
      child: SingleChildScrollView(
        //make scrollable
        child: Column(
          children: [
            //if orientation is landscape
            if (_isLandscape)
              // ...spread operator, cz _buildPortrait return list of widgets, but here need a widget.
              ..._buildLandscapeContent(
                  appBar: _appBar,
                  context: context,
                  mediaQuery: _mediaQuery,
                  recentTransactions: _recentTransactions,
                  showChart: _showChart,
                  transactionList: _transactionList,
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                  }),
            //if orientations is portrait
            if (!_isLandscape)
              // ...spread operator, cz _buildPortrait return list of widgets, but here need a widget.
              ..._buildPortraitContent(
                mediaQuery: _mediaQuery,
                appBar: _appBar,
                recentTransactions: _recentTransactions,
                transactionList: _transactionList,
              ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: _appBar,
      //make floating action button floating in buttom center of the screen
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          //check is platform is IOS, hide the floating action button, cz ios didn't have it
          Platform.isIOS
              ? const SizedBox()
              : FloatingActionButton(
                  onPressed: () => _showAddTransactionForm(),
                  child: const Icon(
                    Icons.add,
                  ),
                ),
      body: _body,
    );
  }
}
