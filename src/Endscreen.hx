class Endscreen {
  public static function present(tex:Rl.Texture) {
    Rl.drawTextureEx(tex, Rl.Vector2.create(Rl.getScreenWidth() / 2, Rl.getScreenHeight() / 2), 0, 5, Rl.Colors.WHITE);
  }
}