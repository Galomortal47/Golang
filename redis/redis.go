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

func Get(key string) string {
  c, _ := redis.Dial("tcp", "127.0.0.1:6379")
	username, _ := redis.String(c.Do("GET", key))
	return username
}

func Flush(){
  c, err := redis.Dial("tcp", "127.0.0.1:6379")
	c.Flush()
	if err != nil {
		fmt.Println("redis get failed:", err)
	}
}
