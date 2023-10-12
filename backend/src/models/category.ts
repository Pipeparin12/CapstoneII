import mongoose, { Mongoose }  from "mongoose"
import { ObjectId, Types } from "mongoose"

export const categorySchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },

})

export default mongoose.model('Category',categorySchema);