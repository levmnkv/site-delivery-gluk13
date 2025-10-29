import express from 'express';
import cors from 'cors'; 
import path from 'path'; 
import 'dotenv/config'; 

import productsRoutes from './routes/products/products.js';
import authRoutes from './routes/auth/login.js'; 
import cartRoutes from './routes/cart/cartRoutes.js'
import favorRoutes from './routes/favour/favorRoutes.js'
import orderRoutes from './routes/orders/orders.js'
import adminOrdersRoutes from './routes/orders/admin-orders.js'
import { authenticateToken } from './middleware/auth.js';
import { checkoutRole } from './middleware/role.js'
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();

//Middleware
const corsOptions = {
    origin: function (origin, callback) {
      // Разрешаем запросы без origin (например, из мобильных приложений)
      if (!origin) return callback(null, true);
      
      // Разрешенные домены
      const allowedOrigins = [
        'http://localhost:3000',
        'http://localhost:5173',
        'https://site-delivery-z5i5.vercel.app',
        'https://site-delivery-z5i5-*.vercel.app',
        'https://site-delivery-production-a039.up.railway.app'
      ];
      
      if (allowedOrigins.indexOf(origin) !== -1 || origin.endsWith('.vercel.app')) {
        callback(null, true);
      } else {
        callback(new Error('CORS not allowed'));
      }
    },
    credentials: true, // ✅ ВКЛЮЧИТЬ для работы с cookies/tokens
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
    optionsSuccessStatus: 200
  };
  
app.use(cors(corsOptions));
app.use(express.json());

// ✅ ДОБАВЬТЕ обработку preflight запросов
app.options('*', cors(corsOptions));
app.use(express.json());

//Routes
app.use('/api/products', productsRoutes);
app.use('/api/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/api/users', authRoutes);
app.use('/api/cart',authenticateToken, cartRoutes);
app.use('/api/favorites',authenticateToken, favorRoutes);
app.use('/api/orders',authenticateToken, orderRoutes);
app.use('/api/orders',authenticateToken, checkoutRole, adminOrdersRoutes);


app.get('/api/test', (req, res) => {
    res.json ({messege: 'Сервер работает!'});
})

app.get('/health', (req, res) => {
    res.status(200).json({ 
      status: 'OK', 
      timestamp: new Date().toISOString(),
      service: 'Express API'
    });
  });
  
// ✅ ДОБАВЬТЕ обработку корневого пути
app.get('/', (req, res) => {
res.json({ 
    message: 'Food Delivery API', 
    endpoints: {
    test: '/api/test',
    health: '/health',
    products: '/api/products',
    auth: '/api/users'
    }
});
});

export default app;

