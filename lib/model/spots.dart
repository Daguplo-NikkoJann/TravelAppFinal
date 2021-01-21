class Spots {
  final String name;
  final String address;
  final String image;
  final String rating;
  final String description;
  Spots({this.address, this.description, this.image, this.name, this.rating});
}

List<Spots> bestList = [
  Spots(
      name: "Palawan",
      address: "",
      description: "",
      image: "assets/palawan.jfif",
      rating: "4.9"),
  Spots(
    name: "Bohol",
    address: "",
    description: "",
    image: "assets/bohol.jpg",
    rating: "4.9",
  ),
  Spots(
    name: "Surigao",
    address: "",
    description: "",
    image: "assets/surigao.jpeg",
    rating: "4.9",
  ),
];
