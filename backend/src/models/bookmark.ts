import mongoose, { Mongoose }  from "mongoose"
import { ObjectId, Types } from "mongoose"

export const bookmarkSchema = new mongoose.Schema({
    owner: {
        type: Types.ObjectId,
        required: true,
        ref: 'User'
    },

    productId: {
        type: Types.ObjectId,
        ref: 'Book'
    },
    productImage:{
        type: String,
    },

},{
    timestamps: true
})

export default mongoose.model('Bookmark',bookmarkSchema);