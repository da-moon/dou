import React from 'react';
import imagenes from './imagenes';
import style from './style.css';

export default function Home() {
  return (
    <div>
      <header>
        <h1>PHOTOGRAPHER</h1>
        <h2>John Doe</h2>
      </header>

      <section>
        <div className="photography">
          <img
            src={imagenes.streetMusicians}
            style={{ width: "50%" }}
            alt="Street Musicians"
          />
          <img
            src={imagenes.girlWalking}
            style={{ width: "50%" }}
            alt="Girl Walking"
          />
        </div>
      </section>

      <footer>
        <p> By: John Doe &reg; 2021</p>
      </footer>
    </div>
  );
}
