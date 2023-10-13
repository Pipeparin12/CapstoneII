import express from "express";
import Cart, { cartSchema } from '../models/cart';
import Product, { ProductSchema } from '../models/product';
import { User } from "@/database/models";
import product from "../models/product";
const cartRoute = express.Router();

cartRoute.post('/add-cart/:id', async (req,res) => {
    const quantity = req.body.quantity;
    // // Check if the user is authenticated (logged in)
    // if (!req.user) {
    //     return res.status(401).json({
    //         success: false,
    //         message: 'User not authenticated.'
    //     });
    // }

    // const user_id = req.user.user_id;

    // ลอง manual ดูก่อนใน postman
    const user_id = req.body.user_id;
    
    try {
        // const product_id = req.params.id;

        // ลอง manual ดูก่อนใน postman
        const product_id = req.body.product_id;

        // Fetch the product's price from the database
        const product = await Product.findById(product_id);

        if (!product) {
            return res.status(404).json({
                success: false,
                message: 'Product not found.'
            });
        }
        
        await Cart.create({
            'owner': user_id,
            "productId":product_id, 
            "quantity":quantity, 
            "productName":product.productName,
            "totalPrice": product.price,
            "status": "unpaid"
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

cartRoute.post('/checkout', async (req, res) => {
    // const user_id = req.user.user_id;

    // ลอง manual ดูก่อนใน postman
    const user_id = req.body.user_id;

    try {
        // Retrieve the user's cart
        const cart = await Cart.find({ owner: user_id });

        // Calculate the total price
        const totalPrice = cart.reduce((total, item) => {
            return total + item.price * item.quantity;
        }, 0);

        // Perform any additional checkout logic (e.g., payment processing)

        // Clear the user's cart after a successful checkout
        await Cart.deleteMany({ owner: user_id });

        return res.json({
            success: true,
            totalPrice,
            message: 'Checkout successful! order will be processing.'
        });
    } catch (err) {
        return res.json({
            success: false,
            message: err
        });
    }
});


cartRoute.get('/get-cart', async (req,res) => {
    try {
        const user = await req.user.user_id; 
        const name = await req.body.ProductName;
        const quantity = await req.body.quantity;     
        const cart = await Cart.find({ 'owner': user}).exec();
        const product = await Product.find({_id: {$in: cart.map((e) => e.productId)}}).exec();

        let serializedCart = JSON.parse(JSON.stringify(cart));
        let serializedProduct = JSON.parse(JSON.stringify(product));

        const carts = serializedCart.map(bm => ({ ...bm, product: serializedProduct.find(p => p._id === bm.productId)}));
        console.log(product);
        return res.json({
            carts,
            success: true,
            message: 'Get cart successfully!'
        });
    } catch (err) {
        return res.json({
            success: false,
            message: err
        });
    }
})

cartRoute.delete('/remove/:id', async (req,res) => {
    try {
        const cart = await Cart.findByIdAndDelete(req.params.id);
        return res.json({
            success: true,
            message: 'Delete cart successfully'
        })
    } catch (err) {
        return res.json({
            success: false,
            message: err
        })
    }
})

export default cartRoute;