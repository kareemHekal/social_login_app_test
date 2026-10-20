import 'package:equatable/equatable.dart';

class SocialRegisterProfile extends Equatable {
  final String firstName;
  final String lastName;
  final String gender;
  final num height;
  final num weight;
  final int age;
  final String goal;
  final String activityLevel;

  const SocialRegisterProfile({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.goal,
    required this.activityLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'height': height,
      'weight': weight,
      'age': age,
      'goal': goal,
      'activityLevel': activityLevel,
    };
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        gender,
        height,
        weight,
        age,
        goal,
        activityLevel,
      ];
}
