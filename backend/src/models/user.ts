import mongoose, { Types } from 'mongoose'

export const userSchema = new mongoose.Schema({
    username:{
        type: String, 
        require: true,
    },
    password:{
        type: String,
        require: true,
    },
    firstName:{
        type: String, 
        require: true,
    },
    lastName:{
        type: String,
        require: true,
    },
    role:{
        type: String,
        required: true
    }
});

export default mongoose.model('User',userSchema);