import 'package:material_ui/material_ui.dart' show IconData, Icons;

/// Secciones del supermercado, en el orden en que se suelen recorrer.
/// El orden de este enum es el orden en que se muestran en la lista.
/// Las sugerencias sirven para elegir rápido, pero siempre se puede escribir
/// otro producto a mano.
enum Categoria {
  frutasVerduras(
    'Frutas y verduras',
    Icons.eco_outlined,
    [
      'Manzanas',
      'Plátanos',
      'Naranjas',
      'Tomates',
      'Lechuga',
      'Zanahorias',
      'Patatas',
      'Cebollas',
    ],
  ),
  proteinas(
    'Proteínas',
    Icons.set_meal_outlined,
    [
      'Ternera',
      'Pollo',
      'Cerdo',
      'Pescado blanco',
      'Salmón',
      'Atún',
      'Gambas',
      'Huevos',
      'Tofu',
      'Tempeh',
      'Seitán',
      'Legumbres',
    ],
  ),
  lacteos(
    'Lácteos y alternativas',
    Icons.icecream_outlined,
    [
      'Leche',
      'Yogur',
      'Queso',
      'Mantequilla',
      'Bebida de avena',
      'Bebida de soja',
      'Yogur vegetal',
    ],
  ),
  panaderia(
    'Panadería',
    Icons.bakery_dining_outlined,
    ['Pan', 'Pan de molde', 'Galletas', 'Bollería'],
  ),
  despensa(
    'Despensa',
    Icons.kitchen_outlined,
    ['Arroz', 'Pasta', 'Aceite', 'Harina', 'Azúcar', 'Conservas', 'Cereales'],
  ),
  congelados(
    'Congelados',
    Icons.ac_unit_outlined,
    ['Verdura congelada', 'Pizza', 'Helado', 'Croquetas'],
  ),
  bebidas(
    'Bebidas',
    Icons.local_drink_outlined,
    ['Agua', 'Zumo', 'Refrescos', 'Café', 'Té'],
  ),
  limpieza(
    'Limpieza e higiene',
    Icons.cleaning_services_outlined,
    ['Detergente', 'Lavavajillas', 'Papel higiénico', 'Jabón', 'Champú'],
  ),
  otros('Otros', Icons.shopping_basket_outlined, []);

  const Categoria(this.etiqueta, this.icono, this.sugerencias);

  /// Nombre que se ve y que lee el lector de pantalla.
  final String etiqueta;

  /// Icono decorativo: el nombre siempre va escrito al lado.
  final IconData icono;

  /// Productos habituales de la sección, para añadirlos con un toque.
  final List<String> sugerencias;
}
