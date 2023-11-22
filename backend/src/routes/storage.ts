import express from 'express';
import multer from 'multer';
import Order from '../models/order';
import Product from '../models/product';
import fs from 'fs';

const currentTimestamp = Date.now();

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

storageRoute.get("/slips/:slip_path", (req, res) => {
	try {
		const fileStream = fs.createReadStream(
			`./uploads/slips/${req.params.slip_path}`
		).on('error', err => console.log(err));
		return fileStream.pipe(res);
	} catch (err) {
		return res.status(404);
	}
});

storageRoute.post('/upload-slips', upload.single('file'), async (req, res, next) => {
    const orderId = req.body.orderId;

	const order = await Order.findOne({ _id: orderId, owner: req.user.user_id });

    if (!order) {
        return res.status(404).json({
            success: false,
            message: 'Order not found'
        });
    }

    const products = order.products;

    await Order.updateMany(
        { _id: orderId, owner: req.user.user_id },
        {
            $set: {
                "paymentInformation.slip": `/slips/${req.file.filename}`,
                "status.status": "Waiting for confirm order.",
                "status.description": "Waiting for confirm order."
            }
        }
    ).catch(err => console.log(err));

    for (const productData of products) {
        const productId = productData.productId;
        const quantityToDecrease = productData.quantity;

        const product = await Product.findById(productId);

        if (product) {
            product.quantity -= quantityToDecrease;
            await product.save().catch(err => console.log(err));
        } else {
            console.log(`Product with ID ${productId} not found`);
        }
    }

    return res.json({
        success: true,
        message: "File uploaded successfully"
    });
});

export default storageRoute;