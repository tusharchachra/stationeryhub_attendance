enum UserType { admin, employee, creator }

extension UserTypeString on UserType {
  String getName() {
    return toString().split('.').last;
    /* switch (this) {
      case 'admin':
        return UserType.admin;
      case 'employee':
        return UserType.employee;
      default:
        return 'employee';
    }*/
  }

  UserType getType() {
    return UserType.values.firstWhere((n) => n.name == name);
  }
}
