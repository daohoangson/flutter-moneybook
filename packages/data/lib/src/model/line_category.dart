const expenseCategories = [
  LineCategory.entertainment,
  LineCategory.food,
  LineCategory.housing,
  LineCategory.investment,
  LineCategory.medical_healthcare,
  LineCategory.personal_spending,
  LineCategory.transportation,
  LineCategory.utilities,
];

const incomeCategories = [
  LineCategory.investment,
  LineCategory.salary,
  LineCategory.selling,
];

enum LineCategory {
  entertainment,
  food,
  housing,
  investment,
  medical_healthcare,
  personal_spending,
  salary,
  selling,
  transportation,
  utilities,
}

extension LineCategory_ on LineCategory {
  String get id => toString().replaceAll(RegExp(r'^\w+\.'), '');
}
