import React, { useState } from 'react';

const DisplayComponent = ({ responseData }) => {
  // Your logic to display different content based on responseData

  // TODO: logic to turn data into the corresponding predominant emotion
  const handleResponseData = () => {
    let raw = responseData.data;
    if (raw == undefined){
      return 'Error: No data received';
    }
    if (raw == 'err1'){
      return 'Error: Arduino is not connected';
    }
    if (raw.slice(0, 2) != 'b:'){
      return 'Error: Invalid data received';
    }
    else{
      // should be in this format 'b: 0,40,51,284017,128944,41894,28099,10124,23677,1752,1289'

      // remove b
      let vals = raw.slice(2, raw.length);
      let split_vals = vals.split(',');
      
      // split_vals = ['0', '40', '51', '284017', '128944', '41894', '28099', '10124', '23677', '1752', '1289']

      let connection = split_vals[0].trim();
      let first = split_vals[1] / 100 ;
      let second = split_vals[2] / 100;
      let third = split_vals[3] / 2000000; 

      if (first > second && first > third){
        return 'Attention Detected';
      }
      else if (second > first && second > third){
        return 'Meditation Detected';
      }
      else if (third > first && third > second){
        return 'Dreamless Sleep Detected (maybe not lol)';
      }
      else{
        return 'ERROR: NO EMOTION DETECTED';
      }

    }
  }
  return (
    <div>
      <h1>{handleResponseData()}</h1>
      {/* <h1>{responseData.data}</h1> */}
      {/* Add more content based on your requirements */}
    </div>
  );
};

export default DisplayComponent;