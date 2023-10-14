import mongoose from 'mongoose'

// Create profile schema firstname, lastname, email, address, phone

export const ProductSchema = new mongoose.Schema({
    productId:{
        type: String, 
        require: true,
    },
    productName:{
        type: String, 
        require: true,
    },
    productDescription:{
        type: String,
        require: true,
    },
    productImage:{
        type: String,
        require: true
    },
    price:{
        type: Number,
        require: true
    },
    color:{
        type: String,
        require: true
    },
    size:{
        type: String,
        require: true
    },
    quantity:{
        type: Number,
        require: true
    },
    category:{
        type: String,
        require: true
    }
});

export default mongoose.model('Product', ProductSchema);