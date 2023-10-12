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
        type: String,
        require: true
    },
    category:{
        type: String,
        require: true
    }
});

export default mongoose.model('Product', ProductSchema);