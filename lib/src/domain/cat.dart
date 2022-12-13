class Cat {
  final int id;
  final String name;
  final String description;
  final String place;
  final int reward;
  final String userId;
  final int date;
  final String? pictureUrl;

  const Cat({
    required this.id,
    required this.name,
    required this.description,
    required this.place,
    required this.reward,
    required this.userId,
    required this.date,
    required this.pictureUrl
  });

  // Map toJson() =>{
  //
  // };

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      name: json['title'],
      description: json['price'],
      place: json['place'],
      reward: json['reward'],
      userId: json['userId'],
      date: json['date'],
      pictureUrl: json['pictureUrl']
    );
  }

  @override
  String toString() {
    return "ID:$id, Title:$name, Price:$description";
  }
}
