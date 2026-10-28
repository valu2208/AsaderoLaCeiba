// Días de la semana: se guardan así en la base de datos (sin tildes)
const List<String> diasSemana = [
  'lunes',
  'martes',
  'miercoles',
  'jueves',
  'viernes',
  'sabado',
  'domingo',
];

// Nombre para mostrar en pantalla
const Map<String, String> nombresDias = {
  'lunes': 'Lunes',
  'martes': 'Martes',
  'miercoles': 'Miércoles',
  'jueves': 'Jueves',
  'viernes': 'Viernes',
  'sabado': 'Sábado',
  'domingo': 'Domingo',
};

// El día de hoy, en el formato de la base de datos
String diaDeHoy() => diasSemana[DateTime.now().weekday - 1];