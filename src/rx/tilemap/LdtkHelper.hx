package rx.tilemap;

class LdtkHelper {
  public static inline function drawTilemap(layer:ldtk.Layer_Tiles, tilesetTexture:Rl.Texture, tileset:ldtk.Tileset, sizeX:Int, sizeY:Int):Void {
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
}