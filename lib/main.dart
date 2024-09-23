import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para convertir JSON a Map
import 'package:dio/dio.dart'; // para solicitudes
import 'package:flutter/services.dart';


void main() => runApp(MiApp());

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mi App",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget{
 const Home({super.key});

 @override
 State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic>? products;

  // Solicitud API
  Future<void> fetchProducts() async {
    final dio = Dio();

    try {
      final response = await dio.get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        setState(() {
          products = response.data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.statusMessage}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Llama a la API al inicializar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos de Tienda'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: products == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Dos columnas
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: products!.length,
                itemBuilder: (context, index) {
                  final product = products![index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(
                              product['image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '\$${product['price']}',
                            style: TextStyle(color: const Color.fromARGB(255, 0, 105, 150), fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 8), // Espacio al final
                      ],
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          // Navegación según la selección
        if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Inicio()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SegundaVista()),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
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
        title: Text("Segunda vista"),
        backgroundColor: Colors.blueAccent,
         automaticallyImplyLeading: false,
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
        selectedIndex: 1,
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.pop(context); // Regresa a la vista anterior
          } else if(index == 2){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SegundaVista()),
              );  
          }
        },
        destinations: const [
           NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
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
        title: Text("Tercera Vista"),
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
              onPressed: () async {
              final sms = Uri.parse('sms:9612545998');
                if (await canLaunchUrl(sms)) {
                  await launchUrl(sms);
                } else {
                  print('Could not launch $sms');
                }
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
              onPressed: () async {
                final web = Uri.parse('https://github.com/Nancy1226/app_movil_2.git');
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
        selectedIndex: 2,
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.pop(context); // Regresa a la vista anterior
          }else if(index == 1){
             Navigator.pop(context);
          }
        },
        destinations: const [
           NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
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
