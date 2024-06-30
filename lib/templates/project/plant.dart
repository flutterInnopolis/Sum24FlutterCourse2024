class Plant {
  String name;
  int waterLevel;
  bool isAlive;

  Plant({required this.name, this.waterLevel = 100, this.isAlive = true});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'waterLevel': waterLevel,
      'isAlive': isAlive,
    };
  }

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'],
      waterLevel: json['waterLevel'],
      isAlive: json['isAlive'],
    );
  }
}

class User {
  double height;
  double weight;
  int age;
  double cupSize;
  double dailyWaterIntake;

  User({
    required this.height,
    required this.weight,
    required this.age,
    required this.cupSize,
  }) : dailyWaterIntake = calculateWaterIntake(height, weight, age);

  static double calculateWaterIntake(double height, double weight, int age) {
    return weight * 0.03; // примерная формула, можно изменить по необходимости
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'age': age,
      'cupSize': cupSize,
      'dailyWaterIntake': dailyWaterIntake,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      height: json['height'],
      weight: json['weight'],
      age: json['age'],
      cupSize: json['cupSize'],
    );
  }
}