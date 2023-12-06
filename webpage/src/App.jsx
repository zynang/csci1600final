import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import PostComponent from './components/PostComponent';
import DisplayComponent from './components/DisplayComponent';


function App() {
  const [responseData, setResponseData] = useState('');

  const updateResponse = (data) => {
    setResponseData(data);
  };

  return (
    <div>
      <PostComponent updateResponse={updateResponse} />
      <DisplayComponent responseData={responseData} />
    </div>
  );
}

export default App;
