import React from 'react';
import { Link, useHistory } from "react-router-dom";
import ticketly from "../../img/ticketly.png";
import "./SideBar.css"

const SideBar = () => {

    const history = useHistory();

    return (
        <div className="sidebar">
            <div className="headers">
                <Link to="/">
                    <img src={ticketly} alt="logo" className="logoTicketly" />
                    <span> TICKETLY </span>
                </Link>
            </div>

            {history.location.pathname.includes("Admin") ? (
                <>
                    <Link to="/Admin/Events">Eventos</Link>
                    <Link to="/Admin/Locations">Ubicacion</Link>
                    <Link to="/Admin/Sales">Ventas</Link>
                </>
            ) : (
                <>
                    <Link to="/EventDetail">Eventos</Link>
                </>
            )}

        </div>
    )
}

export default SideBar