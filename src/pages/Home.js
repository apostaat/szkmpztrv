import React, { useEffect, useRef } from 'react';
import p5 from 'p5';
import './Home.css';

const Home = () => {
  const sketchRef = useRef();
  const p5Instance = useRef();

  useEffect(() => {
    const sketch = (p) => {
      let waves = [];
      const NUM_WAVES = 50;
      let t = 0;

      p.setup = () => {
        const canvas = p.createCanvas(window.innerWidth, window.innerHeight);
        canvas.parent(sketchRef.current);
        p.pixelDensity(2);
        initWaves();
        p.textFont('Stencil, Impact, sans-serif');
      };

      p.windowResized = () => {
        p.resizeCanvas(window.innerWidth, window.innerHeight);
        initWaves();
      };

      function initWaves() {
        waves = [];
        const margin = p.height * 0.08;
        for (let i = 0; i < NUM_WAVES; i++) {
          const y = p.map(i, 0, NUM_WAVES - 1, margin, p.height - margin);
          const amp = p.random(p.height * 0.015, p.height * 0.07);
          const baseK = p.random(0.006, 0.018);
          const speed = p.random(0.0008, 0.0035);
          const q = p.random(1.2, 2.6);
          const phase = p.random(p.TWO_PI);
          waves.push({ y, amp, baseK, speed, q, phase });
        }
      }

      p.draw = () => {
        p.background(0);
        drawWaves();
       
        t += p.deltaTime;
      };

      function drawWaves() {
        p.stroke(255);
        p.strokeWeight(1.5);
        p.noFill();

        const step = 4;
        for (const w of waves) {
          p.beginShape();
          for (let x = 0; x <= p.width; x += step) {
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
            p.vertex(x, y);
          }
          p.endShape();
        }
      }

      p.keyPressed = () => {
        if (p.key === 'r' || p.key === 'R') {
          initWaves();
        }
      };
    };

    p5Instance.current = new p5(sketch);

    return () => {
      if (p5Instance.current) {
        p5Instance.current.remove();
      }
    };
  }, []);

  return (
    <div className="home">
      <div ref={sketchRef} className="sketch-container"></div>
      <div className="home-overlay">
        <div className="home-content">
          <h1 className="trafaret-font">союз композиторов и эвм</h1>
          <p className="home-subtitle">union of composers and electronic machines</p>
        </div>
      </div>
    </div>
  );
};

export default Home;
