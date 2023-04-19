import "./App.css";
import React, {lazy, Suspense} from "react";
import logo from "./logo.svg";
import { BrowserRouter, Route, Routes, Link } from "react-router-dom";
import {
  Collapse,
  Navbar,
  NavbarToggler,
  Nav,
  NavItem,
  NavbarBrand,
} from "reactstrap";
import Page404 from "./components/Page404";
const Home = lazy(() =>
  import('./components/Home'));
const About = lazy(() => {
  return new Promise(resolve => {
  setTimeout(() => resolve(import('./components/About')), 3000);
  });
});

function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <Navbar color="light" light expand="md">
          <NavbarBrand href="/">
            <img src={logo} className="App-logo" alt="logo" />
          </NavbarBrand>
          <NavbarToggler />
          <Collapse navbar>
            <Nav className="ml-auto" navbar>
              <NavItem>
                <Link className="nav-link" to="/">
                  Home
                </Link>
              </NavItem>
              <NavItem>
                <Link className="nav-link" to="/about">
                  About
                </Link>
              </NavItem>
            </Nav>
          </Collapse>
        </Navbar>
        <Suspense fallback={<h1>Loading...</h1>}> 
          <Routes>
            <Route element={<Home />} path="/" exact />
            <Route element={<About />} path="/about" />
            <Route element={<Page404 />} path="*" />
          </Routes>
        </Suspense>
      </BrowserRouter>
    </div>
  );
}

export default App;
