enum UserType { admin, employee }

extension UserTypeString on UserType {
  String getUserName() {
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
}