const express = require('express');
const app = express();
const path = require('path');
const port = 3000;
const db = require('./db');

app.use(express.static(path.join(__dirname, 'public')));

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'testsite.html'));
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
