// Get the objects we need to modify
let addInvoiceForm = document.getElementById('add-invoice-lines-form-ajax');

// Modify the objects we need
addInvoiceForm.addEventListener("submit", function (e) {
    
    // Prevent the form from submitting
    e.preventDefault();

    // Get form fields we need to get data from
    let inputInvoice = document.getElementById("input-invoice-ajax");
    let inputGame = document.getElementById("input-game-ajax");
    let inputQuantity = document.getElementById("input-qty");
    console.log(inputGame.value)

    // Get the values from the form fields
    let invoiceValue = inputInvoice.value;
    let index = 0
    for (var i = 0; i < inputGame.value.length; i++) {
        if (inputGame.value.charAt(i) == ',') {
            index = i
            break
        }
    }
    console.log(typeof index, index)
    let gameValue = inputGame.value.slice(0, index);
    let qtyValue = inputQuantity.value;
    let costValue = inputGame.value.slice(index+1)
    let lineCost = parseFloat(qtyValue) * parseFloat(costValue)


    // Put our data we want to send in a javascript object
    let data = {
        purchase_id: invoiceValue,
        cardgame_id: gameValue,
        purchase_qty: qtyValue,
        line_cost: lineCost
    }

    console.log(data)
    
    // Setup our AJAX request
    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", "/add-invoice-lines-ajax", true);
    xhttp.setRequestHeader("Content-type", "application/json");

    // Tell our AJAX request how to resolve
    xhttp.onreadystatechange = () => {
        if (xhttp.readyState == 4 && xhttp.status == 200) {

            // Add the new data to the table
            addRowToTable(xhttp.response);
            
        }
        else if (xhttp.readyState == 4 && xhttp.status != 200) {
            console.log("There was an error with the input.")
        }
    }

    // Send the request and wait for the response
    xhttp.send(JSON.stringify(data));

})



// Creates a single row from an Object representing a single record
addRowToTable = (data) => {

    // Get a reference to the current table on the page and clear it out.
    let currentTable = document.getElementById("invoice-lines-table");

    // Get the location where we should insert the new row (end of table)
    let newRowIndex = currentTable.rows.length;

    // Get a reference to the new row from the database query (last object)
    let parsedData = JSON.parse(data);
    let newRow = parsedData[parsedData.length - 1]

    // Create a row and 4 cells
    let row = document.createElement("TR");
    let idCell = document.createElement("TD");
    let invoiceCell = document.createElement("TD");
    let titleCell = document.createElement("TD");
    let qtyCell = document.createElement("TD");
    let costCell = document.createElement("TD");



    // Fill the cells with correct data
    idCell.innerText = newRow.invoiceline_id;
    invoiceCell.innerText = newRow.purchase_id;
    titleCell.innerText = newRow.title;
    qtyCell.innerText = newRow.purchase_qty;
    costCell.innerText = newRow.line_cost;

    // Add the cells to the row 
    row.appendChild(idCell);
    row.appendChild(invoiceCell);
    row.appendChild(titleCell);
    row.appendChild(qtyCell);
    row.appendChild(costCell);

    // Add the row to the table
    currentTable.appendChild(row);
}