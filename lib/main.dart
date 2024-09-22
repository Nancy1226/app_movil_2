import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MiApp());

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mi App",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final TextEditingController _controller = TextEditingController();
  Color _borderColor = Colors.grey;
  String _validationMessage = '';

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _borderColor = Colors.grey;
        _validationMessage = '';
      } else if (double.tryParse(value) != null) {
        _borderColor = Colors.red;
        _validationMessage = 'Por favor, ingresa solo letras.';
      } else {
        _borderColor = Colors.green;
        _validationMessage = '';
      }
    });
  }

  void _validateInputSend() {
    setState(() {
      if (_controller.text.isEmpty) {
        _borderColor = Colors.red;
        _validationMessage = 'Campos vacíos, ingresa algún nombre.';
      } else {
        _validationMessage = '';
      }
    });
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: Text('Holiiiii\n'),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showAlert(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Ingresa tu nombre',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: _borderColor),
                  ),
                  errorText: _validationMessage.isEmpty ? null : _validationMessage,
                ),
                onChanged: _validateInput,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              ),
              onPressed: () {
                _validateInputSend();
                if (_validationMessage.isEmpty) {
                  String name = _controller.text;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Hola, $name!')),
                  );
                }
              },
              child: Text(
                'Saludar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SegundaVista()),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class SegundaVista extends StatelessWidget {
const SegundaVista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Segunda Vista"),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Image.asset(
                'assets/yop.jpeg',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Text("221201"),
            Text("Nancy Guadalupe Jimenez Escobar"),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              ),
                onPressed: () async {
                final call = Uri.parse('tel:+529613046705');
                if (await canLaunchUrl(call)) {
                  await launchUrl(call, mode: LaunchMode.externalApplication);
                } else {
                  print('Could not launch $call');
                }
              },
              child: Text(
                'Llamar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              ),
              onPressed: () {
                // Acción para el botón Mensaje
              },
              child: Text(
                'Mensaje',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              ),
              onPressed: () {
                final web = Uri.parse('https://codoweb.com/');
                if (await canLaunchUrl(web)) {
                  await launchUrl(web, mode: LaunchMode.externalApplication);
                } else {
                  print('Could not launch $web');
                }
              },
              child: Text(
                'Repositorio',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.pop(context); // Regresa a la vista anterior
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
    
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Debasis Sil Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         title: const Text('Debasis Sil Flutter Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 final web = Uri.parse('https://codoweb.com/');
//                 if (await canLaunchUrl(web)) {
//                   await launchUrl(web, mode: LaunchMode.externalApplication);
//                 } else {
//                   print('Could not launch $web');
//                 }
//               },
//               child: const Text('Web'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = Uri(
//                   scheme: 'mailto',
//                   path: 'codoweb.tech@gmail.com',
//                   query: 'subject=Hello&body=Test',
//                 );
//                 if (await canLaunchUrl(email)) {
//                   await launchUrl(email);
//                 } else {
//                   print('Could not launch $email');
//                 }
//               },
//               child: const Text('Email'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final call = Uri.parse('tel:+529613046705');
//                 if (await canLaunchUrl(call)) {
//                   await launchUrl(call, mode: LaunchMode.externalApplication);
//                 } else {
//                   print('Could not launch $call');
//                 }
//               },
//               child: const Text('Call'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final sms = Uri.parse('sms:5550101234');
//                 if (await canLaunchUrl(sms)) {
//                   await launchUrl(sms);
//                 } else {
//                   print('Could not launch $sms');
//                 }
//               },
//               child: const Text('SMS'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
