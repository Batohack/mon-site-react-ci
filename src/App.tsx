import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Mon Super Site Déployé avec Jenkins + Docker + Slack !</h1>
        <p>Build du {new Date().toLocaleString()} - Commit: ${process.env.REACT_APP_GIT_COMMIT || 'local'}</p>
      </header>
    </div>
  );
}

export default App;
