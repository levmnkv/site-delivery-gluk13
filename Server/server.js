import express from 'express';

const app = express();

app.use(express.static('../client/dist'));

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../client/dist/index.html'));
});