import express from "express";
import multer from "multer";
import Product, { ProductSchema } from '../models/product';
const productRoute = express.Router();

const storage = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, "./uploads/products");
	},
	filename: function (req, file, cb) {
        const fileName = `${(req as any).productId}.jpg`;
        console.log(`Uploading...`, fileName);
		cb(null,fileName);
	},
});

const upload = multer({ storage });


async function createproduct(req, res, next){
    const user_id = req.user.user_id;
    try {
        const newproduct = await Product.create({
            'owner': user_id,
            'productName': "",
            'productDescription': "",
            'productAmount': 0,
            'productImage': "",
        });
        req.productId = newproduct._id;
        next();
    } catch (err) {
        return res.json({
            success: false,
            message: err
        })
    }
};

productRoute.post('/add', createproduct , upload.single('file'), async (req,res) => {
    const product_name = req.body.productName;
	const product_des = req.body.productDescription;
    const product_price = req.body.productPrice;
    const product_colors = req.body.productColors;
    const product_size = req.body.productSize;
    const product_category = req.body.productCategory;
	const product_image = req.body.productImage;
    const productId = (req as any).productId;

    const newproduct = await Product.updateOne(
		{ _id: productId },
		{
			productName: product_name,
			productDescription: product_des,
			productImage: `/products/${productId}.jpg`,
            productPrice: product_price,
            productColors: product_colors,
            productSize: product_size,
            productCategory: product_category
		}
	);

    return res.json({
        success: true,
        message: "Already added product!",
        newproduct
    })
});

productRoute.get('/all-product', async (req, res) => {
    try{
        const product = await Product.find();
        console.log(product)
        return res.json({
            product,
            success: true,
            message: 'Get product successfully!'
        });
    }catch(err){
        return res.json({
            success: false,
            message: err
        });
    }
});

productRoute.get('/:id', async (req, res) => {
    try{
        const product = await Product.findById(req.params.id);
        return res.json({
            product,
            success: true,
            message: 'Get detail successfully!'
        });
    }catch(err){
        return res.json({
            success: false,
            message: err
        });
    }
});

productRoute.patch('/:id', async (req, res) => {
    const product = await Product.findById(req.params.id);
    if(!product) return res.json({message: "No Data Found"});
    try{
        const updateproduct = await Product.updateOne({_id: req.params.id}, {$set: req.body});
        return res.json({
            updateproduct,
            success: true,
            message: 'Update product successfully!'
        });
    }catch(err){
        return res.json({
            success: false,
            message: err
        });
    }
})

productRoute.delete('/:id',async (req, res) => {
    const product = await Product.findById(req.params.id);
    if (!product) return res.json({message: "No Data Found"});
    try {
        const deletedproduct = await Product.deleteOne({_id: req.params.id});
        return res.json({
            success: true,
            message: 'Delete product successfully'
        })
    } catch (err) {
        return res.json({
            success: false,
            message: err
        })
    }
})

productRoute.get('/search/:key',async (req, res) => {
    try {
        let result = await Product.find({
            "$or": [{
                productName: {$regex: req.params.key}
            }]
        })
        res.send(result);
    } catch (err) {
        return res.json({
            success: false,
            message: err
        })
    }
})
export default productRoute;