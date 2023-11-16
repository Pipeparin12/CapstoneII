import express from "express";
import multer from "multer";
import Product from '../models/product';
import Model from '../models/model';
import User  from "../models/user";
import Profile from "../models/profile"

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
    try {
        const newproduct = await Product.create({
            'productName': "",
            'productDescription': "",
            'price': 0,
            'color': "",
            'size': "",
            'quantity': 0,
            'category': "",
            'productImage': "",
            'productModel': "",
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

async function createModel(req, res, next){
    try {
        const newModel = await Model.create({
            'modelName': "",
            'modelSize': "",
            'modelPath': "",
        });
        req.modelId = newModel._id;
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
    const product_price = req.body.price;
    const product_color = req.body.color;
    const product_size = req.body.size;
    const product_quantuty = req.body.quantity;
    const product_category = req.body.category;
	const product_image = req.body.productImage;
    const productId = (req as any).productId;

    const newproduct = await Product.updateOne(
		{ _id: productId },
		{
			productName: product_name,
			productDescription: product_des,
			productImage: `/products/${productId}.jpg`,
            price: product_price,
            color: product_color,
            size: product_size,
            quantity: product_quantuty,
            category: product_category,
            productModel: `assets/3D_models/test.glb`
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

productRoute.get('/yourProduct/:key', async (req, res) => {
    const user_id = req.user?.user_id;
    try{
        const userProfile = await Profile.findOne({ user: user_id });
        console.log(userProfile)
        if (!userProfile) {
            return res.json({
                success: false,
                message: 'User profile not found.'
            });
        }
        const userSize = userProfile.size;
        // const userGender = userProfile.gender
        const products = await Product.find({ size: userSize, category: {$regex: req.params.key} }).exec();
        console.log(products)
        return res.json({
            products,
            success: true,
            message: 'Get products successfully!'
        });
    } catch (err) {
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

productRoute.patch('/update-quantity', async (req, res) => {
    const product = await Product.findById(req.body.product_id);
    const quantity = req.body.quantityInCart;
    if(!product) return res.json({message: "No Data Found"});
    try{
        const updatequantity = await Product.updateOne({_id: req.body.product_id}, { $set : { quantity : product.quantity-quantity }});
        return res.json({
            updatequantity,
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
        await Product.deleteOne({_id: req.params.id});
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
        const result = await Product.find({
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

productRoute.get('/category/:key',async (req, res) => {
    try {
        const result = await Product.find({
            "$or": [{
                category: {$regex: req.params.key}
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

productRoute.post('/add-model', createModel , upload.single('file'), async (req,res) => {
    const model_name = req.body.modelName;
    const model_size = req.body.modelSize;
    const model_gender = req.body.modelGender; 
    const modelId = (req as any).modelId;

    const newModel = await Model.updateOne(
        { _id: modelId },
        {
            modelName: model_name,
            modelSize: model_size,
            modelGender: model_gender,
            modelPath: `/models/${model_name}.glb`,
        }
    );

    return res.json({
        success: true,
        message: "Already added model!",
        newModel
    })
});

export default productRoute;