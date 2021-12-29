extension ImagesExtension on String {
  String get assetPath => 'assets/images/$this';
  String get assetPathPNG => 'assets/images/$this.png';
}
