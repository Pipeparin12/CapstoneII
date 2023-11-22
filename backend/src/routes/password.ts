import express from "express";
import User from '../models/user';
import Profile from "@/models/profile";

const newpassRoute = express.Router();


newpassRoute.patch('/change-password', async (req, res) => {
  if(req.user == null) return res.json({
    success: false,
    message: "Authentication error!"
  });

  const userId = req.user?.user_id;
    const { currentPassword, newPassword } = req.body;

  const user = await User.findById(userId);
  if (!user || user.password !== currentPassword) {
    return res.status(400).json({ message: 'Incorrect current password.' });
  }
  await User.findByIdAndUpdate(userId, { password: newPassword });
  return res.status(200).json({ message: 'Password changed successfully.' });
});

export default newpassRoute;