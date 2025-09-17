import 'package:flutter/material.dart';
import '../presentation/student_registration/student_registration.dart';
import '../presentation/student_profile/student_profile.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/quiz_interface/quiz_interface.dart';
import '../presentation/leaderboard/leaderboard.dart';
import '../presentation/student_dashboard/student_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String studentRegistration = '/student-registration';
  static const String studentProfile = '/student-profile';
  static const String authentication = '/authentication-screen';
  static const String quizInterface = '/quiz-interface';
  static const String leaderboard = '/leaderboard';
  static const String studentDashboard = '/student-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const StudentRegistration(),
    studentRegistration: (context) => const StudentRegistration(),
    studentProfile: (context) => const StudentProfile(),
    authentication: (context) => const AuthenticationScreen(),
    quizInterface: (context) => const QuizInterface(),
    leaderboard: (context) => const Leaderboard(),
    studentDashboard: (context) => const StudentDashboard(),
    // TODO: Add your other routes here
  };
}
