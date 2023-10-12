import express from "express";
// eslint-disable-next-line new-cap
import User, { userSchema } from '../models/user';
import Profile from '../models/profile';
import jwt from 'jsonwebtoken';
// const User = require('../models/user')
const authRoute = express.Router();

import AppConfig from '@/config';

authRoute.post('/signup', async (req,res)=>{
    try{
        // Find one user!
        let newUser = await User.findOne({username:req.body.username});

        // Check if user exists? If it doesn't...
        if(newUser == null){
            // Create new user
            newUser = new User({
                    username:req.body.username,
                    password:req.body.password
                });
            // Save into a database.
            newUser = await newUser.save();

            // Create new profile along with a user.
            await Profile.create({
				user: newUser._id,
				username:newUser.username,
				firstName: "NoFirstName",
				lastName: "NoLastName",
				phone: "000-000-0000",
				address: "NoAddress",
				email: "anonymous@mail.com",
			}).catch(err => console.log(err));

            // Send it back to flutter
            return res.json({
                success: true,
                message:'Signed up successfully!'
            });
        }

        // Otherwise, do this...
        return res.json({
            success: false,
            message:'username is not available'
        });

    }catch(err){
        // In case there's an error..
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
            // TODO: ...
            delete user["password"];

            return res.json({
                success: true,
                message: "Logged In successfully!",
                token: jwt.sign({ user_id: user._id, username: user.username }, AppConfig.JWT_SECRET)
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

// Service Book Restful API
// TOKEN   ->   sdfsdfkxclvokxlcvklsdkflsdkflsdklfksdlf
//C   POST  /book   body -> { name: 'sirawit', count: 2 }
// C  POST  /book/add-favourite/:id   ->   
//R   GET   /book
//F   GET  /book/:id   /book/1   /book/d121er12dfer12
//U   PATCH /book/:id      body -> { name: 'sirawit', count: 2 }
//D   DELETE /book/:id   


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
	// return res.send(`Auth route ${nanoid(64)}`);
	return res.json(req.user);
});


export default authRoute;