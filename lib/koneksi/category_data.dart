class BoxData {
  final String text;
  final String parameter;
  final String imagePath;

  BoxData(this.text, this.parameter, this.imagePath);
}

List<BoxData> boxes = [
  BoxData("Funny", "funny", "lib/wallpapers/game.jpg"),
  BoxData("Anime", "anime", "lib/wallpapers/anime.jpg"),
  BoxData("Nature", "nature", "lib/wallpapers/nature.jpg"),
  BoxData("Music", "music", "lib/wallpapers/music.jpeg"),
];
