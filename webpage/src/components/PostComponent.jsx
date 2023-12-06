// src/components/PostComponent.js
import React, { useState } from 'react';

const PostComponent = ({ updateResponse }) => {
  const sendData = async () => {
    try {
      const response = await fetch('http://localhost:8000/test', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(),
      });

      const data = await response.json();
      updateResponse(data);
    } catch (error) {
      console.error('Error:', error);
    }
  };
  const sendBrain = async () => {
    try{
      const response = await fetch('http://localhost:8000/brain', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ "data": Math.random() }),
      });
      // console.log(response));
    } catch (error) {
      console.error('Error:', error)
    }
  }

  const getBrain = async () => {
    try {
      const response = await fetch('http://localhost:8000/getBrain', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        }}).then(response => response.json())
        .then(data => {
          updateResponse(data);
          console.log(data)}
          );
    } catch (error){
      console.error('Error:', error)
    }
  }

  return (
    <div>
      {/* {window.setInterval(sendData, 10000)} */}
      {/* <button onClick={sendData}>Send POST Request</button> */}
      <button onClick={sendBrain}>Send Brain Data mock</button>
      <button onClick={getBrain}>Get Brain Data</button>
    </div>
  );
};

export default PostComponent;
