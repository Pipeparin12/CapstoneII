import mongoose from 'mongoose'

// Create profile schema firstname, lastname, email, address, phone

export const ProfileSchema = new mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user'
    },
    imageUrl: {
        type: String,
        default: ''
    },
    firstName: {
        type: String,
        required: true
    },
    lastName: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true
    },
    address: {
        type: String,
        required: true
    },
    phone: {
        type: String,
        required: true
    }
});

export default mongoose.model('Profile', ProfileSchema);