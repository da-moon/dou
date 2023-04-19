import React from 'react';
import imagenes from './imagenes';
import style from "./style.css";

export default function Portfolio() {
  return (
    <div>
      <header>
        <h1>PORTFOLIO</h1>
      </header>

      <section>
        <p className="portfolioParagraph">
          In my mind I visualize a detail. The view and the sensation will
          appear in a print. If it excites me, there is a good chance that it
          will make a good photograph. It is an intuitive sense, a capacity that
          comes from a lot of practice.
        </p>
        <div className="portfolio">
          <img
            src={imagenes.babyBed}
            style={{ "width" : "25%" }}
            alt="Baby in Bed"
          />
          <img
            src={imagenes.camera}
            style={{ "width" : "25%" }}
            alt="Camera"
          />
          <img
            src={imagenes.couple}
            style={{ "width" : "25%" }}
            alt="Couple"
          />
          <img
            src={imagenes.zebras}
             style={{ "width" : "25%" }}
            alt="Zebras"
          />
          <img
            src={imagenes.girlFlowers}
             style={{ "width" : "25%" }}
            alt="Girl with flowers"
          />
          <img
            src={imagenes.airPlane}
             style={{ "width" : "25%" }}
            alt="Air Plane"
          />
        </div>
      </section>

      <footer>
        <p> By: John Doe &reg; 2021</p>
      </footer>
    </div>
  );
}
