import express from "express";
import User from '../models/user';
import Profile from "@/models/profile";

const accountRoute = express.Router();

accountRoute.get('/userdetails', async (req,res) =>{
        try {
            if(req.user == null) return res.json({
                success: false,
                message: "Authentication error!"
            });
    
            const user_id = req.user?.user_id;

            let userProfile = await Profile.findOne({user:user_id})

            if(userProfile){
                console.log(`Found profile: `, userProfile);
                return res.json({
                    success: true,
                    message: "Found profile!",
                    userProfile
                });
            }
            
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

        let user = await User.findOne({ userId });

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

        } catch (err) {
            return res.json({
                success: false,
                message: err
            });
        }
    });

export default accountRoute;