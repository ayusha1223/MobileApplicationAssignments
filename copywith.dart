class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  User copyWith({String? name, int? age}) {
    return User(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}

void main() {
  var user1 = User(name: "Ayusha", age: 22);
  var user2 = user1.copyWith(age: 23);

  print(user1.name);
  print(user2.age);  
}