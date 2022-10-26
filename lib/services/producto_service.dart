
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/producto.dart';

class ProductoService extends ChangeNotifier {
  final String _baseUrl = "productos-jarg-default-rtdb.firebaseio.com";

  final List<Producto> productos = [];

  bool isLoading = true;
  bool isSaving = false;
  Producto? productoSeleccionado;

  
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

}