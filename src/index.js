import express from 'express';
import morgan from 'morgan'
import router from './routes.js';

const app = express();
const PORT = 80;

app.use(morgan('dev'));
app.use(router);

app.listen(PORT, async () => {
    console.log(`Server is running ...`);
}); 