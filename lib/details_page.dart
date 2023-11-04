import 'package:flutter/material.dart';
import 'package:libros/book.dart';
import 'package:libros/convert_utility.dart';

class BookDetails extends StatelessWidget {
  final Book book;

  BookDetails(this.book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del libro ${book.titulo}'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 250,
              height: 250,
              child: (book.photoName != null)
                  ? Utility.ImageFromBase64String(book.photoName!)
                  : Icon(Icons.image),
            ),
            Text('Titulo: ${book.titulo ?? ""}'),
            Text('Autor/Autores: ${book.autor ?? ""}'),
            Text('Editorial: ${book.editorial ?? ""}'),
            Text('No. de Paginas: ${book.pagina ?? ""}'),
            Text('Edicion: ${book.edicion ?? ""}'),
            Text('ISBN: ${book.isbn ?? ""}'),
          ],
        ),
      ),
    );
  }
}
