
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/producto.dart';
import 'dart:io';

class ProductoService extends ChangeNotifier {
  final String _baseUrl = "productos-jarg-default-rtdb.firebaseio.com";

  final List<Producto> productos = [];

  bool isLoading = true;
  bool isSaving = false;
  Producto? productoSeleccionado;
  File? newPictureFile;
  
  notifyListeners();


  //constructor
  ProductoService() {
    this.obtenerProductos();

    
  }


  //método que obtiene elos productos  los productos de la BD

  Future obtenerProductos() async {
    final url = Uri.https(_baseUrl, "productos.json");
    final resp = await http.get(url);

    final Map<String,dynamic> productosMap = json.decode(resp.body);
    //print(productosMap);

    productosMap.forEach((key, value) {
      final productoTemp = Producto.fromMap(value);
      productoTemp.id = key;
      this.productos.add(productoTemp);
    });

    this.isLoading = false;
    notifyListeners();

    // print(this.productos[0].nombre);
    return this.productos;
  }

  //método para actualizar un producto en la BD
  Future<String> updateProducto(Producto producto) async{
      final url = Uri.https(_baseUrl,"productos/${producto.id}.json");

      final resp = await http.put(url,body: producto.toJson());

      final decodedData = resp.body;
      // print(decodedData);
      //actualizamos el listado de productos
      final index = this.productos.indexWhere((element) => element.id == producto.id);
      this.productos[index] = producto;

      return producto.id!;
  }


  //método para crear o actualizar un producto
  Future saveOrCreateProducto(Producto producto) async {
    isSaving = true;
    notifyListeners();
    if (producto.id == null) {
      //producto nuevo
      await this.createProducto(producto);
    }else {
      //actualizar
      await this.updateProducto(producto);
    }

    isSaving = false;
    notifyListeners();
  }

  //método para crear un producto nuevo
  Future<String> createProducto(Producto producto) async {
    final url = Uri.https(_baseUrl,"productos.json");
    final resp = await http.post(url,body: producto.toJson());
    final decodedData = json.decode(resp.body);
    // print(decodedData["name"]);
    producto.id = decodedData["name"];
    this.productos.add(producto);
    return producto.id!;
  }

  void updateImagen(String path) {
    this.productoSeleccionado!.imagen = path;
    this.newPictureFile = File.fromUri(Uri(path:path));
    notifyListeners();
  }

  //método que sube la imagen a cloduinary
  Future<String?> uploadImage() async{
    if (this.newPictureFile == null) return null;
    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dhs1e64wc/image/upload?upload_preset=pt0gnjtd');
    final imageUploadRequest = http.MultipartRequest('POST',url);
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    //print(resp.body);
    //validamos que obtengamos una respuesta satisfactoria
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print("Error en la petición");
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}