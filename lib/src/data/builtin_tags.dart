import 'package:data/data.dart';

extension LineCategoryTag on LineCategory {
  List<String> get tags {
    switch (this) {
      case LineCategory.entertainment:
        return ['movie'];
      case LineCategory.food:
        return ['breakfast', 'lunch', 'dinner'];
      case LineCategory.housing:
        return ['rent'];
      case LineCategory.investment:
        return ['saving', 'stock'];
      case LineCategory.medical_healthcare:
        return ['medicine'];
      case LineCategory.personal_spending:
        return ['gym', 'spa'];
      case LineCategory.salary:
        return [];
      case LineCategory.selling:
        return [];
      case LineCategory.transportation:
        return ['bus', 'gas', 'parking'];
      case LineCategory.utilities:
        return ['electricity', 'internet', 'water'];
    }

    return [];
  }
}
