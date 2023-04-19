import React from "react";
import { Link } from "react-router-dom";

const Button = ({active, handleClick, index, name, path}) => {
    const setId = () => {
        handleClick(index)
    }
    return (
        <Link to={path}>
            <button className={`tab-item ${active ? "active" : ""}`} onClick={setId}>
                {name}
            </button>
        </Link>    
    )
}

export default Button;