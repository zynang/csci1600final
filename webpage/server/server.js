// server.js
import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';

const app = express();
const port = 8000;

app.use(cors());
app.use(bodyParser.json());

const brainWaveData = ['test']
app.post('/test', (req, res) => {
    const d = new Date();
    let time = d.getTime();
    const data = req.body;
  // Your logic to handle the POST request and send a response
    const responseData = {
        message: "Hello, World!",
    // Add more data as needed
    };

  res.json(responseData);
//   console.log('posted')
});

app.post('/brain', (req, res) => {
    const receivedData = req.body;
    
    const responseData = {
        data: receivedData.data
    }
    // console.log(responseData.data)
    brainWaveData.push(responseData.data)
    res.json(responseData);
})

app.get('/getBrain', (req, res) => {
    const responseData = {
        data: brainWaveData[brainWaveData.length - 1]

    }
    res.json(responseData)
})

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
