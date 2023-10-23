import express from 'express';
import multer from 'multer';
import fs from 'fs';

const storageRoute = express.Router();

storageRoute.get("/products/:product_id", (req, res) => {
	try {
		const fileStream = fs.createReadStream(
			`./uploads/products/${req.params.product_id}`
		).on('error', err => console.log(err));
		return fileStream.pipe(res);
	} catch (err) {
		return res.status(404);
	}
});


export default storageRoute;