package redis

import (
	"github.com/aaronkvanmeerten/resec/resec/state"
	"github.com/go-redis/redis"
	log "github.com/sirupsen/logrus"
)

type Manager struct {
	logger    *log.Entry       // logging specificall for Redis
	client    *redis.Client    // redis client
	config    *Config          // redis config
	state     *state.Redis     // redis state
	stateCh   chan state.Redis // redis state channel to publish updates to the reconciler
	commandCh chan Command
	stopCh    chan interface{}
}

type Config struct {
	Address string // address (IP+Port) used to talk to Redis
}
