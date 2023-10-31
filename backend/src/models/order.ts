import mongoose, { Types } from "mongoose";

export const orderSchema = new mongoose.Schema({
    owner: {
        type: Types.ObjectId,
        required: true,
        ref: 'User'
    },
    products: [
        {
            productId: {
                type: mongoose.Schema.Types.ObjectId,
                required: true,
                ref: "Product",
            },
            productName:{
                type: String, 
            },
            productImage:{
                type: String,
            },
            size: {
                type: String,
            },
            quantity: {
                type: Number,
            },
            // Add price field for the product
            totalPrice: { 
                type: Number, 
            },
        },
    ],
    totalPrice: { 
        type: Number, 
        required: true 
    },
    shippingInformation:{
        firstName: String,
        lastName: String,
        phone: String,
        address: String
    },
    paymentInformation:{
        slip: String
    },
    status: {
        status: {
            type: String,
            required: true
        },
        description: String
    }
})

export default mongoose.model("Order", orderSchema);
