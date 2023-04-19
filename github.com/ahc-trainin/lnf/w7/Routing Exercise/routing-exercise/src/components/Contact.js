import React from 'react';
import icons from './icons';
import style from './style.css';


export default function Contact() {
  return (
    <div>
      <header>
        <h1>CONTACT ME</h1>
      </header>

      <section>
        <table>
          <tbody>
            <thead>
              <tr>
                <th>
                  <img
                    src={icons.email}
                    style={{ "width" : "15%" }}
                    alt="Email Icon"
                  />
                </th>
                <th>
                  <img
                    src={icons.whatsApp}
                    style={{ "width" : "15%" }}
                    alt="Whats App Icon"
                  />
                </th>
                <th>
                  <img
                    src={icons.facebook}
                    style={{ "width" : "15%" }}
                    alt="Facebook Icon"
                  />
                </th>
                <th>
                  <img
                    src={icons.instagram}
                    style={{ "width" : "15%" }}
                    alt="Instagram Icon"
                  />
                </th>
              </tr>
              <tr>
                <th> EMAIL <br/> John.doe@gmail.com </th>
                <th> WHATS APP <br/> +52 (55) 123 45 66 </th>
                <th> FACEBOOK <br/> John Doe </th>
                <th> INSTAGRAM <br/> @john.doe </th>
              </tr>
            </thead>
          </tbody>
        </table>
      </section>

      <footer>
        <p> By: John Doe &reg; 2021</p>
      </footer>
    </div>
  );
}
