import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/chart_bar.dart';

class WeeklyChart extends StatelessWidget {
  final List recentTransactions;
  const WeeklyChart(this.recentTransactions, {Key? key}) : super(key: key);

  List get groupedTransactionValues {
    //dart feature to generating list
    return List.generate(7, (index) {
      //to get 7 days ago from today?
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        //generate day fo 1 week ago, and place today in the end of generated list of days
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, transValue) {
      return sum + transValue['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((transaction) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: transaction['day'],
                  spendingAmount: transaction['amount'],
                  spendingPercentage: totalSpending == 0
                      ? 0
                      : transaction['amount'] / totalSpending),
            );
            // Text(
            //     '${transaction['day']} : ${transaction['amount'].toString()}');
          }).toList(),
        ),
      ),
    );
  }
}
