import '../models/categoria.dart';
import '../models/menu.dart';

/// Menú de ejemplo de la semana: siete días con platos distintos, con opciones
/// vegetarianas y veganas. Es de consulta; los ingredientes se pasan a la
/// lista de la compra.
class MenuSemanal {
  static const _lentejas = Ingrediente(
    'Lentejas',
    Categoria.despensa,
    '1 kg',
    4,
  );
  static const _garbanzos = Ingrediente(
    'Garbanzos',
    Categoria.despensa,
    '1 kg',
    4,
  );
  static const _arroz = Ingrediente('Arroz', Categoria.despensa, '1 kg', 5);
  static const _pasta = Ingrediente('Pasta', Categoria.despensa, '500 g', 2);
  static const _fideos = Ingrediente('Fideos', Categoria.despensa, '250 g', 2);
  static const _atun = Ingrediente(
    'Atún en lata',
    Categoria.despensa,
    'pack de 3',
    3,
  );
  static const _zanahorias = Ingrediente(
    'Zanahorias',
    Categoria.frutasVerduras,
    '1 kg',
    4,
  );
  static const _cebollas = Ingrediente(
    'Cebollas',
    Categoria.frutasVerduras,
    '1 kg',
    5,
  );
  static const _patatas = Ingrediente(
    'Patatas',
    Categoria.frutasVerduras,
    '2 kg',
    4,
  );
  static const _tomates = Ingrediente(
    'Tomates',
    Categoria.frutasVerduras,
    '1 kg',
    3,
  );
  static const _lechuga = Ingrediente(
    'Lechuga',
    Categoria.frutasVerduras,
    '1 unidad',
    2,
  );
  static const _calabacin = Ingrediente(
    'Calabacín',
    Categoria.frutasVerduras,
    '1 kg',
    2,
  );
  static const _espinacas = Ingrediente(
    'Espinacas',
    Categoria.frutasVerduras,
    'bolsa de 300 g',
    2,
  );
  static const _verduras = Ingrediente(
    'Verduras variadas',
    Categoria.frutasVerduras,
    '1 kg',
    3,
  );
  static const _pollo = Ingrediente(
    'Pollo',
    Categoria.proteinas,
    '1 kg',
    2,
  );
  static const _merluza = Ingrediente(
    'Merluza',
    Categoria.proteinas,
    '500 g',
    1,
  );
  static const _salmon = Ingrediente(
    'Salmón',
    Categoria.proteinas,
    '400 g',
    1,
  );
  static const _huevos = Ingrediente(
    'Huevos',
    Categoria.proteinas,
    'docena',
    4,
  );
  static const _tofu = Ingrediente('Tofu', Categoria.proteinas, '400 g', 2);
  static const _hamburguesasVeg = Ingrediente(
    'Hamburguesas vegetales',
    Categoria.proteinas,
    'pack de 4',
    2,
  );
  static const _queso = Ingrediente('Queso', Categoria.lacteos, '250 g', 3);
  static const _pan = Ingrediente('Pan', Categoria.panaderia, '1 barra', 1);
  static const _panMolde = Ingrediente(
    'Pan de molde',
    Categoria.panaderia,
    '1 paquete',
    4,
  );

  static const dias = <DiaMenu>[
    DiaMenu(
      'Lunes',
      Plato('Lentejas con verduras', [_lentejas, _zanahorias, _cebollas, _patatas]),
      Plato('Tortilla de patatas con ensalada', [_huevos, _patatas, _lechuga, _tomates]),
    ),
    DiaMenu(
      'Martes',
      Plato('Pasta con tomate y tofu (vegana)', [_pasta, _tomates, _tofu, _cebollas]),
      Plato('Crema de calabacín con pan', [_calabacin, _patatas, _cebollas, _pan]),
    ),
    DiaMenu(
      'Miércoles',
      Plato('Pollo al horno con patatas', [_pollo, _patatas, _cebollas]),
      Plato('Ensalada de pasta con atún', [_pasta, _atun, _tomates, _lechuga]),
    ),
    DiaMenu(
      'Jueves',
      Plato('Lentejas estofadas', [_lentejas, _zanahorias, _cebollas]),
      Plato('Merluza con verduras', [_merluza, _verduras, _patatas]),
    ),
    DiaMenu(
      'Viernes',
      Plato('Arroz con verduras y huevo', [_arroz, _verduras, _huevos]),
      Plato('Hamburguesas vegetales con ensalada', [_hamburguesasVeg, _lechuga, _tomates, _panMolde]),
    ),
    DiaMenu(
      'Sábado',
      Plato('Garbanzos con espinacas (vegano)', [_garbanzos, _espinacas, _cebollas]),
      Plato('Sándwich de queso y tomate', [_panMolde, _queso, _tomates]),
    ),
    DiaMenu(
      'Domingo',
      Plato('Salmón al horno con patatas', [_salmon, _patatas, _verduras]),
      Plato('Sopa de verduras con fideos', [_fideos, _verduras, _zanahorias, _cebollas]),
    ),
  ];

  /// Lo que hay que comprar para los días elegidos. Cada ingrediente cuenta
  /// una vez por día, y se compran los formatos que hagan falta: si 1 kg de
  /// lentejas rinde cuatro días y se usan dos días, basta un paquete.
  static List<LineaCompra> compra(List<DiaMenu> elegidos) {
    final porIngrediente = <Ingrediente, List<String>>{};
    for (final dia in elegidos) {
      for (final ingrediente in dia.ingredientes) {
        final usados = porIngrediente.putIfAbsent(ingrediente, () => []);
        final nombreDia = dia.dia.toLowerCase();
        if (!usados.contains(nombreDia)) usados.add(nombreDia);
      }
    }
    final lineas = [
      for (final entrada in porIngrediente.entries)
        LineaCompra(
          entrada.key,
          (entrada.value.length / entrada.key.rindeDias).ceil(),
          entrada.value,
        ),
    ];
    lineas.sort((a, b) {
      final porSeccion = a.ingrediente.categoria.index.compareTo(
        b.ingrediente.categoria.index,
      );
      return porSeccion != 0
          ? porSeccion
          : a.ingrediente.nombre.compareTo(b.ingrediente.nombre);
    });
    return lineas;
  }
}
