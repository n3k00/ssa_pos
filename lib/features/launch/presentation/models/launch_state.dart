class LaunchState {
  const LaunchState({required this.statusMessage});

  final String statusMessage;

  LaunchState copyWith({String? statusMessage}) {
    return LaunchState(
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}
