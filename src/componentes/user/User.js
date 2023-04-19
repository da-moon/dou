import React from "react";
import './User.css';

const User = ({user}) => {
    return (
        <div className="user-container">
            <h1>{user.name}</h1>
            <p> {user.jobDescription} <span>{user.location}</span></p>
        </div>
    )
}

export default User;