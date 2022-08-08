// Get the objects we need to modify
let addInvoiceForm = document.getElementById('add-invoice-form-ajax');

// Modify the objects we need
addInvoiceForm.addEventListener("submit", function (e) {
    
    // Prevent the form from submitting
    e.preventDefault();

    // Get form fields we need to get data from
    let inputDate = document.getElementById("input-date");
    let inputCustomer = document.getElementById("input-customer-ajax");


    // Get the values from the form fields
    let dateValue = inputDate.value;
    let customerValue = inputCustomer.value;

    // Put our data we want to send in a javascript object
    let data = {
        purchase_date: dateValue,
        customer_id: customerValue
    }
    
    // Setup our AJAX request
    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", "/add-invoice-ajax", true);
    xhttp.setRequestHeader("Content-type", "application/json");

    // Tell our AJAX request how to resolve
    xhttp.onreadystatechange = () => {
        if (xhttp.readyState == 4 && xhttp.status == 200) {

            // Add the new data to the table
            addRowToTable(xhttp.response);

            // Clear the input fields for another transaction
            inputDate.value = '';
            inputCustomer.value = '';
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
    let currentTable = document.getElementById("invoices-table");

    // Get the location where we should insert the new row (end of table)
    let newRowIndex = currentTable.rows.length;

    // Get a reference to the new row from the database query (last object)
    let parsedData = JSON.parse(data);
    let newRow = parsedData[parsedData.length - 1]

    // Create a row and 4 cells
    let row = document.createElement("TR");
    let idCell = document.createElement("TD");
    let dateCell = document.createElement("TD");
    let nameCell = document.createElement("TD");
    let emailCell = document.createElement("TD");



    // Fill the cells with correct data
    idCell.innerText = newRow.purchase_id;
    dateCell.innerText = newRow.purchase_date;
    nameCell.innerText = newRow.name;
    emailCell.innerText = newRow.email;

    // Add the cells to the row 
    row.appendChild(idCell);
    row.appendChild(dateCell);
    row.appendChild(nameCell);
    row.appendChild(emailCell);
    
    // Add a custom row attribute so the deleteRow function can find a newly added row
    row.setAttribute('data-value', newRow.customer_id);

    // Add the row to the table
    currentTable.appendChild(row);

    // Start of new Step 8 code for adding new data to the dropdown menu for updating people
    
    // Find drop down menu, create a new option, fill data in the option (full name, id),
    // then append option to drop down menu so newly created rows via ajax will be found in it without needing a refresh
    let selectMenu = document.getElementById("mySelect");
    let option = document.createElement("option");
    option.text = newRow.name;
    option.value = newRow.customer_id;
    selectMenu.add(option);
    // End of new step 8 code.
}