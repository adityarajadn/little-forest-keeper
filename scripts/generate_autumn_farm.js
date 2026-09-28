// LibreSprite Script to draw Autumn Farm Tileset (192x192, 12x12 tiles of 16x16)
(function() {
  var col = app.pixelColor;
  var s = app.activeSprite;
  var img = app.activeImage;
  
  if (!s || !img || img.width !== 192 || img.height !== 192) {
    console.log("Image not 192x192! Current: " + (img ? img.width + "x" + img.height : "none"));
    return;
  }
  
  img.clear(col.rgba(0, 0, 0, 0));
  
  // ================= PALETTE =================
  var PAL = {
    // Autumn grass
    GRASS_BASE:   col.rgba(189, 128, 51, 255),  // warm amber grass
    GRASS_LIGHT:  col.rgba(217, 155, 68, 255),  // golden highlight
    GRASS_DARK:   col.rgba(148, 97, 36, 255),   // deep autumn shadow
    GRASS_LEAF1:  col.rgba(224, 86, 36, 255),   // red autumn leaf
    GRASS_LEAF2:  col.rgba(235, 178, 50, 255),  // yellow fallen leaf
    
    // Dirt / Path / Farmland
    DIRT_BASE:    col.rgba(142, 85, 46, 255),   // rich loam earth
    DIRT_LIGHT:   col.rgba(175, 112, 68, 255),  // dry soil pebble
    DIRT_DARK:    col.rgba(102, 57, 28, 255),   // furrow / damp ditch
    DIRT_EDGE:    col.rgba(118, 68, 33, 255),
    
    // Stone & Cobblestone Path
    STONE_BASE:   col.rgba(145, 138, 128, 255),
    STONE_LIGHT:  col.rgba(182, 175, 165, 255),
    STONE_DARK:   col.rgba(105, 99, 91, 255),
    STONE_MORTAR: col.rgba(76, 70, 63, 255),
    
    // Red Barn Wood
    BARN_BASE:    col.rgba(168, 48, 38, 255),   // rustic barn red
    BARN_LIGHT:   col.rgba(199, 74, 62, 255),   // sunlit barn red
    BARN_DARK:    col.rgba(122, 30, 24, 255),   // plank shadow
    BARN_LINE:    col.rgba(86, 18, 14, 255),    // plank groove
    
    // White Wood / Trim / Farmhouse
    WHITE_BASE:   col.rgba(235, 230, 218, 255),
    WHITE_LIGHT:  col.rgba(252, 248, 240, 255),
    WHITE_DARK:   col.rgba(194, 186, 170, 255),
    WHITE_SHAD:   col.rgba(152, 142, 126, 255),
    
    // Roof Tiles (Terracotta & Shingle)
    ROOF_BASE:    col.rgba(184, 80, 48, 255),
    ROOF_LIGHT:   col.rgba(214, 112, 75, 255),
    ROOF_DARK:    col.rgba(138, 54, 30, 255),
    ROOF_EDGE:    col.rgba(95, 34, 16, 255),
    
    // Wooden Planks / Logs / Fences / Cart
    WOOD_BASE:    col.rgba(160, 106, 58, 255),
    WOOD_LIGHT:   col.rgba(195, 136, 82, 255),
    WOOD_DARK:    col.rgba(118, 73, 34, 255),
    WOOD_EDGE:    col.rgba(82, 48, 20, 255),
    
    // Glass & Windows
    GLASS_BASE:   col.rgba(142, 192, 214, 255),
    GLASS_LIGHT:  col.rgba(215, 240, 252, 255),
    GLASS_FRAME:  col.rgba(240, 235, 222, 255),
    
    // Hay / Straw
    HAY_BASE:     col.rgba(226, 172, 60, 255),
    HAY_LIGHT:    col.rgba(248, 208, 98, 255),
    HAY_DARK:     col.rgba(184, 132, 34, 255),
    HAY_TIE:      col.rgba(138, 92, 20, 255),
    
    // Crops & Pumpkins
    PUMPKIN_BASE: col.rgba(235, 94, 22, 255),
    PUMPKIN_L:    col.rgba(252, 132, 54, 255),
    PUMPKIN_D:    col.rgba(180, 62, 10, 255),
    STEM_GREEN:   col.rgba(76, 115, 48, 255),
    
    // Shadows & Outlines
    SHADOW:       col.rgba(40, 24, 12, 120),
    BLACK:        col.rgba(30, 20, 16, 255)
  };
  
  function setP(gx, gy, c) {
    if (gx >= 0 && gx < 192 && gy >= 0 && gy < 192) {
      img.putPixel(gx, gy, c);
    }
  }
  
  function fillTile(tx, ty, c) {
    var ox = tx * 16;
    var oy = ty * 16;
    for (var y = 0; y < 16; y++) {
      for (var x = 0; x < 16; x++) {
        setP(ox + x, oy + y, c);
      }
    }
  }

  // -------------------------------------------------------------
  // ROW 0: AUTUMN GRASS & PATH TERRAINS
  // -------------------------------------------------------------
  // (0,0): Pure Autumn Meadow Grass
  fillTile(0, 0, PAL.GRASS_BASE);
  // Grass blades & golden hues
  setP(0*16+3, 4, PAL.GRASS_LIGHT); setP(0*16+3, 3, PAL.GRASS_LIGHT);
  setP(0*16+8, 7, PAL.GRASS_LIGHT); setP(0*16+9, 6, PAL.GRASS_LIGHT);
  setP(0*16+13, 11, PAL.GRASS_LIGHT); setP(0*16+12, 12, PAL.GRASS_LIGHT);
  setP(0*16+5, 13, PAL.GRASS_DARK); setP(0*16+11, 2, PAL.GRASS_DARK);
  // Fallen tiny leaf
  setP(0*16+6, 8, PAL.GRASS_LEAF1); setP(0*16+7, 8, PAL.GRASS_LEAF1);
  setP(0*16+2, 11, PAL.GRASS_LEAF2);

  // (1,0): Autumn Grass with Flowers & Leaves
  fillTile(1, 0, PAL.GRASS_BASE);
  setP(1*16+4, 4, PAL.GRASS_LEAF1); setP(1*16+5, 4, PAL.GRASS_LEAF1); setP(1*16+4, 5, PAL.GRASS_DARK);
  setP(1*16+11, 6, PAL.GRASS_LEAF2); setP(1*16+12, 5, PAL.GRASS_LEAF2);
  setP(1*16+7, 12, PAL.PUMPKIN_L); setP(1*16+8, 12, PAL.PUMPKIN_BASE); setP(1*16+8, 13, PAL.STEM_GREEN);
  setP(1*16+2, 8, PAL.GRASS_LIGHT); setP(1*16+14, 13, PAL.GRASS_LIGHT);

  // (2,0): Farmland Soil (Tilled / Furrowed)
  fillTile(2, 0, PAL.DIRT_BASE);
  for (var r = 0; r < 4; r++) {
    var fy = r * 4 + 1;
    for (var x = 0; x < 16; x++) {
      setP(2*16+x, fy, PAL.DIRT_DARK);
      setP(2*16+x, fy + 1, PAL.DIRT_BASE);
      setP(2*16+x, fy + 2, PAL.DIRT_LIGHT);
    }
  }

  // (3,0): Farmland Moist / Planted Sprouts
  fillTile(3, 0, PAL.DIRT_DARK);
  for (var r = 0; r < 3; r++) {
    var fy = r * 5 + 2;
    for (var x = 0; x < 16; x++) {
      setP(3*16+x, fy + 1, PAL.DIRT_BASE);
    }
    // Tiny autumn crop sprouts
    setP(3*16+4, fy, PAL.STEM_GREEN); setP(3*16+3, fy-1, PAL.STEM_GREEN);
    setP(3*16+11, fy, PAL.STEM_GREEN); setP(3*16+12, fy-1, PAL.STEM_GREEN);
  }

  // (4,0) to (8,0): Dirt Path transitions
  // (4,0): Dirt Path Full Center
  fillTile(4, 0, PAL.DIRT_BASE);
  setP(4*16+3, 3, PAL.DIRT_LIGHT); setP(4*16+4, 3, PAL.DIRT_LIGHT); setP(4*16+3, 4, PAL.DIRT_DARK);
  setP(4*16+9, 8, PAL.DIRT_LIGHT); setP(4*16+10, 8, PAL.DIRT_LIGHT); setP(4*16+10, 9, PAL.DIRT_DARK);
  setP(4*16+6, 12, PAL.DIRT_LIGHT); setP(4*16+13, 4, PAL.DIRT_DARK);

  // (5,0): Path Straight Horizontal
  fillTile(5, 0, PAL.GRASS_BASE);
  for (var y = 3; y <= 12; y++) {
    for (var x = 0; x < 16; x++) {
      setP(5*16+x, y, PAL.DIRT_BASE);
    }
    setP(5*16+((y*5)%16), y, PAL.DIRT_LIGHT);
  }
  for (var x = 0; x < 16; x++) {
    setP(5*16+x, 2, (x%2===0)?PAL.GRASS_LIGHT:PAL.DIRT_EDGE);
    setP(5*16+x, 13, (x%3===0)?PAL.GRASS_DARK:PAL.DIRT_EDGE);
  }

  // (6,0): Path Straight Vertical
  fillTile(6, 0, PAL.GRASS_BASE);
  for (var x = 3; x <= 12; x++) {
    for (var y = 0; y < 16; y++) {
      setP(6*16+x, y, PAL.DIRT_BASE);
    }
    setP(6*16+x, (x*7)%16, PAL.DIRT_LIGHT);
  }
  for (var y = 0; y < 16; y++) {
    setP(6*16+2, y, (y%2===0)?PAL.GRASS_LIGHT:PAL.DIRT_EDGE);
    setP(6*16+13, y, (y%3===0)?PAL.GRASS_DARK:PAL.DIRT_EDGE);
  }

  // (7,0): Cobblestone Path Center
  fillTile(7, 0, PAL.STONE_MORTAR);
  var stones = [
    [1,1,5,4], [7,1,4,3], [12,1,3,4],
    [1,6,4,4], [6,5,5,4], [12,6,3,4],
    [2,11,4,4], [7,10,4,5], [12,11,3,4]
  ];
  for (var sIdx = 0; sIdx < stones.length; sIdx++) {
    var st = stones[sIdx];
    var sx = st[0], sy = st[1], sw = st[2], sh = st[3];
    for (var iy = sy; iy < sy + sh; iy++) {
      for (var ix = sx; ix < sx + sw; ix++) {
        setP(7*16+ix, iy, PAL.STONE_BASE);
      }
    }
    for (var ix = sx; ix < sx + sw - 1; ix++) setP(7*16+ix, sy, PAL.STONE_LIGHT);
    for (var iy = sy; iy < sy + sh; iy++) setP(7*16+sx+sw-1, iy, PAL.STONE_DARK);
    for (var ix = sx; ix < sx + sw; ix++) setP(7*16+ix, sy+sh-1, PAL.STONE_DARK);
  }

  // (8,0): Cobblestone & Grass Edge
  fillTile(8, 0, PAL.GRASS_BASE);
  for (var y = 4; y <= 11; y++) {
    for (var x = 4; x <= 11; x++) {
      setP(8*16+x, y, PAL.STONE_BASE);
    }
  }
  setP(8*16+5, 5, PAL.STONE_LIGHT); setP(8*16+9, 5, PAL.STONE_LIGHT);
  setP(8*16+7, 9, PAL.STONE_DARK); setP(8*16+10, 10, PAL.STONE_DARK);
  setP(8*16+2, 3, PAL.GRASS_LEAF1); setP(8*16+13, 12, PAL.GRASS_LEAF2);

  // (9,0) & (10,0): Water Well / Pond Edge
  fillTile(9, 0, PAL.GRASS_BASE);
  for (var y = 3; y <= 12; y++) {
    for (var x = 3; x <= 12; x++) {
      setP(9*16+x, y, col.rgba(56, 140, 180, 255));
    }
  }
  for (var x = 4; x <= 11; x++) {
    setP(9*16+x, 3, PAL.STONE_BASE);
    setP(9*16+x, 12, PAL.STONE_DARK);
  }
  for (var y = 4; y <= 11; y++) {
    setP(9*16+3, y, PAL.STONE_BASE);
    setP(9*16+12, y, PAL.STONE_DARK);
  }
  setP(9*16+6, 6, col.rgba(125, 200, 235, 255)); // water shimmer

  // (10,0) & (11,0): Stepping stones & Path turn
  fillTile(10, 0, PAL.GRASS_BASE);
  // Curved path corner (Top to Right)
  for (var y = 3; y <= 12; y++) {
    for (var x = 3; x <= 15; x++) {
      if ((x-3)*(x-3) + (y-3)*(y-3) <= 12*12) {
        setP(10*16+x, y, PAL.DIRT_BASE);
      }
    }
  }

  // -------------------------------------------------------------
  // ROW 1: WOODEN FENCES, GATES, BARRELS, HEDGE
  // -------------------------------------------------------------
  // (0,1): Wooden Fence Post
  fillTile(0, 1, col.rgba(0,0,0,0));
  for (var y = 2; y <= 14; y++) {
    setP(0*16+7, y, PAL.WOOD_LIGHT);
    setP(0*16+8, y, PAL.WOOD_BASE);
    setP(0*16+9, y, PAL.WOOD_DARK);
  }
  setP(0*16+8, 1, PAL.WOOD_LIGHT);
  setP(0*16+7, 15, PAL.SHADOW); setP(0*16+8, 15, PAL.SHADOW); setP(0*16+9, 15, PAL.SHADOW);

  // (1,1): Horizontal Wooden Fence
  fillTile(1, 1, col.rgba(0,0,0,0));
  // 2 rails
  for (var x = 0; x < 16; x++) {
    setP(1*16+x, 5, PAL.WOOD_LIGHT);
    setP(1*16+x, 6, PAL.WOOD_BASE);
    setP(1*16+x, 7, PAL.WOOD_DARK);
    
    setP(1*16+x, 10, PAL.WOOD_LIGHT);
    setP(1*16+x, 11, PAL.WOOD_BASE);
    setP(1*16+x, 12, PAL.WOOD_DARK);
  }
  // Center post
  for (var y = 3; y <= 14; y++) {
    setP(1*16+7, y, PAL.WOOD_LIGHT);
    setP(1*16+8, y, PAL.WOOD_BASE);
    setP(1*16+9, y, PAL.WOOD_DARK);
  }

  // (2,1): Vertical Wooden Fence
  fillTile(2, 1, col.rgba(0,0,0,0));
  for (var y = 0; y < 16; y++) {
    setP(2*16+7, y, PAL.WOOD_LIGHT);
    setP(2*16+8, y, PAL.WOOD_BASE);
    setP(2*16+9, y, PAL.WOOD_DARK);
  }
  // Rail stubs
  for (var y = 4; y <= 6; y++) {
    setP(2*16+5, y, PAL.WOOD_BASE); setP(2*16+6, y, PAL.WOOD_BASE);
  }
  for (var y = 10; y <= 12; y++) {
    setP(2*16+5, y, PAL.WOOD_BASE); setP(2*16+6, y, PAL.WOOD_BASE);
  }

  // (3,1): Fence Gate
  fillTile(3, 1, col.rgba(0,0,0,0));
  for (var y = 3; y <= 14; y++) {
    setP(3*16+2, y, PAL.WOOD_BASE); setP(3*16+13, y, PAL.WOOD_BASE);
  }
  for (var x = 3; x <= 12; x++) {
    setP(3*16+x, 5, PAL.WHITE_LIGHT);
    setP(3*16+x, 6, PAL.WHITE_BASE);
    setP(3*16+x, 11, PAL.WHITE_LIGHT);
    setP(3*16+x, 12, PAL.WHITE_BASE);
  }
  // Diagonal cross
  for (var i = 0; i <= 6; i++) {
    setP(3*16+4+i, 6+i, PAL.WHITE_LIGHT);
  }

  // (4,1): Wooden Barrel
  fillTile(4, 1, col.rgba(0,0,0,0));
  for (var y = 3; y <= 13; y++) {
    for (var x = 3; x <= 12; x++) {
      setP(4*16+x, y, PAL.WOOD_BASE);
    }
  }
  for (var y = 4; y <= 12; y++) {
    setP(4*16+2, y, PAL.WOOD_DARK);
    setP(4*16+13, y, PAL.WOOD_DARK);
  }
  // Iron bands
  for (var x = 2; x <= 13; x++) {
    setP(4*16+x, 5, PAL.STONE_DARK);
    setP(4*16+x, 11, PAL.STONE_DARK);
  }
  // Highlights
  for (var y = 4; y <= 12; y++) setP(4*16+5, y, PAL.WOOD_LIGHT);
  // Bottom shadow
  for (var x = 3; x <= 12; x++) setP(4*16+x, 14, PAL.SHADOW);

  // (5,1): Hay Bale (Round/Stack)
  fillTile(5, 1, col.rgba(0,0,0,0));
  for (var y = 4; y <= 13; y++) {
    for (var x = 2; x <= 13; x++) {
      setP(5*16+x, y, PAL.HAY_BASE);
    }
  }
  // Hay strands
  for (var y = 4; y <= 13; y += 2) {
    for (var x = 3; x <= 12; x += 3) {
      setP(5*16+x, y, PAL.HAY_LIGHT);
    }
  }
  // Binding ropes
  for (var y = 4; y <= 13; y++) {
    setP(5*16+5, y, PAL.HAY_TIE);
    setP(5*16+10, y, PAL.HAY_TIE);
  }
  for (var x = 2; x <= 13; x++) setP(5*16+x, 14, PAL.SHADOW);

  // (6,1): Pumpkin Patch (Single / Double Autumn Pumpkins)
  fillTile(6, 1, col.rgba(0,0,0,0));
  // Big pumpkin
  for (var y = 6; y <= 13; y++) {
    for (var x = 2; x <= 10; x++) {
      setP(6*16+x, y, PAL.PUMPKIN_BASE);
    }
  }
  // Ribs & highlights
  for (var y = 7; y <= 12; y++) {
    setP(6*16+4, y, PAL.PUMPKIN_L);
    setP(6*16+7, y, PAL.PUMPKIN_D);
    setP(6*16+8, y, PAL.PUMPKIN_L);
  }
  // Stem
  setP(6*16+6, 5, PAL.STEM_GREEN);
  setP(6*16+7, 4, PAL.STEM_GREEN);
  // Small pumpkin beside
  for (var y = 9; y <= 13; y++) {
    for (var x = 11; x <= 14; x++) {
      setP(6*16+x, y, PAL.PUMPKIN_BASE);
    }
  }
  setP(6*16+12, 10, PAL.PUMPKIN_L); setP(6*16+13, 8, PAL.STEM_GREEN);
  for (var x = 2; x <= 14; x++) setP(6*16+x, 14, PAL.SHADOW);

  // (7,1): Autumn Bush / Shrub (Golden orange)
  fillTile(7, 1, col.rgba(0,0,0,0));
  for (var y = 4; y <= 13; y++) {
    for (var x = 2; x <= 13; x++) {
      setP(7*16+x, y, PAL.GRASS_LEAF2);
    }
  }
  for (var y = 3; y <= 11; y++) {
    for (var x = 4; x <= 11; x++) {
      setP(7*16+x, y, PAL.PUMPKIN_L);
    }
  }
  setP(7*16+6, 5, PAL.HAY_LIGHT); setP(7*16+7, 5, PAL.HAY_LIGHT);
  setP(7*16+8, 9, PAL.GRASS_LEAF1); setP(7*16+9, 9, PAL.GRASS_LEAF1);
  for (var x = 3; x <= 12; x++) setP(7*16+x, 14, PAL.SHADOW);

  // (8,1): Wooden Crate with Apples/Crops
  fillTile(8, 1, col.rgba(0,0,0,0));
  for (var y = 5; y <= 13; y++) {
    for (var x = 2; x <= 13; x++) {
      setP(8*16+x, y, PAL.WOOD_BASE);
    }
  }
  // Planks
  for (var x = 2; x <= 13; x++) {
    setP(8*16+x, 5, PAL.WOOD_LIGHT);
    setP(8*16+x, 9, PAL.WOOD_DARK);
    setP(8*16+x, 13, PAL.WOOD_DARK);
  }
  for (var y = 5; y <= 13; y++) {
    setP(8*16+2, y, PAL.WOOD_EDGE);
    setP(8*16+13, y, PAL.WOOD_EDGE);
  }
  // Red autumn apples overflowing
  setP(8*16+5, 4, PAL.BARN_LIGHT); setP(8*16+6, 4, PAL.BARN_LIGHT);
  setP(8*16+8, 4, PAL.PUMPKIN_L); setP(8*16+9, 4, PAL.PUMPKIN_L);
  setP(8*16+10, 4, PAL.BARN_LIGHT);
  for (var x = 3; x <= 12; x++) setP(8*16+x, 14, PAL.SHADOW);

  // (9,1): Farm Water Trough
  fillTile(9, 1, col.rgba(0,0,0,0));
  for (var y = 5; y <= 12; y++) {
    for (var x = 1; x <= 14; x++) {
      setP(9*16+x, y, PAL.WOOD_BASE);
    }
  }
  // Inside water
  for (var y = 6; y <= 10; y++) {
    for (var x = 2; x <= 13; x++) {
      setP(9*16+x, y, col.rgba(45, 130, 180, 255));
    }
  }
  for (var x = 3; x <= 12; x++) setP(9*16+x, 7, col.rgba(110, 195, 235, 255)); // water surface highlight
  // Legs
  setP(9*16+2, 13, PAL.WOOD_DARK); setP(9*16+3, 13, PAL.WOOD_DARK);
  setP(9*16+12, 13, PAL.WOOD_DARK); setP(9*16+13, 13, PAL.WOOD_DARK);

  // (10,1): Flower Pot / Planter Box
  fillTile(10, 1, col.rgba(0,0,0,0));
  for (var y = 8; y <= 13; y++) {
    for (var x = 3; x <= 12; x++) {
      setP(10*16+x, y, PAL.ROOF_BASE);
    }
  }
  for (var x = 2; x <= 13; x++) setP(10*16+x, 8, PAL.ROOF_LIGHT);
  // Flowers
  setP(10*16+5, 5, PAL.GRASS_LEAF2); setP(10*16+6, 6, PAL.STEM_GREEN);
  setP(10*16+9, 4, PAL.GRASS_LEAF1); setP(10*16+10, 5, PAL.STEM_GREEN);

  // (11,1): Lantern Post / Lamp
  fillTile(11, 1, col.rgba(0,0,0,0));
  for (var y = 5; y <= 14; y++) setP(11*16+8, y, PAL.WOOD_DARK);
  setP(11*16+8, 4, PAL.WOOD_BASE); setP(11*16+7, 4, PAL.WOOD_BASE); setP(11*16+6, 4, PAL.WOOD_BASE);
  // Lantern
  setP(11*16+6, 5, PAL.STONE_DARK);
  setP(11*16+6, 6, PAL.HAY_LIGHT); // warm glow
  setP(11*16+6, 7, PAL.STONE_DARK);

  // -------------------------------------------------------------
  // ROW 2 to 5: RED BARN BUILDING (Modular 4x4 tiles: tiles x=0..3, y=2..5)
  // -------------------------------------------------------------
  // Red Barn consists of:
  // (0,2): Barn Roof Left Slope
  fillTile(0, 2, col.rgba(0,0,0,0));
  for (var y = 0; y < 16; y++) {
    for (var x = 0; x < 16; x++) {
      if (x + y >= 10) {
        setP(0*16+x, 2*16+y, PAL.ROOF_BASE);
        if (x + y === 10) setP(0*16+x, 2*16+y, PAL.WHITE_LIGHT);
        else if ((x + y) % 3 === 0) setP(0*16+x, 2*16+y, PAL.ROOF_LIGHT);
        else if ((x + y) % 4 === 0) setP(0*16+x, 2*16+y, PAL.ROOF_DARK);
      }
    }
  }

  // (1,2): Barn Roof Peak Left
  fillTile(1, 2, col.rgba(0,0,0,0));
  for (var y = 0; y < 16; y++) {
    for (var x = 0; x < 16; x++) {
      if (y - x <= 4) {
        setP(1*16+x, 2*16+y, PAL.ROOF_BASE);
        if (y === 0 || x + y === 4) setP(1*16+x, 2*16+y, PAL.WHITE_LIGHT);
        else if (y % 3 === 0) setP(1*16+x, 2*16+y, PAL.ROOF_LIGHT);
        else if (y % 4 === 0) setP(1*16+x, 2*16+y, PAL.ROOF_DARK);
      }
    }
  }

  // (2,2): Barn Roof Peak Right
  fillTile(2, 2, col.rgba(0,0,0,0));
  for (var y = 0; y < 16; y++) {
    for (var x = 0; x < 16; x++) {
      if (y + x <= 19) {
        setP(2*16+x, 2*16+y, PAL.ROOF_BASE);
        if (y === 0 || (15-x) + y === 4) setP(2*16+x, 2*16+y, PAL.WHITE_LIGHT);
        else if (y % 3 === 0) setP(2*16+x, 2*16+y, PAL.ROOF_LIGHT);
        else if (y % 4 === 0) setP(2*16+x, 2*16+y, PAL.ROOF_DARK);
      }
    }
  }

  // (3,2): Barn Roof Right Slope
  fillTile(3, 2, col.rgba(0,0,0,0));
  for (var y = 0; y < 16; y++) {
    for (var x = 0; x < 16; x++) {
      if ((15 - x) + y >= 10) {
        setP(3*16+x, 2*16+y, PAL.ROOF_BASE);
        if ((15 - x) + y === 10) setP(3*16+x, 2*16+y, PAL.WHITE_LIGHT);
        else if (((15 - x) + y) % 3 === 0) setP(3*16+x, 2*16+y, PAL.ROOF_LIGHT);
        else if (((15 - x) + y) % 4 === 0) setP(3*16+x, 2*16+y, PAL.ROOF_DARK);
      }
    }
  }

  // ROW 3: Barn Upper Wall (Loft & Window)
  // (0,3): Barn Wall Top-Left with White Corner
  fillTile(0, 3, PAL.BARN_BASE);
  for (var y = 0; y < 16; y++) {
    // vertical red planks
    if (y % 4 === 0) {
      for (var x = 0; x < 16; x++) setP(0*16+x, 3*16+y, PAL.BARN_DARK);
    }
    // White corner trim
    setP(0*16+0, 3*16+y, PAL.WHITE_SHAD);
    setP(0*16+1, 3*16+y, PAL.WHITE_BASE);
    setP(0*16+2, 3*16+y, PAL.WHITE_LIGHT);
  }

  // (1,3) & (2,3): Barn Wall Upper Center with Loft Hay Window
  fillTile(1, 3, PAL.BARN_BASE);
  fillTile(2, 3, PAL.BARN_BASE);
  for (var y = 0; y < 16; y++) {
    if (y % 4 === 0) {
      for (var x = 0; x < 16; x++) {
        setP(1*16+x, 3*16+y, PAL.BARN_DARK);
        setP(2*16+x, 3*16+y, PAL.BARN_DARK);
      }
    }
  }
  // Loft door / window across tile (1,3) right and (2,3) left
  // Window frame (x=10..15 in tile 1, x=0..5 in tile 2, y=3..13)
  for (var y = 3; y <= 13; y++) {
    for (var x = 11; x <= 15; x++) setP(1*16+x, 3*16+y, PAL.BLACK);
    for (var x = 0; x <= 4; x++) setP(2*16+x, 3*16+y, PAL.BLACK);
  }
  // Hay spilling out of window
  setP(1*16+12, 3*16+11, PAL.HAY_LIGHT); setP(1*16+13, 3*16+12, PAL.HAY_BASE); setP(1*16+14, 3*16+13, PAL.HAY_LIGHT);
  setP(2*16+1, 3*16+11, PAL.HAY_LIGHT); setP(2*16+2, 3*16+12, PAL.HAY_BASE); setP(2*16+3, 3*16+13, PAL.HAY_LIGHT);
  // White wooden frame
  for (var y = 2; y <= 14; y++) {
    setP(1*16+10, 3*16+y, PAL.WHITE_BASE);
    setP(2*16+5, 3*16+y, PAL.WHITE_BASE);
  }
  for (var x = 10; x <= 15; x++) setP(1*16+x, 3*16+2, PAL.WHITE_LIGHT);
  for (var x = 0; x <= 5; x++) setP(2*16+x, 3*16+2, PAL.WHITE_LIGHT);

  // (3,3): Barn Wall Top-Right with White Corner
  fillTile(3, 3, PAL.BARN_BASE);
  for (var y = 0; y < 16; y++) {
    if (y % 4 === 0) {
      for (var x = 0; x < 16; x++) setP(3*16+x, 3*16+y, PAL.BARN_DARK);
    }
    // White corner trim
    setP(3*16+13, 3*16+y, PAL.WHITE_LIGHT);
    setP(3*16+14, 3*16+y, PAL.WHITE_BASE);
    setP(3*16+15, 3*16+y, PAL.WHITE_SHAD);
  }

  // ROW 4: Barn Lower Wall (Large Barn Doors)
  // (0,4): Barn Lower Left Wall
  fillTile(0, 4, PAL.BARN_BASE);
  for (var y = 0; y < 16; y++) {
    setP(0*16+0, 4*16+y, PAL.WHITE_SHAD);
    setP(0*16+1, 4*16+y, PAL.WHITE_BASE);
    setP(0*16+2, 4*16+y, PAL.WHITE_LIGHT);
  }
  // (1,4) & (2,4): Classic Big Double Barn Doors with 'X' Cross Brace!
  fillTile(1, 4, PAL.BARN_DARK);
  fillTile(2, 4, PAL.BARN_DARK);
  // Door 1 (Tile 1, x=2..15)
  for (var y = 0; y < 16; y++) {
    for (var x = 3; x <= 15; x++) setP(1*16+x, 4*16+y, PAL.BARN_BASE);
    setP(1*16+3, 4*16+y, PAL.WHITE_BASE);
    setP(1*16+15, 4*16+y, PAL.BLACK); // Center crack
  }
  // 'X' Brace on Left Door
  for (var i = 0; i < 12; i++) {
    setP(1*16+3+i, 4*16+2+i, PAL.WHITE_LIGHT);
    setP(1*16+3+i, 4*16+14-i, PAL.WHITE_LIGHT);
  }
  // Door 2 (Tile 2, x=0..12)
  for (var y = 0; y < 16; y++) {
    for (var x = 0; x <= 12; x++) setP(2*16+x, 4*16+y, PAL.BARN_BASE);
    setP(2*16+12, 4*16+y, PAL.WHITE_BASE);
    setP(2*16+0, 4*16+y, PAL.BLACK); // Center crack
  }
  // 'X' Brace on Right Door
  for (var i = 0; i < 12; i++) {
    setP(2*16+12-i, 4*16+2+i, PAL.WHITE_LIGHT);
    setP(2*16+12-i, 4*16+14-i, PAL.WHITE_LIGHT);
  }
  // Iron hinges
  setP(1*16+3, 4*16+3, PAL.BLACK); setP(1*16+4, 4*16+3, PAL.BLACK);
  setP(1*16+3, 4*16+12, PAL.BLACK); setP(1*16+4, 4*16+12, PAL.BLACK);
  setP(2*16+12, 4*16+3, PAL.BLACK); setP(2*16+11, 4*16+3, PAL.BLACK);
  setP(2*16+12, 4*16+12, PAL.BLACK); setP(2*16+11, 4*16+12, PAL.BLACK);

  // (3,4): Barn Lower Right Wall
  fillTile(3, 4, PAL.BARN_BASE);
  for (var y = 0; y < 16; y++) {
    setP(3*16+13, 4*16+y, PAL.WHITE_LIGHT);
    setP(3*16+14, 4*16+y, PAL.WHITE_BASE);
    setP(3*16+15, 4*16+y, PAL.WHITE_SHAD);
  }

  // ROW 5: Barn Stone Foundation / Base
  for (var tx = 0; tx < 4; tx++) {
    fillTile(tx, 5, PAL.STONE_BASE);
    for (var x = 0; x < 16; x++) {
      setP(tx*16+x, 5*16+0, PAL.STONE_LIGHT);
      setP(tx*16+x, 5*16+15, PAL.STONE_DARK);
      if (x % 5 === 0) {
        for (var y = 1; y < 15; y++) setP(tx*16+x, 5*16+y, PAL.STONE_MORTAR);
      }
    }
  }

  // -------------------------------------------------------------
  // ROW 2 to 5 (Columns 4..7): COZY FARMHOUSE / COTTAGE
  // -------------------------------------------------------------
  // Roof Tiles (Terracotta pitched roof)
  // (4,2): Cottage Roof Left Edge
  fillTile(4, 2, col.rgba(0,0,0,0));
  for (var y = 0; y < 16; y++) {
    for (var x = 0; x < 16; x++) {
      if (x + y >= 8) {
        setP(4*16+x, 2*16+y, PAL.ROOF_BASE);
        if (x + y === 8) setP(4*16+x, 2*16+y, PAL.ROOF_LIGHT);
        else if ((x + y) % 3 === 0) setP(4*16+x, 2*16+y, PAL.ROOF_LIGHT);
        else if ((x + y) % 4 === 0) setP(4*16+x, 2*16+y, PAL.ROOF_DARK);
      }
    }
  }
  // (5,2) & (6,2): Cottage Roof Center with Stone Chimney & Smoke
  fillTile(5, 2, PAL.ROOF_BASE);
  fillTile(6, 2, PAL.ROOF_BASE);
  for (var tx = 5; tx <= 6; tx++) {
    for (var y = 0; y < 16; y++) {
      for (var x = 0; x < 16; x++) {
        if (y % 4 === 0) setP(tx*16+x, 2*16+y, PAL.ROOF_DARK);
        else if (y % 4 === 1) setP(tx*16+x, 2*16+y, PAL.ROOF_LIGHT);
      }
    }
  }
  // Chimney on (6,2)
  for (var cy = 0; cy < 10; cy++) {
    for (var cx = 8; cx <= 13; cx++) {
      setP(6*16+cx, 2*16+cy, PAL.STONE_BASE);
    }
    setP(6*16+8, 2*16+cy, PAL.STONE_LIGHT);
    setP(6*16+13, 2*16+cy, PAL.STONE_DARK);
  }
  // Chimney rim
  for (var cx = 7; cx <= 14; cx++) setP(6*16+cx, 2*16+0, PAL.STONE_LIGHT);

  // (7,2): Cottage Roof Right Edge
  fillTile(7, 2, col.rgba(0,0,0,0));
  for (var y = 0; y < 16; y++) {
    for (var x = 0; x < 16; x++) {
      if ((15 - x) + y >= 8) {
        setP(7*16+x, 2*16+y, PAL.ROOF_BASE);
        if ((15 - x) + y === 8) setP(7*16+x, 2*16+y, PAL.ROOF_LIGHT);
        else if (((15 - x) + y) % 3 === 0) setP(7*16+x, 2*16+y, PAL.ROOF_LIGHT);
        else if (((15 - x) + y) % 4 === 0) setP(7*16+x, 2*16+y, PAL.ROOF_DARK);
      }
    }
  }

  // ROW 3: Cottage Upper Wall (Cream Timber & Windows)
  // (4,3): Left Wall Corner (Wooden Post)
  fillTile(4, 3, PAL.WHITE_BASE);
  for (var y = 0; y < 16; y++) {
    setP(4*16+0, 3*16+y, PAL.WOOD_EDGE);
    setP(4*16+1, 3*16+y, PAL.WOOD_BASE);
    setP(4*16+2, 3*16+y, PAL.WOOD_LIGHT);
  }
  // (5,3): Cottage Window Tile
  fillTile(5, 3, PAL.WHITE_BASE);
  // Glass Window
  for (var wy = 4; wy <= 11; wy++) {
    for (var wx = 4; wx <= 11; wx++) {
      setP(5*16+wx, 3*16+wy, PAL.GLASS_BASE);
    }
  }
  // Window frame & shine
  for (var i = 3; i <= 12; i++) {
    setP(5*16+i, 3*16+3, PAL.WOOD_BASE);
    setP(5*16+i, 3*16+12, PAL.WOOD_BASE);
    setP(5*16+3, 3*16+i, PAL.WOOD_BASE);
    setP(5*16+12, 3*16+i, PAL.WOOD_BASE);
  }
  setP(5*16+5, 3*16+5, PAL.GLASS_LIGHT);
  setP(5*16+6, 3*16+5, PAL.GLASS_LIGHT);
  setP(5*16+5, 3*16+6, PAL.GLASS_LIGHT);

  // (6,3): Cottage Timber Wall Plain
  fillTile(6, 3, PAL.WHITE_BASE);
  // Wooden diagonal beam
  for (var i = 0; i < 16; i++) {
    setP(6*16+i, 3*16+i, PAL.WOOD_BASE);
    setP(6*16+i, 3*16+15-i, PAL.WOOD_BASE);
  }

  // (7,3): Right Wall Corner
  fillTile(7, 3, PAL.WHITE_BASE);
  for (var y = 0; y < 16; y++) {
    setP(7*16+13, 3*16+y, PAL.WOOD_LIGHT);
    setP(7*16+14, 3*16+y, PAL.WOOD_BASE);
    setP(7*16+15, 3*16+y, PAL.WOOD_EDGE);
  }

  // ROW 4: Cottage Ground Floor & Front Door
  // (4,4): Lower Wall Left
  fillTile(4, 4, PAL.WHITE_BASE);
  for (var y = 0; y < 16; y++) {
    setP(4*16+0, 4*16+y, PAL.WOOD_EDGE);
    setP(4*16+1, 4*16+y, PAL.WOOD_BASE);
    setP(4*16+2, 4*16+y, PAL.WOOD_LIGHT);
  }
  // (5,4): Front Wooden Door with Round Arch
  fillTile(5, 4, PAL.WHITE_BASE);
  for (var dy = 3; dy < 16; dy++) {
    for (var dx = 3; dx <= 12; dx++) {
      setP(5*16+dx, 4*16+dy, PAL.WOOD_BASE);
    }
  }
  // Arch
  for (var dx = 4; dx <= 11; dx++) setP(5*16+dx, 4*16+2, PAL.WOOD_DARK);
  // Door planks & brass handle
  for (var dy = 3; dy < 16; dy++) {
    setP(5*16+3, 4*16+dy, PAL.WOOD_DARK);
    setP(5*16+12, 4*16+dy, PAL.WOOD_DARK);
    setP(5*16+7, 4*16+dy, PAL.WOOD_DARK);
  }
  setP(5*16+10, 4*16+9, PAL.HAY_LIGHT); // brass doorknob

  // (6,4): Ground Floor Window with Flower Box
  fillTile(6, 4, PAL.WHITE_BASE);
  for (var wy = 4; wy <= 9; wy++) {
    for (var wx = 4; wx <= 11; wx++) {
      setP(6*16+wx, 4*16+wy, PAL.GLASS_BASE);
    }
  }
  setP(6*16+5, 4*16+5, PAL.GLASS_LIGHT);
  // Flower box under window
  for (var fx = 3; fx <= 12; fx++) {
    setP(6*16+fx, 4*16+10, PAL.ROOF_BASE);
    setP(6*16+fx, 4*16+11, PAL.ROOF_DARK);
  }
  setP(6*16+4, 4*16+9, PAL.GRASS_LEAF1); setP(6*16+6, 4*16+9, PAL.GRASS_LEAF2);
  setP(6*16+8, 4*16+9, PAL.GRASS_LEAF1); setP(6*16+11, 4*16+9, PAL.GRASS_LEAF2);

  // (7,4): Lower Wall Right
  fillTile(7, 4, PAL.WHITE_BASE);
  for (var y = 0; y < 16; y++) {
    setP(7*16+13, 4*16+y, PAL.WOOD_LIGHT);
    setP(7*16+14, 4*16+y, PAL.WOOD_BASE);
    setP(7*16+15, 4*16+y, PAL.WOOD_EDGE);
  }

  // ROW 5 (Columns 4..7): Cobblestone Foundation
  for (var tx = 4; tx <= 7; tx++) {
    fillTile(tx, 5, PAL.STONE_BASE);
    for (var x = 0; x < 16; x++) {
      setP(tx*16+x, 5*16+0, PAL.STONE_LIGHT);
      setP(tx*16+x, 5*16+15, PAL.STONE_DARK);
      if ((x + tx*16) % 6 === 0) {
        for (var y = 1; y < 15; y++) setP(tx*16+x, 5*16+y, PAL.STONE_MORTAR);
      }
    }
  }

  // -------------------------------------------------------------
  // ROW 2 to 5 (Columns 8..11): WINDMILL & SILO PIECES
  // -------------------------------------------------------------
  // (8,2) to (9,2): Windmill Blades / Fan
  fillTile(8, 2, col.rgba(0,0,0,0));
  fillTile(9, 2, col.rgba(0,0,0,0));
  // Central rotor gear at edge
  setP(8*16+15, 2*16+8, PAL.WOOD_EDGE);
  setP(9*16+0, 2*16+8, PAL.WOOD_EDGE);
  // Blades radiating out
  for (var i = 0; i < 14; i++) {
    // Upper vertical blade
    setP(8*16+15, 2*16+8-i, PAL.WHITE_LIGHT);
    setP(8*16+14, 2*16+8-i, PAL.WHITE_BASE);
    // Lower vertical blade
    setP(8*16+15, 2*16+8+i, PAL.WHITE_BASE);
    setP(8*16+14, 2*16+8+i, PAL.WHITE_LIGHT);
    // Left horizontal blade
    setP(8*16+15-i, 2*16+8, PAL.WHITE_LIGHT);
    setP(8*16+15-i, 2*16+7, PAL.WHITE_BASE);
    // Right horizontal blade
    setP(9*16+i, 2*16+8, PAL.WHITE_BASE);
    setP(9*16+i, 2*16+7, PAL.WHITE_LIGHT);
  }

  // (8,3) to (9,3): Windmill Stone Tower Wall
  fillTile(8, 3, PAL.STONE_BASE);
  fillTile(9, 3, PAL.STONE_BASE);
  for (var y = 0; y < 16; y++) {
    setP(8*16+2, 3*16+y, PAL.STONE_LIGHT);
    setP(9*16+13, 3*16+y, PAL.STONE_DARK);
  }
  // (8,4) to (9,4): Windmill Lower Base & Door
  fillTile(8, 4, PAL.STONE_BASE);
  fillTile(9, 4, PAL.STONE_BASE);
  for (var dy = 4; dy < 16; dy++) {
    for (var dx = 12; dx <= 15; dx++) setP(8*16+dx, 4*16+dy, PAL.WOOD_BASE);
    for (var dx = 0; dx <= 3; dx++) setP(9*16+dx, 4*16+dy, PAL.WOOD_BASE);
  }

  // (10,2..4): Grain Silo Dome & Corrugated Tin
  fillTile(10, 2, col.rgba(0,0,0,0));
  // Silo Dome
  for (var y = 4; y < 16; y++) {
    for (var x = 2; x <= 13; x++) {
      setP(10*16+x, 2*16+y, PAL.STONE_BASE);
    }
  }
  for (var x = 4; x <= 11; x++) setP(10*16+x, 2*16+3, PAL.STONE_LIGHT);
  // (10,3) & (10,4): Silo Corrugated Metal Wall
  fillTile(10, 3, PAL.STONE_BASE);
  fillTile(10, 4, PAL.STONE_BASE);
  for (var y = 0; y < 16; y++) {
    for (var x = 2; x <= 13; x += 2) {
      setP(10*16+x, 3*16+y, PAL.STONE_LIGHT);
      setP(10*16+x+1, 3*16+y, PAL.STONE_DARK);
      setP(10*16+x, 4*16+y, PAL.STONE_LIGHT);
      setP(10*16+x+1, 4*16+y, PAL.STONE_DARK);
    }
  }

  // (11,2..4): Wooden Water Tower / Grain Tank
  fillTile(11, 2, col.rgba(0,0,0,0));
  // Water tank tub
  for (var y = 5; y <= 15; y++) {
    for (var x = 2; x <= 13; x++) {
      setP(11*16+x, 2*16+y, PAL.WOOD_BASE);
    }
  }
  for (var x = 2; x <= 13; x++) {
    setP(11*16+x, 7, PAL.STONE_DARK);
    setP(11*16+x, 13, PAL.STONE_DARK);
  }
  // (11,3): Wooden Stilts / Scaffolding
  fillTile(11, 3, col.rgba(0,0,0,0));
  for (var y = 0; y < 16; y++) {
    setP(11*16+3, 3*16+y, PAL.WOOD_DARK);
    setP(11*16+4, 3*16+y, PAL.WOOD_BASE);
    setP(11*16+11, 3*16+y, PAL.WOOD_BASE);
    setP(11*16+12, 3*16+y, PAL.WOOD_DARK);
  }
  // Cross brace
  for (var i = 0; i < 8; i++) {
    setP(11*16+4+i, 3*16+4+i, PAL.WOOD_LIGHT);
    setP(11*16+11-i, 3*16+4+i, PAL.WOOD_LIGHT);
  }

  // -------------------------------------------------------------
  // ROW 6: FARM VEHICLES & UTILITIES (Carts, Tools, Autumn Trees)
  // -------------------------------------------------------------
  // (0,6) & (1,6): Wooden Farm Wagon / Hay Cart (2 tiles wide)
  fillTile(0, 6, col.rgba(0,0,0,0));
  fillTile(1, 6, col.rgba(0,0,0,0));
  // Wagon bed
  for (var x = 2; x < 16; x++) {
    for (var y = 5; y <= 10; y++) {
      setP(0*16+x, 6*16+y, PAL.WOOD_BASE);
      setP(1*16+x-2, 6*16+y, PAL.WOOD_BASE);
    }
  }
  // Hay pile inside wagon
  for (var x = 3; x <= 14; x++) {
    setP(0*16+x, 6*16+4, PAL.HAY_LIGHT);
    setP(0*16+x, 6*16+3, PAL.HAY_BASE);
    setP(1*16+x-2, 6*16+4, PAL.HAY_LIGHT);
    setP(1*16+x-2, 6*16+3, PAL.HAY_BASE);
  }
  // Wagon Wheels (Left wheel on tile 0, Right wheel on tile 1)
  // Wheel 1
  for (var wy = 9; wy <= 15; wy++) {
    for (var wx = 4; wx <= 10; wx++) {
      if ((wx-7)*(wx-7) + (wy-12)*(wy-12) <= 3*3) {
        setP(0*16+wx, 6*16+wy, PAL.WOOD_DARK);
      }
    }
  }
  setP(0*16+7, 6*16+12, PAL.STONE_DARK); // hub
  // Wheel 2
  for (var wy = 9; wy <= 15; wy++) {
    for (var wx = 7; wx <= 13; wx++) {
      if ((wx-10)*(wx-10) + (wy-12)*(wy-12) <= 3*3) {
        setP(1*16+wx, 6*16+wy, PAL.WOOD_DARK);
      }
    }
  }
  setP(1*16+10, 6*16+12, PAL.STONE_DARK); // hub

  // (2,6): Scarecrow (with straw hat & coat in autumn field)
  fillTile(2, 6, col.rgba(0,0,0,0));
  // Post
  for (var y = 3; y <= 15; y++) setP(2*16+8, 6*16+y, PAL.WOOD_DARK);
  // Arms
  for (var x = 3; x <= 13; x++) setP(2*16+x, 6*16+6, PAL.BARN_LIGHT);
  // Straw hands
  setP(2*16+2, 6*16+6, PAL.HAY_LIGHT); setP(2*16+14, 6*16+6, PAL.HAY_LIGHT);
  // Plaid coat body
  for (var y = 6; y <= 11; y++) {
    for (var x = 6; x <= 10; x++) {
      setP(2*16+x, 6*16+y, PAL.BARN_BASE);
    }
  }
  // Pumpkin / Burlap Head
  for (var y = 2; y <= 5; y++) {
    for (var x = 6; x <= 10; x++) {
      setP(2*16+x, 6*16+y, PAL.PUMPKIN_L);
    }
  }
  // Straw hat
  for (var x = 4; x <= 12; x++) setP(2*16+x, 6*16+2, PAL.HAY_LIGHT);
  for (var x = 6; x <= 10; x++) setP(2*16+x, 6*16+1, PAL.HAY_BASE);

  // (3,6): Pitchfork & Shovel leaning on post
  fillTile(3, 6, col.rgba(0,0,0,0));
  for (var i = 0; i < 12; i++) {
    setP(3*16+4+i, 6*16+14-i, PAL.WOOD_LIGHT); // Pitchfork shaft
    setP(3*16+6+i, 6*16+14-i, PAL.WOOD_BASE);  // Shovel shaft
  }
  // Iron fork head
  setP(3*16+15, 6*16+2, PAL.STONE_LIGHT);
  setP(3*16+14, 6*16+2, PAL.STONE_LIGHT);
  setP(3*16+13, 6*16+2, PAL.STONE_LIGHT);
  // Shovel spade
  setP(3*16+5, 6*16+14, PAL.STONE_DARK);
  setP(3*16+6, 6*16+15, PAL.STONE_DARK);

  // (4,6): Firewood Stack (Log pile)
  fillTile(4, 6, col.rgba(0,0,0,0));
  for (var ly = 8; ly <= 14; ly += 3) {
    for (var lx = 2; lx <= 13; lx += 4) {
      // Log end
      setP(4*16+lx, 6*16+ly, PAL.WOOD_LIGHT);
      setP(4*16+lx+1, 6*16+ly, PAL.WOOD_BASE);
      setP(4*16+lx, 6*16+ly+1, PAL.WOOD_BASE);
      setP(4*16+lx+1, 6*16+ly+1, PAL.WOOD_DARK);
    }
  }

  // (5,6) to (7,6): Golden Maple / Oak Autumn Tree Canopy & Trunk
  // (5,6): Left canopy
  fillTile(5, 6, col.rgba(0,0,0,0));
  for (var y = 2; y < 16; y++) {
    for (var x = 4; x < 16; x++) {
      if ((x-15)*(x-15) + (y-12)*(y-12) <= 12*12) {
        setP(5*16+x, 6*16+y, ((x+y)%2===0)?PAL.CANOPY_1:PAL.CANOPY_2);
      }
    }
  }
  // (6,6): Top/Center canopy
  fillTile(6, 6, col.rgba(0,0,0,0));
  for (var y = 1; y < 16; y++) {
    for (var x = 0; x < 16; x++) {
      setP(6*16+x, 6*16+y, ((x+y)%3===0)?PAL.CANOPY_2:PAL.CANOPY_1);
      if (y < 5) setP(6*16+x, 6*16+y, PAL.CANOPY_2);
    }
  }
  // (7,6): Right canopy
  fillTile(7, 6, col.rgba(0,0,0,0));
  for (var y = 2; y < 16; y++) {
    for (var x = 0; x < 12; x++) {
      if (x*x + (y-12)*(y-12) <= 12*12) {
        setP(7*16+x, 6*16+y, ((x+y)%2===0)?PAL.CANOPY_3:PAL.CANOPY_1);
      }
    }
  }

  // Save the modified file!
  var targetPath = "C:/Important Files/Universitas Brawijaya'25/projects/GodotGameProjects/little-forest-keeper/assets/tilesets/autumn_farm.png";
  s.saveAs(targetPath, true);
  console.log("Autumn Farm Tileset successfully generated and saved to: " + targetPath);
})();
