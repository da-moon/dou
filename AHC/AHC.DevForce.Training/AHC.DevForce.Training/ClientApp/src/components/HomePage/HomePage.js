import React from 'react';
import facebook from "./icons/facebook.png";
import instagram from "./icons/instagram.png";
import twitter from "./icons/twitter.png";
import ticketly from "../../img/ticketly.png"
import concierto from "../../img/concierto.jpg"
import partido from "../../img/partido.jpg"
import "./HomePage.css";
import { Link } from 'react-router-dom';

const HomePage = () => {
    return (
        <div className="homepageContainer">
            <div className="homepageHeader">
                <div className="logo">
                    <img src={ticketly} alt="logo" className="logoTicketly" />
                    <h1> TICKETLY </h1>
                </div>
                <div className="slogan">
                    <span>Los mejores eventos solo AQUI!!</span>
               </div>
               <div className="events">
                    <img src={concierto} alt="concierto" />
                    <img src={partido} alt="partido" />
               </div>
            </div>
            <div className="socialMedia">
                <div className="followUs">
                    <span>Siguenos en...</span>
                </div>
                <div className="socialMediaLinks">
                    <div className="links">
                        <img src={facebook} alt="facebook" className="facebookTicketly" />
                        <span> @Ticketly </span>
                    </div>
                    <div className="links">
                        <img src={instagram} alt="instagram" className="InstagramTicketly" />
                        <span> @Ticketly </span>
                    </div>
                    <div className="links">
                        <img src={twitter} alt="twitter" className="TwitterTicketly" />
                        <span> @Ticketly </span>
                    </div>
                </div>
            </div>
            <div className="footer">
                <div className="footerLinks">
                    <p>Poltica de Compras | Aviso de Privacidad | Copromisos con COFECE | Administrar mis cockies </p>
                </div>
                <div className="footerInfo">
                    <p>&copy; 1999 - 2022 Ticketly. Todos los derechos reservados.</p>
                </div>
            </div>
        </div>
    )
}

export default HomePage