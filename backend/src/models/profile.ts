import mongoose from 'mongoose'

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
    gender: {
        type: String,
        required: true
    },
    size: {
        type: String,
        required: true
    },
    model: {
        type: String,
        required: true
    }
});

export default mongoose.model('Profile', ProfileSchema);