import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/stock_bloc.dart';
import 'data/mock_websocket.dart';
import 'data/stock_data_source.dart';
import 'model/stock.dart';
import 'repository/stock_repository.dart';
import 'ui/stock_page.dart';

void main() {
  final stocks = List.generate(
    20,
    (i) => Stock(id: '$i', name: 'Stock $i', price: 100 + i.toDouble()),
  );
  final socket = MockWebSocket(stocks);
  final dataSource = StockDataSource(socket);
  final repository = StockRepository(dataSource);

  runApp(StockApp(repository: repository));
}

class StockApp extends StatelessWidget {
  final StockRepository repository;

  const StockApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Manager',
      home: BlocProvider(
        create: (_) => StockBloc(repository),
        child: const StockPage(),
      ),
    );
  }
}
