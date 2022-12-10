import en.Player;

class Main {
  public var world:World;
  public var tilesetTexture:Rl.Texture;

  public var playerA:Player;
  public var playerB:Player;

  public var splitScreenRectangle:Rl.Rectangle;
  public var screenA:Rl.RenderTexture;
  public var screenB:Rl.RenderTexture;
  public var playerACam:Rl.Camera2D;
  public var playerBCam:Rl.Camera2D;

  public function init() {
    Rl.initWindow(1280, 720, "");
    Rl.setTargetFPS(60);

    world = new World();
    tilesetTexture = Aseprite.loadAsepriteToTexture("res/tileset.aseprite");

    playerA = new Player(0, 0, "res/player_a.aseprite", {
      LEFT: Rl.Keys.LEFT,
      RIGHT: Rl.Keys.RIGHT,
      JUMP: Rl.Keys.UP,
      INTERACT: Rl.Keys.Z
    }, world.all_levels.level_0.l_fg);

    playerB = new Player(0, 0, "res/player_b.aseprite", {
      LEFT: Rl.Keys.A,
      RIGHT: Rl.Keys.D,
      JUMP: Rl.Keys.W,
      INTERACT: Rl.Keys.SPACE
    }, world.all_levels.level_0.l_fg);

    splitScreenRectangle = Rl.Rectangle.create(0, 0, Rl.getScreenWidth() / 2, -Rl.getScreenHeight());
    screenA = Rl.loadRenderTexture(Std.int(Rl.getScreenWidth() / 2), Rl.getScreenHeight());
    screenB = Rl.loadRenderTexture(Std.int(Rl.getScreenWidth() / 2), Rl.getScreenHeight());
  
    playerACam = Rl.Camera2D.create(Rl.Vector2.create(0, 0), Rl.Vector2.create(playerA.xx, playerA.yy), 0, 2);
    playerBCam = Rl.Camera2D.create(Rl.Vector2.create(0, 0), Rl.Vector2.create(playerB.xx, playerB.yy), 0, 2);

    trace(world.all_levels.level_0.l_fg.json.gridTiles);
  }

  public function update() {
    playerA.update();
    playerB.update();
    updateCam();
  }

  public function updateCam() {
    playerACam.offset.x = (Rl.getScreenWidth() / 2) / 2;
    playerACam.offset.y = (Rl.getScreenHeight() / 2);
    playerACam.target = Rl.Vector2.create(playerA.xx, playerA.yy);

    playerBCam.offset.x = (Rl.getScreenWidth() / 2) / 2;
    playerBCam.offset.y = (Rl.getScreenHeight() / 2);
    playerBCam.target = Rl.Vector2.create(playerB.xx, playerB.yy);
  }

  public inline function drawTilemap(layer:ldtk.Layer_Tiles, tilesetTexture:Rl.Texture, tileset:ldtk.Tileset, sizeX:Int, sizeY:Int):Void {
    for(r in 0...layer.cHei) {
        for(c in 0...layer.cWid) {
            if(layer.hasAnyTileAt(c, r)) {
                var tileAtMapPos = layer.getTileStackAt(c, r);
                var tilesToDraw = tileAtMapPos[0];
                var x = c * sizeX;
                var y = r * sizeY;

                Rl.drawTextureRec(tilesetTexture, Rl.Rectangle.create(tileset.getAtlasX(tilesToDraw.tileId), tileset.getAtlasY(tilesToDraw.tileId), sizeX, sizeY), Rl.Vector2.create(x, y), Rl.Colors.WHITE);
            }
        }
    }
  }

  function d() {
    // playerA.draw();
    Rl.drawTextureV(playerA.sprite, Rl.Vector2.create(playerA.xx, playerA.yy), Rl.Colors.WHITE);
    // playerB.draw();
    Rl.drawTextureV(playerB.sprite, Rl.Vector2.create(playerB.xx, playerB.yy), Rl.Colors.WHITE);
    drawTilemap(world.all_levels.level_0.l_fg, tilesetTexture, world.all_tilesets.tileset, 16, 16);
  }

  // Things which must be draw twice
  public function draw() {
    // Player A view
    Rl.beginTextureMode(screenA);
    Rl.clearBackground(Rl.Colors.DARKBLUE);

    Rl.beginMode2D(playerACam);
    d();
    Rl.endMode2D();
    Rl.endTextureMode();

    // Player B view
    Rl.beginTextureMode(screenB);
    Rl.clearBackground(Rl.Colors.BLACK);

    Rl.beginMode2D(playerBCam);
    d();
    Rl.endMode2D();
    Rl.endTextureMode();

    Rl.beginDrawing();
    {
      Rl.clearBackground(Rl.Colors.DARKBLUE);
      Rl.drawTextureRec(screenA.texture, splitScreenRectangle, Rl.Vector2.zero(), Rl.Colors.WHITE);
      Rl.drawTextureRec(screenB.texture, splitScreenRectangle, Rl.Vector2.create(Rl.getScreenWidth() / 2, 0), Rl.Colors.WHITE);
    }
    Rl.endDrawing();
  }

  public function close() {
    Rl.unloadRenderTexture(screenA);
    Rl.unloadRenderTexture(screenB);

    Rl.closeWindow();
  }

  public function new() {
    init();
    var timeCounter = 0.0;
    var timeStep = 0.016;
    while (!Rl.windowShouldClose()) {
      // Update 60 times per second
      timeCounter += Rl.getFrameTime();
      while (timeCounter > timeStep) {
        update();
        timeCounter -= timeStep;
      }
      draw();
    }
    close();
  }

  static function main() {
    new Main();
  }
}
