import 'dart:core';

enum PicPathEnum { profile, organization, idCard }

extension PicPath on PicPathEnum {
  static String getPath(PicPathEnum) {
    if (PicPathEnum == PicPathEnum.profile) return 'profilePic';
    if (PicPathEnum == PicPathEnum.organization) return 'organizationPic';
    if (PicPathEnum == PicPathEnum.idCard) return 'idCard';
    return '';

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
