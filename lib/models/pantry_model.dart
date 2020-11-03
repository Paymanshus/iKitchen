class Pantry {
  String itemName;
  String itemImg;
  int itemQty;
  String itemDesc;

  Pantry({
    this.itemName,
    this.itemImg,
    this.itemQty,
    this.itemDesc,
  });
}

List<Pantry> items = [
  Pantry(
    itemName: 'Tomato',
    itemImg: 'assets/tomato1.jpg',
    itemQty: 1,
    itemDesc: "Red vegetable, haters will say it's a fruit",
  ),
  Pantry(
    itemName: 'Potato',
    itemImg: 'assets/potato2.jpg',
    itemQty: 2,
    itemDesc: 'Mashed or Fried',
  ),
  Pantry(
    itemName: 'Onion',
    itemImg: 'assets/onion3.jpg',
    itemQty: 0,
    itemDesc: "Cut with care, pretty sad experience ",
  )
];
