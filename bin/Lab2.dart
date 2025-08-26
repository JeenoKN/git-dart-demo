import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

void main() async {
  String? userId;

  // Login
  print("===== Login =====");
  stdout.write("Username: ");
  String? username = stdin.readLineSync()?.trim();
  stdout.write("Password: ");
  String? password = stdin.readLineSync()?.trim();

  if (username == null || password == null) {
    print("Incomplete input");
    return;
  }
//test
  final body = {"username": username, "password": password};
  final url = Uri.parse('http://localhost:3000/login');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200 && response.body == "Login OK") {
    // Fetch user ID
    final userResponse = await http.get(Uri.parse('http://localhost:3000/userid?username=$username'));
    if (userResponse.statusCode == 200) {
      userId = jsonDecode(userResponse.body)['id'].toString();
    } else {
      print("Error fetching user ID: ${userResponse.body}");
      return;
    }
  } else {
    print("Error ${response.statusCode}: ${response.body}");
    return;
  }

  // Menu Loop
  while (true) {
    print("===== Expense Tracking App =====");
    print("1. All expenses");
    print("2. Today's expense");
    print("3. Exit");
    stdout.write("Choose: ");
    String? choice = stdin.readLineSync()?.trim();

    if (choice == "1") {
      final allExpensesUrl = Uri.parse('http://localhost:3000/expenses?user_id=$userId');
      final allResponse = await http.get(allExpensesUrl);
      if (allResponse.statusCode == 200) {
        final expenses = jsonDecode(allResponse.body) as List<dynamic>;
        printAllExpenses(expenses);
      } else {
        print("Error ${allResponse.statusCode}: ${allResponse.body}");
      }
    } else if (choice == "2") {
      final todayUrl = Uri.parse('http://localhost:3000/todayexpenses?user_id=$userId');
      final todayResponse = await http.get(todayUrl);
      if (todayResponse.statusCode == 200) {
        final expenses = jsonDecode(todayResponse.body) as List<dynamic>;
        printTodayExpenses(expenses);
      } else {
        print("Error ${todayResponse.statusCode}: ${todayResponse.body}");
      }
    } else if (choice == "3") {
<<<<<<< Updated upstream
=======
      stdout.write("Enter item to search: ");
      String? searchItem = stdin.readLineSync()?.trim();
      if (searchItem != null && searchItem.isNotEmpty) {
        final searchUrl = Uri.parse(
          'http://localhost:3000/search?user_id=$userId&item=$searchItem',
        );
        final searchResponse = await http.get(searchUrl);
        if (searchResponse.statusCode == 200) {
          final expenses = jsonDecode(searchResponse.body) as List<dynamic>;
          printSearchExpenses(expenses);
        } else {
          print("Error ${searchResponse.statusCode}: ${searchResponse.body}");
        }
      } else {
        print("Invalid search term");
      }
      } else if (choice == "4") {
  print("========== Add new item ==========");
  stdout.write("Item: ");
  String? item = stdin.readLineSync()?.trim();
  stdout.write("Paid: ");
  String? paidStr = stdin.readLineSync()?.trim();
  int? paid = int.tryParse(paidStr ?? "");
  if (item != null && item.isNotEmpty && paid != null) {
    final body = {"user_id": userId, "item": item, "paid": paid, "date": DateTime.now().toIso8601String()};
    final addUrl = Uri.parse('http://localhost:3000/addexpense');
    final addResponse = await http.post(
      addUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (addResponse.statusCode == 200) {
      print("Inserted!");
    } else {
      print("Error ${addResponse.statusCode}: ${addResponse.body}");
    }
  } else {
    print("Invalid input for new expense");
  }
    } else if (choice == "6") {
>>>>>>> Stashed changes
      print("Bye");
      break;
    } else {
      print("Invalid choice");
    }
  }
}

void printAllExpenses(List<dynamic> expenses) {
  if (expenses.isEmpty) {
    print("No expenses found");
    return;
  }
  int total = 0;
  print("All expenses");
  for (var expense in expenses) {
    if (expense is Map && expense.containsKey('item') && expense.containsKey('paid') && expense.containsKey('date')) {
      total += (expense['paid'] as int);
      String dateStr = expense['date'].toString().split(' ')[0];
      print("${expense['item']} : ${expense['paid']} : $dateStr");
    } else {
      print("Invalid expense data: $expense");
    }
  }
  print("Total expenses = ${total}\$");
}

void printTodayExpenses(List<dynamic> expenses) {
  if (expenses.isEmpty) {
    print("No expenses today");
    return;
  }
  int total = 0;
  print("Today's expenses");
  for (var expense in expenses) {
    if (expense is Map && expense.containsKey('item') && expense.containsKey('paid') && expense.containsKey('date')) {
      total += (expense['paid'] as int);
      String dateStr = expense['date'].toString().split(' ')[0];
      print("${expense['item']} : ${expense['paid']} : $dateStr");
    } else {
      print("Invalid expense data: $expense");
    }
  }
  print("Total expenses = ${total}\$");
}