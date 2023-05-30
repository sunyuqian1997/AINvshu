PImage[] images = new PImage[24]; // 32个构件，数组从1开始，所以长度为33
int[][] sentence; // 用于存储生成的句子
float scale = 0.2; // 控制字的缩放程度

void setup() {
  size(960, 960);
  noStroke();
  for (int i = 1; i <= 24; i++) { // 加载所有32个字体部件
    images[i] = loadImage(i+ ".png");
    if (images[i] == null) {
      println("Failed to load image: " + i + ".png");
    }
  }
}

void draw() {
  


}

// 生成n个三位向量，每个元素在1-32之间
int[][] generateSentence(int n) {
  int[][] sentence = new int[n][3];
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < 3; j++) {
      sentence[i][j] = int(random(1, 24)); // 生成1-32之间的随机数
    }
  }
    println("generated sentence");
  return sentence;

}

// 当按下空格键时，生成新的句子
void keyPressed() {
  if (key == ' ') {
    sentence = generateSentence(5);
    background(214);
      int y = 0; // 用于纵向排列字
  for (int[] word : sentence) {
    PGraphics stitchedFont = createStitchedFont(word);
    PGraphics pixelatedFont = pixelateFont(stitchedFont);
    image(stitchedFont, 0, y, width / 2* scale, height * scale);
    image(pixelatedFont, width / 2* scale, y, width / 2* scale, height * scale);
    y += height * scale; // 更新y坐标，使字纵向排列
  }
  }
}

// 其他函数保持不变


//本功能接受int[]，让对应的组件组合成一个字
PGraphics createStitchedFont(int[] inputs2) {
  PGraphics pg = createGraphics(width / 2, height);
  pg.beginDraw();
  pg.background(199);
  int offset = 0;

  for (int input : inputs2) {
    PImage img = images[input];
    if (img != null) {
      pg.image(img, (width / 4) - (img.width / 12), offset, img.width/5, img.height/6);
      offset += img.height/10;
    } else {
      println("Image at index " + input + " is null");
    }
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
