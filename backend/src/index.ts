import * as chalk from "chalk";

/** Internal Modules */
import dotenv from "dotenv";
import express from "express";
import cors from "cors";
import jwt from "express-jwt";
import cookieParser from "cookie-parser";

/** Routes */
import authRoute from "@/routes/auth";


/** Misc */
import config from "./config";

import mongoose from "mongoose";

/** logger */
import morgan from "morgan";
import { logger } from "@/utils/serviceLog";
import path from "path";
import fs from "fs";
import productRoute from "./routes/product";
import storageRoute from "./routes/storage";
import cartRoute from "./routes/cart";
import newpassRoute from "./routes/password";
import accountRoute from "./routes/account";
import orderRoute from "./routes/order";
import bookmarkRoute from "./routes/bookmark";

/** Instantiate Application */
const app = express();

const accessLogStream = fs.createWriteStream(
	path.join(__dirname, "access.log"),
	{
		flags: "a",
	}
);
/** Express configurations */
app.use(express.json());
app.use(
	config.isDev
		? morgan("combined")
		: morgan("combined", { stream: accessLogStream })
);
app.use(express.urlencoded({ extended: true }));

/** Plugins */
app.use(
	cors({
		origin: "*",
		credentials: true,
	})
);
app.use(cookieParser());

/** Json Web Token */
app.use(
	jwt({
		secret: config.JWT_SECRET,
		algorithms: ["HS256"],
		credentialsRequired: false,
		getToken: function fromHeaderOrQuerystring(req) {
			if (
				req.headers.authorization &&
				req.headers.authorization.split(" ")[0] === "Bearer"
			) {
				return req.headers.authorization.split(" ")[1];
			} else if (req.query && req.query.token) {
				return req.query.token;
			} else if (req.cookies.token) {
				return req.cookies.token;
			}
			return null;
		},
	})
);

/** Routes */
app.use("/auth", authRoute);
app.use("/product", productRoute);
app.use("/storage", storageRoute);
app.use("/cart", cartRoute);
app.use("/password", newpassRoute);
app.use("/account", accountRoute);
app.use("/order", orderRoute);
app.use("/bookmark", bookmarkRoute);
// for testing only
app.get("/", async (req, res) => {
	return res.send(`It works! 😃`);
});

/** Start a server */
(async () => {
	await mongoose
		.connect(config.MONGODB_HOST)
		.catch((err) => logger("Server", err, "🚨", "😭", "error"));
	app.listen(config.PORT, "0.0.0.0", () => {
		logger(
			"Server",
			`running on port ${chalk.bold(":" + config.PORT)}`,
			"🚀",
			"😃"
		);
	});
})();
