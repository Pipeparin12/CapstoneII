import express from "express";
import Cart from '../models/cart';
import Product from '../models/product';
import Profile from '../models/profile';
import { AddOrderRequestProp, addOrderFunc } from "./order";
const cartRoute = express.Router();

cartRoute.post('/add-cart/', async (req, res) => {
    // ลอง manual ดูก่อนใน postman
    const user_id = req.body.user_id;

    const quantity = req.body.quantity;
    // Check if the user is authenticated (logged in)
    // if (!req.user) {
    //     return res.status(401).json({
    //         success: false,
    //         message: 'User not authenticated.'
    //     });
    // }

    // const user_id = req.user.user_id;

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
        } else if (product.quantity < quantity) {
            return res.status(400).json({
                success: false,
                message: 'Product quantity is not enough.'
            });
        }

        await Cart.create({
            'owner': user_id,
            "productId": product_id,
            "quantity": quantity,
            "productName": product.productName,
            "totalPrice": product.price * quantity,
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
        const userProfile = await Profile.findOne({ user: user_id })
        const cart = await Cart.find({ owner: user_id });
        const products = [];
        // Calculate the total price
        let totalPrice = 0;
        cart.map((item) => {
            products.push(item._id);
            totalPrice = totalPrice + item.totalPrice;
        });
        console.log(totalPrice);

        var addOrderDetail: AddOrderRequestProp = {
            owner: user_id,
            products: products,
            totalPrice: totalPrice as number,
            shippingInformation: {
                firstName: userProfile.firstName,
                lastName: userProfile.lastName,
                phone: userProfile.phone,
                address: userProfile.address
            },
            paymentInformation: {
                bankAccountNumber: "Something",
                bankName: "Something again"
            },
            status: {
                status: "Unpaid",
                description: ""
            }
        };
        // Perform any additional checkout logic (e.g., payment processing)
        // const addOrder = await fetch(`http://0.0.0.0:${process.env.SERVER_PORT}/order/add`, {
        //     method:"POST",
        //     headers: {
        //         "Content-Type" : "application/json"
        //     },
        //     body: JSON.stringify(addOrderDetail)
        // }).then(response => response.json())
        // .catch(error => {console.error("Error while fetching local API:", error);});
        const addOrder = addOrderFunc(addOrderDetail);
        console.log(addOrder)
        if(addOrder == null){
            return res.json({
                success: false,
                message: "Can't create order."
            });
        }
        // Clear the user's cart after a successful checkout
        await Cart.deleteMany({ owner: user_id });

        return res.json({
            success: true,
            message: 'Checkout successful! order will be processing.',
            // addOrder
        });
    } catch (err) {
        return res.json({
            success: false,
            message: err
        });
    }
});


cartRoute.get('/get-cart', async (req, res) => {
    try {
        // const user = await req.user.user_id;  
        const user_id = req.body.user_id;
        const cart = await Cart.find({ 'owner': user_id });
        // const product = await Product.find({_id: {$in: cart.map((e) => e.productId)}});

        // const serializedCart = JSON.parse(JSON.stringify(cart));
        // const serializedProduct = JSON.parse(JSON.stringify(product));

        // const carts = serializedCart.map(bm => ({ ...bm, product: serializedProduct.find(p => p._id === bm.productId)}));
        // console.log(product);
        return res.json({
            cart,
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

cartRoute.delete('/remove/:id', async (req, res) => {
    try {
        await Cart.findByIdAndDelete(req.params.id);
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