import React from "react";

const View = ({handleGetUser, user}) => {
    return (
        <React.Fragment>
            <button onClick={handleGetUser}>Get User</button>
            <p>User: {user?.name}</p>
        </React.Fragment>
    )
    
}

export default View;