enum ConnectivityState { online, offline }

class ConnectivityService {
  ConnectivityState _state = ConnectivityState.online;

  ConnectivityState get currentState => _state;

  void setState(ConnectivityState state) {
    _state = state;
  }
}
