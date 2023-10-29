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

export default accountRoute;