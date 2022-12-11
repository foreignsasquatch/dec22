import en.Rocket;
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

  // levels
  // rocket level
  public var rocketLevel:Bool = true;
  public var rocketActive:Bool = false;
  public var rocket:Rocket;

  // testing

  public function init() {
    Rl.initWindow(1280, 720, "");
    Rl.setTargetFPS(60);

    world = new World();
    tilesetTexture = Aseprite.loadAsepriteToTexture("res/tileset.aseprite");

    playerA = new Player(world.all_levels.level_0.l_en.all_player[0].cx * 16, world.all_levels.level_0.l_en.all_player[0].cy * 16, "res/player_a.aseprite", {
      LEFT: Rl.Keys.LEFT,
      RIGHT: Rl.Keys.RIGHT,
      JUMP: Rl.Keys.UP,
      INTERACT: Rl.Keys.Z
    }, world.all_levels.level_0.l_fg);

    playerB = new Player(world.all_levels.level_0.l_en.all_player[1].cx * 16, world.all_levels.level_0.l_en.all_player[1].cy * 16, "res/player_b.aseprite", {
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

    // rocket level stuff
    rocket = new Rocket(world.all_levels.level_0.l_en.all_rocket[0].cx * 16, world.all_levels.level_0.l_en.all_rocket[0].cx * 16, world.all_levels.level_0.l_fg);
  }

  var hasTeleportedToRocket = false;
  public function update() {
    // rocket level updates
    if(rocketLevel) {
      if(world.all_levels.level_0.l_en.all_rocket[0].cx == playerA.cx && world.all_levels.level_0.l_en.all_rocket[0].cy == playerA.cy || world.all_levels.level_0.l_en.all_rocket[0].cx == playerB.cx && world.all_levels.level_0.l_en.all_rocket[0].cy == playerB.cy) {
        rocketActive = true;
      } else if(world.all_levels.level_0.l_en.all_rocket_end[0].cx == rocket.cx) {
        rocketActive = false;
        if(!hasTeleportedToRocket) {
          playerA.setCoords(rocket.xx, rocket.yy);
          playerB.setCoords(rocket.xx, rocket.yy);
          hasTeleportedToRocket = true;
        }
      }

      if(rocketActive) {
        rocket.update();
      }
    }
    // end

    playerA.update();
    playerB.update();
    updateCam();
  }

  public function updateCam() {
    playerACam.offset.x = (Rl.getScreenWidth() / 2) / 2;
    playerACam.offset.y = (Rl.getScreenHeight() / 2);

    playerBCam.offset.x = (Rl.getScreenWidth() / 2) / 2;
    playerBCam.offset.y = (Rl.getScreenHeight() / 2);

    if(!rocketActive) {
      playerACam.target = Rl.Vector2.create(playerA.xx, playerA.yy);
      playerBCam.target = Rl.Vector2.create(playerB.xx, playerB.yy);
    } else if(rocketActive) {
      playerACam.target = Rl.Vector2.create(rocket.xx, rocket.yy);
      playerBCam.target = Rl.Vector2.create(rocket.xx, rocket.yy);
    }
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
    if(!rocketActive) {
      playerA.draw();
      playerB.draw();
    } else if(rocketActive) {
      rocket.draw();
    }

    // rocket level stuff
    if(rocketLevel) {
      drawTilemap(world.all_levels.level_0.l_fg, tilesetTexture, world.all_tilesets.tileset, 16, 16);
    }
    // end
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
      if(rocketActive) Rl.drawText("Rocket active", 0, 0, 30, Rl.Colors.GREEN);
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
