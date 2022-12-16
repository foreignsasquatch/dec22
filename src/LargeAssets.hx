import rx.aseprite.Loader;

class LargeAssets {
  public static var bg:Rl.Texture;
  public static var bg_b:Rl.Texture;

  public static function load() {
    bg = Loader.loadTexture("res/bg.aseprite");
    bg_b = Loader.loadTexture("res/bg_b.aseprite");
  }
}