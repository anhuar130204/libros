class Book {
  int? controlNum;
  String? titulo;
  String? autor;
  String? editorial;
  String? pagina;
  String? edicion;
  String? isbn;
  String? photoName;

  Book({
    this.controlNum,
    this.titulo,
    this.autor,
    this.editorial,
    this.pagina,
    this.edicion,
    this.isbn,
    this.photoName,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'controlNum': controlNum,
      'titulo': titulo,
      'autor': autor,
      'editorial': editorial,
      'pagina': pagina,
      'edicion': edicion,
      'isbn': isbn,
      'photo_name': photoName,
    };
    return map;
  }

  Book.formMap(Map<String, dynamic> map) {
    controlNum = map['controlNum'];
    titulo = map['titulo'];
    autor = map['autor'];
    editorial = map['editorial'];
    pagina = map['pagina'];
    edicion = map['edicion'];
    isbn = map['isbn'];
    photoName = map['photo_name'];
  }
}
