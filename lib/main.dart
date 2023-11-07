import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libros/convert_utility.dart';
import 'package:libros/dbManager.dart';
import 'package:libros/book.dart';
import 'package:flutter/services.dart';
import 'package:libros/details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Book>>? Bookss;
  TextEditingController paginaController = TextEditingController();
  TextEditingController autorController = TextEditingController();
  TextEditingController editorialController = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  TextEditingController edicionController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController controlNumController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String? pagina = '';
  String? autor = '';
  String? edicion = '';
  String? editorial = '';
  String? titulo = '';
  String? isbn = '';
  String? photoname = '';

  int? currentUserId;
  final formKey = GlobalKey<FormState>();
  late var dbHelper;
  late bool isUpdating;

  // Métodos de usuario
  refreshList() {
    setState(() {
      Bookss = dbHelper.getBooks();
    });
  }

  pickImageFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640)
        .then((value) async {
      Uint8List? imageBytes = await value!.readAsBytes();
      setState(() {
        photoname = Utility.base64String(imageBytes!);
      });
    });
  }

  clearFields() {
    paginaController.text = '';
    autorController.text = '';
    editorialController.text = '';
    tituloController.text = '';
    edicionController.text = '';
    isbnController.text = '';
    controlNumController.text = '';
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBManager();
    refreshList();
    isUpdating = false;
  }

  searchByTitle() {
    String searchText = searchController.text;
    setState(() {
      Bookss = dbHelper.searchBooksByTitle(searchText);
    });
  }

  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (photoname == '') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Por favor, seleccione una foto antes de guardar.'),
        ));
        return;
      } else if (isUpdating) {
        Book book = Book(
          controlNum: currentUserId,
          titulo: titulo,
          autor: autor,
          editorial: editorial,
          pagina: pagina,
          edicion: edicion,
          isbn: isbn,
          photoName: photoname,
        );
        dbHelper.update(book);
        isUpdating = false;
      } else {
        Book book = Book(
          controlNum: null,
          titulo: titulo,
          autor: autor,
          editorial: editorial,
          pagina: pagina,
          edicion: edicion,
          isbn: isbn,
          photoName: photoname,
        );
        dbHelper.save(book);
      }
      clearFields();
      refreshList();
    }
  }

  Widget userForm() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            const SizedBox(height: 10),
            TextFormField(
              controller: searchController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Buscar por título',
              ),
            ),
            ElevatedButton(
              onPressed: searchByTitle,
              child: const Text('Buscar'),
            ),
            TextFormField(
              controller: tituloController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Titulo',
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter titulo';
                }
                return null;
              },
              onSaved: (val) => titulo = val!,
            ),
            TextFormField(
              controller: autorController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'autor',
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter autor';
                }
                return null;
              },
              onSaved: (val) => autor = val!,
            ),
            TextFormField(
              controller: editorialController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Editorial',
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter editorial';
                }
                return null;
              },
              onSaved: (val) => editorial = val!,
            ),
            TextFormField(
              controller: paginaController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
              ],
              decoration: const InputDecoration(
                labelText: 'Pagina',
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Ingrese el número de Paginas';
                }
                if (!RegExp(r'^[0-9]*$').hasMatch(val)) {
                  return 'Ingrese solo números';
                }
                return null;
              },
              onSaved: (val) => pagina = val,
            ),
            TextFormField(
              controller: edicionController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'edicion',
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter edicion';
                }
                return null;
              },
              onSaved: (val) => edicion = val!,
            ),
            TextFormField(
              controller: isbnController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'isbn',
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter isbn';
                }
                return null;
              },
              onSaved: (val) => isbn = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: validate,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: Text(isUpdating ? "Actualizar" : "Insertar"),
                ),
                MaterialButton(
                  onPressed: () {
                    pickImageFromGallery();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.green),
                  ),
                  child: const Text("Seleccionar imagen"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView userDataTable(List<Book>? Bookss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
        DataColumn(label: Text('Photo')),
          DataColumn(label: Text('Autor')),
          DataColumn(label: Text('Titulo')), // Cambia el orden aquí
          DataColumn(label: Text('Editorial')),
          DataColumn(label: Text('Pagina')),
          DataColumn(label: Text('Edicion')),
          DataColumn(label: Text('isbn')),
          DataColumn(label: Text('Delete')),
        ],
        rows: Bookss!
            .map((book) => DataRow(cells: [
          DataCell(GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookDetails(book),
                ),
              );
            },
            child: Container(
              width: 80,
              height: 120,
              child: Utility.ImageFromBase64String(book.photoName!),
            ),
          )),
          DataCell(Text(book.autor!), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = book.controlNum;
            });
            tituloController.text = book.titulo!;
            autorController.text = book.autor!;
            editorialController.text = book.editorial!;
            paginaController.text = book.pagina!;
            edicionController.text = book.edicion!;
            isbnController.text = book.isbn!;
          }),
          DataCell(Text(book.titulo!)),
          DataCell(Text(book.editorial!)),
          DataCell(Text(book.pagina!)),
          DataCell(Text(book.edicion!)),
          DataCell(Text(book.isbn!)),
          DataCell(IconButton(
            onPressed: () {
              dbHelper.delete(book.controlNum);
              refreshList();
            },
            icon: const Icon(Icons.delete),
          ))
        ]))
            .toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: SingleChildScrollView(
        child: FutureBuilder(
            future: Bookss,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return userDataTable(snapshot.data);
              }
              if (!snapshot.hasData) {
                print("Data Not Found");
              }
              return const CircularProgressIndicator();
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Libros'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: [userForm(), list()],
      ),
    );
  }
}
