import { User } from '@/database/models';
import type { ResultHandler } from '@/interface/handler';
import { genericError, infoResponse } from "./Handler";
import { generateJwtToken } from "@/utils";
import { SignUpPost } from "@/interface/api/User";

import bcrypt from "bcrypt";
const saltRounds = 10;

export const login = async (username: string, password: string): ResultHandler => {
    try {
        const user = await User.findOne({ username }).exec();
        if (!user) {
            return genericError("User not found", 400);
        }
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return genericError("Password is incorrect", 400);
        }

        const token = generateJwtToken(user._id, user.username);

        return infoResponse(token, "Sign in success");
    } catch (e) {
        return genericError(e.message, 503)
    }
}

export const signup = async (data: SignUpPost): ResultHandler => {
    try {
        const { password, ...props } = data;
        if (password.length < 6) {
            return genericError("Password length must not less than 4", 400);
        }
        const user = await User.findOne({ username: props.username }).exec();
        if (user) {
            return genericError("Username already exists", 400)
        }

        const hashedPassword = await bcrypt.hash(password, saltRounds);
        const myUser = new User({ ...props, password: hashedPassword });
        try {
            await myUser.save();
        } catch (e) {
            return genericError(e.message, 400);
        }

        const token = generateJwtToken(myUser._id, myUser.username);

        return infoResponse(token, "Sign up success", 201);
    } catch (e) {
        return genericError(e.message, 503);
    }
}