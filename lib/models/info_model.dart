class infoModel {
  String nama;
  String iconpath;
  bool boxIsSelected;

  infoModel(
      {required this.nama,
      required this.iconpath,
      required this.boxIsSelected});

  static List<infoModel> getinfoModel() {
    List<infoModel> fitur = [];

    fitur.add(infoModel(
      nama: 'pH Tanah',
      iconpath: 'assets/icons/information-icon-svgrepo-com.svg',
      boxIsSelected: true,
    ));

    fitur.add(infoModel(
      nama: 'Suhu Tanah',
      iconpath: 'assets/icons/information-icon-svgrepo-com.svg',
      boxIsSelected: true,
    ));

    fitur.add(infoModel(
      nama: 'Kelembapan Tanah',
      iconpath: 'assets/icons/information-icon-svgrepo-com.svg',
      boxIsSelected: true,
    ));

    fitur.add(infoModel(
      nama: 'Electronic Conductivity (EC)',
      iconpath: 'assets/icons/information-icon-svgrepo-com.svg',
      boxIsSelected: true,
    ));

    return fitur;
  }
}
