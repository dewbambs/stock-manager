import 'dart:async';
import 'dart:math';

import '../model/stock.dart';

class MockWebSocket {
  final List<Stock> _stocks;
  final StreamController<Stock> _controller = StreamController.broadcast();
  final Random _random = Random();
  Timer? _timer;

  MockWebSocket(this._stocks) {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _updateRandom());
  }

  Stream<Stock> get stream => _controller.stream;

  List<Stock> get stocks => List.unmodifiable(_stocks);

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }

  void _updateRandom() {
    if (_stocks.isEmpty) return;
    final index = _random.nextInt(_stocks.length);
    final change = _random.nextDouble() * 10 - 5;
    final stock = _stocks[index];
    stock.price += change;
    _controller.add(stock);
  }
}
