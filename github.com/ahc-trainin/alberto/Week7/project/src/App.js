import React, {lazy, Suspense} from 'react';
import { BrowserRouter, Route, Routes, Link } from 'react-router-dom'
import { Collapse, Navbar, NavbarToggler, Nav, NavItem} from 'reactstrap'
import './App.css';

const Home = lazy(() => import('./components/Home'));
const About = lazy(() => import('./components/About'));
const Projects = lazy(() => import('./components/Projects'));
const Contact = lazy(() => import('./components/Contact'));

function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <Navbar color='light' light expand='md'>
          <NavbarToggler/>
          <Collapse navbar>
            <Nav className='ml-auto' navbar>
              <NavItem>
                <Link className='nav-link' to='/'>
                  Home
                </Link>
              </NavItem>
              <NavItem>
                <Link className='nav-link' to='/projects'>
                  Projects
                </Link>
              </NavItem>
              <NavItem>
                <Link className='nav-link' to='/about'>
                  About
                </Link>
              </NavItem>
              <NavItem>
                <Link className='nav-link' to='/contact'>
                  Contact
                </Link>
              </NavItem>
            </Nav>
          </Collapse>
        </Navbar>
        <Suspense fallback={<h1>Loading...</h1>}>
            <Routes>
              <Route element={<Home/>} path='/' exact/>
              <Route element={<Projects/>} path='/projects'/>
              <Route element={<About/>} path='/about'/>
              <Route element={<Contact/>} path='/contact'/>
            </Routes>
          </Suspense>
      </BrowserRouter>
    </div>
  );
}

export default App;
