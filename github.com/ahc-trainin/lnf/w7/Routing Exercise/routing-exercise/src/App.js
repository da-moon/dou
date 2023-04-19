import './App.css';
import React, { lazy, Suspense } from 'react';
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';

import Home from './components/Home';
import Portfolio from './components/Portfolio';
import Weddings from './components/Weddings';
import Contact from './components/Contact';
import Page404 from './components/Page404';

function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <nav class="links">
          <Link className="nav-link" to="/">
            Home
          </Link>
          <Link className="nav-link" to="/Portfolio">
            Portfolio
          </Link>
          <Link className="nav-link" to="/Weddings">
            Weddings
          </Link>
          <Link className="nav-link" to="/Contact">
            Contact
          </Link>
        </nav>
        <Suspense fallback={<h1>Loading...</h1>}>
          <Routes>
            <Route element={<Home />} exact path="/" />
            <Route element={<Portfolio />} path="/Portfolio" />
            <Route element={<Weddings />} path="/Weddings" />
            <Route element={<Contact />} path="/Contact" />
            <Route element={<Page404 />} path="*" />
          </Routes>
        </Suspense>
      </BrowserRouter>
    </div>
  );
}

export default App;
