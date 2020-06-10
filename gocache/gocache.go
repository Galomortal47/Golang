package main

import (
	"fmt"
	"github.com/patrickmn/go-cache"
	"time"
)

func main() {
	c := cache.New(1*time.Second, 3*time.Second)

	c.Set("foo", "bar", cache.DefaultExpiration)

	foo, found := c.Get("foo")
	if found {
		fmt.Println(foo.(string))
	}
}
