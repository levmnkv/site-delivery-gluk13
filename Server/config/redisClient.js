import dotenv from 'dotenv';
import Redis from 'ioredis';

dotenv.config();

let redisClientInstance = null;

const createRedisClient = () => {
  const redisUrl = process.env.REDIS_URL;
  
  if (redisUrl) {
    return new Redis(redisUrl, {
      connectTimeout: 5000,
      retryDelayOnFailover: 100,
      maxRetriesPerRequest: 2,
      lazyConnect: true,
      showFriendlyErrorStack: true,
    });
  } else {
    return new Redis({
      host: 'localhost',
      port: 6379,
      connectTimeout: 5000,
      lazyConnect: true,
    });
  }
};

const getRedisClient = () => {
  if (!redisClientInstance) {
    redisClientInstance = createRedisClient();
    
    redisClientInstance.on('connect', () => {
      console.log('Redis клиент подключён');
    });
    
    redisClientInstance.on('error', (err) => {
      console.error('Redis ошибка:', err.message);
    });
  }
  
  return redisClientInstance;
};

export const testRedisConnection = async () => {
  try {
    const client = getRedisClient();
    await client.ping();
    console.log('Redis доступен');
    return true;
  } catch (error) {
    console.error('Redis недоступен:', error.message);
    return false;
  }
};

export default getRedisClient;
