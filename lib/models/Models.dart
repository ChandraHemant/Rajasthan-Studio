class Albums {
  String name = "";
  String subTitle = "";
  String img = "";
}

class ProTheme {
  String name;
  bool show_cover;
  List<ProTheme> sub_kits;
  String title_name;
  String type;
  String icon;
  bool is_theme;
  String tag;

  ProTheme(
      {this.name,
      this.icon,
      this.is_theme,
      this.tag,
      this.type,
      this.show_cover,
      this.sub_kits,
      this.title_name});

  factory ProTheme.fromJson(Map<String, dynamic> json) {
    return ProTheme(
      name: json['name'],
      icon: json['icon'],
      is_theme: json['is_theme'],
      tag: json['tag'],
      type: json['type'],
      show_cover: json['show_cover'],
      sub_kits: json['sub_kits'] != null
          ? (json['sub_kits'] as List).map((i) => ProTheme.fromJson(i)).toList()
          : null,
      title_name: json['title_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['show_cover'] = this.show_cover;
    data['title_name'] = this.title_name;
    data['type'] = this.type;
    if (this.sub_kits != null) {
      data['sub_kits'] = this.sub_kits.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
