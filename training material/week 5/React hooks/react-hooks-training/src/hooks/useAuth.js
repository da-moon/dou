import { useState } from "react";

function useAuth () {
    const [user, setUser] = useState(null);

    const login = (userEmail, password) => {
        // loginService.login(userEmail, password);
    }

    const logout = () => {
        // authService.logout(user);
    }

    const signUp = (userEmail, password) => {
        // authService.signUp(userEmail, password)
    }

    const refreshToken = () => {
        if(user) {
            // refresh user token
        }
        else {
            // no user logged in. Please login first
        }
    }

    return { login, logout, signUp, refreshToken, user };
}