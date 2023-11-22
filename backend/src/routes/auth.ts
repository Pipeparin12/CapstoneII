import express from "express";
import User, { userSchema } from '../models/user';
import Profile from '../models/profile';
import jwt from 'jsonwebtoken';
const authRoute = express.Router();

import AppConfig from '@/config';

authRoute.post('/signup', async (req,res)=>{
    try{
        let newUser = await User.findOne({username:req.body.username});
        if(newUser == null){
            newUser = new User({
                    username:req.body.username,
                    password:req.body.password,
                    firstName:req.body.firstName,
                    lastName:req.body.lastName,
                    role: "customer"
                });
            newUser = await newUser.save();
            await Profile.create({
				user: newUser._id,
				username: newUser.username,
				firstName: newUser.firstName,
				lastName: newUser.lastName,
				phone: "000-000-0000",
				address: "Please fill your Address",
				email: "anonymous@mail.com",
                height: 0,
                weight: 0,
                chestSize: 0,
                waistSize: 0,
                hipsSize: 0,
                gender: "Unknown",
                size: "Unknown",
                model: "Unknown"
			}).catch(err => console.log(err));
            return res.json({
                success: true,
                message:'Signed up successfully!'
            });
        }
        return res.json({
            success: false,
            message:'username is not available'
        });

    }catch(err){
        return res.json({
            success: false,
            message: err
        });
    }
});

authRoute.post('/signin',async (req,res)=>{
    try{
        const user = await User.findOne({username:req.body.username,password:req.body.password});

        if(user){
            delete user["password"];

            return res.json({
                success: true,
                message: "Logged In successfully!",
                token: jwt.sign({ user_id: user._id, username: user.username }, AppConfig.JWT_SECRET),
                role: user.role
            });
        }

        return res.json({
            success: false,
            message: "Authentication error!"
        });

    }catch(err){
        return res.json({
            success: false,
            message: err
        });
    }
})

authRoute.get("/me", async (req, res) => {
    try{
        if(req.user == null) return res.json({
            success: false,
            message: "Authentication error!"
        });

        const user_id = req.user?.user_id;

        const profile = await Profile.findOne({ user: user_id });

        if(profile){
            console.log(`Found profile: `, profile);
            return res.json({
                success: true,
                message: "Logged In successfully!",
                profile
            });
        }

        return res.json({
            success: false,
            message: "Profile not found!"
        });
    }catch(err){
        return res.json({
            success: false,
            message: err
        });
    }
});

authRoute.patch("/me", async (req, res) => {
    try {
        const { username, firstName, lastName, email, phone, address } = req.body;
        if (req.user == null) return res.json({
            success: false,
            message: "Authentication error!"
        });

        const user_id = req.user?.user_id;

        await Profile.updateOne({ user: user_id }, {
			username,
            firstName,
            lastName,
            email,
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

authRoute.get("/", (req, res) => {
	return res.json(req.user);
});


export default authRoute;