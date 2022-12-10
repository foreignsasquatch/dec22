import ldtk.Layer_Tiles;

class Entity {
    public var sprite:Rl.Texture;

    public var cx:Int;
    public var cy:Int;
    public var xr:Float;
    public var yr:Float;

    public var xx:Float;
    public var yy:Float;

    // Velocity
    public var dx:Float;
    public var dy:Float;

    public var map:ldtk.Layer_Tiles;
    public var onFloor = false;

    public function new(m:ldtk.Layer_Tiles) {
        map = m;
    }

    public function update() {
        xr += dx;
        dx *= 0.8;

        if(map.isCoordValid(cx + 1, cy) && map.hasAnyTileAt(cx + 1, cy) && xr >= 0) {
            xr = 0;
            dx = 0;
        }

        if(map.isCoordValid(cx - 1, cy) && map.hasAnyTileAt(cx - 1, cy) && xr <= 0) {
            xr = 0;
            dx = 0;
        }

        while(xr > 1) {
            xr--; cx++;
        }
        while(xr < 0) {
            xr++; cx--;
        }

        yr += dy;
        dy *= 0.98;

        // Ceiling
        if(map.isCoordValid(cx, cy - 1) && map.hasAnyTileAt(cx, cy - 1) && yr <= 0) {
            yr = 0;
            dy = 0;
        }

        // Floor
        if(map.isCoordValid(cx, cy + 1) && map.hasAnyTileAt(cx, cy + 1) && yr >= 0) {
            yr = 0;
            dy = 0;

            onFloor = true;
        } else {
            onFloor = false;
        }

        while(yr > 1) {
            yr--; cy++;
        }
        while(yr < 0) {
            yr++; cy--;
        }

        xx = (cx + xr) * 16;
        yy = (cy + yr) * 16;
    }

    public function draw() {
        Rl.drawTextureV(sprite, Rl.Vector2.create(xx, yy), Rl.Colors.WHITE);
    }

    public function setCoords(x, y) {
        xx = x;
        yy = y;
        cx = Std.int(xx / 16);
        cy = Std.int(yy / 16);
        xr = (xx - cx * 16) / 16;
        yr = (yy - cy * 16) / 16;
    }
}
