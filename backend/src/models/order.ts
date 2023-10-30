import mongoose, { Types } from "mongoose";

export const orderSchema = new mongoose.Schema({
    owner: {
        type: Types.ObjectId,
        required: true,
        ref: 'User'
    },
    products: [{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'Product'
    }],
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

export default mongoose.model('Order',orderSchema);