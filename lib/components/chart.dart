import 'package:despesas_financeiras/components/chart_bar.dart';
import 'package:despesas_financeiras/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransaction {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.00;

      for (var i = 0; i < recentTransactions.length; i++) {
        bool sameDay = recentTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentTransactions[i].date.month == weekDay.month;
        bool sameYear = recentTransactions[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransactions[i].value;
        }
      }
      // print(DateFormat.E().format(weekDay)[0]);
      // print(totalSum);
      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
      //Utilizamos o rever para alterar a ordem da lista.
      //Antes: seg,domingo,sabado,sexta,quinta,quarta,terca
      //Utilizando o reverse: terca,quarta,quinta,sexta,sab,dom,seg
    }).reversed.toList();
  }

  double get weekTotalValue {
    return groupedTransaction.fold(
        0.0,
        (sum, tr) =>
            sum +
            tr['value']); // sum eh o acumulador que estamos definimos como SOMA, e o tr eh o map do dia e valor.
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransaction.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'],
                value: tr['value'],
                percentage: weekTotalValue == 0 ? 0 :(tr['value'] as double) / weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
