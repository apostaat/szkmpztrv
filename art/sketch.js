let waves = [];
const NUM_WAVES = 50;
let t = 0;

function setup() {
  createCanvas(windowWidth, windowHeight);
  pixelDensity(2);
  initWaves();
  textFont('Stencil, Impact, sans-serif');

}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
  initWaves();
}

function initWaves() {
  waves = [];
  const margin = height * 0.08;
  for (let i = 0; i < NUM_WAVES; i++) {
    const y = map(i, 0, NUM_WAVES - 1, margin, height - margin);
    const amp = random(height * 0.015, height * 0.07);
    const baseK = random(0.006, 0.018);
    const speed = random(0.0008, 0.0035);
    const q = random(1.2, 2.6);
    const phase = random(TWO_PI);
    waves.push({ y, amp, baseK, speed, q, phase });
  }
}

function draw() {
  background(0);
  drawWaves();
  drawCenterSquare();
  t += deltaTime;
}

function drawWaves() {
  stroke(255);
  strokeWeight(1.5);
  noFill();

  const step = 4;
  for (const w of waves) {
    beginShape();
    for (let x = 0; x <= width; x += step) {
      let yOff = 0;
      const k = w.baseK;
      const time = t * w.speed;
      const harmonics = 5;
      for (let n = 1; n <= harmonics; n++) {
        const weight = 1 / Math.pow(n, w.q);
        const omega = (1 + n * 0.17);
        yOff += weight * Math.sin(n * (k * x + w.phase) - omega * time);
      }
      const y = w.y + w.amp * yOff;
      vertex(x, y);
    }
    endShape();
  }
}

function drawCenterSquare() {
  const s = min(width, height) * 0.36;
  const x = width / 2 - s / 2;
  const y = height / 2 - s / 2;

  noStroke();
  fill(255);
  rect(x, y, s, s, 8);

  const lines = ['союз', 'композиторов', 'и эвм'];
  fill(0);
  textAlign(CENTER, CENTER);
  const maxTextSize = s * 0.12;
  textSize(maxTextSize);
  const lineH = maxTextSize * 1.2;
  const startY = height / 2 - lineH;
  for (let i = 0; i < lines.length; i++) {
    text(lines[i], width / 2, startY + i * lineH);
  }
}

function keyPressed() {
  if (key === 'r' || key === 'R') {
    initWaves();
  }
}
