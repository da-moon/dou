import './App.css';
import React, {useState, useEffect} from 'react';
import { Routes, Route } from 'react-router-dom';
import Menu from './componentes/menu/Menu';
import User from './componentes/user/User';
import Tabs from './componentes/tabs/Tabs';
import { getUser } from './componentes/common/Helpers';
import Skills from './componentes/skills/Skills';

function App() {
  const [user, setUser] = useState(null);

  useEffect(() => {
    const userLogged = getUser(1);
    setUser(userLogged);
  }, []);

  return (
    <React.Fragment>
      {
        user && (
          <React.Fragment>
            <Menu name={user.name} />
            <User user={user} />
          </React.Fragment>
        )
      }
      <Routes>
        <Route path='/' element={<Tabs />}>
            <Route index element={<Skills/>}></Route>
            <Route path='/approvals' element={<div>tab 2</div>}></Route>
            <Route path='/advanced-search' element={<div>tab 3</div>}></Route>
            <Route path='/search-profile' element={<div>tab 4</div>}></Route>
        </Route>
      </Routes>
    </React.Fragment>
  );
}

export default App;
