package main

import "net"
import "fmt"
//import "bufio"
//import "strings" // only needed below for sample processing
//import "time"

func main() {

  fmt.Println("Launching server...")

  // listen on all interfaces
  ln, _ := net.Listen("tcp", ":8081")

  // accept connection on port
  conn, _ := ln.Accept()

  // run loop forever (or until ctrl-c)
  for {
    // will listen for message to process ending in newline (\n)
    buf := make([]byte, 1024)
    n, _ := conn.Read(buf)
    // output message received
    //fmt.Print(string(message))
    // sample process for string received
    //newmessage := strings.ToUpper(message)
    // send new string back to client
    conn.Write(buf[0:n])
    //time.Sleep(time.Second / 60)
  }
}
