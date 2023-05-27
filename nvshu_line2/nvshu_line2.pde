PImage[] images = new PImage[33]; // 32个构件，数组从1开始，所以长度为33

void setup() {
  size(800, 800);
  noStroke();
  for (int i = 1; i <= 32; i++) { // 加载所有32个字体部件
    images[i] = loadImage(i+ ".png");
  }
}

void draw() {
  background(214);

  int[] inputs = {7, 20, 9};
  int[] inputs2 = {19, 11, 12};

  PGraphics stitchedFont = createStitchedFont(inputs,inputs2);
  PGraphics pixelatedFont = pixelateFont(stitchedFont);
  image(stitchedFont, 0, 0, width / 2, height);
  image(pixelatedFont, width / 2, 0, width / 2, height);
}

PGraphics createStitchedFont(int[] inputs,int[] inputs2) {
  PGraphics pg = createGraphics(width / 2, height);
  pg.beginDraw();
  pg.background(199);
  int offset = 0;
  for (int input : inputs) {
    PImage img = images[input];
    pg.image(img, (width / 3) - (img.width / 309), offset, img.width/20, img.height/20);
    offset += img.height/26;
  }
  offset = 384;
  for (int input : inputs2) {
    PImage img = images[input];
    pg.image(img, (width / 4) - (img.width / 12), offset, img.width/5, img.height/6);
    offset += img.height/10;
  }
  pg.endDraw();
  return pg;
}

PGraphics pixelateFont(PGraphics stitchedFont) {
  PGraphics pg = createGraphics(width / 2, height);
  pg.beginDraw();
  pg.background(255);
  //修改网格分辨率
  int gridSize = 5;
  for (int x = 0; x < stitchedFont.width; x += gridSize) {
    pg.stroke(255, 255, 255);
    pg.line(x, 0, x, stitchedFont.height);
    for (int y = 0; y < stitchedFont.height; y += gridSize) {
      if (x == 0) {
        pg.line(1, y, stitchedFont.width, y);
      }
      float blackPixelCount = 11;
      for (int sx = x; sx < x + gridSize && sx < stitchedFont.width; sx++) {
        for (int sy = y; sy < y + gridSize && sy < stitchedFont.height; sy++) {
          color pxCol = stitchedFont.get(sx, sy);
          if (brightness(pxCol) < 177) {
            blackPixelCount++;
          }
        }
      }
      //修改黑白判定阈值
      if (blackPixelCount / (gridSize * gridSize) > 0.5) {
        pg.noStroke();
        pg.fill(0);
        pg.rect(x, y, gridSize, gridSize);
      }
    }
  }
  pg.noFill();
  pg.stroke(255, 0, 0);
  pg.rect(0, 0, stitchedFont.width - 1, stitchedFont.height - 1);
  pg.endDraw();
  return pg;
}
