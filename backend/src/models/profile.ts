import mongoose from 'mongoose'

// Create profile schema firstname, lastname, email, address, phone

export const ProfileSchema = new mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user'
    },
    username: {
        type: String,
        required: true
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
    },
    height: {
        type: Number,
        required: true
    },
    weight: {
        type: Number,
        required: true
    },
    chestSize: {
        type: Number,
        required: true
    },
    waistSize: {
        type: Number,
        required: true
    },
    hipsSize: {
        type: Number,
        required: true
    },
});

export default mongoose.model('Profile', ProfileSchema);