class Profile {
  final int id;
  final String name;
  final String address;
  final String birth;
  final int height;
  final int weight;
  final String photo;

  const Profile({
    required this.id,
    required this.name,
    required this.address,
    required this.birth,
    required this.height,
    required this.weight,
    required this.photo,
  });

  Profile.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        address = res["address"],
        birth = res["birth"],
        height = res["height"],
        weight = res["weight"],
        photo = res["photo"];

  Map<String, Object?> toMap() {
    return {
      'id':id,
      'name': name,
      'address': address,
      'birth': birth,
      'height': height,
      'weight': weight,
      'photo': photo,
      };
  }
  
}