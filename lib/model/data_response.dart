class Data{

  final String id;
  final String  category;
  final String name ;
  final String img_url;
  final String locality;


  Data({this.id,this.category,this.name,this.img_url,this.locality});


  factory Data.fromJson(Map<String, dynamic> json) {


    return Data(
        id: json['studio_id'],
        category: json['studio_category'],
        name: json['studio_name'],
        img_url: json['studio_logo'],
        locality: json['locality_name'],
    );
  }
}