import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import './Navigation.css';

const Navigation = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const location = useLocation();

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  const closeMenu = () => {
    setIsMenuOpen(false);
  };

  return (
    <nav className="navigation">
      <div className="nav-container">
        <Link to="/" className="nav-logo" onClick={closeMenu}>
          <span className="trafaret-font">союз композиторов и эвм</span>
        </Link>
        
        <div className={`nav-menu ${isMenuOpen ? 'active' : ''}`}>
          <Link 
            to="/manifest" 
            className={`nav-link ${location.pathname === '/manifest' ? 'active' : ''}`}
            onClick={closeMenu}
          >
            manifest
          </Link>
          <Link 
            to="/team" 
            className={`nav-link ${location.pathname === '/team' ? 'active' : ''}`}
            onClick={closeMenu}
          >
            team
          </Link>
          <Link 
            to="/events" 
            className={`nav-link ${location.pathname === '/events' ? 'active' : ''}`}
            onClick={closeMenu}
          >
            events
          </Link>
          <Link 
            to="/merch" 
            className={`nav-link ${location.pathname === '/merch' ? 'active' : ''}`}
            onClick={closeMenu}
          >
            merch
          </Link>
        </div>

        <div className="nav-toggle" onClick={toggleMenu}>
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>
    </nav>
  );
};

export default Navigation;
