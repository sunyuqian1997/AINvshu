//本代码要实现从字体部件生成新字，并将新字纵向排列，形成一句话
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

  PGraphics stitchedFont = createStitchedFont(inputs2);
  PGraphics pixelatedFont = pixelateFont(stitchedFont);
  //image(stitchedFont, 0, 0, 0, 0);
  //image(pixelatedFont, 0, 0, 0, 0);
  image(stitchedFont, 0, 0, width / 2, height);
  image(pixelatedFont, width / 2, 0, width / 2, height);
}

//本功能接受int[]，让对应的组件组合成一个字
PGraphics createStitchedFont(int[] inputs2) {
  PGraphics pg = createGraphics(width / 2, height);
  pg.beginDraw();
  pg.background(199);
  int offset = 0;

  for (int input : inputs2) {
    PImage img = images[input];
    pg.image(img, (width / 4) - (img.width / 12), offset, img.width/5, img.height/6);
    offset += img.height/10;
  }
  pg.endDraw();
  return pg;
}

//本功能对生成的字做像素化处理
//修改意见：仅针对createStitchedFont中产生的PGraphic做处理，分辨率也和其保持一致
PGraphics pixelateFont(PGraphics stitchedFont) {
  PGraphics pg = createGraphics(width / 2, height);
  pg.beginDraw();
  pg.background(255);
  //修改网格分辨率
  int gridSize = 12;
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

//修改意见：增加功能，每次按空格，调用一个功能叫generateSentence随机生成五组三位向量，每一个数字在1-32之间
//根据这五组向量，生成五个字，然后让这五个字在屏幕上纵向排列。应该有一个float来控制相比原字的缩放程度
//按照更科学的方法，你可以多写几个功能，来让代码更优雅
//最终请给出修改draw()函数的意见
void generateSentence(){
  
//把功能写在这里
}
