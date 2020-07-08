package redis

import (
	"fmt"
	"github.com/garyburd/redigo/redis"
)

func Set(key string, value string){
  c, err := redis.Dial("tcp", "127.0.0.1:6379")
	_, err = c.Do("SET", key, value, "EX", "1")
	if err != nil {
		fmt.Println("redis set failed:", err)
	}
}

func Get(key string){
  c, err := redis.Dial("tcp", "127.0.0.1:6379")
	username, err := redis.String(c.Do("GET", key))
	if err != nil {
		fmt.Println("redis get failed:", err)
	} else {
		fmt.Printf("Get mykey: %v \n", username)
	}
}

func Flush(){
  c, err := redis.Dial("tcp", "127.0.0.1:6379")
	c.Flush()
	if err != nil {
		fmt.Println("redis get failed:", err)
	}
}
