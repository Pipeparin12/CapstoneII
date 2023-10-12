import mongoose, { Mongoose }  from "mongoose"
import { ObjectId, Types } from "mongoose"

export const orderLineSchema = new mongoose.Schema({
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
    quantity: {
        type: Number,
        required: true,
        min: 1
    },
    // Add price field for the product
    price: { 
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

export default mongoose.model('OrderLine',orderLineSchema);