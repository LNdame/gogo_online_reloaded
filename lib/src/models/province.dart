class Province{
  String name;
  bool selected;

  Province({this.name, this.selected});

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(dynamic other) {
    return other.name == this.name;
  }
}