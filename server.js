const express = require("express");
const bodyparser = require("body-parser");
const fs = require("fs");
const { exit } = require("process");
const X_LEN = 720 // Pixel Length in (X)
const Z_LEN = 720 // Pixel Length in (Y)

var app = express();

var content = ""

function notePixel(r, g, b){
    // Noting the pixel, so we can write it into file later
    content += `${r} ${g} ${b}\n`
}
// Use JSON Parser
app.use(bodyparser.json())

// Route that receives a POST request to /
app.post('/', function (req, res) {
    // No print / log statements here to increase speed, this function is called millions of times.
    const body = req.body

    const color_data = body.color // {r, g, b}

    for (var i = 0; i < Z_LEN; i ++){
        var row = color_data[i]

        var r = row[0]
        var g = row[1]
        var b = row[2]

        notePixel(r, g, b)
    }

    res.send(true)
})

app.post('/res', function(req, res){
    console.log("Sent the resolution", X_LEN, Z_LEN)
    res.send(`${X_LEN} ${Z_LEN}`)
})

app.post('/end', function(req, res){
    fs.writeFile('pixinfo.txt', content, err => {
        if (err) { throw err; }
    });
    console.log("Ended session")

    content = ''

    res.send("Image data recorded successfully")
})

// Tell our app to listen on port 3000
app.listen(3000, function (err) {
    if (err) {
        throw err;
    }

    console.log('Server started on port 3000')
})