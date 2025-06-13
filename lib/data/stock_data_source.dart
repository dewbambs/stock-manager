import 'dart:async';

import '../model/stock.dart';
import 'mock_websocket.dart';

class StockDataSource {
  final MockWebSocket _socket;
  final StreamController<List<Stock>> _controller =
      StreamController.broadcast();
  final List<Stock> _stocks;
  final Set<String> _visibleIds = {};
  late final StreamSubscription<Stock> _sub;

  StockDataSource(this._socket) : _stocks = List.of(_socket.stocks) {
    _controller.add(List.of(_stocks));
    _sub = _socket.stream.listen(_onUpdate);
  }

  Stream<List<Stock>> get stream => _controller.stream;

  Future<List<Stock>> fetchStocks() async {
    return List.of(_stocks);
  }

  void _onUpdate(Stock stock) {
    if (_visibleIds.contains(stock.id)) {
      final index = _stocks.indexWhere((e) => e.id == stock.id);
      if (index != -1) {
        _stocks[index] = stock;
        _controller.add(List.of(_stocks));
      }
    }
  }

  void updateVisibility(Set<String> ids) {
    _visibleIds
      ..clear()
      ..addAll(ids);
  }

  void dispose() {
    _sub.cancel();
    _controller.close();
  }
}
