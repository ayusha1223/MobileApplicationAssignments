Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2)); // waits 2 seconds
  return "Data loaded successfully!";
}

void main() async {
  print("Loading...");
  String result = await fetchData(); // waits for Future to complete
  print(result);
}