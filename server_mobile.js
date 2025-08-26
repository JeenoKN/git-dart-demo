const con = require('./db');
const express = require('express');
const bcrypt = require('bcrypt');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// password generator
app.get('/password/:pass', (req, res) => {
  const password = req.params.pass;
  bcrypt.hash(password, 10, function(err, hash) {
    if (err) {
      return res.status(500).send('Hashing error');
    }
    res.send(hash);
  });
});

// login
app.post('/login', (req, res) => {
  const {username, password} = req.body;
  const sql = "SELECT id, password FROM users WHERE username = ?";
  con.query(sql, [username], function(err, results) {
    if (err) {
      return res.status(500).send("Database server error");
    }
    if (results.length != 1) {
      return res.status(401).send("Wrong username");
    }
    bcrypt.compare(password, results[0].password, function(err, same) {
      if (err) {
        return res.status(500).send("Hashing error");
      }
      if (same) {
        return res.send("Login OK");
      }
      return res.status(401).send("Wrong password");
    });
  });
});

// register
app.post('/register', (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).send("Missing username or password");
  }

  const checkUserSql = "SELECT id FROM users WHERE username = ?";
  con.query(checkUserSql, [username], function (err, results) {
    if (err) {
      return res.status(500).send("Database server error");
    }
    if (results.length > 0) {
      return res.status(409).send("Username already taken");
    }

    bcrypt.hash(password, 10, function (err, hash) {
      if (err) {
        return res.status(500).send("Hashing error");
      }

      const insertSql = "INSERT INTO users (username, password) VALUES (?, ?)";
      con.query(insertSql, [username, hash], function (err, result) {
        if (err) {
          return res.status(500).send("Database insert error");
        }
        res.send("Register OK");
      });
    });
  });
});

// Get user ID
app.get('/userid', (req, res) => {
  const { username } = req.query;
  const sql = "SELECT id FROM users WHERE username = ?";
  con.query(sql, [username], function (err, results) {
    if (err || results.length != 1) {
      return res.status(500).send("User not found");
    }
    res.json({ id: results[0].id });
  });
});

// Get all expenses for a user
app.get('/expenses', (req, res) => {
  const { user_id } = req.query;
  const sql = "SELECT item, paid, date FROM expense WHERE user_id = ?";
  con.query(sql, [user_id], function (err, results) {
    if (err) {
      return res.status(500).send("Database error");
    }
    res.json(results);
  });
});

// Get today's expenses for a user
app.get('/todayexpenses', (req, res) => {
  const { user_id } = req.query;
  const today = new Date().toISOString().split('T')[0];
  const sql = "SELECT item, paid, date FROM expense WHERE user_id = ? AND DATE(date) = ?";
  con.query(sql, [user_id, today], function (err, results) {
    if (err) {
      return res.status(500).send("Database error");
    }
    res.json(results);
  });
});

<<<<<<< HEAD
<<<<<<< HEAD
// Search expenses by item
app.get('/search', (req, res) => {
  const { user_id, item } = req.query;
  const sql = "SELECT item, paid, date FROM expense WHERE user_id = ? AND item LIKE ?";
  con.query(sql, [user_id, `%${item}%`], function (err, results) {
    if (err) {
      return res.status(500).send("Database error");
    }
    res.json(results);
  });
});

<<<<<<< Updated upstream
=======
// Search expenses by item
app.get('/search', (req, res) => {
  const { user_id, item } = req.query;
  const sql = "SELECT item, paid, date FROM expense WHERE user_id = ? AND item LIKE ?";
  con.query(sql, [user_id, `%${item}%`], function (err, results) {
    if (err) {
      return res.status(500).send("Database error");
    }
    res.json(results);
  });
});
// Add new expense
app.post('/addexpense', (req, res) => {
  const { user_id, item, paid, date } = req.body;
  const sql = "INSERT INTO expense (user_id, item, paid, date) VALUES (?, ?, ?, ?)";
  con.query(sql, [user_id, item, paid, date], function (err, result) {
    if (err) {
      return res.status(500).send("Database insert error");
    }
    res.sendStatus(200);
  });
});
>>>>>>> Stashed changes
=======
>>>>>>> parent of 5d0bc9f (Merge pull request #3 from JeenoKN/Search-expense)
=======
>>>>>>> parent of 5d0bc9f (Merge pull request #3 from JeenoKN/Search-expense)
// Server starts here
const PORT = 3000;
app.listen(PORT, () => {
  console.log('Server is running at ' + PORT);
});