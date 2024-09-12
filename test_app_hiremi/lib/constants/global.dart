class GlobalState {
  GlobalState._privateConstructor();

  static final GlobalState _instance = GlobalState._privateConstructor();

  factory GlobalState() {
    return _instance;
  }
  String? registeredEmail;

  int? profileId;
}
