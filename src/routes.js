import express from 'express';
import users from './users.js';

const router = express.Router();

router.get('/', (req, res) => {
    res.send('Hello World!');
});

router.get('/users', users.getUsers);
router.post('/users/add/', users.addUsers);

    
export default router;
    
