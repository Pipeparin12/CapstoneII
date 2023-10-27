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

  // Check if the current password matches the password in the database.
  const user = await User.findById(userId);
  if (!user || user.password !== currentPassword) {
    return res.status(400).json({ message: 'Incorrect current password.' });
  }
  // Update the password in the database for both the users and profiles tables.
  await User.findByIdAndUpdate(userId, { password: newPassword });
  // Return a success response to the client.
  return res.status(200).json({ message: 'Password changed successfully.' });
});

export default newpassRoute;