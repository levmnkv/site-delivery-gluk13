import { Pool } from 'pg';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

async function runMigrations() {
  const client = await pool.connect();
  
  try {
    console.log('🚀 Запуск миграций...');
    
    // Проверяем подключение к какой базе
    const dbResult = await client.query('SELECT current_database()');
    console.log('📊 Текущая база данных:', dbResult.rows[0].current_database);
    
    // Создаем таблицу для отслеживания миграций
    await client.query(`
      CREATE TABLE IF NOT EXISTS migrations (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL UNIQUE,
        executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Получаем выполненные миграции
    const { rows: executedMigrations } = await client.query(
      'SELECT name FROM migrations ORDER BY name'
    );
    
    const executedNames = new Set(executedMigrations.map(m => m.name));
    
    // Читаем файлы миграций
    const migrationsDir = path.join(__dirname, '../migrations');
    const files = fs.readdirSync(migrationsDir)
      .filter(file => file.endsWith('.sql'))
      .sort();
    
    console.log(`📁 Найдено ${files.length} файлов миграций`);
    
    for (const file of files) {
      if (!executedNames.has(file)) {
        console.log(`\n📦 Выполняем миграцию: ${file}`);
        
        const migrationPath = path.join(migrationsDir, file);
        const sql = fs.readFileSync(migrationPath, 'utf8');
        
        // Разделяем SQL на отдельные запросы
        const queries = sql.split(';').filter(q => q.trim().length > 0);
        
        for (let i = 0; i < queries.length; i++) {
          const query = queries[i].trim();
          if (query) {
            try {
              await client.query(query + ';');
              console.log(`   ✅ Запрос ${i + 1} выполнен`);
            } catch (error) {
              console.error(`   ❌ Ошибка в запросе ${i + 1}:`, error.message);
              // Продолжаем выполнение следующих миграций
              continue;
            }
          }
        }
        
        await client.query(
          'INSERT INTO migrations (name) VALUES ($1)',
          [file]
        );
        
        console.log(`✅ Миграция ${file} завершена`);
      } else {
        console.log(`⏭️ Миграция ${file} уже выполнена`);
      }
    }
    
    console.log('\n🎉 Все миграции завершены!');
    
  } catch (error) {
    console.error('❌ Критическая ошибка при выполнении миграций:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

// Запускаем миграции
runMigrations().then(() => {
  console.log('Миграции завершены');
  process.exit(0);
}).catch(error => {
  console.error('Неустранимая ошибка:', error);
  process.exit(1);
});