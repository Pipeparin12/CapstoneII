import express from "express";
import Cart from '../models/cart';
import Product from '../models/product';
import Profile from '../models/profile';
import { AddOrderRequestProp, addOrderFunc } from "./order";
import order from "@/models/order";
const cartRoute = express.Router();

cartRoute.post('/add-cart/:id', async (req, res) => {
    const user_id = req.user.user_id;
    const size = req.body.size
    const quantity = req.body.quantity;
    if (!req.user) {
        return res.status(401).json({
            success: false,
            message: 'User not authenticated.'
        });
    }

    try {
        const product_id = req.params.id;
        const product = await Product.findById(product_id);
        console.log(product)

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
            "size": size,
            "quantity": quantity,
            "productName": product.productName,
            "productImage": product.productImage,
            "price": product.price,
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
    const user_id = req.user.user_id;

    const currentTimestamp = Date.now(); 

    try {
        const userProfile = await Profile.findOne({ user: user_id })
        const cart = await Cart.find({ owner: user_id });
        const products = [];
        let totalPrice = 0;
        cart.map((cart) => {
            products.push({
                productId: cart.productId,
                productName: cart.productName,
                productImage: cart.productImage,
                size: cart.size,
                quantity: cart.quantity,
                totalPrice: cart.totalPrice
              });
          });

        var addOrderDetail: AddOrderRequestProp = {
            owner: user_id,
            products: products,
            totalPrice: 0,
            shippingInformation: {
                firstName: userProfile.firstName,
                lastName: userProfile.lastName,
                phone: userProfile.phone,
                address: userProfile.address
            },
            paymentInformation: {
                slip: `/slips/${userProfile.user_id}_at_${currentTimestamp}.jpg`
            },
            status: {
                status: "Unpaid",
                description: ""
            }
        };
        const addOrder = await addOrderFunc(addOrderDetail); 
        var orderId

        if (addOrder) {
            orderId = addOrder._id
        }
        console.log(addOrder)
        if(addOrder == null){
            return res.json({
                success: false,
                message: "Can't create order."
            });
        }
        await Cart.deleteMany({ owner: user_id });

        return res.json({
            success: true,
            message: 'Checkout successful! order will be processing.',
            orderId: orderId,
        });
    } catch (err) {
        return res.json({
            success: false,
            message: err
        });
    }
});

cartRoute.get('/check-product/:id', async (req, res) => {
    const user_id = req.user.user_id;
    const product_id = req.params.id;
  
    try {
      const cartItem = await Cart.findOne({ owner: user_id, productId: product_id });
      
      if (cartItem) {
        return res.json({
          found: true,
          quantity: cartItem.quantity
        });
      } else {
        return res.json({
          found: false
        });
      }
    } catch (err) {
      return res.json({
        success: false,
        message: err
      });
    }
  });

  cartRoute.put('/update-cart/:id', async (req, res) => {
    const user_id = req.user.user_id;
    const product_id = req.params.id;
    const { quantity, size, productImage } = req.body;
  
    try {
      const cartItem = await Cart.findOne({ owner: user_id, productId: product_id });
  
      if (!cartItem) {
        return res.status(404).json({
          success: false,
          message: 'Product not found in the cart.'
        });
      }
  
      const product = await Product.findById(product_id);
      console.log(product)
      cartItem.quantity = quantity;
      cartItem.size = size;
      cartItem.productImage = productImage;
      cartItem.totalPrice = cartItem.quantity * product.price;
  
      await cartItem.save();
  
      return res.json({
        success: true,
        message: 'Cart item updated successfully'
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
        const userId = await req.user.user_id;
        const cart = await Cart.find({ 'owner': userId });
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