const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root', // CHANGE THIS TO YOUR MYSQL USERNAME
  password: 'WhoNeedsThumbs?!2006', // change to your MySQL password
  database: 'transactions_sakila', // change to your MySQL database name
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err.stack);
    return;
  }
  console.log('Connected to MySQL as ID', connection.threadId);
});

module.exports = connection;
