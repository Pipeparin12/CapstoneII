import express from "express";
import User from '../models/user';
import Profile from "@/models/profile";
import Model from "@/models/model";

const accountRoute = express.Router();

accountRoute.get('/all-user', async (req, res) => {
    try {
        const users = await User.find().select('-password');
        return res.json({
            success: true,
            users,
        });
    } catch (error) {
        return res.json({
            success: false,
            message: error,
        });
    }
});

accountRoute.patch('/update-role', async (req, res) => {
    const { users } = req.body;

    if (!users || !Array.isArray(users)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid request body. Make sure "users" array is provided.',
      });
    }
    
    try {
      for (const { userId, role } of users) {
        await User.updateOne({ _id: userId }, { role });
      }
    
      return res.json({
        success: true,
        message: 'Updated profiles!',
      });
    } catch (err) {
      console.error(err);
      return res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: err.message,
      });
    }
  });



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

        const model = await Model.findOne({ modelSize: size, modelGender: gender });

        if (!model) {
            return res.json({
                success: false,
                message: "No matching model found for the given size and gender."
            });
        }

        const modelPath = model.modelName;

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