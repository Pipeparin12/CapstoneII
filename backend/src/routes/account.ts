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
        const userId = req.body.userId;
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
accountRoute.post('/userdetails', async (req, res) => {
    try {
        const { userId, phone, address } = req.body;

        const user = await User.findOne({ userId });

        if (!user) {
            return res.json({

                success: false,
                message: "Authentication error!"
            });
    
            const user_id = req.user?.user_id;
    
            await Profile.updateOne({ user: user_id }, {
                phone,
                address
            });
    
            return res.json({
                success: true,
                message: "Updated profile!"
            });
    
        }} catch (err) {
            return res.json({
                success: false,
                message: err
            });
        }
    });

export default accountRoute;