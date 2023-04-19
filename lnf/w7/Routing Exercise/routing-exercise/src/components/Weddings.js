import React from 'react';
import imagenes from './imagenes';
import style from './style.css';

export default function Weddings() {
  return (
    <div>
      <header>
        <h1>WEDDINGS</h1>
      </header>

      <section>
        <p className="weddingsParagraph">
          The important thing is to see what is invisible to others.
        </p>
        <div className="photographWedding">
          <img
            src={imagenes.wedding1}
             style={{ "width" : "25%" }}
            alt="Wedding 1"
          />
          <img
            src={imagenes.weddingRings}
             style={{ "width" : "25%" }}
            alt="Wedding Rings"
          />
          <img
            src={imagenes.wedding2}
             style={{ "width" : "25%" }}
            alt="Weeding 2"
          />
          <img
            src={imagenes.bridalBouquet}
             style={{ "width" : "25%" }}
            alt="Bridal Bouquet"
          />
          <img
            src={imagenes.wedding3}
             style={{ "width" : "25%" }}
            alt="Weeding 3"
          />
          <img
            src={imagenes.weddingCar}
             style={{ "width" : "25%" }}
            alt="Wedding Car"
          />
        </div>
      </section>

      <footer>
        <p> By: John Doe &reg; 2021</p>
      </footer>
    </div>
  );
}
