import pg from 'pg';
import 'dotenv/config';

const { Pool } = pg;

const isDocker = process.env.DOCKER_ENV === 'true';
const dbHost = process.env.DB_HOST || process.env.PGHOST || (isDocker ? 'postgres' : 'localhost');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

pool.on('connect', () => {
  console.log('Успешное подключение к БД!');
});

pool.on('error', (err) => {
  console.error('Ошибка соединения с БД:', err);
});

const testConnection = async () => {
  try {
    const client = await pool.connect();
    console.log('База данных подключена успешно!');
    client.release();
  } catch (error) {
    console.error('Ошибка подключения к БД:', error.message);
  }
};

testConnection();

export default pool;
