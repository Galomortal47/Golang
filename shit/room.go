package main

import "net"

type roomm struct{
  name string
  menbers map[net.Addr]*client
}

func (r * room) broadcast(sender *client, msg string){
  for addr, m := range r.members{
    if addre != sender.conn.RemoteAddr(){
        m.msg(msg)
      }
    }
}
