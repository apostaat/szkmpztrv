import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navigation from './components/Navigation';
import Home from './pages/Home';
import Manifest from './pages/Manifest';
import Team from './pages/Team';
import Events from './pages/Events';
import Merch from './pages/Merch';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Navigation />
        <main>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/manifest" element={<Manifest />} />
            <Route path="/team" element={<Team />} />
            <Route path="/events" element={<Events />} />
            <Route path="/merch" element={<Merch />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;
