import 'dart:async';

import 'package:bloc/bloc.dart';

import '../model/stock.dart';
import '../repository/stock_repository.dart';

abstract class StockEvent {}

class FetchStocks extends StockEvent {}

class StockVisibilityChanged extends StockEvent {
  final String id;
  final bool visible;

  StockVisibilityChanged(this.id, this.visible);
}

class _StocksUpdated extends StockEvent {
  final List<Stock> stocks;

  _StocksUpdated(this.stocks);
}

class StockState {
  final List<Stock> stocks;

  const StockState(this.stocks);
}

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockRepository _repository;
  StreamSubscription<List<Stock>>? _subscription;

  StockBloc(this._repository) : super(const StockState([])) {
    on<FetchStocks>(_onFetch);
    on<StockVisibilityChanged>(_onVisibilityChanged);
    on<_StocksUpdated>(_onStocksUpdated);
  }

  Future<void> _onFetch(FetchStocks event, Emitter<StockState> emit) async {
    final stocks = await _repository.fetchStocks();
    emit(StockState(List.of(stocks)));
    _subscription?.cancel();
    _subscription = _repository.subscribe((list) => add(_StocksUpdated(list)));
  }

  void _onVisibilityChanged(
      StockVisibilityChanged event, Emitter<StockState> emit) {
    if (event.visible) {
      _repository.addVisible(event.id);
    } else {
      _repository.removeVisible(event.id);
    }
  }

  void _onStocksUpdated(_StocksUpdated event, Emitter<StockState> emit) {
    emit(StockState(List.of(event.stocks)));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
