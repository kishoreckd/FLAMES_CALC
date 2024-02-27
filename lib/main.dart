import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/quickalert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flames Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController1 = TextEditingController();
  TextEditingController nameController2 = TextEditingController();
  String result = '';

  OutlineInputBorder getOutlineInputBorder(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDarkMode ? Colors.white : Colors.black12;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor),
    );
  }

  @override
  Widget build(BuildContext context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flames Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              cursorColor: Colors.purple,
              controller: nameController1,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  nameController1.text = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Enter Your Name",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: getDecorationColor(context), // Use the method here
                ),
                enabledBorder: getOutlineInputBorder(context),
                focusedBorder: getOutlineInputBorder(context),
                suffixIcon: nameController1.text.length > 2
                    ? Container(
                        height: 30,
                        width: 30,
                        margin: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              cursorColor: Colors.purple,
              controller: nameController2,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) {
                setState(() {
                  nameController2.text = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Enter Your Partner Name",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: getDecorationColor(context), // Use the method here
                ),
                enabledBorder: getOutlineInputBorder(context),
                focusedBorder: getOutlineInputBorder(context),
                suffixIcon: nameController2.text.length > 2
                    ? Container(
                        height: 30,
                        width: 30,
                        margin: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateFlames();
              },
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  result,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                    height: 20), // Add some space between text and image
                result.isNotEmpty
                    ? Image.asset(
                        'assets/${result.toLowerCase()}.png',
                        height: 100, // Adjust the height as needed
                      )
                    : const SizedBox()
              ],
            )
          ],
        ),
      ),
    );
  }

  void calculateFlames() {
    String name1 = nameController1.text.toLowerCase();
    String name2 = nameController2.text.toLowerCase();
    int count = 0;

    // Reset result to empty string
    setState(() {
      result = '';
    });
    if (name1.isEmpty && name2.isEmpty) {
      showAlert(title: "Error", message: "Please enter both names.");

      return;
    }

    if (name1.isEmpty) {
      showAlert(title: "Error", message: "Your Name is required");
      return;
    }

    if (name2.isEmpty) {
      showAlert(title: "Error", message: "Your Partner Name is required");
      return;
    }
    for (int i = 0; i < name1.length; i++) {
      for (int j = 0; j < name2.length; j++) {
        if (name1[i] == name2[j]) {
          name1 = name1.replaceFirst(name1[i], '*');
          name2 = name2.replaceFirst(name2[j], '*');
        }
      }
    }

    List<String> filteredNames = [...name1.split(''), ...name2.split('')];
    for (int x = 0; x < filteredNames.length; x++) {
      if (filteredNames[x] != "*") {
        count++;
      }
    }
    int position = 0;
    String flames = "flames";
    for (int s = flames.length; s > 1; s--) {
      position = (count + position) % s;
      if (position == 0) {
        position = s - 1;
      } else {
        position--;
      }
      flames = flames.replaceRange(position, position + 1, "");
    }

    showResult(flames);
  }

  void showResult(String flames) {
    String resultText;
    String imagePath;

    switch (flames) {
      case "f":
        resultText = "Friend";
        imagePath = "assets/friend.png"; // Replace with your asset path
        break;
      case "l":
        resultText = "Lover";
        imagePath = "assets/love.png"; // Replace with your asset path
        break;
      case "a":
        resultText = "Affair";
        imagePath = "assets/affection.png"; // Replace with your asset path
        break;
      case "m":
        resultText = "Marriage";
        imagePath = "assets/marriage.png"; // Replace with your asset path
        break;
      case "e":
        resultText = "Enemy";
        imagePath = "assets/enemy.png"; // Replace with your asset path
        break;
      case "s":
        resultText = "Sister";
        imagePath = "assets/sister.png"; // Replace with your asset path
        break;
      default:
        resultText = "Unknown relationship";
        imagePath = "assets/flames.png"; // Replace with your asset path
    }

    setState(() {
      result = resultText;
    });

    // Show image alert
    showImageAlert(resultText, imagePath);
  }

  void showImageAlert(String resultText, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Result: $resultText"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                height: 100, // Adjust the height as needed
              ),
              const SizedBox(height: 20),
              const Text(
                "Congratulations!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void showAlert({required String title, required String message}) {
    QuickAlert.show(
      context: context,
      title: title,
      text: message,
      type: QuickAlertType.success,
    );
  }

  Color getDecorationColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.white : Colors.grey.shade600;
  }
}
