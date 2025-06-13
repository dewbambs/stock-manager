import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../bloc/stock_bloc.dart';
import '../model/stock.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final PagingController<int, Stock> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      context.read<StockBloc>().add(FetchStocks());
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stocks')),
      body: BlocListener<StockBloc, StockState>(
        listener: (context, state) {
          _pagingController.itemList = List.of(state.stocks);
        },
        child: PagedListView<int, Stock>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Stock>(
            itemBuilder: (context, stock, index) => VisibilityDetector(
              key: Key('stock_${stock.id}'),
              onVisibilityChanged: (info) {
                context.read<StockBloc>().add(
                      StockVisibilityChanged(
                        stock.id,
                        info.visibleFraction > 0,
                      ),
                    );
              },
              child: ListTile(
                title: Text(stock.name),
                trailing: Text(stock.price.toStringAsFixed(2)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
