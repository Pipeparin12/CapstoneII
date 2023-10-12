import express from "express";
import Product, { ProductSchema } from '../models/product';
const productRoute = express.Router();

productRoute.get('/all-product', async (req, res) => {
    try{
        const product = await Product.find();
        console.log(product)
        return res.json({
            product,
            success: true,
            message: 'Get product successfully!'
        });
    }catch(err){
        return res.json({
            success: false,
            message: err
        });
    }
});

productRoute.get('/:id', async (req, res) => {
    try{
        const product = await Product.findById(req.params.id);
        return res.json({
            product,
            success: true,
            message: 'Get detail successfully!'
        });
    }catch(err){
        return res.json({
            success: false,
            message: err
        });
    }
});

productRoute.get('/search/:key',async (req, res) => {
    try {
        let result = await Product.find({
            "$or": [{
                productName: {$regex: req.params.key}
            }]
        })
        res.send(result);
    } catch (err) {
        return res.json({
            success: false,
            message: err
        })
    }
})
export default productRoute;