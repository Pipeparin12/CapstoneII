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
accountRoute.post('/userdetails/update', async (req, res) => {
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