import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final String name;
  final int age;

  const Person(this.name, this.age);

  @override
  List<Object?> get props => [name, age];
}

void main() {
  var p1 = Person("Ayusha", 22);
  var p2 = Person("Ayusha", 22);

  print(p1 == p2); 
}
