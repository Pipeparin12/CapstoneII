import express from 'express';
import multer from 'multer';
import Order from '../models/order';
import fs from 'fs';

const currentTimestamp = Date.now(); // Get the current timestamp

const storage = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, "./uploads/slips");
	},
	filename: function (req, file, cb) {
        const fileName = `${req.user.user_id}_at_${currentTimestamp}.jpg`;
        console.log(`Uploading...`, fileName);

		cb(null,fileName);
	},
});

const upload = multer({ storage });
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

storageRoute.post('/upload-slips', upload.single('file'), async (req, res, next) => {
    // req.file is the `slip` file
    // req.body will hold the text fields, if there were any
    // console.log(req.file);

    await Order.updateMany(
		{ owner: req.user.user_id },
		{
			$set: {
				"paymentInformation.slip": `/slips/${req.file.filename}`,
				"status.status": "Packing",
				"status.description": "waiting for tracking Number"
			}
		}
	).catch(err => console.log(err));

    return res.json({
        success: true,
        message: "File uploaded successfully"
    });
});


export default storageRoute;