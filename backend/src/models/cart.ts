import mongoose, { Types } from "mongoose";

export const cartSchema = new mongoose.Schema({
    owner: {
        type: Types.ObjectId,
        required: true,
        ref: 'User'
    },
    productId: {
        type: Types.ObjectId,
        ref: 'Product'
    },
    productName:{
        type: String, 
    },
    size: {
        type: String,
        required: true
    },
    quantity: {
        type: Number,
        required: true,
        min: 1
    },
    // Add price field for the product
    totalPrice: { 
        type: Number, 
        required: true 
    },
    status: { 
        type: String, 
        default: "unpaid" 
    }, // Add status field
},{
    timestamps: true
})

export default mongoose.model('Cart',cartSchema);