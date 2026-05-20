class Week {
  final DateTime startMonday;

  const Week(this.startMonday);

  List<DateTime> get days =>
      List.generate(7, (i) => startMonday.add(Duration(days: i)));
}