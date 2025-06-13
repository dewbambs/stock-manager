import 'dart:async';

import '../model/stock.dart';
import '../data/stock_data_source.dart';

class StockRepository {
  final StockDataSource _dataSource;
  final Set<String> _visibleSet = {};

  StockRepository(this._dataSource);

  Future<List<Stock>> fetchStocks() => _dataSource.fetchStocks();

  StreamSubscription<List<Stock>> subscribe(void Function(List<Stock>) callback) {
    return _dataSource.stream.listen(callback);
  }

  void addVisible(String id) {
    _visibleSet.add(id);
    _dataSource.updateVisibility(_visibleSet);
  }

  void removeVisible(String id) {
    _visibleSet.remove(id);
    _dataSource.updateVisibility(_visibleSet);
  }
}
