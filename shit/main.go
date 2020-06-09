package main

func main(){
  s := newServer()
  go s.run()

  listener, err := net.Listener("tcp", ":8888")
  if err != nil{
    log.Fatalf("unable to start server: %s", err.Error())
  }
  defer listener.Close()
  log.Printf("started server on :8888")

  for{
    conn, err := listener.Accept()
    if err != nil{
      log.Printf("unnable to accept connection: %s", err.Error())
      continue
    }
    go s.newClient(conn)
  }
}
