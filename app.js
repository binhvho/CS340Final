// App.js

/*
    SETUP
*/
var express = require('express');   // We are using the express library for the web server
var app = express();            // We need to instantiate an express object to interact with the server in our code
PORT = 5395;                 // Set a port number at the top so it's easy to change in the future

// app.js
const { engine } = require('express-handlebars');
var exphbs = require('express-handlebars');     // Import express-handlebars
app.engine('.hbs', engine({ extname: ".hbs" }));  // Create an instance of the handlebars engine to process templates
app.set('view engine', '.hbs');                 // Tell express to use the handlebars engine whenever it encounters a *.hbs file.

// Database
var db = require('./database/db-connector')

// app.js - SETUP section
app.use(express.json())
app.use(express.urlencoded({ extended: true }))
app.use(express.static(__dirname + '/public'));         // this is needed to allow for the form to use the ccs style sheet/javscript


// app.js


/*
    ROUTES
*/
app.get('/', function (req, res) {
    res.render('index');
});

app.get('/customers', function (req, res) {
    let query1 = "SELECT * FROM Customers;";
    db.pool.query(query1, function (error, rows, fields) {
        res.render('customers', { data: rows });
    })
});

app.post('/add-customer-ajax', function (req, res) {
    // Capture the incoming data and parse it back to a JS object
    let data = req.body;


    // Create the query and run it on the database
    query1 = `INSERT INTO Customers (name, phone_num, birthday, email) VALUES ('${data.name}', '${data.phone_num}', '${data.birthday}', '${data.email}')`;
    db.pool.query(query1, function (error, rows, fields) {

        // Check to see if there was an error
        if (error) {

            // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
            console.log(error)
            res.sendStatus(400);
        }
        else {
            // If there was no error, perform a SELECT *
            query2 = `SELECT * FROM Customers`;
            db.pool.query(query2, function (error, rows, fields) {

                // If there was an error on the second query, send a 400
                if (error) {

                    // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
                    console.log(error);
                    res.sendStatus(400);
                }
                // If all went well, send the results of the query back.
                else {
                    res.send(rows);
                }
            })
        }
    })
});

app.delete('/delete-customer-ajax/', function(req,res,next){
    let data = req.body;
    let customerID = parseInt(data.customer_id);
    let deleteCustomer = `DELETE FROM Customers WHERE customer_id = ?`;
    
    db.pool.query(deleteCustomer, [customerID], function(error, rows, fields) {
  
        if (error) {
            console.log(error);
            res.sendStatus(400);
        } else {
            res.sendStatus(204);
        }
    })  
  });

app.get('/invoices', function (req, res) {
    let query1 = "SELECT purchase_id, purchase_date, Customers.name, Customers.email FROM Invoices LEFT JOIN Customers ON Invoices.customer_id = Customers.customer_id ORDER BY purchase_id";
    
    db.pool.query(query1, function (error, rows, fields) {

        let invoices = rows
        let query2 = "SELECT * FROM Customers;"
        
        db.pool.query(query2, function (error, rows, fields) {

            let customers = rows
            res.render('invoices', {data: invoices, customers: customers})
    
        })

    })
});

app.post('/add-invoice-ajax', function (req, res) {
    // Capture the incoming data and parse it back to a JS object
    let data = req.body;

    // Create the query and run it on the database
    query1 = `INSERT INTO Invoices (purchase_date, customer_id) VALUES ('${data.purchase_date}', '${data.customer_id}')`;
    db.pool.query(query1, function (error, rows, fields) {

        // Check to see if there was an error
        if (error) {

            // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
            console.log(error)
            res.sendStatus(400);
        }
        else {
            // If there was no error, perform a SELECT *
            query2 = "SELECT purchase_id, purchase_date, Customers.name, Customers.email FROM Invoices LEFT JOIN Customers ON Invoices.customer_id = Customers.customer_id ORDER BY purchase_id";
            db.pool.query(query2, function (error, rows, fields) {

                // If there was an error on the second query, send a 400
                if (error) {

                    // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
                    console.log(error);
                    res.sendStatus(400);
                }
                // If all went well, send the results of the query back.
                else {
                    res.send(rows);
                }
            })
        }
    })
});

app.get('/invoice_lines', function (req, res) {
    let query1 = "SELECT invoiceline_id, Invoices.purchase_id, CardGames.title, purchase_qty, line_cost FROM Invoices LEFT JOIN InvoiceLines ON Invoices.purchase_id = InvoiceLines.purchase_id LEFT JOIN CardGames ON InvoiceLines.cardgame_id = CardGames.cardgame_id ORDER BY invoiceline_id";
    
    db.pool.query(query1, function (error, rows, fields) {

        let invoiceLines = rows
        let query2 = "SELECT purchase_id, purchase_date, Customers.name, Customers.email FROM Invoices LEFT JOIN Customers ON Invoices.customer_id = Customers.customer_id ORDER BY purchase_id"
        
        db.pool.query(query2, function (error, rows, fields) {

            let invoices = rows
            let query3 = "SELECT * FROM CardGames"
    
            db.pool.query(query3, function (error, rows, fields) {
                let cardGames = rows
                res.render('invoice_lines', {invoiceLines: invoiceLines, invoices: invoices, cardGames: cardGames})
            })

        })
    })
});


app.post('/add-invoice-lines-ajax', function (req, res) {
    // Capture the incoming data and parse it back to a JS object
    let data = req.body;

    // Create the query and run it on the database
    query1 = `INSERT INTO InvoiceLines (purchase_qty, line_cost, cardgame_id, purchase_id) VALUES (${data.purchase_qty}, ${data.line_cost}, ${data.cardgame_id}, ${data.purchase_id})`;
    db.pool.query(query1, function (error, rows, fields) {

        // Check to see if there was an error
        if (error) {

            // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
            console.log(error)
            res.sendStatus(400);
        }
        else {
            // If there was no error, perform a SELECT *
            query2 = "SELECT invoiceline_id, Invoices.purchase_id, CardGames.title, purchase_qty, line_cost FROM Invoices LEFT JOIN InvoiceLines ON Invoices.purchase_id = InvoiceLines.purchase_id LEFT JOIN CardGames ON InvoiceLines.cardgame_id = CardGames.cardgame_id ORDER BY invoiceline_id";
            db.pool.query(query2, function (error, rows, fields) {

                // If there was an error on the second query, send a 400
                if (error) {

                    // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
                    console.log(error);
                    res.sendStatus(400);
                }
                // If all went well, send the results of the query back.
                else {
                    res.send(rows);
                }
            })
        }
    })
});

/*
    LISTENER
*/
app.listen(PORT, function () {
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});
