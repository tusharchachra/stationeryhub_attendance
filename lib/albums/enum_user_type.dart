enum UserType { admin, employee, none }

extension UserTypeString on String {
  UserType get userType {
    switch (this) {
      case 'admin':
        return UserType.admin;
      case 'employee':
        return UserType.employee;
      default:
        return UserType.none;
    }
  }
}