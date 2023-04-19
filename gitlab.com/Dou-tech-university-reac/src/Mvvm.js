import React, {useState} from "react";
import { DB } from "./DB";
import View from "./View";

const Mvvm = ({userId}) => {
    const [user, setUser] = useState(null);

    const handleGetUser = () => {
        const user = DB.filter(item => {
            return item.id === userId;
        });

        setUser(user[0])
    }

    return (
        <View handleGetUser={handleGetUser} user={user} />
    )
}

export default Mvvm;