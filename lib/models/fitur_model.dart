class fiturModel {
  String nama;
  String iconpath;
  bool boxIsSelected;

  fiturModel(
      {required this.nama,
      required this.iconpath,
      required this.boxIsSelected});

  static List<fiturModel> getfiturModel() {
    List<fiturModel> fitur = [];

    fitur.add(fiturModel(
      nama: 'Prakiraan Cuaca',
      iconpath: 'assets/icons/sunny_weather_icon_150663.svg',
      boxIsSelected: true,
    ));

    fitur.add(fiturModel(
      nama: 'Pengukuran Unsur Tanah',
      iconpath: 'assets/icons/if-advantage-eco-friendly-1034358_88853.svg',
      boxIsSelected: true,
    ));

    fitur.add(fiturModel(
      nama: 'Informasi Unsur Tanah',
      iconpath: 'assets/icons/information_77957.svg',
      boxIsSelected: true,
    ));

    return fitur;
  }
}
