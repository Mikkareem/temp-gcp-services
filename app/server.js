const http = require('http')
const port = 8080

// Always fails with 401 - Unauthorized
const server = http.createServer((req, res) => {
  if(req.url.includes("success")) {
    res.writeHead(200, { 'Content-Type': 'application/json' })
    const response = JSON.stringify({ name: "Irsath", company: "Google", status: 'PASS' })
    res.write(response)
    res.end()
  } else {
    res.writeHead(401, { 'Content-Type': 'application/json' })
    const response = JSON.stringify({ name: "Irsath", company: "Google", status: "FAIL" })
    res.write(response)
    res.end()
  }
})

server.listen(port, (err) => {
  if(err) {
    console.log("Server not started with Error, ", err)
  }
})