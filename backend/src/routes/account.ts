import express from "express";
import User from '../models/user';
import Profile from "@/models/profile";

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

accountRoute.patch('/userdetails/update', async (req, res) => {
    try {
        const { phone, address } = req.body;
        if(req.user == null) return res.json({
            success: false,
            message: "Authentication error!"
        });

        const userId = req.user?.user_id;

        let user = await User.findOne({ userId });

        if (!user) {
            return res.json({
                success: false,
                message: "User not found"
            });
        }

        let userProfile = await Profile.findOne({ user: user._id });

        if (!userProfile) {
            userProfile = new Profile({
                user: user._id,
                phone,
                address
            });
        } else {
            if (phone !== undefined) {
                userProfile.phone = phone;
            }
            if (address !== undefined) {
                userProfile.address = address;
            }
        }

        await userProfile.save();

        return res.json({
            success: true,
            message: "Phone and address updated and saved successfully"
        });

    } catch (error) {
        return res.json({
            success: false,
            message: error
        });
    }
});

export default accountRoute;