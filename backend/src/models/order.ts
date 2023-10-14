import mongoose, { Mongoose }  from "mongoose"
import { ObjectId, Types } from "mongoose"

export const orderSchema = new mongoose.Schema({
    owner: {
        type: Types.ObjectId,
        required: true,
        ref: 'User'
    },
    productId: {
        type: Types.ObjectId,
        ref: 'Product'
    },
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
        bankAccountNumber: String,
        bankName: String
    }
})

export default mongoose.model('Order',orderSchema);