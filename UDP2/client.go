package main

import (
    "fmt"
    "net"
    "time"
    "strconv"
    "encoding/json"
  //  "math/rand"
)

var parsed interface{}

var id = 0

type User struct {
    Id     string `json:"id"`
    Data   string `json:"data"`
}

func CheckError(err error) {
    if err  != nil {
        fmt.Println("Error: " , err)
    }
}

func main() {
  for i := 0; i < 100; i++ {
      id = i
      go send_data(id)
    }
    fmt.Println("initialize")
    time.Sleep(300 * time.Second)
}

func send_data(id2 int){
    ServerAddr,err := net.ResolveUDPAddr("udp","127.0.0.1:10001")
    CheckError(err)

    LocalAddr, err := net.ResolveUDPAddr("udp", "127.0.0.1:0")
    CheckError(err)

    Conn, err := net.DialUDP("udp", LocalAddr, ServerAddr)
    CheckError(err)

    defer Conn.Close()
    i := 0
    for {
      id3 := strconv.Itoa(id2)
      app := User{id3,"test"}
      data, _ := json.Marshal(app)
      //json.Unmarshal(data, &parsed)
      //fmt.Println(parsed)
        msg := strconv.Itoa(i)
        i++
        buf := []byte(data)
        garbage := make([]byte,8)
        garbage2 := make([]byte,1)
        send := append(garbage,buf...)
        send2 := append(send,garbage2...)
        _,err := Conn.Write(send2)
      //  fmt.Println(string(data))
        if err != nil {
            fmt.Println(msg, err)
        }
        time.Sleep(time.Second / 60)
    }
}
