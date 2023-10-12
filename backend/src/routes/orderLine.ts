import express from "express";
import OrderLine, { orderLineSchema } from '../models/orderLine';
import Product, { ProductSchema } from '../models/product';
import { User } from "@/database/models";
import product from "../models/product";
const orderLineRoute = express.Router();

orderLineRoute.post('/add-order/:id', async (req,res) => {
    const quantity = req.body.quantity;
    const user_id = req.user.user_id;
    const price = req.body.price;
    
    try {
        const product_id = req.params.id;
        const name = req.body.productName;
        
        await OrderLine.create({
            'owner': user_id,
            "productId":product_id, 
            "quantity":quantity, 
            "productName":name,
            "price": price
        });        
        return res.json({
            success: true,
            message: 'Added to cart successfully'
        })
    } catch (err) {
        return res.json({
            success: false,
            message: err
        })
    }
})

orderLineRoute.post('/checkout', async (req, res) => {
    const user_id = req.user.user_id;

    try {
        // Retrieve the user's cart
        const cart = await OrderLine.find({ owner: user_id });

        // Calculate the total price
        const totalPrice = cart.reduce((total, item) => {
            return total + item.price * item.quantity;
        }, 0);

        // Perform any additional checkout logic (e.g., payment processing)

        // Clear the user's cart after a successful checkout
        await OrderLine.deleteMany({ owner: user_id });

        return res.json({
            success: true,
            totalPrice,
            message: 'Checkout successful! Orders will be processing.'
        });
    } catch (err) {
        return res.json({
            success: false,
            message: err
        });
    }
});


orderLineRoute.get('/get-cart', async (req,res) => {
    try {
        const user = await req.user.user_id; 
        const name = await req.body.ProductName;
        const quantity = await req.body.quantity;     
        const order = await OrderLine.find({ 'owner': user}).exec();
        const product = await Product.find({_id: {$in: order.map((e) => e.productId)}}).exec();

        let serializedCart = JSON.parse(JSON.stringify(order));
        let serializedProduct = JSON.parse(JSON.stringify(product));

        const carts = serializedCart.map(bm => ({ ...bm, product: serializedProduct.find(p => p._id === bm.productId)}));
        console.log(product);
        return res.json({
            carts,
            success: true,
            message: 'Get order successfully!'
        });
    } catch (err) {
        return res.json({
            success: false,
            message: err
        });
    }
})

orderLineRoute.delete('/remove/:id', async (req,res) => {
    try {
        const order = await OrderLine.findByIdAndDelete(req.params.id);
        return res.json({
            success: true,
            message: 'Delete order successfully'
        })
    } catch (err) {
        return res.json({
            success: false,
            message: err
        })
    }
})

export default orderLineRoute;