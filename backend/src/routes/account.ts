import express from "express";
import User from '../models/user';
import Profile from "@/models/profile";

const accountRoute = express.Router();

accountRoute.get('/userdetails', async (req,res) =>{
        try {
            const {userId} = req.body;
            let userProfile = await Profile.findOne({user:userId})
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