import React from 'react';
import './Team.css';

const Team = () => {
  const teamMembers = [
    {
      id: 'apostaat',
      name: 'artem apostatov',
      alias: 'ap0$taat',
      role: 'music producer',
      background: 'academic jurisprudence, functional programming',
      inspiration: 'spectralism, minimalism, parametric composition',
      instrument: 'roland sp404-mk2',
      style: 'idm/experimental',
      hasImage: true
    },
    {
      id: 'chris',
      name: 'christian gorski',
      alias: 'chris',
      role: 'visual artist',
      background: 'math',
      inspiration: 'punk culture',
      instrument: 'touchdesigner',
      style: 'glitch',
      hasImage: true
    },
    {
      id: 'coff',
      name: 'dmitry baykof',
      alias: 'c0ff',
      role: 'music producer',
      background: 'c++ programming, modular synthesis',
      inspiration: 'spectralism, minimalism, parametric composition',
      instrument: 'roland sp404-mk2',
      style: 'idm/experimental/drone ambient',
      hasImage: true
    },
    {
      id: 'vdovina',
      name: 'vdovina ekaterina',
      role: 'animation director',
      background: 'math',
      inspiration: '',
      instrument: '',
      style: '',
      hasImage: true
    },
    {
      id: 'w96k',
      name: 'w96k',
      role: '',
      background: '',
      inspiration: '',
      instrument: '',
      style: '',
      hasImage: false
    }
  ];

  return (
    <div className="team">
      <div className="container">
        <h1 className="page-title">team</h1>
        
        <div className="team-grid">
          {teamMembers.map((member) => (
            <div key={member.id} className="team-member">
              <div className="member-photo">
                {member.hasImage ? (
                  <img 
                    src={`/team/${member.id}.jpg`} 
                    alt={member.name}
                    onError={(e) => {
                      e.target.style.display = 'none';
                      e.target.nextSibling.style.display = 'flex';
                    }}
                  />
                  <div className="photo-placeholder" style={{ display: 'none' }}>
                    <span className="trafaret-font">союз композиторов и эвм</span>
                  </div>
                ) : (
                  <div className="photo-placeholder">
                    <span className="trafaret-font">союз композиторов и эвм</span>
                  </div>
                )}
              </div>
              
              <div className="member-info">
                <h3 className="member-name">{member.name}</h3>
                {member.alias && <p className="member-alias">aka {member.alias}</p>}
                {member.role && <p className="member-role">{member.role}</p>}
                
                {member.background && (
                  <div className="member-detail">
                    <strong>background:</strong> {member.background}
                  </div>
                )}
                
                {member.inspiration && (
                  <div className="member-detail">
                    <strong>source of inspiration:</strong> {member.inspiration}
                  </div>
                )}
                
                {member.instrument && (
                  <div className="member-detail">
                    <strong>favourite instrument:</strong> {member.instrument}
                  </div>
                )}
                
                {member.style && (
                  <div className="member-detail">
                    <strong>style:</strong> {member.style}
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Team;
