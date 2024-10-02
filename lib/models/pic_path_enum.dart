import 'dart:core';

enum PicPathEnum { profile, organization, idCard }

extension PicPath on PicPathEnum {
  String getPath() {
    switch (this) {
      case PicPathEnum.profile:
        return 'profilePic';
      case PicPathEnum.organization:
        return 'organizationPic';
      case PicPathEnum.idCard:
        return 'idCard';
    }
    /*if (picPathEnum == PicPathEnum.profile) return 'profilePic';
    if (picPathEnum == PicPathEnum.organization) return 'organizationPic';
    if (picPathEnum == PicPathEnum.idCard) return 'idCard';
    return '';*/

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
