import mongoose from 'mongoose'

// Create profile schema firstname, lastname, email, address, phone

export const ModelSchema = new mongoose.Schema({
    modelId:{
        type: String, 
        require: true,
    },
    modelName:{
        type: String, 
        require: true,
    },
    modelSize:{
        type: String, 
        require: true,
    },
    modelGender:{
        type: String, 
        require: true,
    },
    modelPath:{
        type: String, 
        require: true,
    },
    
});

export default mongoose.model('Model', ModelSchema);