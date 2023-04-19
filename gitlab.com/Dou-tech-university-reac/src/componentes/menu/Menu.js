import React from "react";
import './Menu.css';

const Menu = ({name}) => {
    const words = name.split(' ');
    return(
        <div className="skill-menu">
            <div className="skill-menu--logo">
                <img src="https://www.digitalonus.com/wp-content/uploads/2021/10/Tech-Mahindra-01.png" />
            </div>
            <div className="skill-menu--avatar">{`${words[0][0]}${words[1][0]}`}</div>
        </div>
    )
}

export default Menu;