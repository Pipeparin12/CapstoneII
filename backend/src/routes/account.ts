import express from "express";
import User from '../models/user';
import Profile from "@/models/profile";
import Model from "@/models/model";

const accountRoute = express.Router();

accountRoute.get('/all-user', async (req, res) => {
    try {
        const users = await User.find();
        return res.json({
            success: true,
            users,
        })
    } catch (error) {
        return res.json({
            success: false,
            message: error
        });
    }
})

accountRoute.get('/userdetails', async (req, res) => {
    try {
        if(req.user == null) return res.json({
            success: false,
            message: "Authentication error!"
        });

        const userId = req.user?.user_id;
        const userProfile = await Profile.findOne({ user: userId })
        return res.json({
            success: true,
            userProfile
        })
    } catch (error) {
        return res.json({
            success: false,
            message: error
        });
    }
});

accountRoute.patch('/userdetails/update', async (req, res) => {
    try {
        const { phone, address } = req.body;
        if(req.user == null) return res.json({
            success: false,
            message: "Authentication error!"
        });

        const userId = req.user?.user_id;

        await Profile.updateOne({ user: userId }, {
            phone,
            address
        });

        return res.json({
            success: true,
            message: "Updated profile!"
        });

    } catch (err) {
        return res.json({
            success: false,
            message: err
        });
    }
    }
);

accountRoute.patch('/usersize/update', async (req, res) => {
    try {
        const { height, weight, chestSize, waistSize, hipsSize, gender, size } = req.body;

        if (req.user == null) {
            return res.json({
                success: false,
                message: "Authentication error!"
            });
        }

        const userId = req.user?.user_id;

        // Find the model based on size and gender
        const model = await Model.findOne({ modelSize: size, modelGender: gender });

        if (!model) {
            // Handle the case where no matching model is found
            return res.json({
                success: false,
                message: "No matching model found for the given size and gender."
            });
        }

        // Extract modelPath
        const modelPath = model.modelName;

        // Update user profile with the new size and modelPath
        await Profile.updateOne({ user: userId }, {
            height, weight, chestSize, waistSize, hipsSize, gender, size, model: modelPath
        });

        return res.json({
            success: true,
            message: "Updated size and model path!",
            model: {
                modelPath
            }
        });

    } catch (err) {
        return res.json({
            success: false,
            message: err.message || "An error occurred while updating the size and model path."
        });
    }
});


export default accountRoute;